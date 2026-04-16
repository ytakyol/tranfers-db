from flask import Blueprint, flash, redirect, render_template, request, session, url_for
from database_utils import execute_query

manager_bp = Blueprint('manager_blueprint', __name__)

@manager_bp.route('/')
def manager_dashboard():
    if session.get('user', {}).get('role') != 'manager': 
        return redirect('/')
    
    user_id = session['user']['id']
    
    # 1. Get Manager Profile and Club Info [cite: 63]
    profile = execute_query("""
        SELECT p.name, p.surname, p.nationality, p.date_of_birth, m.preferred_formation, 
               m.experience_level, c.club_name, c.club_ID
        FROM persons p 
        JOIN managers m ON p.person_ID = m.person_ID 
        LEFT JOIN clubs c ON c.manager_ID = m.person_ID
        WHERE p.person_ID = %s
    """, (user_id,), fetch=True)
    
    profile_data = profile[0] if profile else {}
    club_id = profile_data.get('club_ID')

    fixtures, active_roster, standings, squad_stats = [], [], [], []
    top_scorers, top_assists, top_ratings = [], [], []
    all_comps, seasons = [], []

    # Get competitions for dropdowns
    all_comps = execute_query("SELECT competition_ID, name, season FROM competitions ORDER BY season DESC, name", fetch=True)
    seasons = list(set([c['season'] for c in all_comps])) if all_comps else []

    if club_id:
        # Filter params
        season_filter = request.args.get('season', '')
        comp_filter = request.args.get('competition_id', '')
        stat_filter_type = request.args.get('stat_filter_type', 'current')
        lb_season = request.args.get('lb_season', '')
        lb_comp = request.args.get('lb_comp', '')

        # 2. Fixtures & Results (Chronological DESC) [cite: 71, 73]
        fixture_query = """
            SELECT match_ID, match_datetime, 
                   IF(home_club_ID = %s, away_club_name, home_club_name) AS opposing_club,
                   competition_name, season, stadium_name,
                   IF(match_datetime > NOW(), 'Scheduled', CONCAT(home_goals, ' - ', away_goals)) AS final_score,
                   IF(match_datetime > NOW(), 'Scheduled',
                       IF(home_goals = away_goals, 'Draw',
                           IF((home_club_ID = %s AND home_goals > away_goals) OR 
                              (away_club_ID = %s AND away_goals > home_goals), 'Win', 'Loss')
                       )
                   ) AS result
            FROM view_manager_fixtures
            WHERE (home_club_ID = %s OR away_club_ID = %s)
        """
        params = [club_id, club_id, club_id, club_id, club_id]
        if season_filter:
            fixture_query += " AND season = %s"
            params.append(season_filter)
        if comp_filter:
            fixture_query += " AND competition_ID = %s"
            params.append(comp_filter)
        fixture_query += " ORDER BY match_datetime DESC"
        fixtures = execute_query(fixture_query, tuple(params), fetch=True)

        # 3. Active Roster (Loan Constraint enforced: player on loan can't play for parent) 
        active_roster = execute_query("""
            SELECT per.person_ID, per.name, per.surname, pl.main_position
            FROM persons per
            JOIN players pl ON per.person_ID = pl.person_ID
            JOIN contracts c ON per.person_ID = c.player_id
            WHERE c.club_id = %s AND c.start_date <= CURDATE() AND c.end_date >= CURDATE()
            AND (c.contract_type = 'Loan' OR 
                (c.contract_type = 'Permanent' AND NOT EXISTS (
                    SELECT 1 FROM contracts loan_c 
                    WHERE loan_c.player_id = c.player_id AND loan_c.contract_type = 'Loan' 
                    AND loan_c.start_date <= CURDATE() AND loan_c.end_date >= CURDATE()
                )))
        """, (club_id,), fetch=True)

        # 4. League Standings [cite: 78, 79, 80]
        standings = execute_query("""
            SELECT * FROM view_league_standings 
            WHERE (competition_ID = %s OR %s = '') AND (season = %s OR %s = '')
            ORDER BY total_points DESC, goal_difference DESC
        """, (comp_filter, comp_filter, season_filter, season_filter), fetch=True)

        # 5. Squad Statistics [cite: 83, 84, 85, 87]
        if stat_filter_type == 'current':
            squad_stats = execute_query("""
                SELECT per.name, per.surname, TIMESTAMPDIFF(YEAR, per.date_of_birth, CURDATE()) as age, 
                       pl.main_position, pl.strong_foot, pl.height, pl.market_value, per.nationality,
                       COUNT(ms.match_ID) as matches_played, COALESCE(SUM(ms.goals), 0) as goals, 
                       COALESCE(SUM(ms.assists), 0) as assists, COALESCE(SUM(ms.yellow_cards), 0) as yellow_cards, 
                       COALESCE(SUM(ms.red_cards), 0) as red_cards, AVG(ms.rating) as avg_rating, 
                       AVG(ms.minutes_played) as avg_minutes
                FROM persons per
                JOIN players pl ON per.person_ID = pl.person_ID
                JOIN contracts c ON per.person_ID = c.player_id
                LEFT JOIN match_stats ms ON per.person_ID = ms.player_ID AND ms.club_ID = %s
                WHERE c.club_id = %s AND c.start_date <= CURDATE() AND c.end_date >= CURDATE()
                GROUP BY per.person_ID
            """, (club_id, club_id), fetch=True)
        else:
            squad_stats = execute_query("""
                SELECT per.name, per.surname, TIMESTAMPDIFF(YEAR, per.date_of_birth, CURDATE()) as age, 
                       pl.main_position, pl.strong_foot, pl.height, pl.market_value, per.nationality,
                       COUNT(ms.match_ID) as matches_played, COALESCE(SUM(ms.goals), 0) as goals, 
                       COALESCE(SUM(ms.assists), 0) as assists, COALESCE(SUM(ms.yellow_cards), 0) as yellow_cards, 
                       COALESCE(SUM(ms.red_cards), 0) as red_cards, AVG(ms.rating) as avg_rating, 
                       AVG(ms.minutes_played) as avg_minutes
                FROM match_stats ms
                JOIN persons per ON ms.player_ID = per.person_ID
                JOIN players pl ON per.person_ID = pl.person_ID
                JOIN matches m ON ms.match_ID = m.match_ID
                JOIN competitions comp ON m.competition_ID = comp.competition_ID
                WHERE ms.club_ID = %s AND (comp.season = %s OR %s = '') AND (comp.competition_ID = %s OR %s = '')
                GROUP BY per.person_ID
            """, (club_id, season_filter, season_filter, comp_filter, comp_filter), fetch=True)

        # 6. Competition Leaderboards [cite: 88, 89, 90]
        if lb_comp and lb_season:
            top_scorers = execute_query("SELECT name, surname, club_name, matches_played, total_goals as metric FROM view_player_leaderboard_stats WHERE competition_ID=%s AND season=%s ORDER BY total_goals DESC LIMIT 10", (lb_comp, lb_season), fetch=True)
            top_assists = execute_query("SELECT name, surname, club_name, matches_played, total_assists as metric FROM view_player_leaderboard_stats WHERE competition_ID=%s AND season=%s ORDER BY total_assists DESC LIMIT 10", (lb_comp, lb_season), fetch=True)
            top_ratings = execute_query("SELECT name, surname, club_name, matches_played, avg_rating as metric FROM view_player_leaderboard_stats WHERE competition_ID=%s AND season=%s AND matches_played >= 3 ORDER BY avg_rating DESC LIMIT 10", (lb_comp, lb_season), fetch=True)

    return render_template('manager.html', 
                           profile=profile_data,
                           fixtures=fixtures,
                           active_roster=active_roster,
                           standings=standings,
                           squad_stats=squad_stats,
                           top_scorers=top_scorers,
                           top_assists=top_assists,
                           top_ratings=top_ratings,
                           all_comps=all_comps,
                           seasons=seasons,
                           request_args=request.args)

@manager_bp.route('/submit-squad', methods=['POST'])
def submit_squad():
    if session.get('user', {}).get('role') != 'manager': 
        return "Unauthorized", 403
    
    match_id = request.form['match_id']
    club_id = request.form['club_id']
    starters = request.form.getlist('starters')
    subs = request.form.getlist('subs')
    
    all_players = starters + subs

    if not (11 <= len(all_players) <= 23):
        flash("Squad size must be between 11 and 23 players.")
        return redirect(url_for(".manager_dashboard"))

    try:
        for pid in all_players:
            is_starter = 1 if pid in starters else 0
            position = 'START' if is_starter else 'SUB'
            execute_query("""
                INSERT INTO match_stats (player_ID, match_ID, club_ID, is_starter, minutes_played, position_in_match, goals, assists, yellow_cards, red_cards)
                VALUES (%s, %s, %s, %s, 0, %s, 0, 0, 0, 0)
            """, (pid, match_id, club_id, is_starter, position))
        flash("Match squad submitted successfully.")
    except Exception as e:
        flash(f"Error submitting squad: {e}")
        
    return redirect(url_for(".manager_dashboard"))