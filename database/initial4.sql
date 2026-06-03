USE transfer_db;

-- ==========================================
-- 1. DB MANAGERS
-- ==========================================
INSERT INTO db_managers (username, password) VALUES
('kevin', SHA2('K3v!n#2024', 256)),
('bob', SHA2('Bob@Secure88', 256)),
('maria', SHA2('M@r1a321!', 256));

-- ==========================================
-- 2. PERSONS (Ana Tablo)
-- ==========================================
INSERT INTO persons (person_ID, username, password, name, surname, nationality, date_of_birth) VALUES
-- Players
(1, 'mauro_icardi', SHA2('Icard1@GS!', 256), 'Mauro', 'Icardi', 'Argentina', '1993-02-19'),
(2, 'lucas_torreira', SHA2('Tor3ira#22', 256), 'Lucas', 'Torreira', 'Uruguay', '1996-02-11'),
(3, 'davinson_sanchez', SHA2('Dav!nson22', 256), 'Davinson', 'Sánchez', 'Colombia', '1996-06-12'),
(4, 'fernando_muslera', SHA2('Mus#Lera!1', 256), 'Fernando', 'Muslera', 'Uruguay', '1986-06-16'),
(5, 'hakim_ziyech', SHA2('Z!yech@22', 256), 'Hakim', 'Ziyech', 'Morocco', '1993-03-19'),
(6, 'kerem_akturkoglu', SHA2('Ker3m!Ak#,', 256), 'Kerem', 'Aktürkoğlu', 'Türkiye', '1998-10-21'),
(7, 'tete_bra', SHA2('T3te@Bra!1', 256), 'Tetê', 'Mota', 'Brazil', '2000-02-13'),
(8, 'wilfried_zaha', SHA2('Z@h@GS2024', 256), 'Wilfried', 'Zaha', 'Cote d''Ivoire', '1992-11-10'),
(9, 'baris_alper', SHA2('B@r!sBAY7', 256), 'Barış Alper', 'Yılmaz', 'Türkiye', '2000-05-23'),
(10, 'abdülkerim_b', SHA2('Abdülk3r!m', 256), 'Abdülkerim', 'Bardakcı', 'Türkiye', '1994-09-07'),
(11, 'michy_batshuayi', SHA2('M1chy!Bats', 256), 'Michy', 'Batshuayi', 'Belgium', '1993-10-02'),
(12, 'dries_mertens', SHA2('M3rt3ns#10', 256), 'Dries', 'Mertens', 'Belgium', '1987-05-06'),
(13, 'kaan_ayhan', SHA2('K@@n!Ayhan', 256), 'Kaan', 'Ayhan', 'Türkiye', '1995-03-10'),
(14, 'edin_dzeko', SHA2('Dz3ko!FB1', 256), 'Edin', 'Džeko', 'Bosnia', '1986-03-17'),
(15, 'dusan_tadic', SHA2('T@dic#FB1!', 256), 'Dušan', 'Tadić', 'Serbia', '1988-11-20'),
(16, 'irfan_can_e', SHA2('!rfanCan1#', 256), 'İrfan Can', 'Eğribayat', 'Türkiye', '1998-06-30'),
(17, 'bright_o_samuel', SHA2('Br!ghtOS1@', 256), 'Bright', 'Osayi-Samuel', 'Nigeria', '1997-12-31'),
(18, 'sebastian_szym', SHA2('Sz!man@2024', 256), 'Sebastian', 'Szymański', 'Poland', '1999-05-10'),
(19, 'cengiz_under', SHA2('C3ng!zUnd1', 256), 'Cengiz', 'Ünder', 'Türkiye', '1997-07-14'),
(20, 'rafa_silva', SHA2('R@faSilva!1', 256), 'Rafa', 'Silva', 'Portugal', '1993-05-17'),
(21, 'gedson_fernandes', SHA2('G3dson#BJK', 256), 'Gedson', 'Fernandes', 'Portugal', '1999-01-09'),
(22, 'vincent_aboubakar', SHA2('Abou!BJK10', 256), 'Vincent', 'Aboubakar', 'Cameroon', '1992-01-22'),
(23, 'bruno_fernandes', SHA2('Brun0!MUFC', 256), 'Bruno', 'Fernandes', 'Portugal', '1994-09-08'),
(24, 'marcus_rashford', SHA2('R@shford10', 256), 'Marcus', 'Rashford', 'England', '1997-10-31'),
(25, 'casemiro_18', SHA2('C@s3m1ro18', 256), 'Carlos', 'Casemiro', 'Brazil', '1992-02-23'),
(26, 'mohamed_salah', SHA2('S@lah!LFC1', 256), 'Mohamed', 'Salah', 'Egypt', '1992-06-15'),
(27, 'virgil_van_dijk', SHA2('VVD!LFC44', 256), 'Virgil', 'van Dijk', 'Netherlands', '1991-07-08'),
(28, 'alexis_mac_all', SHA2('Al3x!sMacA', 256), 'Alexis', 'Mac Allister', 'Argentina', '1998-12-24'),
(29, 'victor_osimhen', SHA2('Os1mh3n!GS', 256), 'Victor', 'Osimhen', 'Nigeria', '1998-12-29'),
(30, 'andreas_christ', SHA2('Andre@s#1!', 256), 'Andreas', 'Christensen', 'Denmark', '1996-04-10'),
-- Managers
(2001, 'okan_buruk', SHA2('Okan@Mng25', 256), 'Okan', 'Buruk', 'Türkiye', '1973-10-19'),
(2002, 'jose_mourinho', SHA2('Jose#Spec1', 256), 'José', 'Mourinho', 'Portugal', '1963-01-26'),
(2003, 'ole_solskjaer', SHA2('Ole$2024!', 256), 'Ole', 'Solskjær', 'Norway', '1973-02-26'),
(2004, 'erik_ten_hag', SHA2('Erik@TH2024', 256), 'Erik', 'ten Hag', 'Netherlands', '1970-02-02'),
(2005, 'arne_slot', SHA2('Arne$Slot1!', 256), 'Arne', 'Slot', 'Netherlands', '1978-09-17'),
(2006, 'carlo_ancelotti', SHA2('Carlo#Anc!1', 256), 'Carlo', 'Ancelotti', 'Italy', '1959-06-10'),
-- Referees
(1001, 'cuneyt_cakir', SHA2('Cun3yt!Ref', 256), 'Cüneyt', 'Çakır', 'Türkiye', '1976-11-23'),
(1002, 'halil_meler', SHA2('H@lil#Ref2', 256), 'Halil', 'Meler', 'Türkiye', '1986-08-22'),
(1003, 'michael_oliver', SHA2('M!chael@Ref3', 256), 'Michael', 'Oliver', 'England', '1985-02-20'),
(1004, 'anthony_taylor', SHA2('Ant#Taylor4!', 256), 'Anthony', 'Taylor', 'England', '1978-10-20');

