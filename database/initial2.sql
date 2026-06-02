-- ============================================================
-- TransferDB  –  Initial data seed  (from TransferDB_Demo_Data.xlsx)
-- CMPE 321, Spring 2026
-- ============================================================
-- IMPORTANT: load BEFORE triggers and procedures so that
-- historical / pre-existing data is not blocked by forward-
-- looking constraints.
--
--   mysql -u root -p transferdb < initial_data_seed.sql
--   mysql -u root -p transferdb < 02_triggers.sql
--   mysql -u root -p transferdb < 03_procedures.sql
--
-- Planted invalid records (required by spec; do NOT remove):
--   (a) Contract 31  – Player 1 (Icardi) has a 2nd active Permanent at MU (club 4).
--       T4 prevents new occurrences.
--   (b) Contract 32  – Player 29 (Christensen) has only a Loan at GS; no Permanent.
--       T4 prevents new occurrences.
--   (c) Transfer 7   – Player 29 Loan with NULL from_club_id.
--       T10 prevents new occurrences.
--   (d) Match 1 stats – GS (club 1) has 12 is_starter=TRUE entries.
--       T7 prevents new occurrences.
--   (e) Match 4      – attendance 60000 exceeds RAMS Park capacity 52223.
--       T5/T6 prevent new occurrences.
--   (f) Matches 15 & 16 – same stadium (1) on 2025-09-30 at 14:00 and 15:00.
--       Also a club conflict: GS appears in both.  T5 prevents new occurrences.
--   (g) Matches 17 & 18 – referee 1003 (Oliver) assigned to two matches on
--       2025-11-10 at 19:00 and 19:30 (within 120 min).  T5 prevents new occurrences.
-- ============================================================

USE transfer_db;

SET FOREIGN_KEY_CHECKS = 0;

-- -------------------------------------------------------
-- 1. Stadiums
-- -------------------------------------------------------
INSERT INTO Stadium (stadium_ID, stadium_name, city, capacity) VALUES
  (1, 'RAMS Park',      'Istanbul',   52223),
  (2, 'Ülker Stadium',  'Istanbul',   50509),
  (3, 'Tüpraş Stadium', 'Istanbul',   41903),
  (4, 'Old Trafford',   'Manchester', 74310),
  (5, 'Anfield',        'Liverpool',  53394);

-- -------------------------------------------------------
-- 2. Person  (players 1–29, referees 1001–1004, managers 2001–2006)
-- -------------------------------------------------------
INSERT INTO Person (person_ID, name, surname, nationality, date_of_birth) VALUES
  -- Players
  (1,  'Mauro',      'Icardi',         'Argentina',   '1993-02-19'),
  (2,  'Lucas',      'Torreira',       'Uruguay',     '1996-02-11'),
  (3,  'Davinson',   'Sánchez',        'Colombia',    '1996-06-12'),
  (4,  'Fernando',   'Muslera',        'Uruguay',     '1986-06-16'),
  (5,  'Hakim',      'Ziyech',         'Morocco',     '1993-03-19'),
  (6,  'Kerem',      'Aktürkoğlu',     'Türkiye',     '1998-10-21'),
  (7,  'Tetê',       'Mota',           'Brazil',      '2000-02-13'),
  (8,  'Yunus',      'Akgün',          'Türkiye',     '2000-07-07'),
  (9,  'Sacha',      'Boey',           'France',      '2000-09-13'),
  (10, 'Abdülkerim', 'Bardakcı',       'Türkiye',     '1995-09-07'),
  (11, 'Dries',      'Mertens',        'Belgium',     '1987-05-06'),
  (12, 'Wilfried',   'Zaha',           'Türkiye',     '1992-11-10'),
  (13, 'Kaan',       'Ayhan',          'Türkiye',     '1995-03-10'),
  (14, 'Edin',       'Džeko',          'Bosnia',      '1986-03-17'),
  (15, 'Dušan',      'Tadić',          'Serbia',      '1988-11-20'),
  (16, 'İrfan Can',  'Eğribayat',      'Türkiye',     '1998-06-30'),
  (17, 'Bright',     'Osayi-Samuel',   'Nigeria',     '1997-12-31'),
  (18, 'Sebastian',  'Szymański',      'Poland',      '1999-05-10'),
  (19, 'Cengiz',     'Ünder',          'Türkiye',     '1997-07-14'),
  (20, 'Rafa',       'Silva',          'Portugal',    '1993-05-17'),
  (21, 'Vincent',    'Aboubakar',      'Cameroon',    '1992-01-22'),
  (22, 'Mert',       'Günok',          'Türkiye',     '1989-03-01'),
  (23, 'Ernest',     'Muçi',           'Albania',     '2001-03-19'),
  (24, 'Bruno',      'Fernandes',      'Portugal',    '1994-09-08'),
  (25, 'Marcus',     'Rashford',       'England',     '1997-10-31'),
  (26, 'André',      'Onana',          'Cameroon',    '1996-04-02'),
  (27, 'Mohamed',    'Salah',          'Egypt',       '1992-06-15'),
  (28, 'Virgil',     'van Dijk',       'Netherlands', '1991-07-08'),
  (29, 'Andreas',    'Christensen',    'Denmark',     '1996-04-10'),
  -- Referees
  (1001, 'Cüneyt',   'Çakır',          'Türkiye',     '1976-11-23'),
  (1002, 'Halil',    'Meler',          'Türkiye',     '1986-08-22'),
  (1003, 'Michael',  'Oliver',         'England',     '1985-02-20'),
  (1004, 'Anthony',  'Taylor',         'England',     '1978-10-20'),
  -- Managers
  (2001, 'Okan',     'Buruk',          'Türkiye',     '1973-10-19'),
  (2002, 'José',     'Mourinho',       'Portugal',    '1963-01-26'),
  (2003, 'Ole',      'Solskjær',       'Norway',      '1973-02-26'),
  (2004, 'Erik',     'ten Hag',        'Netherlands', '1970-02-02'),
  (2005, 'Arne',     'Slot',           'Netherlands', '1978-09-17'),
  (2006, 'Carlo',    'Ancelotti',      'Italy',       '1959-06-10');

