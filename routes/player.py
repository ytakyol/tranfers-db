from flask import Blueprint, flash, redirect, render_template, request, session, url_for
from database_utils import execute_query

player_bp = Blueprint('player_blueprint', __name__)

@player_bp.route('/')
def player_dashboard():
    if session.get('user', {}).get('role') != 'player': 
        return redirect('/')
    
    user_id = session['user']['id']
    
    # 1. Fetch Profile using the View
    profile = execute_query("SELECT * FROM view_player_profile WHERE person_ID = %s", (user_id,), fetch=True)

    # 2. Performance Statistics Filters (Aggregating from the Match History View)
    filter_type = request.args.get('filter_type', 'career')
    season = request.args.get('season', '')
    comp_id = request.args.get('competition_id', '')
    
    stats_query = """
        SELECT COUNT(*) as games_played, 
               COALESCE(SUM(goals), 0) as total_goals, 
               COALESCE(SUM(assists), 0) as total_assists,
               COALESCE(SUM(yellow_cards), 0) as total_yellow_cards, 
               COALESCE(SUM(red_cards), 0) as total_red_cards, 
               AVG(rating) as average_rating
        FROM view_player_match_history 
        WHERE player_ID = %s
    """
    params = [user_id]
    
    if filter_type == 'season' and season:
        stats_query += " AND season = %s"
        params.append(season)
    elif filter_type == 'competition' and season and comp_id:
        stats_query += " AND season = %s AND competition_ID = %s"
        params.extend([season, comp_id])
        
    stats = execute_query(stats_query, tuple(params), fetch=True)

    # 3. Match History using the View
    match_history = execute_query("""
        SELECT * FROM view_player_match_history 
        WHERE player_ID = %s ORDER BY match_datetime DESC
    """, (user_id,), fetch=True)

    # 4. Career History (Contracts & Transfers) using Views
    contracts = execute_query("SELECT * FROM view_player_contracts WHERE player_id = %s ORDER BY start_date DESC", (user_id,), fetch=True)
    transfers = execute_query("SELECT * FROM view_player_transfers WHERE player_id = %s ORDER BY transfer_date DESC", (user_id,), fetch=True)

    # 5. Fetch unique seasons and competitions for the UI dropdown filters
    all_comps = execute_query("SELECT competition_ID, name, season FROM competitions ORDER BY season DESC, name", fetch=True)
    seasons = list(set([c['season'] for c in all_comps])) if all_comps else []

    return render_template('player.html', 
                           profile=profile[0] if profile else {},
                           stats=stats[0] if stats else {},
                           match_history=match_history,
                           contracts=contracts,
                           transfers=transfers,
                           filter_type=filter_type,
                           seasons=seasons,
                           all_comps=all_comps,
                           selected_season=season,
                           selected_comp=comp_id)