from flask import Flask, render_template, request, redirect, session, flash
import hashlib
from datetime import date
from database_utils import execute_query

app = Flask(__name__)
app.secret_key = 'super_secret_key'

# Password Hashing (SHA-256) as required [cite: 166]
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

# Role Decorator (Optional but good for security)
def login_required(role=None):
    def wrapper(fn):
        def decorated_view(*args, **kwargs):
            if 'user' not in session:
                return redirect('/')
            if role and session['user'].get('role') != role:
                return "Unauthorized", 403
            return fn(*args, **kwargs)
        return decorated_view
    return wrapper

# ==========================================
# AUTHENTICATION & REGISTRATION
# ==========================================

@app.route('/')
def index():
    if 'user' in session:
        return redirect(f"/{session['user']['role']}")
    return render_template('index.html')

@app.route('/signup', methods=['POST'])
def signup():
    username = request.form['username']
    password = request.form['password']
    role = request.form['role']
    
    # Password Policy Check
    if len(password) < 8 or not any(c.isupper() for c in password) or \
       not any(c.islower() for c in password) or not any(c.isdigit() for c in password) or \
       not any(not c.isalnum() for c in password):
        flash("Password does not meet requirements! Needs 8 chars, Upper, Lower, Digit, Special.") 
        return redirect('/')

    hashed_pw = hash_password(password)
    
    try:
        if role == 'db_manager':
            query = "INSERT INTO db_managers (username, password) VALUES (%s, %s)"
            execute_query(query, (username, hashed_pw))
            
        else:
            # 1. Capture base Person fields
            name = request.form.get('name', 'Unknown')
            surname = request.form.get('surname', 'Unknown')
            nationality = request.form.get('nationality', 'Unknown')
            dob = request.form.get('dob', '2000-01-01')
            
            # Insert into 'persons' table
            query = """INSERT INTO persons (username, password, name, surname, nationality, date_of_birth) 
                       VALUES (%s, %s, %s, %s, %s, %s)"""
            execute_query(query, (username, hashed_pw, name, surname, nationality, dob))
            
            # Fetch the generated person_ID
            person_id = execute_query("SELECT LAST_INSERT_ID() AS id", fetch=True)[0]['id']
            
            # 2. Capture specific fields based on Role and Insert
            if role == 'player':
                market_value = request.form.get('market_value', 100000)
                height = request.form.get('height', 180)
                main_position = request.form.get('main_position', 'Midfielder')
                strong_foot = request.form.get('strong_foot', 'Right')
                
                execute_query("""
                    INSERT INTO players (person_ID, market_value, height, main_position, strong_foot) 
                    VALUES (%s, %s, %s, %s, %s)""", 
                    (person_id, market_value, height, main_position, strong_foot))
                    
            elif role == 'manager':
                preferred_formation = request.form.get('preferred_formation', '4-4-2')
                experience_level = request.form.get('experience_level', 'Intermediate')
                
                execute_query("""
                    INSERT INTO managers (person_ID, preferred_formation, experience_level) 
                    VALUES (%s, %s, %s)""", 
                    (person_id, preferred_formation, experience_level))
                    
            elif role == 'referee':
                license_level = request.form.get('license_level', 'National')
                years_of_experience = request.form.get('years_of_experience', 0)
                
                execute_query("""
                    INSERT INTO referees (person_ID, license_level, years_of_experience) 
                    VALUES (%s, %s, %s)""", 
                    (person_id, license_level, years_of_experience))
                
        flash("Registration successful! You can now log in.")
    except Exception as e:
        flash(f"Error during registration: {e}")

    return redirect('/')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    hashed_pw = hash_password(password)

    # Check DB Managers [cite: 34]
    dbm_query = "SELECT * FROM db_managers WHERE username = %s AND password = %s"
    db_manager = execute_query(dbm_query, (username, hashed_pw), fetch=True)
    if db_manager:
        session['user'] = {'username': username, 'role': 'db_manager'}
        return redirect('/db_manager')

    # Check Persons [cite: 39, 45, 51]
    person_query = "SELECT * FROM persons WHERE username = %s AND password = %s"
    person = execute_query(person_query, (username, hashed_pw), fetch=True)
    
    if person:
        p_id = person[0]['person_ID']
        # Determine specific role
        if execute_query("SELECT 1 FROM players WHERE person_ID = %s", (p_id,), fetch=True):
            session['user'] = {'id': p_id, 'username': username, 'role': 'player'}
            return redirect('/player')
        elif execute_query("SELECT 1 FROM managers WHERE person_ID = %s", (p_id,), fetch=True):
            session['user'] = {'id': p_id, 'username': username, 'role': 'manager'}
            return redirect('/manager')
        elif execute_query("SELECT 1 FROM referees WHERE person_ID = %s", (p_id,), fetch=True):
            session['user'] = {'id': p_id, 'username': username, 'role': 'referee'}
            return redirect('/referee')

    flash("Login Failed")
    return redirect('/')