-- ==========================================
-- 3. PLAYERS (Alt Tablo)
-- ==========================================
INSERT INTO players (player_ID, market_value, main_position, strong_foot, height) VALUES
(1, 12000000, 'Forward', 'Right', 184),
(2, 15000000, 'Midfielder', 'Right', 168),
(3, 20000000, 'Defender', 'Right', 187),
(4, 1500000, 'Goalkeeper', 'Right', 190),
(5, 12000000, 'Forward', 'Left', 181),
(6, 18000000, 'Forward', 'Right', 173),
(7, 8000000, 'Forward', 'Left', 175),
(8, 10000000, 'Forward', 'Right', 180),
(9, 14000000, 'Forward', 'Right', 186),
(10, 7500000, 'Defender', 'Left', 185),
(11, 8500000, 'Forward', 'Right', 185),
(12, 2000000, 'Midfielder', 'Right', 169),
(13, 7000000, 'Defender', 'Right', 184),
(14, 3500000, 'Forward', 'Right', 193),
(15, 4000000, 'Midfielder', 'Left', 181),
(16, 6000000, 'Goalkeeper', 'Right', 188),
(17, 12000000, 'Defender', 'Right', 174),
(18, 22000000, 'Midfielder', 'Right', 175),
(19, 16000000, 'Forward', 'Left', 173),
(20, 18000000, 'Midfielder', 'Right', 178),
(21, 15000000, 'Midfielder', 'Right', 181),
(22, 4500000, 'Forward', 'Right', 184),
(23, 70000000, 'Midfielder', 'Right', 179),
(24, 60000000, 'Forward', 'Right', 180),
(25, 15000000, 'Midfielder', 'Right', 185),
(26, 65000000, 'Forward', 'Left', 175),
(27, 30000000, 'Defender', 'Right', 195),
(28, 65000000, 'Midfielder', 'Right', 176),
(29, 100000000, 'Forward', 'Right', 185),
(30, 30000000, 'Defender', 'Right', 187);

