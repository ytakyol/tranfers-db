from flask import Blueprint, flash, redirect, render_template, request, session, url_for

from database_utils import execute_query

# 1. Define the Blueprint name and where it is located
player_bp = Blueprint('player_blueprint', __name__)

@player_bp .route('/player')
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

@player_bp .route('/player/stats', methods=['GET'])
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