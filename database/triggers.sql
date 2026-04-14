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
          AND (start_date <= NEW.end_date AND end_date >= NEW.start_date)) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player already has an overlapping contract';
    END IF;
    IF (SELECT COUNT(*) FROM contracts 
        WHERE contract_type = "Permanent" AND NEW.contract_type = "Loan" AND club_id != NEW.club_id
          AND (start_date <= NEW.start_date AND end_date >= NEW.end_date)) < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Club already has an overlapping contract';
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
        WHERE stadium_ID = NEW.stadium_ID AND capacity >= NEW.attendance) < 1 THEN
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
          AND end_date >= NEW.transfer_date AND start_date <= NEW.transfer_date) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player is not currently contracted to the from club or transfer date is after contract end date';
    END IF;
END$$

CREATE TRIGGER before_insert_match_stats
BEFORE INSERT ON match_stats
FOR EACH ROW
BEGIN
    IF NEW.is_starter <> 0 AND (SELECT COUNT(*)
    FROM match_stats
    WHERE match_ID = NEW.match_ID AND is_starter = 1 AND club_ID = NEW.club_ID) >= 11 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Starter count exceeds 11 for a match';
    END IF;
    IF (SELECT COUNT(*)
    FROM match_stats
    WHERE match_ID = NEW.match_ID AND club_ID = NEW.club_ID) >= 23 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player count exceeds 23 for a match';
    END IF;
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
    IF EXISTS(SELECT 1
    FROM matches m
    JOIN match_stats ms ON m.match_ID = ms.match_ID
    JOIN competitions c ON m.competition_ID = c.competition_ID
    WHERE (ms.yellow_cards >= 1) AND ms.player_ID = NEW.player_ID AND ms.club_ID = NEW.club_ID
    AND c.competition_ID = (SELECT competition_ID FROM matches WHERE match_ID = NEW.match_ID)
    AND m.match_datetime = (SELECT MAX(match_datetime)
      FROM matches a 
      WHERE a.match_datetime < (SELECT match_datetime FROM matches WHERE match_ID = NEW.match_ID)
      AND a.competition_ID = (SELECT competition_ID FROM matches WHERE match_ID = NEW.match_ID)
      AND (NEW.club_ID = a.home_club_ID OR NEW.club_ID = a.away_club_ID))
    AND (SELECT SUM(yellow_cards) FROM match_stats ms2
     JOIN matches m2 ON ms2.match_ID = m2.match_ID
     WHERE ms2.player_ID = NEW.player_ID AND ms2.club_ID = NEW.club_ID
     AND m2.competition_ID = (SELECT competition_ID FROM matches WHERE match_ID = NEW.match_ID)
     AND m2.match_datetime < (SELECT match_datetime FROM matches WHERE match_ID = NEW.match_ID)) >= 5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Player is suspended for this match due to yellow card accumulation';
    END IF;
END$$

DELIMITER ;