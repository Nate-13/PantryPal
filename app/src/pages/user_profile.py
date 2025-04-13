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
                col1, col2 = st.columns(2)
                for idx, recipe in enumerate(recipes):
                    with (col1 if idx % 2 == 0 else col2):
                        st.markdown("----")
                        with st.container():
                            left_col, right_col = st.columns([1, 2])
                            with left_col:
                                # Placeholder for recipe image
                                st.image(f"https://placehold.co/300x400", use_container_width=True)
                            with right_col:
                                if st.button(f"**{recipe['title']}**", key=f"recipe_{recipe['recipeId']}"):
                                    st.session_state['recipeId'] = recipe['recipeId']
                                    st.switch_page('pages/recipePage.py')

                                st.markdown(recipe['description'])
                                chef_id = recipe['chefId']
                                st.markdown(f"**🕒 Prep Time:** {recipe['prepTime']} minutes | **🍽️ Servings:** {recipe['servings']}")
                                st.markdown(f"**Calories:** {recipe['calories']}")
                                difficulty = recipe.get("difficulty", "UNKNOWN")
                                if difficulty == "EASY":
                                    st.badge("EASY", color="green")
                                elif difficulty == "MEDIUM":
                                    st.badge("MEDIUM", color="orange")
                                elif difficulty == "HARD":
                                    st.badge("HARD", color="red")
                                else:
                                    st.info(f"Difficulty: {difficulty}")
            else:
                st.info("User has no recipes.")
        except Exception as e:
            st.error("Error connecting to the API")
            st.text(str(e))
else:
    st.error("This user could not be found")