-- ==========================================
-- 4. MANAGERS (Alt Tablo)
-- ==========================================
INSERT INTO managers (manager_ID, preferred_formation, experience_level) VALUES
(2001, '4-2-3-1', 'Advanced'),
(2002, '4-2-3-1', 'Expert'),
(2003, '4-3-3', 'Intermediate'),
(2004, '4-3-3', 'Expert'),
(2005, '4-2-3-1', 'Advanced'),
(2006, '4-3-3', 'Expert');

-- ==========================================
-- 5. REFEREES (Alt Tablo)
-- ==========================================
INSERT INTO referees (referee_id, license_level, years_of_experience) VALUES
(1001, 'FIFA', 20),
(1002, 'FIFA', 12),
(1003, 'UEFA Elite', 15),
(1004, 'UEFA Elite', 18);

-- ==========================================
-- 6. STADIUMS
-- ==========================================
INSERT INTO stadiums (stadium_id, stadium_name, city, capacity) VALUES
(1, 'RAMS Park', 'Istanbul', 52223),
(2, 'Ülker Stadium', 'Istanbul', 50509),
(3, 'Tüpraş Stadium', 'Istanbul', 41903),
(4, 'Old Trafford', 'Manchester', 74310),
(5, 'Anfield', 'Liverpool', 53394);

-- ==========================================
-- 7. CLUBS
-- ==========================================
INSERT INTO clubs (club_id, club_name, foundation_year, stadium_id, manager_id) VALUES
(1, 'Galatasaray', 1905, 1, 2001),
(2, 'Fenerbahçe', 1907, 2, 2002),
(3, 'Beşiktaş', 1903, 3, 2003),
(4, 'Manchester United', 1878, 4, 2004),
(5, 'Liverpool', 1892, 5, NULL);

-- ==========================================
-- 8. COMPETITIONS
-- ==========================================
INSERT INTO competitions (competition_id, name, season, country, competition_type) VALUES
(1, 'Süper Lig', '2025/2026', 'Türkiye', 'League'),
(2, 'Türkiye Kupası', '2025/2026', 'Türkiye', 'Cup'),
(3, 'Premier League', '2025/2026', 'England', 'League'),
(4, 'Süper Lig', '2024/2025', 'Türkiye', 'League');