-- -------------------------------------------------------
-- 3. Players
-- -------------------------------------------------------
INSERT INTO Player (player_ID, market_value, strong_foot, height, main_position) VALUES
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
-- 4. Referees
-- -------------------------------------------------------
INSERT INTO Referee (referee_ID, license_level, years_of_experience) VALUES
  (1001, 'FIFA',       20),
  (1002, 'FIFA',       12),
  (1003, 'UEFA Elite', 15),
  (1004, 'UEFA Elite', 18);

-- -------------------------------------------------------
-- 5. Managers
-- -------------------------------------------------------
INSERT INTO Manager (manager_ID, preferred_formation, experience_level) VALUES
  (2001, '4-2-3-1', 'Advanced'),
  (2002, '4-2-3-1', 'Expert'),
  (2003, '4-3-3',   'Intermediate'),
  (2004, '4-3-3',   'Expert'),
  (2005, '4-2-3-1', 'Advanced'),
  (2006, '4-3-3',   'Expert');

-- -------------------------------------------------------
-- 6. Clubs
-- -------------------------------------------------------
INSERT INTO Club (club_ID, club_name, foundation_year, stadium_name, city, manager_id) VALUES
  (1, 'Galatasaray',       1905, 'RAMS Park',      'Istanbul',   2001),
  (2, 'Fenerbahçe',        1907, 'Ülker Stadium',  'Istanbul',   2002),
  (3, 'Beşiktaş',          1903, 'Tüpraş Stadium', 'Istanbul',   2003),
  (4, 'Manchester United', 187a8, 'Old Trafford',   'Manchester', 2004),
  (5, 'Liverpool',         1892, 'Anfield',        'Liverpool',  NULL);

-- -------------------------------------------------------
-- 7. Competitions
-- -------------------------------------------------------
INSERT INTO Competition (competition_ID, name, season, country, competition_type) VALUES
  (1, 'Süper Lig',      '2025/2026', 'Türkiye', 'League'),
  (2, 'Türkiye Kupası', '2025/2026', 'Türkiye', 'Cup'),
  (3, 'Premier League', '2025/2026', 'England', 'League'),
  (4, 'Süper Lig',      '2024/2025', 'Türkiye', 'League');

