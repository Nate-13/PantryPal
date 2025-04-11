import logging
logger = logging.getLogger(__name__)

import streamlit as st
import requests
from modules.nav import SideBarLinks

st.set_page_config(layout='wide')

SideBarLinks()

st.title(f"Welcome, {st.session_state['first_name']}.")
st.write('')
st.write('### What would you like to do today?')

with st.form(key='ingredient_form'):
    ingredients_input = st.text_input('Enter ingredient(s) (comma-separated):', '')
    submitted = st.form_submit_button('Search Recipes')

if submitted and ingredients_input:
    with st.spinner("Searching for recipes..."):
        try:
            response = requests.post(
                "http://web-api:4000/recipes",
                json={"ingredients": ingredients_input}
            )
            response.raise_for_status()
            recipes = response.json()

            if recipes:
                st.success(f"Found {len(recipes)} recipes!")
                for recipe in recipes:
                    st.markdown(f"**{recipe['name']}**")
                    st.write(f"Ingredients: {', '.join(recipe['ingredients'])}")
                    st.write(f"Instructions: {recipe['instructions']}")
                    st.markdown("---")
            else:
                st.warning("No recipes found for those ingredients.")
        except Exception as e:
            st.error(f"Error fetching recipes: {e}")