-- ==========================================
-- 9. CONTRACTS
-- ==========================================
INSERT INTO contracts (contract_id, player_id, club_id, contract_type, weekly_wage, start_date, end_date) VALUES
(1, 1, 1, 'Permanent', 150000, '2024-08-15', '2027-06-30'),
(2, 2, 1, 'Permanent', 80000, '2023-08-01', '2026-06-30'),
(3, 3, 1, 'Permanent', 75000, '2023-07-15', '2027-06-30'),
(4, 4, 1, 'Permanent', 60000, '2022-07-01', '2027-06-30'),
(5, 5, 1, 'Permanent', 90000, '2024-08-01', '2027-06-30'),
(6, 6, 1, 'Permanent', 100000, '2023-07-01', '2028-06-30'),
(8, 8, 1, 'Permanent', 70000, '2022-09-01', '2027-06-30'),
(9, 9, 1, 'Permanent', 85000, '2023-07-20', '2027-06-30'),
(10, 10, 1, 'Permanent', 65000, '2023-08-10', '2026-06-30'),
(11, 11, 1, 'Permanent', 55000, '2024-07-15', '2026-06-30'),
(12, 12, 1, 'Permanent', 70000, '2021-07-01', '2025-06-30'),
(13, 13, 1, 'Permanent', 50000, '2024-01-15', '2026-06-30'),
(14, 14, 2, 'Permanent', 120000, '2024-07-15', '2026-06-30'),
(15, 15, 2, 'Permanent', 95000, '2023-07-10', '2027-06-30'),
(16, 16, 2, 'Permanent', 30000, '2023-08-01', '2027-06-30'),
(17, 17, 2, 'Permanent', 50000, '2021-08-15', '2026-06-30'),
(18, 18, 2, 'Permanent', 85000, '2023-08-20', '2027-06-30'),
(19, 19, 2, 'Permanent', 90000, '2024-08-01', '2027-06-30'),
(20, 20, 3, 'Permanent', 110000, '2024-07-01', '2027-06-30'),
(21, 21, 3, 'Permanent', 80000, '2022-07-15', '2026-06-30'),
(22, 22, 3, 'Permanent', 75000, '2023-01-20', '2025-06-30'),
(23, 23, 4, 'Permanent', 250000, '2020-01-30', '2027-06-30'),
(24, 24, 4, 'Permanent', 200000, '2016-07-01', '2028-06-30'),
(25, 25, 4, 'Permanent', 180000, '2022-08-22', '2026-06-30'),
(26, 26, 5, 'Permanent', 350000, '2017-07-01', '2025-06-30'),
(27, 27, 5, 'Permanent', 220000, '2018-01-01', '2026-06-30'),
(28, 28, 5, 'Permanent', 150000, '2023-06-08', '2028-06-30'),
(29, 29, 1, 'Loan', 120000, '2025-09-01', '2026-06-30'),
(30, 7, 1, 'Loan', 60000, '2025-07-01', '2026-06-30');

-- ==========================================
-- 10. TRANSFER RECORDS
-- ==========================================
INSERT INTO transfer_records (transfer_id, player_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type) VALUES
(1, 1, 5, 1, '2024-08-15', 25000000, 'Purchase'),
(2, 1, NULL, 5, '2022-08-01', 30000000, 'Purchase'),
(3, 14, 1, 2, '2024-07-15', 3000000, 'Purchase'),
(4, 14, NULL, 1, '2023-08-15', 0, 'Free'),
(5, 2, NULL, 1, '2023-08-01', 10000000, 'Purchase'),
(6, 7, 4, 1, '2025-07-01', 2000000, 'Loan'),
(7, 29, NULL, 1, '2025-09-01', 1500000, 'Loan'),
(8, 19, NULL, 2, '2024-08-01', 16000000, 'Purchase'),
(9, 20, NULL, 3, '2024-07-01', 10000000, 'Purchase');

