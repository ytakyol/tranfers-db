DROP DATABASE IF EXISTS transfer_db;
CREATE DATABASE transfer_db;
USE transfer_db;

CREATE TABLE db_managers (
username VARCHAR(50) PRIMARY KEY,
password VARCHAR(255) NOT NULL
);
CREATE TABLE persons (
person_ID INT AUTO_INCREMENT PRIMARY KEY,
username VARCHAR(50) UNIQUE NOT NULL,
password VARCHAR(255) NOT NULL,
name VARCHAR(50) NOT NULL,
surname VARCHAR(50) NOT NULL,
nationality VARCHAR(50) NOT NULL,
date_of_birth DATE NOT NULL
);
CREATE TABLE players (
person_ID INT PRIMARY KEY,
main_position ENUM('Goalkeeper', 'Defender', 'Midfielder', 'Forward'),
strong_foot ENUM('Left', 'Right', 'Both'), -- May have no information
market_value DECIMAL(15,3) CHECK (market_value > 0),
height INT CHECK (height > 0),
FOREIGN KEY (person_ID) REFERENCES persons(person_ID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE managers (
person_ID INT PRIMARY KEY,
preferred_formation VARCHAR(10),
experience_level VARCHAR(50),
FOREIGN KEY (person_ID) REFERENCES persons(person_ID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE referees (
person_ID INT PRIMARY KEY,
license_level VARCHAR(50) NOT NULL,
years_of_experience INT CHECK (years_of_experience >= 0),
FOREIGN KEY (person_ID) REFERENCES persons(person_ID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE stadiums (
stadium_ID INT AUTO_INCREMENT PRIMARY KEY,
stadium_name VARCHAR(100) NOT NULL,
city VARCHAR(100) NOT NULL,
capacity INT NOT NULL CHECK (capacity > 0),
UNIQUE (stadium_name, city)
);
CREATE TABLE clubs (
club_ID INT AUTO_INCREMENT PRIMARY KEY,
club_name VARCHAR(100) UNIQUE NOT NULL,
foundation_year INT NOT NULL,
manager_ID INT UNIQUE, -- May be managerless at some interval
stadium_name VARCHAR(100),
city VARCHAR(100) NOT NULL,
FOREIGN KEY (manager_ID) REFERENCES managers(person_ID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (stadium_name, city) REFERENCES stadiums(stadium_name, city)
ON DELETE CASCADE
ON UPDATE CASCADE
);

CREATE TABLE competitions (
competition_ID INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
season VARCHAR(20) NOT NULL,
country VARCHAR(50) NOT NULL,
competition_type VARCHAR(50) NOT NULL,
UNIQUE (name, season)
);

CREATE TABLE contracts (
contract_id INT AUTO_INCREMENT PRIMARY KEY,
player_id INT NOT NULL,
club_id INT NOT NULL,
start_date DATE NOT NULL,
end_date DATE NOT NULL,
weekly_wage DECIMAL(15, 2) NOT NULL CHECK (weekly_wage > 0),
contract_type ENUM('Permanent', 'Loan') NOT NULL,
FOREIGN KEY (player_id) REFERENCES players(person_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (club_id) REFERENCES clubs(club_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE transfer_record (
transfer_id INT AUTO_INCREMENT PRIMARY KEY,
player_id INT NOT NULL,
from_club_id INT,
to_club_id INT NOT NULL,
transfer_date DATE NOT NULL,
transfer_fee DECIMAL(15, 2) NOT NULL CHECK (transfer_fee >= 0),
transfer_type ENUM('Free', 'Purchase', 'Loan') NOT NULL,
FOREIGN KEY (player_id) REFERENCES players(person_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (from_club_id) REFERENCES clubs(club_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (to_club_id) REFERENCES clubs(club_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
CHECK (transfer_type != 'Free' OR transfer_fee = 0)
);

CREATE TABLE matches (
match_ID INT AUTO_INCREMENT PRIMARY KEY ,
competition_ID INT NOT NULL,
home_club_ID INT NOT NULL,
away_club_ID INT NOT NULL,
stadium_ID INT NOT NULL,
referee_ID INT NOT NULL,
match_datetime DATETIME NOT NULL,
attendance INT CHECK (attendance >= 0),
home_goals INT CHECK (home_goals >= 0),
away_goals INT CHECK (away_goals >= 0),
FOREIGN KEY (competition_ID) REFERENCES competitions(competition_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (home_club_ID) REFERENCES clubs(club_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (away_club_ID) REFERENCES clubs(club_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (stadium_ID) REFERENCES stadiums(stadium_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (referee_ID) REFERENCES referees(person_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE match_stats (
player_ID INT NOT NULL,
match_ID INT NOT NULL,
club_ID INT NOT NULL,
is_starter BOOLEAN NOT NULL,
minutes_played INT NOT NULL CHECK (minutes_played BETWEEN 0 AND 120),
position_in_match VARCHAR(5) NOT NULL,
goals INT NOT NULL CHECK (goals >= 0),
assists INT NOT NULL CHECK (assists >= 0),
yellow_cards INT NOT NULL CHECK (yellow_cards IN (0, 1, 2)),
red_cards BOOLEAN NOT NULL,
rating DECIMAL(3,1) CHECK (rating BETWEEN 1.0 AND 10.0),
PRIMARY KEY (player_ID, match_ID),
FOREIGN KEY (player_ID) REFERENCES players(person_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE,
FOREIGN KEY (match_ID) REFERENCES matches(match_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE
FOREIGN KEY (club_ID) REFERENCES clubs(club_ID)
ON DELETE RESTRICT
ON UPDATE CASCADE
);

CREATE TABLE participates (
club_ID INT NOT NULL,
competition_ID INT NOT NULL,
PRIMARY KEY (club_ID, competition_ID),
FOREIGN KEY (club_ID) REFERENCES clubs(club_ID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (competition_ID) REFERENCES competitions(competition_ID)
ON DELETE CASCADE
ON UPDATE CASCADE
);