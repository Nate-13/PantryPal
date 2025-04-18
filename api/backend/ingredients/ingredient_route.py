from flask import Blueprint, request, jsonify, make_response, current_app
from backend.db_connection import db

# ------------------------------------------------------------
# Create a new Blueprint object for ingredients
ingredients = Blueprint('ingredients', __name__)

# ------------------------------------------------------------
# Gets all ingredients from the database
@ingredients.route('/ingredients', methods=['GET'])
def get_all_ingredients():
    query = '''
            SELECT *
            FROM ingredients;
            '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

# ------------------------------------------------------------
# POST /ingredients
# This endpoint inserts a new ingredient into the database.
@ingredients.route('/ingredients', methods=['POST'])
def add_ingredient():
    data = request.get_json()
    name = data.get('name')

    query = '''
        INSERT INTO ingredients (name)
        VALUES (%s);
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query, (name,))
    db.get_db().commit()

    return make_response(jsonify({'message': 'Ingredient added successfully'}), 201)


# ------------------------------------------------------------
# PUT /ingredients/<id>
# This endpoint updates the ingredient name in the database.
@ingredients.route('/ingredients/<int:id>', methods=['PUT'])
def update_ingredient(id):
    data = request.get_json()
    name = data.get('name')

    query = '''
        UPDATE ingredients
        SET name = %s
        WHERE ingredientId = %s;
    '''

    cursor = db.get_db().cursor()
    cursor.execute(query, (name, id))
    db.get_db().commit()

    return make_response(jsonify({'message': 'Ingredient updated successfully'}), 200)

# ------------------------------------------------------------
# gets an ingredient id by name
@ingredients.route('/ingredients/<name>', methods=['GET'])
def get_ingredient_by_name(name):
    query = '''
            SELECT *
            FROM ingredients
            WHERE name = %s;
            '''
    cursor = db.get_db().cursor()
    cursor.execute(query, (name,))
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response