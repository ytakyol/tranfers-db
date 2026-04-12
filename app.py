from flask import Flask, render_template, request, redirect, session, flash
import hashlib
from database_utils import execute_query

app = Flask(__name__)
app.secret_key = 'super_secret_key'

# Password Hashing (SHA-256) as required [cite: 148]
def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/signup', methods=['POST'])
def signup():
    username = request.form['username']
    password = request.form['password']
    role = request.form['role']
    
    # Password Policy Check (Must be done in Backend) [cite: 158]
    if len(password) < 8 or not any(c.isupper() for c in password):
        flash("Password does not meet requirements!") 
        return redirect('/')

    hashed_pw = hash_password(password)
    
    # Manual SQL Insert [cite: 172]
    query = "INSERT INTO Users (username, password, role) VALUES (%s, %s, %s)"
    execute_query(query, (username, hashed_pw, role))
    return redirect('/')

@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    hashed_pw = hash_password(password)

    # Prepared Statement for Login [cite: 151, 153]
    query = "SELECT * FROM Users WHERE username = %s AND password = %s"
    user = execute_query(query, (username, hashed_pw), fetch=True)

    if user:
        session['user'] = user[0]
        role = user[0]['role']
        if role == 'db_manager': return redirect('/db_manager')
        if role == 'player': return redirect('/player')
        return redirect('/')
    return "Login Failed"

@app.route('/db_manager/schedule', methods=['POST'])
def schedule_match():
    # Only DB Managers can schedule [cite: 49]
    if session.get('user', {}).get('role') != 'db_manager':
        return "Unauthorized", 403
        
    data = (
        request.form['match_date'], # Must be YYYY-MM-DD [cite: 178]
        request.form['stadium_id'],
        request.form['home_club'],
        request.form['away_club'],
        request.form['referee_id'],
        request.form['comp_id']
    )
    
    query = """
        INSERT INTO Matches (match_date, stadium_id, home_club_id, away_club_id, referee_id, competition_id)
        VALUES (%s, %s, %s, %s, %s, %s)
    """
    try:
        execute_query(query, data)
    except Exception as e:
        # This will catch Trigger failures (e.g., 120-min conflict) [cite: 157, 162]
        return f"Database Error: {str(e)}"
    
    return redirect('/db_manager')

if __name__ == '__main__':
    app.run(debug=True)