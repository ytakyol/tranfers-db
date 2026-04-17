DELIMITER $$

CREATE TRIGGER before_insert_player
BEFORE INSERT ON players
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM managers WHERE person_id = NEW.person_id)
       OR EXISTS (SELECT 1 FROM referees WHERE person_id = NEW.person_id) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Person already assigned a different role';
    END IF;
END$$

CREATE TRIGGER before_insert_manager
BEFORE INSERT ON managers
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM players WHERE person_id = NEW.person_id)
       OR EXISTS (SELECT 1 FROM referees WHERE person_id = NEW.person_id) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Person already assigned a different role';
    END IF;
END$$

CREATE TRIGGER before_insert_referee
BEFORE INSERT ON referees
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM managers WHERE person_id = NEW.person_id)
       OR EXISTS (SELECT 1 FROM players WHERE person_id = NEW.person_id) THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Person already assigned a different role';
    END IF;
END$$

CREATE TRIGGER before_insert_contract
BEFORE INSERT ON contracts
FOR EACH ROW
BEGIN
    IF NEW.start_date >= NEW.end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Contract start date must be before end date';
    END IF;
    IF (SELECT COUNT(*) FROM contracts 
        WHERE player_id = NEW.player_id AND contract_type = NEW.contract_type
          AND (start_date < NEW.end_date AND end_date > NEW.start_date)) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player already has an overlapping contract';
    END IF;
    IF NEW.contract_type = "Loan" AND (SELECT COUNT(*) FROM contracts 
        WHERE contract_type = "Permanent" AND club_id != NEW.club_id
          AND (start_date <= NEW.start_date AND end_date >= NEW.end_date)) < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A different club must have a permanent contract with the player for a loan contract to be valid';
    END IF;
END$$

CREATE TRIGGER before_insert_match
BEFORE INSERT ON matches
FOR EACH ROW
BEGIN
    IF NEW.home_club_ID = NEW.away_club_ID THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Home and away clubs cannot be the same';
    END IF;
    IF (SELECT COUNT(*) FROM stadiums
        WHERE stadium_ID = NEW.stadium_ID AND capacity >= NEW.attendance OR NEW.attendance IS NULL) < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'attendance exceeds stadium capacity';
    END IF;
    IF (SELECT COUNT(*) FROM matches
        WHERE (home_club_ID = NEW.home_club_ID OR away_club_ID = NEW.home_club_ID 
               OR home_club_ID = NEW.away_club_ID OR away_club_ID = NEW.away_club_ID
               OR referee_ID = NEW.referee_ID OR stadium_ID = NEW.stadium_ID)
          AND ABS(TIMESTAMPDIFF(MINUTE, match_datetime, NEW.match_datetime)) <= 120) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'One of the clubs, referees, or stadium is already scheduled for another match at the same time';
    END IF; 
END$$

CREATE TRIGGER before_update_match
BEFORE UPDATE ON matches
FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*) FROM stadiums
        WHERE stadium_ID = NEW.stadium_ID AND capacity >= NEW.attendance) < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'attendance exceeds stadium capacity';
    END IF;
END$$

CREATE TRIGGER before_insert_transfer
BEFORE INSERT ON transfer_record
FOR EACH ROW
BEGIN
    IF NEW.from_club_id = NEW.to_club_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'From and To clubs cannot be the same';
    END IF;
    IF NEW.transfer_type = 'Loan' AND NOT EXISTS(SELECT *
          FROM contracts 
          WHERE player_id = NEW.player_id 
          AND club_id = NEW.from_club_id 
          AND contract_type = 'Permanent'
          AND end_date >= NEW.transfer_date AND start_date <= NEW.transfer_date) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player is not currently contracted to the from club or transfer date is after contract end date';
    END IF;
END$$

