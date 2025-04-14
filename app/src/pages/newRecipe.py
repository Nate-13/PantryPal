import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
import time

st.set_page_config(page_title="New Recipe", page_icon="🍽️", layout='wide')

SideBarLinks()

st.write("### Create a New Recipe")
recipe_name = st.text_input("Recipe Name", placeholder="Enter recipe name")
recipe_description = st.text_area("Description", placeholder="Enter recipe description")
recipe_instructions = st.text_area("Instructions", placeholder="Enter recipe instructions")

col1, col2, col3, col4 = st.columns([1, 1, 1, 1])
with col1:
    difficulty = st.selectbox("Difficulty", ["EASY", "MEDIUM", "HARD"])
with col2:
    prep_time = st.text_input("Prep Time (minutes)", placeholder="Enter prep time")
with col3:
    calories = st.text_input("Calories", placeholder="Enter calories")
with col4:
    servings = st.text_input("Servings", placeholder="Enter number of servings")
st.write("")
st.write("----")
st.write("### Ingredients")

ingredients = []

ingredient_options = []

try:
    ingredients_response = requests.get("http://web-api:4000/ingredients")
    ingredients_response.raise_for_status()
    all_ingredients = ingredients_response.json()
    ingredient_options = sorted(list(set(i['name'] for i in all_ingredients if 'name' in i)))
except Exception as e:
    st.warning("Could not fetch ingredients.")
    st.exception(e)

def add_ingredient():
    ingredients.append({"name": "", "quantity": "", "unit": ""})

if "ingredients" not in st.session_state:
    st.session_state.ingredients = [{"name": "", "quantity": "", "unit": ""}]

# Handle adding a new ingredient
if st.button("Add Another Ingredient"):
    st.session_state.ingredients.append({"name": "", "quantity": "", "unit": ""})

# Render the ingredients list
for i, ingredient in enumerate(st.session_state.ingredients):
    cols = st.columns([3, 1, 1, 0.5])
    ingredient["name"] = cols[0].selectbox(f"Ingredient", options=ingredient_options, key=f"name_{i}")
    ingredient["quantity"] = cols[1].text_input(f"Quantity", value=ingredient["quantity"], placeholder="Enter quantity", key=f"quantity_{i}")
    ingredient["unit"] = cols[2].text_input(f"Unit", value=ingredient["unit"], placeholder="Enter unit", key=f"unit_{i}")
    with cols[3]:
        if st.button("❌", key=f"delete_{i}"):  # Add a delete button
            st.session_state.ingredients.pop(i)


st.write("")  # Add some spacing
if st.button("Submit Recipe", type='primary', use_container_width=True):
    if not recipe_name or not recipe_description or not calories or not servings or not prep_time:
        st.warning("Please fill in all fields.")
    elif not any(ingredient["name"] for ingredient in st.session_state.ingredients):
        st.warning("Please add at least one ingredient.")
    elif not all(ingredient["quantity"] and ingredient["unit"] for ingredient in st.session_state.ingredients if ingredient["name"]):
        st.warning("Please fill in all ingredient fields.")
    else:
        for ingredient in st.session_state.ingredients:
            compiled_ingredients = []
        for ingredient in st.session_state.ingredients:
            try:
                ingredient_data = requests.get(f"http://web-api:4000/ingredients/{ingredient['name']}").json()
                ingredient_id = ingredient_data[0].get('ingredientId', None)

                if ingredient_id:
                    compiled_ingredients.append({
                        "ingredientId": ingredient_id,
                        "name": ingredient["name"],
                        "quantity": ingredient["quantity"],
                        "unit": ingredient["unit"]
                    })
                else:
                    st.warning(f"Ingredient ID not found for {ingredient['name']}.")
            except Exception as e:
                st.warning(f"Could not fetch ingredient ID for {ingredient['name']}.")
                st.exception(e)

        recipe_data = {
            "title": recipe_name,
            "description": recipe_description,
            "instructions": recipe_instructions,
            "difficulty": difficulty,  # Placeholder for difficulty
            "prepTime": prep_time,  # Placeholder for prep time
            "calories": calories,  # Placeholder for calories
            "servings": servings,  # Placeholder for servings
            "ingredients": compiled_ingredients,
            "chefId": st.session_state['userId']  # Assuming the userId is the chefId
        }
        try:
            response = requests.post("http://web-api:4000/recipe/add", json=recipe_data)
            response.raise_for_status()
            st.success("Recipe submitted successfully!")
            with st.spinner("Redirecting..."):
                time.sleep(1)
                st.switch_page('pages/pantrypal_home.py')
        except Exception as e:
            st.error("Failed to submit recipe.")
            st.exception(e)