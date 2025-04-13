from flask import  request
from flask import Blueprint
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db



challenges_bp = Blueprint('challenges', __name__)

#-----------------------------------------------
# gets all challenge from the database
# and returns them to the client

@challenges_bp.route('/all', methods=['GET'])
def get_all_challenges():
    sql = "SELECT * FROM challenges ORDER BY createdAt DESC;"
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    data = cursor.fetchall()
    return make_response(jsonify(data), 200)

#-----------------------------------------------
# gets all challenge requests from the database
# and returns them to the client
@challenges_bp.route('/all-requests', methods=['GET'])
def get_all_requests():
    sql = ("SELECT * "
           "FROM challengeRequests;")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response
#-----------------------------------------------

# ----- Challenge Requests -----
@challenges_bp.route('/requests/not-reviewed', methods=['GET'])
def not_reviewed():
    sql = ("SELECT * "
           "FROM challengeRequests "
           "WHERE status = 'NOT REVIEWED';")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()



    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@challenges_bp.route('/requests/denied', methods=['GET'])
def denied_requests():
    sql = """
        SELECT u.username, cr.requestID, cr.dateSubmitted
        FROM challengeRequests cr
        JOIN users u ON cr.requestedById = u.userId
        WHERE cr.status = 'denied';
    """
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()



    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@challenges_bp.route('/requests/<int:request_id>/approve', methods=['PUT'])
def approve_request(request_id):
    try:
        reviewer_id = 2
        cursor = db.get_db().cursor()

        # Step 1: Mark request as approved
        cursor.execute("""
            UPDATE challengeRequests
            SET status = 'APPROVED', reviewedBy = %s
            WHERE requestID = %s;
        """, (reviewer_id, request_id))

        # Step 2: Fetch request data
        cursor.execute("""
            SELECT description, requestedById
            FROM challengeRequests
            WHERE requestID = %s;
        """, (request_id,))
        req = cursor.fetchone()

        if req is None:
            db.get_db().rollback()
            return make_response({'error': 'Request not found'}, 404)

        description, requested_by_id = req
        current_app.logger.info(f"Approving request {request_id} with description: {description}")

        # Step 3: Insert challenge with difficulty NULL
        cursor.execute("""
            INSERT INTO challenges (description, approvedById, difficulty, status)
            VALUES (%s, %s, %s, 'UNCLAIMED');
        """, (description, reviewer_id, None))
        challenge_id = cursor.lastrowid

        # Step 4: Copy ingredients safely
        cursor.execute("""
            SELECT ingredientId
            FROM requestIngredients
            WHERE requestId = %s;
        """, (request_id,))
        ingredients = cursor.fetchall()

        # This will work whether fetchall() returns tuples or dicts
        for row in ingredients:
            if isinstance(row, dict):
                ingredient_id = row["ingredientId"]
            else:
                ingredient_id = row[0]

            cursor.execute("""
                INSERT INTO challengeIngredients (challengeId, ingredientId)
                VALUES (%s, %s);
            """, (challenge_id, ingredient_id))

        db.get_db().commit()
        return make_response({'message': f'Request {request_id} approved and challenge {challenge_id} created'}, 200)

    except Exception as e:
        db.get_db().rollback()
        current_app.logger.error(f"Error during approval: {str(e)}")
        return make_response({'error': str(e)}, 500)


@challenges_bp.route('/requests/<int:request_id>/decline', methods=['PUT'])
def decline_request(request_id):
    try:
        reviewer_id = 1
        sql = """
            UPDATE challengeRequests
            SET status = 'DENIED', reviewedBy = %s
            WHERE requestID = %s;
        """
        cursor = db.get_db().cursor()
        cursor.execute(sql, (reviewer_id, request_id))
        db.get_db().commit()

        response = make_response({'message': f'Request {request_id} declined'})
        response.status_code = 200
        return response

    except Exception as e:
        db.get_db().rollback()
        return make_response({'error': str(e)}, 500)

@challenges_bp.route('/requests/user/<int:user_id>', methods=['GET'])
def user_requests(user_id):
    sql = (f"SELECT * "
           f"FROM challengeRequests "
           f"WHERE requestedById = {user_id};")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@challenges_bp.route('/requests/active', methods=['GET'])
