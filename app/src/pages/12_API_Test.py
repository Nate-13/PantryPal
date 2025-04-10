import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# Accessing a REST API from Within Streamlit")

"""
Simply retrieving data from a REST api running in a separate Docker Container.

If the container isn't running, this will be very unhappy.  But the Streamlit app 
should not totally die. 
"""
data = {} 
try:
    response = requests.get('http://web-api:4000/recipes')
    response.raise_for_status()
    recipes = response.json()
except Exception as e:
    st.error("Could not connect to the API.")
    st.exception(e)
    recipes = []

st.title("📖 All Recipes")
difficulty_filter = st.selectbox("Filter by difficulty", options=["All", "EASY", "MEDIUM", "HARD"])

search = st.text_input("🔍 Search recipes by title, ingredients, or category")
# Apply filters
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

    ingredient_match = any(
        search.lower() in str(ing.get('name', '')).lower()
        for ing in ingredients
    )

    if (title_match or ingredient_match) and (
        difficulty_filter == "All" or r["difficulty"] == difficulty_filter
    ):
        r['ingredients'] = ingredients
        filtered_recipes.append(r)

if not filtered_recipes:
    st.info("No recipes found.")
else:
    num_cols = 1
    for i in range(0, len(filtered_recipes), num_cols):
        cols = st.columns(num_cols)
        for col, recipe in zip(cols, filtered_recipes[i:i + num_cols]):
            with col:
                st.markdown("----")
                st.subheader(f"🍽️ {recipe['title']}")
                st.markdown(f"**🧑‍🍳 Chef ID:** {recipe['chefId']}")
                st.markdown(f"**📝 Description:** {recipe['description']}")
                st.markdown(f"**📅 Posted on:** {recipe['datePosted']}")
                st.markdown(f"**🕒 Prep Time:** {recipe['prepTime']} minutes")
                st.markdown(f"**🍽️ Servings:** {recipe['servings']}")
                st.markdown(f"**🔥 Calories:** {recipe['calories']}")
                
                difficulty = recipe.get("difficulty", "UNKNOWN")
                if difficulty == "EASY":
                    st.success("Difficulty: EASY")
                elif difficulty == "MEDIUM":
                    st.warning("Difficulty: MEDIUM")
                elif difficulty == "HARD":
                    st.error("Difficulty: HARD")
                else:
                    st.info(f"Difficulty: {difficulty}")