-- -------------------------------------------------------
-- 8. ClubsInCompetition
-- -------------------------------------------------------
INSERT INTO ClubsInCompetition (club_ID, competition_ID) VALUES
  -- Süper Lig 2025/2026 (comp 1)
  (1, 1), (2, 1), (3, 1),
  -- Türkiye Kupası 2025/2026 (comp 2)
  (1, 2), (2, 2), (3, 2),
  -- Premier League 2025/2026 (comp 3)
  (4, 3), (5, 3),
  -- Süper Lig 2024/2025 (comp 4)
  (1, 4), (2, 4), (3, 4);

-- -------------------------------------------------------
-- 9. auth_user  (passwords are bcrypt-hashed from plaintext in Credentials sheet)
-- -------------------------------------------------------
INSERT INTO auth_user (username, pwd_hash, role, person_ID) VALUES
  -- DB Managers (person_ID = NULL – no Person record)
  ('kevin',            '$2b$12$GsuvwksiixmmuJBCZqSiNOMsHNXU7u79NZHlDJPEJOxUfgKNyf3Fe', 'db_manager', NULL),
  ('bob',              '$2b$12$P2jXkR/JuoGfQS1qD7qw3OjIWynK2EQGRxPnvOjjno4R2Zohk8Z7K', 'db_manager', NULL),
  ('maria',            '$2b$12$XiEEyrVSctcnoiDWYPxMK.tter7LPZ0aKMhcU2/F7fEA.OPkYM1lC', 'db_manager', NULL),
  -- Managers
  ('okan_buruk',       '$2b$12$FJ8gkU0aMT9r53vBgONxzOImnJIpAvCaxXTPoLkEkASGUMmP8g2fy', 'manager',    2001),
  ('jose_mourinho',    '$2b$12$Zdy8CEpVNeMCkYJfzdao5ed1IaqXu5oyFTooAiXSkG430jH0y24OS', 'manager',    2002),
  ('ole_solskjaer',    '$2b$12$Nh50AF8n2VcFp.jP0r9qDOFDfipkB5cll00/AxlBn69HrB4Bfka2S', 'manager',    2003),
  ('erik_ten_hag',     '$2b$12$r73U7TFymSq.IgdnBHuNiO79MkxCB/opa4uK02Py.XJNOWt3x95bm', 'manager',    2004),
  ('arne_slot',        '$2b$12$OaZOPrwUAV3OQyb9rrYzOeGY4XAKH98s00vDv21Jpm63DlilN2lXa', 'manager',    2005),
  ('carlo_ancelotti',  '$2b$12$wOiOhPdbcHkhXP/n8ikhv.Lg/ifvsova7umsfp6BfptmiUDVxypZ2', 'manager',    2006),
  -- Referees
  ('cuneyt_cakir',     '$2b$12$Nt2bvqpc6iD4ery0Gx9qoOc.7klxnLZvRaRIiA3TbeHfHJctgngaO', 'referee',   1001),
  ('halil_meler',      '$2b$12$oLU.oACwBrqmvlML4NwdbuuTauZfqptAcOZ7iH6DLd3qbxEhlrTS.', 'referee',   1002),
  ('michael_oliver',   '$2b$12$e5GkQ1m0Oueqajwhu8UX8OeNNvMY1A.pVdku8NcQC5ZSGZqx4UJte', 'referee',   1003),
  ('anthony_taylor',   '$2b$12$OZD.kerjGZV7ysh9Zs7xkeRCl1SY6ZQm0QHSIha0LHYx2pWedlsLG', 'referee',   1004),
  -- Players
  ('mauro_icardi',     '$2b$12$OFakmg9yVtkkQSFkUJGijeGeIOpnZJpGn4w5CdGm4vyR.UeHBKCUq', 'player',    1),
  ('lucas_torreira',   '$2b$12$rbl.tcUNk3tOoH/EcceP5exeeLwb8lyKq31F8J6kD/oDQsPNEGSqy', 'player',    2),
  ('davinson_sanchez', '$2b$12$DSq7ER5Lq1.v.IzGfoZpsuR1JFIsZK9r1wIvAwrGg6telVOXYSAJm', 'player',    3),
  ('fernando_muslera', '$2b$12$ebEjLmOBvOjIEb8VaRxzJeLotRyRKVF9n1ERFFfdXLLqOc.EyHjIu', 'player',    4),
  ('hakim_ziyech',     '$2b$12$Efy1Oapf3JvNoyhUdxsaAeW3Xq4cUuDCrXePHUMvm0wWqolYYAicO', 'player',    5),
  ('kerem_akturkoglu', '$2b$12$XdbSAXyU77XYKvqi4fe81ueXDrZ54UWHNjneduwqE4gIhp0FUKmrS', 'player',    6),
  ('tete_bra',         '$2b$12$s3KoVYlCEObhsrGAj9BXSe4wwv5LsGdjvKCo7OlJZxJWp/CBUSAey', 'player',    7),
  ('yunus_akgun',      '$2b$12$jmND.xU3Yrle0BCz2zkuke2uYuVbuf68NJBP4ylLSUlHVvL1mFuo.', 'player',    8),
  ('sacha_boey',       '$2b$12$ugt2Vrs6dngIX0GnGXpgle4H2RnymZbdw46inECfuehaBGXWVYkLi', 'player',    9),
  ('abdulkerim_b',     '$2b$12$v88hlwewlj5XkP4lsw068e5cNS.19BHG29QwqzE/WxC2lfQ2Q6zg.', 'player',    10),
  ('dries_mertens',    '$2b$12$tkWZVeePaOVskvHGIe871e8oFCdW/pONo06tJaPCW6Rs6VQa5tVJK', 'player',    11),
  ('wilfried_zaha',    '$2b$12$riMjCL9xuMHYn8lgpjkAxeiOdV4PTxSkXCa02cLZ/TzlfVnjgklrq', 'player',    12),
  ('kaan_ayhan',       '$2b$12$Cdkc4dOhN/CxtbZxe.PBJeGSmokopqtXIDQ4O6YumfPKHsoI4Edja', 'player',    13),
  ('edin_dzeko',       '$2b$12$0WqqdZm5YoCZjs4UnHu4FOIQjJplPH9Gy8Av8k9cQMxn1CcXR9K2.', 'player',    14),
  ('dusan_tadic',      '$2b$12$EX7hfTgQIwn/3oR.Ufx.UehHJmLSNnd2cBSJRVb26gu8HLNe9dK3q', 'player',    15),
  ('irfan_can_e',      '$2b$12$TTHMA0chFNjKPZWtnyQ6A.YQzvdjBhEEAeCf8xs1gs4LRRaGQClS6', 'player',    16),
  ('bright_o_samuel',  '$2b$12$cMj0xw6AKVwetFvXEVZ00OP2NK2CV7R/rv6mU0hYJG0BZ26q3p.r6', 'player',    17),
  ('sebastian_szym',   '$2b$12$kKKCjVTWroKFbTz6CZGaiOW.uKxmm0Y29ziJIq8wkdn0QdgPw/K/m', 'player',    18),
  ('cengiz_under',     '$2b$12$mVxuE6YzH8l8Oy2yFMh.P.vF4SMAEI4NXqs1zFnoOx3ykbLS85QfO', 'player',    19),
  ('rafa_silva',       '$2b$12$7ALR9lC4wyj.3lXtGct4t.bepvoEZOGjtccD2Cph1OPfP0mzdDYoS', 'player',    20),
  ('vincent_abou',     '$2b$12$yoWD9GSRV5epmeQr1nF/r.VwHqHHtoQE06vWo9aA7IVXxJv7WFHrO', 'player',    21),
  ('mert_gunok',       '$2b$12$Zv4FIXE.uWqdMP.Z/a2koup/HK04Vp.mDvA3.N2JfFo3GTy64iE/C', 'player',    22),
  ('ernest_muci',      '$2b$12$N22DVAdIv3wY64eHc5kTO.AaWQt/Ph6mEdKlp87qKmFSQy.vNcGoy', 'player',    23),
  ('bruno_fernandes',  '$2b$12$aow8ZvXORU9QLh7lacwJ/.OhuM/aHsfomrcvdrm1h3rWTuNTLSb5S', 'player',    24),
  ('marcus_rashford',  '$2b$12$KQ1ItDUvWpYUg9xpzt7ZFuRdSM4ISQyRIRpnhqQAzclh5trLDUJRm', 'player',   25),
  ('andre_onana',      '$2b$12$AIGaqaAU8YT0arCi1Khk8eJjbebzR8YvK/udJqvmPoxbrRd.s1Ulq', 'player',    26),
  ('mohamed_salah',    '$2b$12$JxvABTeNGTEB60yqPH/5j.dorVWyIrkkoLdk7uOJJIyH9ixiZpDAq', 'player',    27),
  ('virgil_van_dijk',  '$2b$12$QsFrKfkQIsy97gXZetEYxeU/1HyVKA2K9Qah9Yhc9qcNTpnVMf3PC', 'player',   28),
  ('andreas_christ',   '$2b$12$WMtoJlgVgbeZL52VALXAFucJCh8Wv27mz4zWTe08QwKnynklSaCMG', 'player',    29);

