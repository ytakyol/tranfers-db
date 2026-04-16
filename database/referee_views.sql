USE transfer_db;

-- 1. Referee Profile View
CREATE OR REPLACE VIEW view_referee_profile AS
SELECT p.person_ID, p.name, p.surname, p.nationality, p.date_of_birth,
       r.license_level, r.years_of_experience
FROM persons p
JOIN referees r ON p.person_ID = r.person_ID;

-- 2. Referee Match History View
CREATE OR REPLACE VIEW view_referee_match_history AS
SELECT 
    m.referee_ID,
    m.match_ID,
    m.match_datetime,
    c.name AS competition_name,
    s.stadium_name,
    m.attendance,
    m.home_goals,
    m.away_goals,
    CONCAT(home.club_name, ' vs ', away.club_name) AS match_teams,
    IF(m.match_datetime > NOW(), 'Scheduled', CONCAT(m.home_goals, '-', m.away_goals)) AS result_or_status,
    COALESCE(SUM(ms.yellow_cards), 0) AS total_yellow_cards,
    COALESCE(SUM(ms.red_cards), 0) AS total_red_cards
FROM matches m
JOIN competitions c ON m.competition_ID = c.competition_ID
JOIN stadiums s ON m.stadium_ID = s.stadium_ID
JOIN clubs home ON m.home_club_ID = home.club_ID
JOIN clubs away ON m.away_club_ID = away.club_ID
LEFT JOIN match_stats ms ON m.match_ID = ms.match_ID
GROUP BY m.match_ID, m.referee_ID, m.match_datetime, c.name, s.stadium_name, m.attendance, m.home_goals, m.away_goals, home.club_name, away.club_name;