from flask import Blueprint, flash, redirect, render_template, request, session, url_for

from database_utils import execute_query

# 1. Define the Blueprint name and where it is located
manager_bp = Blueprint('manager_blueprint', __name__)

@manager_bp.route('/')
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

@manager_bp.route('/submit-squad', methods=['POST'])
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
        
    return redirect(url_for(".manager_dashboard"))