# referee.py
from flask import Blueprint, flash, redirect, render_template, request, session, url_for
from database_utils import execute_query

# 1. Define the Blueprint name and where it is located
referee_bp = Blueprint('referee_blueprint', __name__)

@referee_bp.route('/')
def referee_dashboard():
    if session.get('user', {}).get('role') != 'referee': return redirect('/')
    user_id = session['user']['id']
    
    # Profile [cite: 36, 46]
    profile = execute_query("SELECT * FROM view_referee_profile WHERE person_ID = %s", (user_id,), fetch=True)
    
    # Career stats overview (Only counts matches that have been played/officiated) [cite: 94]
    stats = execute_query("""
        SELECT COUNT(DISTINCT m.match_ID) as matches_officiated, 
               COALESCE(SUM(ms.red_cards), 0) as total_reds, 
               COALESCE(SUM(ms.yellow_cards), 0) as total_yellows
        FROM matches m LEFT JOIN match_stats ms ON m.match_ID = ms.match_ID
        WHERE m.referee_ID = %s AND m.match_datetime < NOW() AND m.attendance IS NOT NULL
    """, (user_id,), fetch=True)[0]

    # Match history [cite: 95, 96, 97, 98]
    match_history = execute_query("""
        SELECT * FROM view_referee_match_history 
        WHERE referee_ID = %s ORDER BY match_datetime DESC
    """, (user_id,), fetch=True)
    
    return render_template('referee.html', 
                           profile=profile[0] if profile else {}, 
                           stats=stats, 
                           match_history=match_history)

@referee_bp.route('/submit-result', methods=['POST'])
def submit_result():
    if session.get('user', {}).get('role') != 'referee': return "Unauthorized", 403
    
    match_id = request.form['match_id']
    attendance = request.form['attendance']
    home_goals = request.form['home_goals']
    away_goals = request.form['away_goals']
    
    try:
        # Only process if time has passed (Application-side check possible, but DB handles capacity trigger) [cite: 92, 93]
        execute_query("""
            UPDATE matches SET attendance = %s, home_goals = %s, away_goals = %s 
            WHERE match_ID = %s AND match_datetime < NOW() AND referee_ID = %s
        """, (attendance, home_goals, away_goals, match_id, session['user']['id']))
        flash("Match outcome updated.")
    except Exception as e:
        flash(f"Database Error: {e}")
        
    return redirect(url_for('.referee_dashboard'))

@referee_bp.route('/submit-player-stats', methods=['POST'])
def submit_player_stats():
    if session.get('user', {}).get('role') != 'referee': return "Unauthorized", 403
    
    match_id = request.form['match_id']
    player_id = request.form['player_id']
    minutes_played = request.form['minutes_played']
    position = request.form['position']
    goals = request.form['goals']
    assists = request.form['assists']
    yellow_cards = request.form['yellow_cards']
    red_cards = request.form['red_cards']
    rating = request.form['rating']

    try:
        # Security: Ensure the match belongs to this referee and has already happened [cite: 35, 92]
        valid_match = execute_query("SELECT 1 FROM matches WHERE match_ID = %s AND referee_ID = %s AND match_datetime < NOW()", (match_id, session['user']['id']), fetch=True)
        if not valid_match:
            flash("Invalid match or match hasn't happened yet.")
            return redirect(url_for('.referee_dashboard'))

        # Update the squad player stats initialized by the manager [cite: 35]
        execute_query("""
            UPDATE match_stats 
            SET minutes_played = %s, position_in_match = %s, goals = %s, assists = %s, 
                yellow_cards = %s, red_cards = %s, rating = %s
            WHERE match_ID = %s AND player_ID = %s
        """, (minutes_played, position, goals, assists, yellow_cards, red_cards, rating, match_id, player_id))
        flash("Player performance statistics updated successfully.")
    except Exception as e:
        flash(f"Database Error: {e}")

    return redirect(url_for('.referee_dashboard'))