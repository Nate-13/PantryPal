import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import time

SideBarLinks()

st.header("PantryPal")
'''
The ingredient-driven recipe platform.
'''
if st.session_state.get('role') == 'student':
    st.button("Recipe Challenges 🏆", type='primary', use_container_width=True)

data = {} 
try:
    response = requests.get('http://web-api:4000/recipes')
    response.raise_for_status()
    recipes = response.json()
except Exception as e:
    st.error("Could not connect to the API.")
    st.exception(e)
    recipes = []

try:
    ingredients_response = requests.get("http://web-api:4000/ingredients")
    ingredients_response.raise_for_status()
    all_ingredients = ingredients_response.json()  # Expecting a list of dicts with 'name'
    ingredient_options = sorted(list(set(i['name'] for i in all_ingredients if 'name' in i)))
except Exception as e:
    st.warning("Could not fetch ingredients for filter.")
    st.exception(e)
    ingredient_options = []

# UI with side-by-side layout
col1, col2, col3 = st.columns([3,2, 1])
with col1:
    selected_ingredients = st.multiselect("Search by ingredients", options=ingredient_options)
with col2:
    search = st.text_input("Search recipes by title or category")
with col3:
    difficulty_filter = st.selectbox("Filter by difficulty", options=["All", "EASY", "MEDIUM", "HARD"])

# apply search filters
filtered_recipes = []
for r in recipes:
    title_match = search.lower() in r['title'].lower()

    recipeId = r['recipeId']
    try:
        ingredients_response = requests.get(f"http://web-api:4000/recipe/{recipeId}/ingredients")
        ingredients_response.raise_for_status()
        ingredients = ingredients_response.json()
    except Exception as e:
        ingredients = []

    ingredient_names = [ing.get('name', '').lower() for ing in ingredients]

    matches_selected_ingredients = all(
        ing.lower() in ingredient_names for ing in selected_ingredients
    ) if selected_ingredients else True

    matches_difficulty = difficulty_filter == "All" or r["difficulty"] == difficulty_filter
    matches_search = search.lower() in r['title'].lower() or any(
        search.lower() in ing_name for ing_name in ingredient_names
    )

    if matches_difficulty and matches_search and matches_selected_ingredients:
        r['ingredients'] = ingredients
        filtered_recipes.append(r)

if not filtered_recipes:
    st.info("No recipes found. Request a recipe challenge from culinary students or chefs below!")
    with st.expander("✏️ Request a recipe challenge"):  # Use expander for a wider section
        st.multiselect("Select ingredients for your challenge:", default=selected_ingredients, options=ingredient_options)
        st.text_area("Write a brief description:")
        if st.button("Submit Challenge"):
            with st.spinner("Submitting your challenge..."):
                time.sleep(1.5)
                # API call to submit the challenge HERE
                st.success("Challenge submitted!")
else:
    f'''
    found {len(filtered_recipes)} recipes!
    '''
    num_cols = 2
    for i in range(0, len(filtered_recipes), num_cols):
        cols = st.columns(num_cols)
        for col, recipe in zip(cols, filtered_recipes[i:i + num_cols]):
            with col:
                st.markdown("----")
                with st.container():
                    left_col, right_col = st.columns([1, 2])
                    with left_col:
                        # Placeholder for recipe image
                        st.image(f"https://picsum.photos/id/159/300/400/?blur=10", use_container_width=True)
                    with right_col:
                        st.markdown(f"### {recipe['title']}")
                        st.markdown(recipe['description'])
                        st.markdown(f"**Created by:** {recipe['chefName']}")
                        st.markdown(f"**🕒 Prep Time:** {recipe['prepTime']} minutes | **🍽️ Servings:** {recipe['servings']}")
                        
                        difficulty = recipe.get("difficulty", "UNKNOWN")
                        if difficulty == "EASY":
                            st.badge("EASY", color="green")
                        elif difficulty == "MEDIUM":
                            st.badge("MEDIUM", color="orange")
                        elif difficulty == "HARD":
                            st.badge("HARD", color="red")
                        else:
                            st.info(f"Difficulty: {difficulty}")
                        
                        st.markdown(f"**🔥 Calories:** {recipe['calories']}")
