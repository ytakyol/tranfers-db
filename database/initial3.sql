-- ============================================================
-- TransferDB Initial Data Seed - Reformatted for New Schema
-- Converted from initial2.sql to match new_schema.sql
-- ============================================================

DROP DATABASE IF EXISTS transfer_db;
CREATE DATABASE transfer_db;
USE transfer_db;

SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------
-- 1. Stadiums
-- -------------------------------------------------------
INSERT INTO stadiums (stadium_ID, stadium_name, city, capacity) VALUES
  (1, 'RAMS Park',      'Istanbul',   52223),
  (2, 'Ülker Stadium',  'Istanbul',   50509),
  (3, 'Tüpraş Stadium', 'Istanbul',   41903),
  (4, 'Old Trafford',   'Manchester', 74310),
  (5, 'Anfield',        'Liverpool',  53394);

-- -------------------------------------------------------
-- 2. Persons (combines Person and auth_user)
-- -------------------------------------------------------
INSERT INTO persons (person_ID, username, password, name, surname, nationality, date_of_birth) VALUES
  -- Players
  (1,  'mauro_icardi',     '$2b$12$OFakmg9yVtkkQSFkUJGijeGeIOpnZJpGn4w5CdGm4vyR.UeHBKCUq', 'Mauro',      'Icardi',         'Argentina',   '1993-02-19'),
  (2,  'lucas_torreira',   '$2b$12$rbl.tcUNk3tOoH/EcceP5exeeLwb8lyKq31F8J6kD/oDQsPNEGSqy', 'Lucas',      'Torreira',       'Uruguay',     '1996-02-11'),
  (3,  'davinson_sanchez', '$2b$12$DSq7ER5Lq1.v.IzGfoZpsuR1JFIsZK9r1wIvAwrGg6telVOXYSAJm', 'Davinson',   'Sánchez',        'Colombia',    '1996-06-12'),
  (4,  'fernando_muslera', '$2b$12$ebEjLmOBvOjIEb8VaRxzJeLotRyRKVF9n1ERFFfdXLLqOc.EyHjIu', 'Fernando',   'Muslera',        'Uruguay',     '1986-06-16'),
  (5,  'hakim_ziyech',     '$2b$12$Efy1Oapf3JvNoyhUdxsaAeW3Xq4cUuDCrXePHUMvm0wWqolYYAicO', 'Hakim',      'Ziyech',         'Morocco',     '1993-03-19'),
  (6,  'kerem_akturkoglu', '$2b$12$XdbSAXyU77XYKvqi4fe81ueXDrZ54UWHNjneduwqE4gIhp0FUKmrS', 'Kerem',      'Aktürkoğlu',     'Türkiye',     '1998-10-21'),
  (7,  'tete_bra',         '$2b$12$s3KoVYlCEObhsrGAj9BXSe4wwv5LsGdjvKCo7OlJZxJWp/CBUSAey', 'Tetê',       'Mota',           'Brazil',      '2000-02-13'),
  (8,  'yunus_akgun',      '$2b$12$jmND.xU3Yrle0BCz2zkuke2uYuVbuf68NJBP4ylLSUlHVvL1mFuo.', 'Yunus',      'Akgün',          'Türkiye',     '2000-07-07'),
  (9,  'sacha_boey',       '$2b$12$ugt2Vrs6dngIX0GnGXpgle4H2RnymZbdw46inECfuehaBGXWVYkLi', 'Sacha',      'Boey',           'France',      '2000-09-13'),
  (10, 'abdulkerim_b',     '$2b$12$v88hlwewlj5XkP4lsw068e5cNS.19BHG29QwqzE/WxC2lfQ2Q6zg.', 'Abdülkerim', 'Bardakcı',       'Türkiye',     '1995-09-07'),
  (11, 'dries_mertens',    '$2b$12$tkWZVeePaOVskvHGIe871e8oFCdW/pONo06tJaPCW6Rs6VQa5tVJK', 'Dries',      'Mertens',        'Belgium',     '1987-05-06'),
  (12, 'wilfried_zaha',    '$2b$12$riMjCL9xuMHYn8lgpjkAxeiOdV4PTxSkXCa02cLZ/TzlfVnjgklrq', 'Wilfried',   'Zaha',           'Türkiye',     '1992-11-10'),
  (13, 'kaan_ayhan',       '$2b$12$Cdkc4dOhN/CxtbZxe.PBJeGSmokopqtXIDQ4O6YumfPKHsoI4Edja', 'Kaan',       'Ayhan',          'Türkiye',     '1995-03-10'),
  (14, 'edin_dzeko',       '$2b$12$0WqqdZm5YoCZjs4UnHu4FOIQjJplPH9Gy8Av8k9cQMxn1CcXR9K2.', 'Edin',       'Džeko',          'Bosnia',      '1986-03-17'),
  (15, 'dusan_tadic',      '$2b$12$EX7hfTgQIwn/3oR.Ufx.UehHJmLSNnd2cBSJRVb26gu8HLNe9dK3q', 'Dušan',      'Tadić',          'Serbia',      '1988-11-20'),
  (16, 'irfan_can_e',      '$2b$12$TTHMA0chFNjKPZWtnyQ6A.YQzvdjBhEEAeCf8xs1gs4LRRaGQClS6', 'İrfan Can',  'Eğribayat',      'Türkiye',     '1998-06-30'),
  (17, 'bright_o_samuel',  '$2b$12$cMj0xw6AKVwetFvXEVZ00OP2NK2CV7R/rv6mU0hYJG0BZ26q3p.r6', 'Bright',     'Osayi-Samuel',   'Nigeria',     '1997-12-31'),
  (18, 'sebastian_szym',   '$2b$12$kKKCjVTWroKFbTz6CZGaiOW.uKxmm0Y29ziJIq8wkdn0QdgPw/K/m', 'Sebastian',  'Szymański',      'Poland',      '1999-05-10'),
  (19, 'cengiz_under',     '$2b$12$mVxuE6YzH8l8Oy2yFMh.P.vF4SMAEI4NXqs1zFnoOx3ykbLS85QfO', 'Cengiz',     'Ünder',          'Türkiye',     '1997-07-14'),
  (20, 'rafa_silva',       '$2b$12$7ALR9lC4wyj.3lXtGct4t.bepvoEZOGjtccD2Cph1OPfP0mzdDYoS', 'Rafa',       'Silva',          'Portugal',    '1993-05-17'),
  (21, 'vincent_abou',     '$2b$12$yoWD9GSRV5epmeQr1nF/r.VwHqHHtoQE06vWo9aA7IVXxJv7WFHrO', 'Vincent',    'Aboubakar',      'Cameroon',    '1992-01-22'),
  (22, 'mert_gunok',       '$2b$12$Zv4FIXE.uWqdMP.Z/a2koup/HK04Vp.mDvA3.N2JfFo3GTy64iE/C', 'Mert',       'Günok',          'Türkiye',     '1989-03-01'),
  (23, 'ernest_muci',      '$2b$12$N22DVAdIv3wY64eHc5kTO.AaWQt/Ph6mEdKlp87qKmFSQy.vNcGoy', 'Ernest',     'Muçi',           'Albania',     '2001-03-19'),
  (24, 'bruno_fernandes',  '$2b$12$aow8ZvXORU9QLh7lacwJ/.OhuM/aHsfomrcvdrm1h3rWTuNTLSb5S', 'Bruno',      'Fernandes',      'Portugal',    '1994-09-08'),
  (25, 'marcus_rashford',  '$2b$12$KQ1ItDUvWpYUg9xpzt7ZFuRdSM4ISQyRIRpnhqQAzclh5trLDUJRm', 'Marcus',     'Rashford',       'England',     '1997-10-31'),
  (26, 'andre_onana',      '$2b$12$AIGaqaAU8YT0arCi1Khk8eJjbebzR8YvK/udJqvmPoxbrRd.s1Ulq', 'André',      'Onana',          'Cameroon',    '1996-04-02'),
  (27, 'mohamed_salah',    '$2b$12$JxvABTeNGTEB60yqPH/5j.dorVWyIrkkoLdk7uOJJIyH9ixiZpDAq', 'Mohamed',    'Salah',          'Egypt',       '1992-06-15'),
  (28, 'virgil_van_dijk',  '$2b$12$QsFrKfkQIsy97gXZetEYxeU/1HyVKA2K9Qah9Yhc9qcNTpnVMf3PC', 'Virgil',     'van Dijk',       'Netherlands', '1991-07-08'),
  (29, 'andreas_christ',   '$2b$12$WMtoJlgVgbeZL52VALXAFucJCh8Wv27mz4zWTe08QwKnynklSaCMG', 'Andreas',    'Christensen',    'Denmark',     '1996-04-10'),
  -- Referees
  (1001, 'cuneyt_cakir',     '$2b$12$Nt2bvqpc6iD4ery0Gx9qoOc.7klxnLZvRaRIiA3TbeHfHJctgngaO', 'Cüneyt',     'Çakır',          'Türkiye',     '1976-11-23'),
  (1002, 'halil_meler',      '$2b$12$oLU.oACwBrqmvlML4NwdbuuTauZfqptAcOZ7iH6DLd3qbxEhlrTS.', 'Halil',      'Meler',          'Türkiye',     '1986-08-22'),
  (1003, 'michael_oliver',   '$2b$12$e5GkQ1m0Oueqajwhu8UX8OeNNvMY1A.pVdku8NcQC5ZSGZqx4UJte', 'Michael',    'Oliver',         'England',     '1985-02-20'),
  (1004, 'anthony_taylor',   '$2b$12$OZD.kerjGZV7ysh9Zs7xkeRCl1SY6ZQm0QHSIha0LHYx2pWedlsLG', 'Anthony',    'Taylor',         'England',     '1978-10-20'),
  -- Managers
  (2001, 'okan_buruk',       '$2b$12$FJ8gkU0aMT9r53vBgONxzOImnJIpAvCaxXTPoLkEkASGUMmP8g2fy', 'Okan',       'Buruk',          'Türkiye',     '1973-10-19'),
  (2002, 'jose_mourinho',    '$2b$12$Zdy8CEpVNeMCkYJfzdao5ed1IaqXu5oyFTooAiXSkG430jH0y24OS', 'José',       'Mourinho',       'Portugal',    '1963-01-26'),
  (2003, 'ole_solskjaer',    '$2b$12$Nh50AF8n2VcFp.jP0r9qDOFDfipkB5cll00/AxlBn69HrB4Bfka2S', 'Ole',        'Solskjær',       'Norway',      '1973-02-26'),
  (2004, 'erik_ten_hag',     '$2b$12$r73U7TFymSq.IgdnBHuNiO79MkxCB/opa4uK02Py.XJNOWt3x95bm', 'Erik',       'ten Hag',        'Netherlands', '1970-02-02'),
  (2005, 'arne_slot',        '$2b$12$OaZOPrwUAV3OQyb9rrYzOeGY4XAKH98s00vDv21Jpm63DlilN2lXa', 'Arne',       'Slot',           'Netherlands', '1978-09-17'),
  (2006, 'carlo_ancelotti',  '$2b$12$wOiOhPdbcHkhXP/n8ikhv.Lg/ifvsova7umsfp6BfptmiUDVxypZ2', 'Carlo',      'Ancelotti',      'Italy',       '1959-06-10');

