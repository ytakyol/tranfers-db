USE transfer_db;

-- 1. Player Profile View
CREATE OR REPLACE VIEW view_player_profile AS
SELECT p.person_ID, p.name, p.surname, 
       TIMESTAMPDIFF(YEAR, p.date_of_birth, CURDATE()) as age, 
       p.nationality, pl.market_value, pl.main_position, pl.strong_foot, pl.height,
       (SELECT c.club_name FROM contracts ct 
        JOIN clubs c ON ct.club_id = c.club_ID
        WHERE ct.player_id = p.person_ID 
        AND ct.start_date <= CURDATE() AND ct.end_date >= CURDATE()
        ORDER BY ct.contract_type = 'Loan' DESC LIMIT 1) as current_club
FROM persons p 
JOIN players pl ON p.person_ID = pl.person_ID;

-- 2. Player Match History View (Can also be used for aggregation/stats)
CREATE OR REPLACE VIEW view_player_match_history AS
SELECT ms.player_ID, m.match_datetime, c.name as competition_name, c.season, c.competition_ID,
       s.stadium_name,
       IF(m.home_club_ID = ms.club_ID, away.club_name, home.club_name) as opposing_club,
       CONCAT(m.home_goals, ' - ', m.away_goals) as final_result,
       ms.minutes_played, ms.position_in_match, ms.goals, ms.assists, 
       ms.yellow_cards, ms.red_cards, ms.rating
FROM match_stats ms
JOIN matches m ON ms.match_ID = m.match_ID
JOIN competitions c ON m.competition_ID = c.competition_ID
JOIN stadiums s ON m.stadium_ID = s.stadium_ID
JOIN clubs home ON m.home_club_ID = home.club_ID
JOIN clubs away ON m.away_club_ID = away.club_ID;

-- 3. Player Contracts View
CREATE OR REPLACE VIEW view_player_contracts AS
SELECT ct.player_id, c.club_name, ct.weekly_wage as salary, ct.contract_type, ct.start_date, ct.end_date
FROM contracts ct
JOIN clubs c ON ct.club_id = c.club_ID;

-- 4. Player Transfer History View
CREATE OR REPLACE VIEW view_player_transfers AS
SELECT tr.player_id, tr.transfer_date, tr.transfer_fee, 
       from_c.club_name as source_club, 
       to_c.club_name as destination_club, 
       tr.transfer_type
FROM transfer_record tr
LEFT JOIN clubs from_c ON tr.from_club_id = from_c.club_ID
JOIN clubs to_c ON tr.to_club_id = to_c.club_ID;