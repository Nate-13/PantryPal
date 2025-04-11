import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

recipe_id = st.session_state.get('recipeId', None)

if not recipe_id:
    st.warning("No recipe ID provided.")

recipe_req = requests.get(f"http://web-api:4000/recipe/{recipe_id}")

if recipe_req.status_code != 200:
    st.error("Could not fetch recipe details.")
else:
    recipe_data = recipe_req.json()[0]
    st.title(recipe_data['title'])
    st.write(recipe_data['description'])
    

