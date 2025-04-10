from flask import Blueprint
from flask import request
from flask import jsonify
from flask import make_response
from flask import current_app
from backend.db_connection import db

#------------------------------------------------------------
# Create a new Blueprint object, which is a collection of 
# routes.
recipes = Blueprint('recipes', __name__)


#------------------------------------------------------------
# Get all the recipes from the database, package them up,
# and return them to the client
@recipes.route('/recipes', methods=['GET'])
def get_recipes():
    query = '''
        SELECT  *
        FROM recipes;
    '''
    
    # get a cursor object from the database
    cursor = db.get_db().cursor()

    # use cursor to query the database for a list of products
    cursor.execute(query)

    # fetch all the data from the cursor
    # The cursor will return the data as a 
    # Python Dictionary
    theData = cursor.fetchall()

    # Create a HTTP Response object and add results of the query to it
    # after "jasonify"-ing it.
    response = make_response(jsonify(theData))
    # set the proper HTTP Status code of 200 (meaning all good)
    response.status_code = 200
    # send the response back to the client
    return response

#------------------------------------------------------------
# Gets a single recipe from the database by id, packages it up,
# and return it to the client
#------------------------------------------------------------
@recipes.route('/recipe/<id>', methods=['GET'])
def get_recipe (id):

    query = f'''SELECT *
            FROM recipes 
            WHERE recipeId = {str(id)} 
        '''
    
    # logging the query for debugging purposes.  
    # The output will appear in the Docker logs output
    # This line has nothing to do with actually executing the query...
        # It is only for debugging purposes. 
        
    current_app.logger.info(f'GET /recipes/<id> query={query}')

    # get the database connection, execute the query, and 
    # fetch the results as a Python Dictionary
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()
        
    # Another example of logging for debugging purposes.
    # You can see if the data you're getting back is what you expect. 
    current_app.logger.info(f'GET /recipes/<id> Result of query = {theData}')
        
    response = make_response(jsonify(theData))
    response.status_code = 200
    return response

#------------------------------------------------------------
# Gets all ingredients for a single  recipe from the database by id,
# packages it up, and return it to the client
#------------------------------------------------------------
@recipes.route('/recipe/<id>/ingredients', methods=['GET'])
def get_recipe_ingredients(id):
    query = f'''
            SELECT i.name, i.cost, ri.quantity, ri.unit
            FROM ingredients i
            JOIN recipeIngredients ri ON i.ingredientId = ri.ingredientId
            WHERE ri.recipeId = {str(id)};
            '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


#------------------------------------------------------------
# Gets all recipies in a single category from the database
# by category name, packages it up, and return it to the client
#------------------------------------------------------------
@recipes.route('/recipes/<categoryName>', methods=['GET']) # must put categoty name in quotes
def get_recipes_by_category(categoryName):
    query = f'''
            SELECT *
            FROM  recipes r
            JOIN categories c ON r.recipeId = c.recipeId
            where c.categoryName = {str(categoryName)};
            '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    theData = cursor.fetchall()

    response = make_response(jsonify(theData))
    response.status_code = 200
    return response


# ------------------------------------------------------------
# This is a POST route to add a new recipe.
@recipes.route('/recipes', methods=['POST'])
def add_new_recipe():
    
    # In a POST request, there is a 
    # collecting data from the request object 
    the_data = request.json
    current_app.logger.info(the_data)

    #extracting the variable
    chefId = the_data['chef_id']
    title = the_data['title']
    description = the_data['description']
    prepTime = the_data['prepTime']
    servings = the_data['servings']
    difficulty = the_data['difficulty']
    calories = the_data['calories']
    
    query = f'''
        INSERT INTO recipes (chefId, title, description, prepTime, servings, difficulty, calories)
        VALUES ('{chefId}', '{title}', '{description}', {prepTime}, {servings}, {difficulty}, {calories})
    '''
 
    current_app.logger.info(query)

    # executing and committing the insert statement 
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    
    response = make_response("Successfully added recipe")
    response.status_code = 200
    return response


# ------------------------------------------------------------
# Updates a recipe in the database
@recipes.route('/recipes', methods=['PUT'])
def update_recipe_post():
    current_app.logger.info('PUT /recipe route')

    recipe_info = request.json

    recipeId = recipe_info['recipeId']
    chefId = recipe_info['chefId']
    title = recipe_info['title']
    description = recipe_info['description']
    prepTime = recipe_info['prepTime']
    servings = recipe_info['servings']
    difficulty = recipe_info['difficulty']
    calories = recipe_info['calories']

    query = f'''
            UPDATE recipes
            SET chefId = {str(chefId)},
            title = {title},
            description = {description},
            prepTime = {str(prepTime)},
            servings = {str(servings)},
            difficulty = {difficulty},
            calories = {str(calories)}
            WHERE recipeId = {str(recipeId)}
            '''

    cursor = db.get_db().cursor()
    r = cursor.execute(query)
    db.get_db().commit()
    return f'recipe added!'

# ------------------------------------------------------------
# Deletes a recipe from the database # BROKEN?
@recipes.route('/recipe/<id>/delete', methods=['DELETE'])
def delete_recipe(id):
    query = f'''
            DELETE FROM recipes
            WHERE recipeId = {str(id)};
            '''
    cursor = db.get_db().cursor()
    cursor.execute(query)
    db.get_db().commit()
    return "Recipe Deleted!"
