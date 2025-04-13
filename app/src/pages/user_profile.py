import streamlit as st
import requests
from modules.nav import SideBarLinks

API_BASE_USER = "http://web-api:4000/users"
API_BASE_RECIPES = "http://web-api:4000/user"

SideBarLinks()

userId = st.session_state.get("viewingId", None)
if userId:
    with st.spinner("Fetching data..."):
        try:
            user_resp = requests.get(f"{API_BASE_USER}/{userId}")
            user_data = user_resp.json()

            if user_resp.status_code == 200 and user_data:
                if isinstance(user_data, list):
                    user = user_data[0]
                else:
                    user = user_data

                left, right = st.columns([1, 5])
                with left:
                    st.image(f"https://placehold.co/200x200", use_container_width=True)
                with right:
                    st.subheader(f"*{user.get('firstName', 'N/A')} {user.get('lastName', 'N/A')}*")
                    st.title(user.get('username', 'N/A'))
                    st.write(user.get('bio', 'N/A'))
                st.write("----")
            else:
                st.info("User not found.")

            recipe_resp = requests.get(f"{API_BASE_RECIPES}/{userId}/recipes")
            recipes = recipe_resp.json()

            if recipe_resp.status_code == 200 and recipes:
                st.subheader("Recipes")
                for recipe in recipes:
                    st.markdown(f"""
                        ### {recipe.get('title', 'Untitled')}
                        - Description: {recipe.get('description', 'N/A')}
                        - Difficulty: {recipe.get('difficulty', 'N/A')}
                        - Calories: {recipe.get('calories', 'N/A')}
                        - Prep Time: {recipe.get('prepTime', 'N/A')} mins
                        - Servings: {recipe.get('servings', 'N/A')}
                        - Date Posted: {recipe.get('datePosted', 'N/A')}
                        - Created At: {recipe.get('createdAt', 'N/A')}
                    """)
            else:
                st.info("User has no recipes.")
        except Exception as e:
            st.error("Error connecting to the API")
            st.text(str(e))
else:
    st.error("This user could not be found")