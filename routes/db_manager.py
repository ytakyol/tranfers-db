from flask import Blueprint, flash, redirect, render_template, request, session, url_for
from database_utils import execute_query

# Define the Blueprint name and where it is located
dbmanager_bp = Blueprint('dbmanager_blueprint', __name__)

@dbmanager_bp.route('/')
def db_manager_dashboard():
    if session.get('user', {}).get('role') != 'db_manager': return redirect('/')
    
    # Use the newly created view to fetch stadiums
    stadiums = execute_query("SELECT * FROM view_stadiums", fetch=True) 
    return render_template('db_manager.html', stadiums=stadiums)

@dbmanager_bp.route('/schedule-match', methods=['POST'])
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
        execute_query(query, data) 
        flash("Match scheduled successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
    
    return redirect(url_for(".db_manager_dashboard"))

@dbmanager_bp.route('/transfer', methods=['POST'])
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
        
        # 1. Insert Transfer Record
        execute_query("""
            INSERT INTO transfer_record (player_id, from_club_id, to_club_id, transfer_date, transfer_fee, transfer_type)
            VALUES (%s, %s, %s, CURDATE(), %s, %s)
        """, (player_id, from_club_id, to_club_id, fee, transfer_type))
        
        # 2. Update Market Value if Purchase
        if transfer_type == 'Purchase':
            execute_query("UPDATE players SET market_value = %s WHERE person_ID = %s", (fee, player_id))
            # Terminate old permanent contract
            execute_query("UPDATE contracts SET end_date = CURDATE() WHERE player_id = %s AND contract_type = 'Permanent' AND end_date > CURDATE()", (player_id,))
            
        # 3. Create new Contract
        execute_query("""
            INSERT INTO contracts (player_id, club_id, start_date, end_date, weekly_wage, contract_type)
            VALUES (%s, %s, CURDATE(), %s, %s, %s)
        """, (player_id, to_club_id, request.form['end_date'], request.form['wage'], transfer_type))

        flash("Transfer registered successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
        
    return redirect(url_for(".db_manager_dashboard"))

@dbmanager_bp.route('/rename-stadium', methods=['POST'])
def rename_stadium():
    if session.get('user', {}).get('role') != 'db_manager': return "Unauthorized", 403
    
    stadium_id = request.form['stadium_id']
    new_name = request.form['new_name']
    
    try:
        # ON UPDATE CASCADE in schema handles updating club associations automatically
        execute_query("UPDATE stadiums SET stadium_name = %s WHERE stadium_ID = %s", (new_name, stadium_id))
        flash("Stadium renamed successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
        
    return redirect(url_for(".db_manager_dashboard"))

@dbmanager_bp.route('/assign-manager', methods=['POST'])
def assign_manager():
    if session.get('user', {}).get('role') != 'db_manager': return "Unauthorized", 403
    
    club_id = request.form['club_id']
    manager_id = request.form['manager_id']
    
    try:
        # Allows for assigning a manager or removing one (if input is empty)
        manager_val = manager_id if manager_id.strip() else None
        execute_query("UPDATE clubs SET manager_ID = %s WHERE club_ID = %s", (manager_val, club_id))
        flash("Manager assigned to club successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
        
    return redirect(url_for(".db_manager_dashboard"))

@dbmanager_bp.route('/create-competition', methods=['POST'])
def create_competition():
    if session.get('user', {}).get('role') != 'db_manager': return "Unauthorized", 403
    
    name = request.form['name']
    season = request.form['season']
    country = request.form['country']
    comp_type = request.form['competition_type']
    
    try:
        execute_query("""
            INSERT INTO competitions (name, season, country, competition_type)
            VALUES (%s, %s, %s, %s)
        """, (name, season, country, comp_type))
        flash("Competition created successfully.")
    except Exception as e:
        flash(f"Database Error: {str(e)}")
        
    return redirect(url_for(".db_manager_dashboard"))