-- -------------------------------------------------------
-- 3. DB Managers
-- -------------------------------------------------------
INSERT INTO db_managers (username, password) VALUES
  ('kevin',  '$2b$12$GsuvwksiixmmuJBCZqSiNOMsHNXU7u79NZHlDJPEJOxUfgKNyf3Fe'),
  ('bob',    '$2b$12$P2jXkR/JuoGfQS1qD7qw3OjIWynK2EQGRxPnvOjjno4R2Zohk8Z7K'),
  ('maria',  '$2b$12$XiEEyrVSctcnoiDWYPxMK.tter7LPZ0aKMhcU2/F7fEA.OPkYM1lC');

-- -------------------------------------------------------
-- 4. Players
-- -------------------------------------------------------
INSERT INTO players (person_ID, market_value, strong_foot, height, main_position) VALUES
  (1,  12000000,  'Right', 184, 'Forward'),
  (2,  15000000,  'Right', 168, 'Midfielder'),
  (3,  20000000,  'Right', 187, 'Defender'),
  (4,  1500000,   'Right', 190, 'Goalkeeper'),
  (5,  12000000,  'Left',  181, 'Forward'),
  (6,  18000000,  'Right', 173, 'Forward'),
  (7,  8000000,   'Right', 172, 'Forward'),
  (8,  10000000,  'Right', 178, 'Midfielder'),
  (9,  22000000,  'Right', 180, 'Defender'),
  (10, 12000000,  'Left',  192, 'Defender'),
  (11, 3000000,   'Right', 169, 'Forward'),
  (12, 12000000,  'Right', 180, 'Forward'),
  (13, 7000000,   'Right', 184, 'Defender'),
  (14, 3500000,   'Right', 193, 'Forward'),
  (15, 4000000,   'Left',  181, 'Midfielder'),
  (16, 6000000,   'Right', 188, 'Goalkeeper'),
  (17, 12000000,  'Right', 174, 'Defender'),
  (18, 22000000,  'Right', 175, 'Midfielder'),
  (19, 16000000,  'Left',  173, 'Forward'),
  (20, 10000000,  'Right', 173, 'Midfielder'),
  (21, 5000000,   'Right', 184, 'Forward'),
  (22, 4000000,   'Right', 195, 'Goalkeeper'),
  (23, 8000000,   'Right', 174, 'Forward'),
  (24, 65000000,  'Right', 179, 'Midfielder'),
  (25, 45000000,  'Right', 180, 'Forward'),
  (26, 30000000,  'Right', 190, 'Goalkeeper'),
  (27, 60000000,  'Left',  175, 'Forward'),
  (28, 40000000,  'Right', 193, 'Defender'),
  (29, 18000000,  'Right', 187, 'Defender');

