from flask import Flask, render_template, request, redirect, session, flash
import hashlib
from datetime import date
from database_utils import execute_query
from routes.player import player_bp
from routes.referee import referee_bp
from routes.manager import manager_bp
from routes.db_manager import dbmanager_bp

app = Flask(__name__)
app.secret_key = 'super_secret_key'

# Registering roles with a prefix
app.register_blueprint(player_bp, url_prefix='/player')
app.register_blueprint(referee_bp, url_prefix='/referee')
app.register_blueprint(manager_bp, url_prefix='/manager')
app.register_blueprint(dbmanager_bp, url_prefix='/db_manager')


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
            last_insert_result = execute_query("SELECT LAST_INSERT_ID() AS id", fetch=True)
            if not last_insert_result:
                raise Exception("Failed to retrieve the last inserted person ID.")
            first_row = last_insert_result[0]
            if isinstance(first_row, dict):
                person_id = first_row.get('id')
            else:
                person_id = first_row[0] if len(first_row) > 0 else None
            if person_id is None:
                raise Exception("Failed to retrieve the last inserted person ID.")

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

    # Check DB Managers 
    dbm_query = "SELECT * FROM db_managers WHERE username = %s AND password = %s"
    db_manager = execute_query(dbm_query, (username, hashed_pw), fetch=True)
    if db_manager:
        session['user'] = {'username': username, 'role': 'db_manager'}
        return redirect('/db_manager')

    # Check Persons 
    person_query = "SELECT * FROM persons WHERE username = %s AND password = %s"
    person = execute_query(person_query, (username, hashed_pw), fetch=True)
    
    if person:
        person_record = person[0]
        p_id = person_record['person_ID'] if isinstance(person_record, dict) else person_record[0]
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

if __name__ == '__main__':
    app.run()