-- ==========================================
-- 11. MATCHES
-- ==========================================
INSERT INTO matches (match_id, match_date, match_time, stadium_id, home_club_id, away_club_id, referee_id, competition_id, home_goals, away_goals, attendance) VALUES
(1, '2025-09-20', '19:00:00', 1, 1, 2, 1001, 1, 2, 1, 51000),
(2, '2025-10-04', '20:00:00', 2, 2, 3, 1002, 1, 1, 1, 49000),
(3, '2025-10-25', '20:00:00', 3, 3, 1, 1001, 1, 0, 2, 41000),
(4, '2025-11-15', '19:00:00', 1, 1, 3, 1002, 1, 3, 0, 60000),
(5, '2025-12-06', '20:00:00', 2, 2, 1, 1001, 1, 2, 2, 50000),
(6, '2026-02-14', '20:00:00', 3, 3, 2, 1002, 1, 1, 2, 40000),
(7, '2025-10-19', '17:30:00', 5, 5, 4, 1003, 3, 3, 1, 53000),
(8, '2026-02-22', '16:30:00', 4, 4, 5, 1004, 3, 1, 1, 73000);

-- ==========================================
-- 12. MATCH STATS
-- ==========================================
INSERT INTO match_stats (match_id, player_id, club_id, is_starter, minutes_played, position_played, goals, assists, yellow_cards, red_cards, rating) VALUES
-- Match 1 Stats
(1, 4, 1, TRUE, 90, 'GK', 0, 0, 0, 0, 7.4),
(1, 3, 1, TRUE, 90, 'CB', 0, 0, 0, 0, 7.0),
(1, 10, 1, TRUE, 90, 'CB', 0, 0, 1, 0, 6.8),
(1, 9, 1, TRUE, 90, 'RB', 0, 1, 0, 0, 7.5),
(1, 13, 1, TRUE, 90, 'LB', 0, 0, 0, 0, 6.9),
(1, 2, 1, TRUE, 90, 'CDM', 0, 0, 0, 0, 7.6),
(1, 8, 1, TRUE, 90, 'CM', 0, 0, 0, 0, 7.1),
(1, 5, 1, TRUE, 90, 'RW', 1, 0, 0, 0, 8.2),
(1, 6, 1, TRUE, 90, 'LW', 0, 1, 0, 0, 7.7),
(1, 12, 1, TRUE, 90, 'AM', 0, 0, 0, 0, 7.0),
(1, 1, 1, TRUE, 90, 'ST', 1, 0, 0, 0, 8.0),
(1, 11, 1, FALSE, 5, 'ST', 0, 0, 0, 0, 7.2),
(1, 16, 2, TRUE, 90, 'GK', 0, 0, 0, 0, 6.8),
(1, 17, 2, TRUE, 90, 'RB', 0, 0, 1, 0, 6.5),
-- Match 19 (Örnek Kısa Kesit)
(19, 15, 2, TRUE, 90, 'AM', 0, 0, 0, 0, 6.8),
(19, 19, 2, TRUE, 90, 'LW', 0, 0, 0, 0, 6.4),
(19, 17, 2, TRUE, 90, 'RB', 0, 0, 0, 0, 6.5),
-- Match 20 Stats
(20, 1, 1, TRUE, 90, 'ST', 1, 0, 0, 0, 8.0),
(20, 4, 1, TRUE, 90, 'GK', 0, 0, 0, 0, 7.2),
(20, 10, 1, TRUE, 90, 'CB', 0, 0, 1, 0, 6.5),
(20, 6, 1, TRUE, 90, 'LW', 0, 0, 0, 0, 7.4),
(20, 5, 1, TRUE, 90, 'RW', 0, 1, 0, 0, 7.6),
(20, 9, 1, TRUE, 90, 'RB', 0, 0, 0, 0, 7.1),
(20, 3, 1, TRUE, 90, 'CB', 0, 0, 0, 0, 7.0),
(20, 13, 1, TRUE, 90, 'LB', 0, 0, 0, 0, 6.8),
(20, 8, 1, TRUE, 90, 'CM', 0, 0, 0, 0, 7.2),
(20, 12, 1, TRUE, 90, 'AM', 0, 0, 0, 0, 7.0),
(20, 11, 1, TRUE, 90, 'ST', 0, 0, 0, 0, 6.9);