-- -------------------------------------------------------
-- 5. Referees
-- -------------------------------------------------------
INSERT INTO referees (person_ID, license_level, years_of_experience) VALUES
  (1001, 'FIFA',       20),
  (1002, 'FIFA',       12),
  (1003, 'UEFA Elite', 15),
  (1004, 'UEFA Elite', 18);

-- -------------------------------------------------------
-- 6. Managers
-- -------------------------------------------------------
INSERT INTO managers (person_ID, preferred_formation, experience_level) VALUES
  (2001, '4-2-3-1', 'Advanced'),
  (2002, '4-2-3-1', 'Expert'),
  (2003, '4-3-3',   'Intermediate'),
  (2004, '4-3-3',   'Expert'),
  (2005, '4-2-3-1', 'Advanced'),
  (2006, '4-3-3',   'Expert');

-- -------------------------------------------------------
-- 7. Clubs
-- -------------------------------------------------------
INSERT INTO clubs (club_ID, club_name, foundation_year, manager_ID, stadium_ID) VALUES
  (1, 'Galatasaray',       1905, 2001, 1),
  (2, 'Fenerbahçe',        1907, 2002, 2),
  (3, 'Beşiktaş',          1903, 2003, 3),
  (4, 'Manchester United', 1878, 2004, 4),
  (5, 'Liverpool',         1892, NULL, 5);