-- -------------------------------------------------------
-- 10. Contracts
-- Note: contract_id 7 intentionally absent (not in source data).
-- Contracts 31, 32 are planted invalids loaded before T4.
-- -------------------------------------------------------
INSERT INTO Contract
  (contract_id, player_id, club_id, contract_type, weekly_wage, start_date, end_date)
VALUES
  -- Galatasaray active contracts
  (1,  1,  1, 'Permanent', 150000, '2024-08-15', '2027-06-30'),  -- Icardi @ GS
  (2,  2,  1, 'Permanent',  80000, '2023-08-01', '2026-06-30'),  -- Torreira @ GS
  (3,  3,  1, 'Permanent',  75000, '2023-07-15', '2027-06-30'),  -- Sánchez @ GS
  (4,  4,  1, 'Permanent',  60000, '2022-07-01', '2027-06-30'),  -- Muslera @ GS
  (5,  5,  1, 'Permanent',  90000, '2024-08-01', '2027-06-30'),  -- Ziyech @ GS
  (6,  6,  1, 'Permanent', 100000, '2023-07-01', '2028-06-30'),  -- Aktürkoğlu @ GS
  -- contract_id 7 skipped (absent from source data)
  (8,  8,  1, 'Permanent',  70000, '2022-09-01', '2027-06-30'),  -- Akgün @ GS
  (9,  9,  1, 'Permanent',  85000, '2023-07-20', '2027-06-30'),  -- Boey @ GS
  (10, 10, 1, 'Permanent',  65000, '2023-08-10', '2026-06-30'),  -- Bardakcı @ GS
  (11, 11, 1, 'Permanent',  55000, '2024-07-15', '2026-06-30'),  -- Mertens @ GS
  (12, 12, 1, 'Permanent',  70000, '2023-09-01', '2026-06-30'),  -- Zaha @ GS
  (13, 13, 1, 'Permanent',  50000, '2023-07-15', '2026-06-30'),  -- Ayhan @ GS
  -- Tetê: Permanent at MU, on Loan at GS
  (14, 7,  4, 'Permanent',  80000, '2023-07-01', '2027-06-30'),  -- Tetê @ MU
  (15, 7,  1, 'Loan',       40000, '2025-07-01', '2026-06-30'),  -- Tetê on Loan @ GS
  -- Fenerbahçe active contracts
  (16, 14, 2, 'Permanent',  95000, '2024-07-15', '2026-06-30'),  -- Džeko @ FB
  (17, 15, 2, 'Permanent', 100000, '2023-07-01', '2026-06-30'),  -- Tadić @ FB
  (18, 16, 2, 'Permanent',  55000, '2022-07-01', '2027-06-30'),  -- Eğribayat @ FB
  (19, 17, 2, 'Permanent',  65000, '2021-07-01', '2026-06-30'),  -- Osayi-Samuel @ FB
  (20, 18, 2, 'Permanent', 110000, '2023-07-15', '2028-06-30'),  -- Szymański @ FB
  (21, 19, 2, 'Permanent',  80000, '2024-08-01', '2027-06-30'),  -- Ünder @ FB
  -- Beşiktaş active contracts
  (22, 20, 3, 'Permanent',  90000, '2024-07-01', '2027-06-30'),  -- Rafa Silva @ BJK
  (23, 21, 3, 'Permanent',  60000, '2024-08-01', '2026-06-30'),  -- Aboubakar @ BJK
  (24, 22, 3, 'Permanent',  55000, '2022-08-01', '2026-06-30'),  -- Günok @ BJK
  (25, 23, 3, 'Permanent',  70000, '2023-09-01', '2027-06-30'),  -- Muçi @ BJK
  -- Manchester United active contracts
  (26, 24, 4, 'Permanent', 300000, '2020-01-15', '2027-06-30'),  -- B. Fernandes @ MU
  (27, 25, 4, 'Permanent', 250000, '2018-07-01', '2027-06-30'),  -- Rashford @ MU
  (28, 26, 4, 'Permanent', 120000, '2023-07-01', '2028-06-30'),  -- Onana @ MU
  -- Liverpool active contracts
  (29, 27, 5, 'Permanent', 400000, '2017-07-01', '2027-06-30'),  -- Salah @ LIV
  (30, 28, 5, 'Permanent', 350000, '2018-01-01', '2027-06-30'),  -- van Dijk @ LIV
  -- PLANTED INVALID (a): Icardi's 2nd active Permanent at MU – blocked by T4 going forward
  (31, 1,  4, 'Permanent', 180000, '2025-08-01', '2027-08-01'),
  -- PLANTED INVALID (b): Christensen has only a Loan at GS; no Permanent anywhere – blocked by T4
  (32, 29, 1, 'Loan',       50000, '2025-09-01', '2026-06-30'),
  -- Expired historical contracts
  (33, 1,  5, 'Permanent', 150000, '2022-08-01', '2024-08-14'),  -- Icardi @ LIV (expired)
  (34, 14, 1, 'Permanent',  90000, '2023-08-15', '2024-07-14');  -- Džeko @ GS (expired)

