from flask import Blueprint, request, jsonify, make_response, current_app
import json
from backend.db_connection import db

users = Blueprint('users', __name__)

# Get all user profiles
@users.route('/users', methods=['GET'])
def get_all_users():
    cursor = db.get_db().cursor()
    the_query = '''
        SELECT userId, username, firstName, lastName, email
        FROM users
    '''
    cursor.execute(the_query)
    theData = cursor.fetchall()
    the_response = make_response(theData)
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Get a specific user profile
@users.route('/users/<userId>', methods=['GET'])
def get_user(userId):
    current_app.logger.info('GET /users/<userId> route')
    cursor = db.get_db().cursor()
    cursor.execute('SELECT userId, username, firstName, lastName, email FROM users WHERE userId = %s', (userId,))
    theData = cursor.fetchall()
    the_response = make_response(jsonify(theData))
    the_response.status_code = 200
    the_response.mimetype = 'application/json'
    return the_response

# Update a specific user's profile
@users.route('/users', methods=['PUT'])
def update_user():
    current_app.logger.info('PUT /users route')
    
    user_info = request.json
    user_id = user_info['userId']
    username = user_info['username']
    first = user_info['firstName']
    last = user_info['lastName']
    email = user_info['email']

    query = '''
        UPDATE users 
        SET username = %s, firstName = %s, lastName = %s, email = %s 
        WHERE userId = %s
    '''
    data = (username, first, last, email, user_id)

    cursor = db.get_db().cursor()
    cursor.execute(query, data)
    db.get_db().commit()

    return 'user updated!'

# Delete a user profile
@users.route('/users/<userId>', methods=['DELETE'])
def delete_user(userId):
    cursor = db.get_db().cursor()
    cursor.execute('DELETE FROM users WHERE userId = %s', (userId,))
    db.get_db().commit()
    return 'user deleted!'