-- -------------------------------------------------------
-- 8. Competitions
-- -------------------------------------------------------
INSERT INTO competitions (competition_ID, name, season, country, competition_type) VALUES
  (1, 'Süper Lig',      '2025/2026', 'Türkiye', 'League'),
  (2, 'Türkiye Kupası', '2025/2026', 'Türkiye', 'Cup'),
  (3, 'Premier League', '2025/2026', 'England', 'League'),
  (4, 'Süper Lig',      '2024/2025', 'Türkiye', 'League');

-- -------------------------------------------------------
-- 9. Participates (ClubsInCompetition)
-- -------------------------------------------------------
INSERT INTO participates (club_ID, competition_ID) VALUES
  -- Süper Lig 2025/2026 (comp 1)
  (1, 1), (2, 1), (3, 1),
  -- Türkiye Kupası 2025/2026 (comp 2)
  (1, 2), (2, 2), (3, 2),
  -- Premier League 2025/2026 (comp 3)
  (4, 3), (5, 3),
  -- Süper Lig 2024/2025 (comp 4)
  (1, 4), (2, 4), (3, 4);

-- -------------------------------------------------------
-- 10. Contracts
-- Note: contract_id 7 intentionally absent (not in source data).
-- Contracts 31, 32 are planted invalids loaded before triggers.
-- -------------------------------------------------------
INSERT INTO contracts (contract_id, player_id, club_id, contract_type, weekly_wage, start_date, end_date) VALUES
  -- Galatasaray active contracts
  (1,  1,  1, 'Permanent', 150000, '2024-08-15', '2027-06-30'),
  (2,  2,  1, 'Permanent',  80000, '2023-08-01', '2026-06-30'),
  (3,  3,  1, 'Permanent',  75000, '2023-07-15', '2027-06-30'),
  (4,  4,  1, 'Permanent',  60000, '2022-07-01', '2027-06-30'),
  (5,  5,  1, 'Permanent',  90000, '2024-08-01', '2027-06-30'),
  (6,  6,  1, 'Permanent', 100000, '2023-07-01', '2028-06-30'),
  (8,  8,  1, 'Permanent',  70000, '2022-09-01', '2027-06-30'),
  (9,  9,  1, 'Permanent',  85000, '2023-07-20', '2027-06-30'),
  (10, 10, 1, 'Permanent',  65000, '2023-08-10', '2026-06-30'),
  (11, 11, 1, 'Permanent',  55000, '2024-07-15', '2026-06-30'),
  (12, 12, 1, 'Permanent',  70000, '2023-09-01', '2026-06-30'),
  (13, 13, 1, 'Permanent',  50000, '2023-07-15', '2026-06-30'),
  -- Tetê: Permanent at MU, on Loan at GS
  (14, 7,  4, 'Permanent',  80000, '2023-07-01', '2027-06-30'),
  (15, 7,  1, 'Loan',       40000, '2025-07-01', '2026-06-30'),
  -- Fenerbahçe active contracts
  (16, 14, 2, 'Permanent',  95000, '2024-07-15', '2026-06-30'),
  (17, 15, 2, 'Permanent', 100000, '2023-07-01', '2026-06-30'),
  (18, 16, 2, 'Permanent',  55000, '2022-07-01', '2027-06-30'),
  (19, 17, 2, 'Permanent',  65000, '2021-07-01', '2026-06-30'),
  (20, 18, 2, 'Permanent', 110000, '2023-07-15', '2028-06-30'),
  (21, 19, 2, 'Permanent',  80000, '2024-08-01', '2027-06-30'),
  -- Beşiktaş active contracts
  (22, 20, 3, 'Permanent',  90000, '2024-07-01', '2027-06-30'),
  (23, 21, 3, 'Permanent',  60000, '2024-08-01', '2026-06-30'),
  (24, 22, 3, 'Permanent',  55000, '2022-08-01', '2026-06-30'),
  (25, 23, 3, 'Permanent',  70000, '2023-09-01', '2027-06-30'),
  -- Manchester United active contracts
  (26, 24, 4, 'Permanent', 300000, '2020-01-15', '2027-06-30'),
  (27, 25, 4, 'Permanent', 250000, '2018-07-01', '2027-06-30'),
  (28, 26, 4, 'Permanent', 120000, '2023-07-01', '2028-06-30'),
  -- Liverpool active contracts
  (29, 27, 5, 'Permanent', 400000, '2017-07-01', '2027-06-30'),
  (30, 28, 5, 'Permanent', 350000, '2018-01-01', '2027-06-30'),
  -- PLANTED INVALID (a): Icardi's 2nd active Permanent at MU
  (31, 1,  4, 'Permanent', 180000, '2025-08-01', '2027-08-01'),
  -- PLANTED INVALID (b): Christensen has only a Loan at GS; no Permanent anywhere
  (32, 29, 1, 'Loan',       50000, '2025-09-01', '2026-06-30'),
  -- Expired historical contracts
  (33, 1,  5, 'Permanent', 150000, '2022-08-01', '2024-08-14'),
  (34, 14, 1, 'Permanent',  90000, '2023-08-15', '2024-07-14');