-- -------------------------------------------------------
-- 11. TransferRecord
-- Transfer 7 is a planted invalid: Loan with NULL from_club_id – blocked by T10 going forward.
-- -------------------------------------------------------
INSERT INTO TransferRecord
  (transfer_id, player_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type)
VALUES
  (1, 1,  5,    1, '2024-08-15', 25000000, 'Purchase'),  -- Icardi: LIV → GS
  (2, 1,  NULL, 5, '2022-08-01', 30000000, 'Purchase'),  -- Icardi: free agent → LIV
  (3, 14, 1,    2, '2024-07-15',  3000000, 'Purchase'),  -- Džeko: GS → FB
  (4, 14, NULL, 1, '2023-08-15',        0, 'Free'),       -- Džeko: free agent → GS
  (5, 2,  NULL, 1, '2023-08-01', 10000000, 'Purchase'),  -- Torreira: free agent → GS
  (6, 7,  4,    1, '2025-07-01',  2000000, 'Loan'),       -- Tetê: MU → GS (Loan)
  -- PLANTED INVALID (c): Loan transfer with NULL from_club_id – blocked by T10 going forward
  (7, 29, NULL, 1, '2025-09-01',  1500000, 'Loan'),       -- Christensen: NULL → GS
  (8, 19, NULL, 2, '2024-08-01', 16000000, 'Purchase'),  -- Ünder: free agent → FB
  (9, 20, NULL, 3, '2024-07-01', 10000000, 'Purchase');  -- Rafa Silva: free agent → BJK

