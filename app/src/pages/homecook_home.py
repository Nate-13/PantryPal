import streamlit as st
import requests

API_BASE_USER = "http://web-api:4000/users"
API_BASE_RECIPES = "http://web-api:4000/user"

st.title("User Information")

user_id = st.text_input("Enter User ID:")

if user_id.strip():
    with st.spinner("Fetching data..."):
        try:
            user_resp = requests.get(f"{API_BASE_USER}/{user_id}")
            user_data = user_resp.json()

            if user_resp.status_code == 200 and user_data:
                if isinstance(user_data, list):
                    user = user_data[0]
                else:
                    user = user_data

                st.subheader(f"Profile: {user.get('username', 'N/A')}")
                st.markdown(f"""
                    - First Name: {user.get('firstName', 'N/A')}
                    - Last Name: {user.get('lastName', 'N/A')}
                    - Email: {user.get('email', 'N/A')}
                    - User ID: {user.get('userId', 'N/A')}
                """)
            else:
                st.info("User not found.")

            recipe_resp = requests.get(f"{API_BASE_RECIPES}/{user_id}/recipes")
            recipes = recipe_resp.json()

            if recipe_resp.status_code == 200 and recipes:
                st.subheader("User's Recipes")
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