import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
from datetime import datetime

SideBarLinks()

st.write("### Create a New Recipe")
recipe_name = st.text_input("Recipe Name", placeholder="Enter recipe name")
recipe_description = st.text_area("Description", placeholder="Enter recipe description")
recipe_instructions = st.text_area("Instructions", placeholder="Enter recipe instructions")

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
    ingredient["name"] = cols[0].selectbox(f"Ingredient {i+1}", options=ingredient_options, key=f"name_{i}")
    ingredient["quantity"] = cols[1].text_input(f"Quantity {i+1}", value=ingredient["quantity"], placeholder="Enter quantity", key=f"quantity_{i}")
    ingredient["unit"] = cols[2].text_input(f"Unit {i+1}", value=ingredient["unit"], placeholder="Enter unit", key=f"unit_{i}")
    with cols[3]:
        if st.button("❌", key=f"delete_{i}"):  # Add a delete button
            st.session_state.ingredients.pop(i)


st.write("")  # Add some spacing
if st.button("Submit Recipe"):
    if not recipe_name or not recipe_description:
        st.warning("Please fill in all fields.")
    elif not any(ingredient["name"] for ingredient in st.session_state.ingredients):
        st.warning("Please add at least one ingredient.")
    elif not all(ingredient["quantity"] and ingredient["unit"] for ingredient in st.session_state.ingredients if ingredient["name"]):
        st.warning("Please fill in all ingredient fields.")
    else:
        for ingredient in st.session_state.ingredients:
            st.json(ingredient)
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
            "difficulty": 'EASY',  # Placeholder for difficulty
            "prepTime": '30',  # Placeholder for prep time
            "calories": '200',  # Placeholder for calories
            "servings": 2,  # Placeholder for servings
            "ingredients": compiled_ingredients
        }
        try:
            response = requests.post("http://web-api:4000/recipe/add", json=recipe_data)
            response.raise_for_status()
            st.success("Recipe submitted successfully!")
        except Exception as e:
            st.error("Failed to submit recipe.")
            st.exception(e)