-- -------------------------------------------------------
-- 12. FootballMatch  (all matches; past-dated ones loaded before T5)
-- Planted invalids: M4 (attendance > capacity), M15+M16 (stadium/club conflict),
--                  M17+M18 (referee conflict within 120 min).
-- -------------------------------------------------------
INSERT INTO FootballMatch
  (match_ID, competition_ID, home_club_ID, away_club_ID,
   stadium_ID, match_datetime, home_goals, away_goals, attendance, referee_ID)
VALUES
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
  -- PLANTED INVALID (f): M15 and M16 – same stadium (RAMS Park) within 60 min on 2025-09-30;
  --   also a club conflict (GS appears in both matches)
  (15, 2, 1, 3, 1, '2025-09-30 14:00:00',  2,    0,    45000, 1001),
  (16, 2, 2, 1, 1, '2025-09-30 15:00:00',  1,    1,    46000, 1002),
  -- PLANTED INVALID (g): M17 and M18 – referee 1003 assigned to two matches on 2025-11-10
  --   at 19:00 (Old Trafford) and 19:30 (RAMS Park), within the 120-min conflict window
  (17, 3, 4, 5, 4, '2025-11-10 19:00:00',  2,    1,    70000, 1003),
  (18, 1, 1, 2, 1, '2025-11-10 19:30:00',  1,    1,    49000, 1003);