CREATE TRIGGER before_insert_match_stats
BEFORE INSERT ON match_stats
FOR EACH ROW
BEGIN
    -- Check for starter count
    IF NEW.is_starter = True AND (SELECT COUNT(*)
    FROM match_stats
    WHERE match_ID = NEW.match_ID AND is_starter = 1 AND club_ID = NEW.club_ID) >= 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Starter count exceeds 11 for a match';
    END IF;
    -- Check for total player count (starters + substitutes)
    IF (SELECT COUNT(*)
    FROM match_stats
    WHERE match_ID = NEW.match_ID AND club_ID = NEW.club_ID) >= 23 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player count exceeds 23 for a match';
    END IF;
    -- Check for 2 yellow card = red card
    IF NEW.yellow_cards = 2 AND NEW.red_cards = False THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player cannot have 2 yellow cards without a red card';
    END IF;
    -- Check for red card accumulation
    IF EXISTS(SELECT 1
    FROM matches m
    JOIN match_stats ms ON m.match_ID = ms.match_ID
    JOIN competitions c ON m.competition_ID = c.competition_ID
    WHERE (ms.red_cards > 0 ) AND ms.player_ID = NEW.player_ID AND ms.club_ID = NEW.club_ID
    AND c.competition_ID = (SELECT competition_ID FROM matches WHERE match_ID = NEW.match_ID)
    AND m.match_datetime = (SELECT MAX(match_datetime) 
     FROM matches a 
     WHERE a.match_datetime < (SELECT match_datetime FROM matches WHERE match_ID = NEW.match_ID)
     AND a.competition_ID = (SELECT competition_ID FROM matches WHERE match_ID = NEW.match_ID)
     AND (NEW.club_ID = a.home_club_ID OR NEW.club_ID = a.away_club_ID))) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player is suspended for this match due to red card';
    END IF;
END$$

CREATE TRIGGER yellow_card_gemini
BEFORE INSERT ON match_stats
FOR EACH ROW
BEGIN
    -- 1. Variable Declarations
    DECLARE v_active_yellows INT DEFAULT 0;
    DECLARE v_played INT;
    DECLARE v_yellows_in_match INT;
    DECLARE done INT DEFAULT FALSE;

    -- 2. Cursor Declaration: Fetch all past matches for the club chronologically
    DECLARE history_cursor CURSOR FOR 
        SELECT 
            -- Check if player participated in this specific past match (1 = Yes, 0 = No)
            (SELECT COUNT(*) FROM match_stats WHERE match_ID = m.match_ID AND player_ID = NEW.player_ID),
            -- Count yellows earned in this specific past match
            (SELECT COALESCE(SUM(yellow_cards), 0) FROM match_stats WHERE match_ID = m.match_ID AND player_ID = NEW.player_ID)
        FROM matches m
        WHERE (m.home_club_ID = NEW.club_ID OR m.away_club_ID = NEW.club_ID)
          AND m.competition_ID = (SELECT competition_ID FROM matches WHERE match_ID = NEW.match_ID)
          AND m.match_datetime < (SELECT match_datetime FROM matches WHERE match_ID = NEW.match_ID)
        ORDER BY m.match_datetime ASC;

    -- 3. Handler Declaration
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 4. Execute the Cursor Loop
    OPEN history_cursor;
    
    history_loop: LOOP
        FETCH history_cursor INTO v_played, v_yellows_in_match;
        
        IF done THEN
            LEAVE history_loop;
        END IF;
        
        IF v_played > 0 THEN
            -- Player played. Add any cards to the running total.
            SET v_active_yellows = v_active_yellows + v_yellows_in_match;
        ELSE
            -- Player missed the match. Check the exact state of their counter.
            IF v_active_yellows >= 5 THEN
                -- They had 5+ cards. This absence counts as a served suspension! Hard Reset.
                SET v_active_yellows = 0;
            END IF;
            -- If v_active_yellows < 5, they missed the match for injury/tactics. 
            -- The counter is NOT reset.
        END IF;
    END LOOP;
    
    CLOSE history_cursor;

    -- 5. Final Check for the Current Insertion
    -- If the loop finished and the active count is still >= 5, they haven't served it yet.
    IF v_active_yellows >= 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player is suspended: Yellow card accumulation limit reached.';
    END IF;

END$$

CREATE TRIGGER sanity_check_on_match_stats
BEFORE INSERT ON match_stats
FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT 1 FROM contracts WHERE player_ID = NEW.player_ID AND club_id = NEW.club_ID
    AND start_date <= (SELECT match_datetime FROM matches WHERE match_ID = NEW.match_ID) AND end_date >= (SELECT match_datetime FROM matches WHERE match_ID = NEW.match_ID)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player is not contracted to the club at the time of the match';
    END IF;
    IF NOT EXISTS(SELECT 1 FROM MATCHES m WHERE (m.home_club_ID = NEW.club_ID OR m.away_club_ID = NEW.club_ID) AND m.match_id = NEW.match_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Club is not participating in the match';
    END IF;
END$$

CREATE TRIGGER username_uniqueness_person
BEFORE INSERT ON persons
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM db_managers WHERE username = NEW.username) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    END IF;
END$$

CREATE TRIGGER username_uniqueness_db_manager
BEFORE INSERT ON db_managers
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM persons WHERE username = NEW.username) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    END IF;
END$$

DELIMITER ;