@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')

# ==========================================
# DATABASE MANAGER ROUTES
# ==========================================

@app.route('/db_manager')
def db_manager_dashboard():
    if session.get('user', {}).get('role') != 'db_manager': return redirect('/')
    stadiums = execute_query("""
        SELECT s.stadium_name, s.city, s.capacity, GROUP_CONCAT(c.club_name) as home_clubs 
        FROM stadiums s LEFT JOIN clubs c ON s.stadium_name = c.stadium_name AND s.city = c.city
        GROUP BY s.stadium_ID
    """, fetch=True) # View stadiums requirement [cite: 65]
    return render_template('db_manager.html', stadiums=stadiums)

@app.route('/schedule-match', methods=['POST'])
def schedule_match():
    if session.get('user', {}).get('role') != 'db_manager': return "Unauthorized", 403
    
    data = (
        request.form['competition_id'],
        request.form['home_club'],
        request.form['away_club'],
        request.form['stadium_id'],
        request.form['referee_id'],
        request.form['match_date'] + " " + request.form.get('match_time', '00:00:00')
    )
    
    query = """
        INSERT INTO matches (competition_ID, home_club_ID, away_club_ID, stadium_ID, referee_ID, match_datetime)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    try:
        execute_query(query, data) # Triggers handle 120-min and capacity logic [cite: 68, 69, 135]
        flash("Match scheduled successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
    
    return redirect('/db_manager')

@app.route('/transfer', methods=['POST'])
def register_transfer():
    if session.get('user', {}).get('role') != 'db_manager': return "Unauthorized", 403
    
    player_id = request.form['player_id']
    to_club_id = request.form['club_id']
    fee = request.form['fee']
    transfer_type = request.form.get('transfer_type', 'Purchase')
    
    try:
        # Retrieve current club for transfer record
        current_contract = execute_query("SELECT club_id FROM contracts WHERE player_id = %s AND end_date > CURDATE() AND contract_type = 'Permanent'", (player_id,), fetch=True)
        from_club_id = current_contract[0]['club_id'] if current_contract else None
        
        # 1. Insert Transfer Record [cite: 93, 94]
        execute_query("""
            INSERT INTO transfer_record (player_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type)
            VALUES (%s, %s, %s, CURDATE(), %s, %s)
        """, (player_id, from_club_id, to_club_id, fee, transfer_type))
        
        # 2. Update Market Value if Purchase [cite: 95]
        if transfer_type == 'Purchase':
            execute_query("UPDATE players SET market_value = %s WHERE person_ID = %s", (fee, player_id))
            # Terminate old permanent contract [cite: 97]
            execute_query("UPDATE contracts SET end_date = CURDATE() WHERE player_id = %s AND contract_type = 'Permanent' AND end_date > CURDATE()", (player_id,))
            
        # 3. Create new Contract [cite: 92]
        execute_query("""
            INSERT INTO contracts (player_id, club_id, start_date, end_date, weekly_wage, contract_type)
            VALUES (%s, %s, CURDATE(), %s, %s, %s)
        """, (player_id, to_club_id, request.form['end_date'], request.form['wage'], transfer_type))

        flash("Transfer registered successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
        
    return redirect('/db_manager')

# ==========================================
# MANAGER ROUTES
# ==========================================

@app.route('/manager')
def manager_dashboard():
    if session.get('user', {}).get('role') != 'manager': return redirect('/')
    user_id = session['user']['id']
    
    profile = execute_query("""
        SELECT p.name, p.surname, p.nationality, p.date_of_birth, m.preferred_formation, m.experience_level, c.club_name, c.club_ID
        FROM persons p JOIN managers m ON p.person_ID = m.person_ID 
        LEFT JOIN clubs c ON c.manager_ID = m.person_ID
        WHERE p.person_ID = %s
    """, (user_id,), fetch=True)
    
    return render_template('manager.html', profile=profile[0] if profile else {})

@app.route('/submit-squad', methods=['POST'])
def submit_squad():
    if session.get('user', {}).get('role') != 'manager': return "Unauthorized", 403
    
    match_id = request.form['match_id']
    player_ids = request.form.getlist('player_id')
    starters = request.form.getlist('is_starter')
    club_id = request.form['club_id']
    
    try:
        # Loop and insert to match_stats. Triggers enforce 11 starter max & 23 player max [cite: 76, 137]
        for pid in player_ids:
            is_starter = 1 if pid in starters else 0
            execute_query("""
                INSERT INTO match_stats (player_ID, match_ID, club_ID, is_starter, minutes_played, position_in_match, goals, assists, yellow_cards, red_cards)
                VALUES (%s, %s, %s, %s, 0, 'SUB', 0, 0, 0, 0)
            """, (pid, match_id, club_id, is_starter))
        flash("Squad submitted.")
    except Exception as e:
        flash(f"Error submitting squad: {e}")
        
    return redirect('/manager')

# ==========================================
# REFEREE ROUTES
# ==========================================

@app.route('/referee')
def referee_dashboard():
    if session.get('user', {}).get('role') != 'referee': return redirect('/')
    user_id = session['user']['id']
    
    # Career stats overview [cite: 112]
    stats = execute_query("""
        SELECT COUNT(DISTINCT m.match_ID) as matches_officiated, 
               SUM(ms.red_cards) as total_reds, SUM(ms.yellow_cards) as total_yellows
        FROM matches m LEFT JOIN match_stats ms ON m.match_ID = ms.match_ID
        WHERE m.referee_ID = %s
    """, (user_id,), fetch=True)[0]
    
    return render_template('referee.html', stats=stats)

@app.route('/submit-result', methods=['POST'])
def submit_result():
    if session.get('user', {}).get('role') != 'referee': return "Unauthorized", 403
    
    match_id = request.form['match_id']
    attendance = request.form['attendance']
    home_goals = request.form['home_goals']
    away_goals = request.form['away_goals']
    
    try:
        # Only process if time has passed (Application-side check possible, but DB handles capacity trigger) [cite: 110]
        execute_query("""
            UPDATE matches SET attendance = %s, home_goals = %s, away_goals = %s 
            WHERE match_ID = %s AND match_datetime < NOW() AND referee_ID = %s
        """, (attendance, home_goals, away_goals, match_id, session['user']['id']))
        flash("Results updated.")
    except Exception as e:
        flash(f"Database Error: {e}")
        
    return redirect('/referee')

# ==========================================
# PLAYER ROUTES
# ==========================================

@app.route('/player')
def player_dashboard():
    if session.get('user', {}).get('role') != 'player': return redirect('/')
    user_id = session['user']['id']
    
    # Player Profile [cite: 62]
    profile = execute_query("""
        SELECT p.name, p.surname, p.nationality, pl.market_value, pl.main_position, pl.strong_foot, pl.height
        FROM persons p JOIN players pl ON p.person_ID = pl.person_ID
        WHERE p.person_ID = %s
    """, (user_id,), fetch=True)
    
    return render_template('player.html', profile=profile[0] if profile else {})

@app.route('/player/stats', methods=['GET'])
def player_stats():
    user_id = session['user']['id']
    filter_type = request.args.get('filter_type', 'career')
    season = request.args.get('season')
    comp_id = request.args.get('competition_id')
    
    # Base query for aggregation [cite: 118]
    query = """
        SELECT COUNT(ms.match_ID) as games, SUM(ms.goals) as total_goals, SUM(ms.assists) as total_assists,
               SUM(ms.yellow_cards) as yellow, SUM(ms.red_cards) as red, AVG(ms.rating) as avg_rating
        FROM match_stats ms JOIN matches m ON ms.match_ID = m.match_ID JOIN competitions c ON m.competition_ID = c.competition_ID
        WHERE ms.player_ID = %s
    """
    params = [user_id]
    
    if filter_type == 'season' and season:
        query += " AND c.season = %s"
        params.append(season)
    elif filter_type == 'competition' and season and comp_id:
        query += " AND c.season = %s AND c.competition_ID = %s"
        params.extend([season, comp_id])
        
    stats = execute_query(query, tuple(params), fetch=True)
    return render_template('player.html', stats=stats[0] if stats else None)

if __name__ == '__main__':
    app.run(debug=True)