def active_requests():
    sql = ("SELECT * "
           "FROM challengeRequests "
           "WHERE status = 'approved';")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ----- Challenges Management -----
@challenges_bp.route('/available', methods=['GET'])
def available_challenges():
    sql = ("SELECT * "
           "FROM challenges "
           "WHERE status = 'UNCLAIMED';") # never null...
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@challenges_bp.route('/claim/<int:challenge_id>', methods=['PUT'])
def claim_challenge(challenge_id):
    user_id = request.json.get('user_id')
    sql = (f"UPDATE challenges "
           f"SET studentId = {user_id} "
           f"WHERE challengeId = {challenge_id};")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    db.get_db().commit()

    response = make_response({'message': f'Challenge {challenge_id} claimed by user {user_id}'})
    response.status_code = 200
    return response

@challenges_bp.route('/status/<int:challenge_id>', methods=['PUT'])
def update_challenge_status(challenge_id):
    status = request.json.get('status')
    sql = (f"UPDATE challenges "
           f"SET status = '{status}' "
           f"WHERE challengeId = {challenge_id};")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    db.get_db().commit()

    response = make_response({'message': f'Challenge {challenge_id} updated to {status}'})
    response.status_code = 200
    return response


@challenges_bp.route('/post', methods=['POST'])
def post_challenge():
    data = request.json
    description = data.get('description')
    difficulty = data.get('difficulty')
    approved_by = data.get('approvedById')
    sql = f"""
        INSERT INTO challenges (description, difficulty,approvedById)
        VALUES ('{description}', '{difficulty}', '{approved_by}');
    """
    current_app.logger.info(sql)

    # executing and committing the insert statement
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    db.get_db().commit()

    response = make_response({'message': 'Challenge created'})
    response.status_code = 200
    return response

@challenges_bp.route('/<int:challenge_id>', methods=['GET'])
def get_challenge(challenge_id):
    sql = f"SELECT * FROM challenges WHERE challengeId = {challenge_id};"
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@challenges_bp.route('/<int:challenge_id>/ingredients', methods=['GET'])
def get_challenge_ingredients(challenge_id):
    sql = (f"SELECT i.name "
           f"FROM challengeIngredients ci JOIN ingredients i ON ci.ingredientId = i.ingredientId "
           f"WHERE challengeId = {challenge_id};")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

@challenges_bp.route('/difficulty/<string:level>', methods=['GET'])
def challenges_by_difficulty(level):
    sql = (f"SELECT * "
           f"FROM challenges "
           f"WHERE difficulty = '{level}' AND status is NULL;")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response




@challenges_bp.route('/new-challenge-request', methods=['POST'])
def submit_challenge_request():
    the_data = request.json
    current_app.logger.info(the_data)

    # Extracting variables
    description = the_data['description']
    ingredients = the_data['ingredients']
    requestedById = the_data['requestedById']

    try:
        
        query = '''
            INSERT INTO challengeRequests (requestedById, description)
            VALUES (%s, %s);
        '''
        cursor = db.get_db().cursor()
        cursor.execute(query, (requestedById, description))
        req_id = cursor.lastrowid  

        for ing in ingredients:
            req_ing_query = '''
                INSERT INTO requestIngredients (requestId, ingredientId)
                VALUES (%s, %s);
            '''
            cursor.execute(req_ing_query, (req_id, ing))

        db.get_db().commit()

        response = make_response({'message': 'Challenge request submitted'})
        response.status_code = 200
    except Exception as e:
        current_app.logger.error(f"Error submitting challenge request: {e}")
        db.get_db().rollback()
        response = make_response({'message': 'Failed to submit challenge request'}, 500)

    return response

# gets all ingredients for a challenge request
@challenges_bp.route('/<int:request_id>/ingredients', methods=['GET'])
def get_request_ingredients(request_id):
    sql = (f"SELECT i.name "
           f"FROM requestIngredients ri JOIN ingredients i ON ri.ingredientId = i.ingredientId "
           f"WHERE requestId = {request_id};")
    cursor = db.get_db().cursor()
    cursor.execute(sql)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response