-- -------------------------------------------------------
-- 11. Transfer_Record
-- Transfer 7 is a planted invalid: Loan with NULL from_club_id
-- -------------------------------------------------------
INSERT INTO transfer_record (transfer_id, player_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type) VALUES
  (1, 1,  5,    1, '2024-08-15', 25000000, 'Purchase'),
  (2, 1,  NULL, 5, '2022-08-01', 30000000, 'Purchase'),
  (3, 14, 1,    2, '2024-07-15',  3000000, 'Purchase'),
  (4, 14, NULL, 1, '2023-08-15',        0, 'Free'),
  (5, 2,  NULL, 1, '2023-08-01', 10000000, 'Purchase'),
  (6, 7,  4,    1, '2025-07-01',  2000000, 'Loan'),
  -- PLANTED INVALID (c): Loan transfer with NULL from_club_id
  (7, 29, NULL, 1, '2025-09-01',  1500000, 'Loan'),
  (8, 19, NULL, 2, '2024-08-01', 16000000, 'Purchase'),
  (9, 20, NULL, 3, '2024-07-01', 10000000, 'Purchase');

-- -------------------------------------------------------
-- 12. Matches (from FootballMatch)
-- PLANTED INVALID (e): Match 4 attendance exceeds RAMS Park capacity
-- PLANTED INVALID (f): Matches 15 & 16 have stadium/club conflicts
-- PLANTED INVALID (g): Matches 17 & 18 have referee conflicts
-- -------------------------------------------------------
INSERT INTO matches (match_ID, competition_ID, home_club_ID, away_club_ID, stadium_ID, match_datetime, home_goals, away_goals, attendance, referee_ID) VALUES
  -- Past matches with results
  (1,  1, 1, 2, 1, '2025-09-20 19:00:00',  2,    1,    51000, 1001),
  (2,  1, 2, 3, 2, '2025-10-04 20:00:00',  1,    1,    49000, 1002),
  (3,  1, 3, 1, 3, '2025-10-25 20:00:00',  0,    2,    41000, 1001),
  -- PLANTED INVALID (e): attendance 60000 exceeds RAMS Park capacity 52223
  (4,  1, 1, 3, 1, '2025-11-15 19:00:00',  3,    0,    60000, 1002),
  (5,  1, 2, 1, 2, '2025-12-06 20:00:00',  2,    2,    50000, 1001),
  (6,  1, 3, 2, 3, '2026-02-14 20:00:00',  1,    2,    40000, 1002),
  (7,  3, 5, 4, 5, '2025-10-19 17:30:00',  3,    1,    53000, 1003),
  (8,  3, 4, 5, 4, '2026-02-22 16:30:00',  1,    1,    73000, 1004),
  (9,  2, 1, 3, 1, '2025-11-22 21:00:00',  1,    0,    50000, 1002),
  (10, 4, 1, 2, 1, '2025-04-12 20:00:00',  1,    1,    51000, 1001),
  -- Future matches (no result yet)
  (11, 3, 5, 4, 5, '2026-04-25 18:00:00',  NULL, NULL, NULL,  1003),
  (12, 1, 1, 2, 1, '2026-05-25 20:00:00',  NULL, NULL, NULL,  1001),
  (13, 1, 1, 3, 1, '2026-06-10 20:00:00',  NULL, NULL, NULL,  1002),
  (14, 1, 2, 3, 2, '2026-06-20 19:00:00',  NULL, NULL, NULL,  1003),
  -- PLANTED INVALID (f): Matches 15 & 16 – same stadium within 60 min with club conflict
  (15, 2, 1, 3, 1, '2025-09-30 14:00:00',  2,    0,    45000, 1001),
  (16, 2, 2, 1, 1, '2025-09-30 15:00:00',  1,    1,    46000, 1002),
  -- PLANTED INVALID (g): Matches 17 & 18 – referee 1003 assigned within 120 min
  (17, 3, 4, 5, 4, '2025-11-10 19:00:00',  2,    1,    70000, 1003),
  (18, 1, 1, 2, 1, '2025-11-10 19:30:00',  1,    1,    49000, 1003);