-- -------------------------------------------------------
-- 13. Match_Stats
-- Column: position_in_match (schema name)
-- red_cards is BOOLEAN: FALSE = no red card
-- PLANTED INVALID (d): Match 1 – GS (club 1) has 12 rows with is_starter = TRUE
-- -------------------------------------------------------
INSERT INTO Match_Stats
  (match_id, player_id, club_id, is_starter, minutes_played,
   position_in_match, goals, assists, yellow_cards, red_cards, rating)
VALUES
  -- === Match 1: GS 2–1 FB (2025-09-20) ===
  -- GS: 12 starters – PLANTED INVALID (d)
  (1,  4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.4),
  (1,  3,  1, TRUE, 90,  'CB',  0, 0, 0, FALSE, 7.0),
  (1,  10, 1, TRUE, 90,  'CB',  0, 0, 1, FALSE, 6.8),
  (1,  9,  1, TRUE, 90,  'RB',  0, 1, 0, FALSE, 7.5),
  (1,  13, 1, TRUE, 90,  'LB',  0, 0, 0, FALSE, 6.9),
  (1,  2,  1, TRUE, 90,  'CDM', 0, 0, 0, FALSE, 7.6),
  (1,  8,  1, TRUE, 90,  'CM',  0, 0, 0, FALSE, 7.1),
  (1,  5,  1, TRUE, 90,  'RW',  1, 0, 0, FALSE, 8.2),
  (1,  6,  1, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.7),
  (1,  12, 1, TRUE, 90,  'AM',  0, 0, 0, FALSE, 7.0),
  (1,  1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 8.0),
  (1,  11, 1, TRUE, 85,  'ST',  0, 0, 0, FALSE, 7.2),  -- 12th starter (planted invalid)
  -- FB
  (1,  16, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.8),
  (1,  17, 2, TRUE, 90,  'RB',  0, 0, 1, FALSE, 6.5),
  (1,  18, 2, TRUE, 90,  'CM',  0, 0, 0, FALSE, 7.0),
  (1,  15, 2, TRUE, 90,  'AM',  0, 1, 0, FALSE, 7.4),
  (1,  19, 2, TRUE, 90,  'LW',  0, 0, 0, FALSE, 6.7),
  (1,  14, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.6),

  -- === Match 2: FB 1–1 BJK (2025-10-04) ===
  (2,  16, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (2,  17, 2, TRUE, 90,  'RB',  0, 0, 0, FALSE, 6.9),
  (2,  18, 2, TRUE, 90,  'CM',  1, 0, 0, FALSE, 7.8),
  (2,  15, 2, TRUE, 90,  'AM',  0, 1, 1, FALSE, 7.2),
  (2,  19, 2, TRUE, 90,  'RW',  0, 0, 0, FALSE, 6.5),
  (2,  14, 2, TRUE, 90,  'ST',  0, 0, 0, FALSE, 6.8),
  (2,  22, 3, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.1),
  (2,  20, 3, TRUE, 90,  'AM',  1, 0, 0, FALSE, 8.0),
  (2,  21, 3, TRUE, 90,  'ST',  0, 0, 0, FALSE, 6.5),
  (2,  23, 3, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.0),

  -- === Match 3: BJK 0–2 GS (2025-10-25) ===
  (3,  4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.5),
  (3,  5,  1, TRUE, 90,  'RW',  1, 0, 0, FALSE, 8.3),
  (3,  1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 8.1),
  (3,  6,  1, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.4),
  (3,  2,  1, TRUE, 90,  'CDM', 0, 1, 1, FALSE, 7.5),
  (3,  22, 3, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.4),
  (3,  20, 3, TRUE, 90,  'AM',  0, 0, 0, FALSE, 6.7),
  (3,  21, 3, TRUE, 90,  'ST',  0, 0, 1, FALSE, 6.0),

  -- === Match 4: GS 3–0 BJK (2025-11-15) – attendance > capacity ===
  (4,  4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.2),
  (4,  1,  1, TRUE, 90,  'ST',  2, 0, 0, FALSE, 8.7),
  (4,  5,  1, TRUE, 90,  'RW',  1, 1, 0, FALSE, 8.4),
  (4,  6,  1, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.5),
  (4,  22, 3, TRUE, 90,  'GK',  0, 0, 0, FALSE, 5.5),
  (4,  21, 3, TRUE, 90,  'ST',  0, 0, 1, FALSE, 6.0),

  -- === Match 5: FB 2–2 GS (2025-12-06) ===
  (5,  4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (5,  1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.8),
  (5,  5,  1, TRUE, 90,  'RW',  1, 0, 1, FALSE, 7.6),
  (5,  6,  1, TRUE, 80,  'LW',  0, 1, 0, FALSE, 7.2),
  (5,  16, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.8),
  (5,  14, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.4),
  (5,  18, 2, TRUE, 90,  'CM',  1, 1, 1, FALSE, 7.8),
  (5,  15, 2, TRUE, 90,  'AM',  0, 1, 0, FALSE, 7.2),

  -- === Match 6: BJK 1–2 FB (2026-02-14) ===
  (6,  22, 3, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.5),
  (6,  20, 3, TRUE, 90,  'AM',  1, 0, 0, FALSE, 7.5),
  (6,  21, 3, TRUE, 90,  'ST',  0, 1, 0, FALSE, 6.8),
  (6,  16, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.2),
  (6,  14, 2, TRUE, 90,  'ST',  2, 0, 0, FALSE, 8.4),
  (6,  18, 2, TRUE, 90,  'CM',  0, 1, 0, FALSE, 7.5),
  (6,  19, 2, TRUE, 90,  'LW',  0, 1, 1, FALSE, 7.0),

  -- === Match 7: LIV 3–1 MU (2025-10-19) ===
  (7,  27, 5, TRUE, 90,  'RW',  2, 0, 0, FALSE, 9.0),
  (7,  28, 5, TRUE, 90,  'CB',  0, 0, 0, FALSE, 7.5),
  (7,  24, 4, TRUE, 90,  'AM',  1, 0, 1, FALSE, 7.4),
  (7,  25, 4, TRUE, 90,  'LW',  0, 0, 0, FALSE, 6.8),
  (7,  26, 4, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.5),

  -- === Match 8: MU 1–1 LIV (2026-02-22) ===
  (8,  24, 4, TRUE, 90,  'AM',  1, 0, 0, FALSE, 8.0),
  (8,  25, 4, TRUE, 90,  'LW',  0, 1, 0, FALSE, 7.4),
  (8,  26, 4, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (8,  27, 5, TRUE, 90,  'RW',  1, 0, 1, FALSE, 7.5),
  (8,  28, 5, TRUE, 90,  'CB',  0, 0, 0, FALSE, 7.2),

  -- === Match 9: GS 1–0 BJK, Türkiye Kupası (2025-11-22) ===
  (9,  4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (9,  1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.8),
  (9,  5,  1, TRUE, 90,  'RW',  0, 1, 0, FALSE, 7.4),
  (9,  22, 3, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.8),
  (9,  21, 3, TRUE, 90,  'ST',  0, 0, 0, FALSE, 6.0),

  -- === Match 10: GS 1–1 FB, Süper Lig 2024/2025 (2025-04-12) ===
  (10, 4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (10, 1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.5),
  (10, 5,  1, TRUE, 90,  'RW',  0, 1, 1, FALSE, 7.0),
  (10, 16, 2, TRUE, 90,  'GK',  0, 0, 0, FALSE, 6.8),
  (10, 14, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.4),
  (10, 18, 2, TRUE, 90,  'CM',  0, 1, 0, FALSE, 7.0),

  -- === Match 15: GS 2–0 BJK, Türkiye Kupası (2025-09-30 14:00) – planted conflict ===
  (15, 4,  1, TRUE, 90,  'GK',  0, 0, 0, FALSE, 7.0),
  (15, 1,  1, TRUE, 90,  'ST',  2, 0, 0, FALSE, 8.5),

  -- === Match 16: FB 1–1 GS, Türkiye Kupası (2025-09-30 15:00) – planted conflict ===
  (16, 14, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.5),
  (16, 1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.4),

  -- === Match 17: MU 2–1 LIV (2025-11-10 19:00) – planted referee conflict ===
  (17, 24, 4, TRUE, 90,  'AM',  2, 0, 0, FALSE, 9.2),
  (17, 27, 5, TRUE, 90,  'RW',  1, 0, 0, FALSE, 7.8),

  -- === Match 18: GS 1–1 FB (2025-11-10 19:30) – planted referee conflict ===
  (18, 1,  1, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.6),
  (18, 14, 2, TRUE, 90,  'ST',  1, 0, 0, FALSE, 7.4);

SET FOREIGN_KEY_CHECKS = 1;