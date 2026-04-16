USE transfer_db;

-- View: Stadiums and their Home Clubs
-- Fulfills the requirement for DB Managers to view stadiums, cities, capacities, and associated home clubs.
CREATE OR REPLACE VIEW view_stadiums AS
SELECT 
    s.stadium_ID, 
    s.stadium_name, 
    s.city, 
    s.capacity, 
    GROUP_CONCAT(c.club_name SEPARATOR ', ') as home_clubs 
FROM stadiums s 
LEFT JOIN clubs c ON s.stadium_name = c.stadium_name AND s.city = c.city
GROUP BY s.stadium_ID, s.stadium_name, s.city, s.capacity;