-- -------------------------------------------------------
-- 13. Match_Stats
-- PLANTED INVALID (d): Match 1 – GS has 12 is_starter=TRUE entries
-- -------------------------------------------------------
INSERT INTO match_stats (player_ID, match_ID, club_ID, is_starter, minutes_played, position_in_match, goals, assists, yellow_cards, red_cards, rating) VALUES
  -- === Match 1: GS 2–1 FB (2025-09-20) ===
  -- GS: 12 starters – PLANTED INVALID (d)
  (4,  1, 1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.4),
  (3,  1, 1, TRUE, 90,  'CB',  0, 0, 0, FALSE, 7.0),
  (10, 1, 1, TRUE, 90,  'CB',  0, 0, 1, FALSE, 6.8),
  (9,  1, 1, TRUE, 90,  'RB',  0, 1, 0, FALSE, 7.5),
  (13, 1, 1, TRUE, 90,  'LB',  0, 0, 0, FALSE, 6.9),
  (2,  1, 1, TRUE, 90,  'CDM', 0, 0, 0, FALSE, 7.6),
  (8,  1, 1, TRUE, 90,  'CM',  0, 0, 0, FALSE, 7.1),
  (5,  1, 1, TRUE, 90,  'RW',  1, 0, 0, FALSE, 8.2),
  (6,  1, 1, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.7),
  (12, 1, 1, TRUE, 90,  'AM',  0, 0, 0, FALSE, 7.0),
  (1,  1, 1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 8.0),
  (11, 1, 1, TRUE, 85,  'ST',  0, 0, 0, FALSE, 7.2),
  -- FB
  (16, 1, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.8),
  (18, 1, 2, TRUE, 90,  'CB',  0, 0, 0, FALSE, 6.9),
  (19, 1, 2, TRUE, 90,  'CB',  0, 0, 1, FALSE, 7.1),
  (17, 1, 2, TRUE, 90,  'RB',  0, 0, 0, FALSE, 6.7),
  (20, 1, 2, TRUE, 90,  'LB',  0, 0, 0, FALSE, 7.0),
  (15, 1, 2, TRUE, 90,  'CDM', 0, 0, 0, FALSE, 7.2),
  (14, 1, 2, TRUE, 90,  'CM',  0, 0, 0, FALSE, 6.9),
  (21, 1, 2, FALSE, 0,  'RW',  0, 0, 0, FALSE, NULL),
  (23, 1, 2, FALSE, 0,  'LW',  0, 0, 0, FALSE, NULL),
  (14, 1, 2, TRUE, 90,  'AM',  0, 0, 0, FALSE, 7.4),
  (15, 1, 2, FALSE, 0,  'ST',  0, 0, 0, FALSE, NULL),
  (14, 1, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.8),
  -- Match 2: FB 1–1 BJK
  (16, 2, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (18, 2, 2, TRUE, 90,  'CB',  0, 0, 0, FALSE, 7.1),
  (19, 2, 2, TRUE, 90,  'CB',  0, 0, 0, FALSE, 6.8),
  (17, 2, 2, TRUE, 90,  'RB',  0, 0, 1, FALSE, 6.9),
  (20, 2, 2, TRUE, 90,  'LB',  0, 0, 0, FALSE, 7.0),
  (15, 2, 2, TRUE, 90,  'CDM', 0, 0, 0, FALSE, 7.2),
  (14, 2, 2, TRUE, 90,  'CM',  0, 0, 0, FALSE, 7.1),
  (21, 2, 2, TRUE, 90,  'RW',  0, 0, 0, FALSE, 6.8),
  (23, 2, 2, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.5),
  (14, 2, 2, TRUE, 90,  'AM',  0, 0, 0, FALSE, 6.9),
  (15, 2, 2, FALSE, 0,  'ST',  0, 0, 0, FALSE, NULL),
  (14, 2, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.3),
  (22, 2, 3, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.2),
  (13, 2, 3, TRUE, 90,  'CB',  0, 0, 0, FALSE, 7.0),
  (20, 2, 3, TRUE, 90,  'CB',  0, 0, 0, FALSE, 6.9),
  (17, 2, 3, TRUE, 90,  'RB',  0, 0, 0, FALSE, 7.0),
  (17, 2, 3, TRUE, 90,  'LB',  0, 0, 0, FALSE, 6.8),
  (8,  2, 3, TRUE, 90,  'CDM', 0, 0, 1, FALSE, 7.1),
  (2,  2, 3, TRUE, 90,  'CM',  0, 0, 0, FALSE, 7.3),
  (21, 2, 3, TRUE, 90,  'RW',  0, 0, 0, FALSE, 6.9),
  (12, 2, 3, TRUE, 90,  'LW',  1, 0, 0, FALSE, 7.6),
  (5,  2, 3, TRUE, 90,  'AM',  0, 0, 0, FALSE, 6.8),
  (20, 2, 3, FALSE, 0,  'ST',  0, 0, 0, FALSE, NULL);

SET FOREIGN_KEY_CHECKS = 1;
