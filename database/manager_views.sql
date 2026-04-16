USE transfer_db;

-- 1. Manager Fixtures View
-- Simplifies querying fixtures and match details for clubs
CREATE OR REPLACE VIEW view_manager_fixtures AS
SELECT 
    m.match_ID, 
    m.match_datetime, 
    m.competition_ID, 
    c.name AS competition_name, 
    c.season,
    s.stadium_name, 
    m.home_club_ID, 
    m.away_club_ID, 
    hc.club_name AS home_club_name, 
    ac.club_name AS away_club_name,
    m.home_goals, 
    m.away_goals
FROM matches m
JOIN competitions c ON m.competition_ID = c.competition_ID
JOIN stadiums s ON m.stadium_ID = s.stadium_ID
JOIN clubs hc ON m.home_club_ID = hc.club_ID
JOIN clubs ac ON m.away_club_ID = ac.club_ID;

-- 2. League Standings View
-- Calculates current standings for competitions typed as 'League'
CREATE OR REPLACE VIEW view_league_standings AS
SELECT 
    c.competition_ID, 
    c.name AS competition_name, 
    c.season,
    cl.club_ID, 
    cl.club_name,
    COUNT(m.match_ID) AS matches_played,
    SUM(IF(m.home_club_ID = cl.club_ID AND m.home_goals > m.away_goals, 1, 
        IF(m.away_club_ID = cl.club_ID AND m.away_goals > m.home_goals, 1, 0))) AS wins,
    SUM(IF(m.home_goals = m.away_goals AND m.home_goals IS NOT NULL, 1, 0)) AS draws,
    SUM(IF(m.home_club_ID = cl.club_ID AND m.home_goals < m.away_goals, 1, 
        IF(m.away_club_ID = cl.club_ID AND m.away_goals < m.home_goals, 1, 0))) AS losses,
    SUM(IF(m.home_club_ID = cl.club_ID, m.home_goals, m.away_goals)) AS goals_scored,
    SUM(IF(m.home_club_ID = cl.club_ID, m.away_goals, m.home_goals)) AS goals_conceded,
    (SUM(IF(m.home_club_ID = cl.club_ID, m.home_goals, m.away_goals)) - 
     SUM(IF(m.home_club_ID = cl.club_ID, m.away_goals, m.home_goals))) AS goal_difference,
    (SUM(IF(m.home_club_ID = cl.club_ID AND m.home_goals > m.away_goals, 3, 
        IF(m.away_club_ID = cl.club_ID AND m.away_goals > m.home_goals, 3, 
        IF(m.home_goals = m.away_goals AND m.home_goals IS NOT NULL, 1, 0))))) AS total_points
FROM participates p
JOIN competitions c ON p.competition_ID = c.competition_ID
JOIN clubs cl ON p.club_ID = cl.club_ID
LEFT JOIN matches m ON m.competition_ID = c.competition_ID 
     AND (m.home_club_ID = cl.club_ID OR m.away_club_ID = cl.club_ID) 
     AND m.match_datetime < NOW()
WHERE c.competition_type = 'League'
GROUP BY c.competition_ID, c.name, c.season, cl.club_ID, cl.club_name;

-- 3. Leaderboard Statistics View
-- Aggregates player stats for the leaderboard features
CREATE OR REPLACE VIEW view_player_leaderboard_stats AS
SELECT 
    ms.player_ID, 
    per.name, 
    per.surname, 
    cl.club_name,
    c.competition_ID, 
    c.season,
    COUNT(ms.match_ID) AS matches_played,
    SUM(ms.goals) AS total_goals,
    SUM(ms.assists) AS total_assists,
    AVG(ms.rating) AS avg_rating
FROM match_stats ms
JOIN matches m ON ms.match_ID = m.match_ID
JOIN competitions c ON m.competition_ID = c.competition_ID
JOIN players pl ON ms.player_ID = pl.person_ID
JOIN persons per ON pl.person_ID = per.person_ID
JOIN clubs cl ON ms.club_ID = cl.club_ID
GROUP BY ms.player_ID, per.name, per.surname, cl.club_name, c.competition_ID, c.season;