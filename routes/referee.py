# referee.py
from flask import Blueprint, flash, redirect, render_template, request, session, url_for

from database_utils import execute_query

# 1. Define the Blueprint name and where it is located
referee_bp = Blueprint('referee_blueprint', __name__)

@referee_bp.route('/')
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

@referee_bp.route('/submit-result', methods=['POST'])
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
        
    return redirect(url_for('.referee_dashboard'))