from fileinput import filename

import pandas as pd
import mysql.connector
import hashlib

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '2005',
    'database': 'Transfer_DB' # Name from your first.sql
}

def hash_password(password):
    return hashlib.sha256(str(password).encode()).hexdigest()

def import_all(file_path):
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()

        f = open('database/reset.sql', 'r')
        sql_file = f.read()
        f.close()
        #cursor.execute(sql_file)
        cursor.close()
        conn.close()

        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor()
        
        f = open('database/schema.sql', 'r')
        sql_file = f.read()
        f.close()
        #cursor.execute(sql_file)

        cursor.execute("SET FOREIGN_KEY_CHECKS=0")
        
        # 1. STADIUMS (Table: stadium | Columns: stadium_ID, stadium_name, city, capacity)
        stadiums_df = pd.read_excel(file_path, sheet_name='Stadiums')
        for _, row in stadiums_df.iterrows():
            cursor.execute("INSERT INTO stadiums (stadium_ID, stadium_name, city, capacity) VALUES (%s, %s, %s, %s)", 
                           (row['stadium_id'], row['stadium_name'], row['city'], row['capacity']))

        # 2. COMPETITIONS (Table: competition | Columns: competition_ID, name, season, country, competition_type)
        comps_df = pd.read_excel(file_path, sheet_name='Competitions')
        for _, row in comps_df.iterrows():
            cursor.execute("INSERT INTO competitions (competition_ID, name, season, country, competition_type) VALUES (%s, %s, %s, %s, %s)", 
                           (row['competition_id'], row['name'], row['season'], row['country'], row['competition_type']))

        # 3. DB MANAGERS (Table: db_manager)
        db_mgrs_df = pd.read_excel(file_path, sheet_name='DB Managers')
        for _, row in db_mgrs_df.iterrows():
            cursor.execute("INSERT INTO db_managers (username, password) VALUES (%s, %s)", (row['username'], hash_password(row['password'])))

        # 4. PERSONS & SUBTYPES (Handling ID consistency)
        for sheet, subtype in [('Players', 'player'), ('Managers', 'manager'), ('Referees', 'referee')]:
            df = pd.read_excel(file_path, sheet_name=sheet)
            id_col = f"{subtype}_id"
            for _, row in df.iterrows():
                # Insert into person table first
                cursor.execute("""INSERT INTO persons (person_ID, username, password, name, surname, nationality, date_of_birth) 
                                  VALUES (%s, %s, %s, %s, %s, %s, %s)""", 
                               (row[id_col], row['username'], hash_password(row['password']), row['name'], row['surname'], row['nationality'], row['date_of_birth']))
                
                # Insert into subtype table
                if subtype == 'player':
                    cursor.execute("INSERT INTO players (person_ID, main_position, strong_foot, market_value, height) VALUES (%s, %s, %s, %s, %s)",
                                   (row[id_col], row['main_position'], row['strong_foot'], row['market_value'], row['height']))
                elif subtype == 'manager':
                    cursor.execute("INSERT INTO managers (person_ID, preferred_formation, experience_level) VALUES (%s, %s, %s)",
                                   (row[id_col], row['preferred_formation'], row['experience_level']))
                elif subtype == 'referee':
                    cursor.execute("INSERT INTO referees (person_ID, license_level, years_of_experience) VALUES (%s, %s, %s)",
                                   (row[id_col], row['license_level'], row['years_of_experience']))

        # 5. CLUBS (Requires joining with Stadiums to get stadium_name and city)
        clubs_df = pd.read_excel(file_path, sheet_name='Clubs')
        clubs_merged = clubs_df.merge(stadiums_df[['stadium_id', 'stadium_name', 'city']], on='stadium_id')
        for _, row in clubs_merged.iterrows():
            mgr_id = None if pd.isna(row['manager_id']) else int(row['manager_id'])
            cursor.execute("INSERT INTO clubs (club_ID, club_name, foundation_year, manager_ID, stadium_name, city) VALUES (%s, %s, %s, %s, %s, %s)", 
                           (row['club_id'], row['club_name'], row['foundation_year'], mgr_id, row['stadium_name'], row['city']))

        # 6. MATCHES (Combining Date and Time into match_datetime)
        matches_df = pd.read_excel(file_path, sheet_name='Matches')
        for _, row in matches_df.iterrows():
            # Assuming 'row' is a row from your Matches dataframe
            match_date = str(row['match_date']).split()[0] # Format: YYYY-MM-DD
            match_time = str(row['match_time']) # Format: HH:MM:SS

            # Combine into the format MySQL expects
            dt = f"{match_date} {match_time}"
            cursor.execute("""INSERT INTO `matches` (match_ID, competition_ID, home_club_ID, away_club_ID, stadium_ID, referee_ID, match_datetime, attendance, home_goals, away_goals) 
                              VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""", 
                           (row['match_id'], row['competition_id'], row['home_club_id'], row['away_club_id'], row['stadium_id'], row['referee_id'], dt, row['attendance'], row['home_goals'], row['away_goals']))

        # 7. MATCH STATS
        stats_df = pd.read_excel(file_path, sheet_name='Match Stats')
        for _, row in stats_df.iterrows():
            cursor.execute("""INSERT INTO match_stats (player_ID, match_ID, is_starter, minutes_played, position_in_match, goals, assists, yellow_cards, red_cards, rating) 
                              VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""", 
                           (row['player_id'], row['match_id'], row['is_starter'], row['minutes_played'], row['position_played'], row['goals'], row['assists'], row['yellow_cards'], row['red_cards'], row['rating']))

        conn.commit()
        print("Success: Data imported into transfer_db schema.")
    except Exception as e:
        print(f"Import Failed: {e}")
        conn.rollback()
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.execute("SET FOREIGN_KEY_CHECKS=1")
            cursor.close()
            conn.close()

if __name__ == "__main__":
    import_all('initial_data.xlsx')
    print("Data import process completed.")
    