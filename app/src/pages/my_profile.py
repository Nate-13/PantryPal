import streamlit as st
import requests
from modules.nav import SideBarLinks

API_BASE_USER = "http://web-api:4000/users"
API_BASE_RECIPES = "http://web-api:4000/recipes"

SideBarLinks()

st.write("### My Profile")
userId = st.session_state.get("userId", None)

if not userId:
    st.warning("Something went wrong. Please log in again.")
else:
    user_req = requests.get(f"{API_BASE_USER}/{userId}")
    if user_req.status_code != 200:
        st.error("Could not fetch user details.")
    else:
        user_data = user_req.json()[0]
        st.write(f"👤 {user_data['username']}")
        st.write(f"📧 {user_data['email']}")
        st.write(f"📝 {user_data['bio']}")
        st.write("----")

        user_recipes = requests.get(f"http://web-api:4000/user/{userId}/recipes")
        if user_recipes.status_code != 200:
            st.error("Could not fetch user recipes.")
        else:
            user_recipes_data = user_recipes.json()
            if not user_recipes_data:
                st.write("No recipes found.")
            else:
                for recipe in user_recipes_data:
                    pic, left, right = st.columns([1, 4, 1])
                    with pic:
                        st.image("https://placehold.co/200x200")
                    with left:
                        if st.button(f"**{recipe['title']}**"):
                            st.session_state.recipeId = recipe['recipeId']
                            st.switch_page("pages/recipePage.py")
                        st.write(f"📖 {recipe['description']}")
                        st.write(f"🕒 {recipe['createdAt']}")
                        st.write("----")

                    with right:
                        if st.button("❌", key=recipe['recipeId']):
                            delete_req = requests.delete(f"http://web-api:4000/recipe/{recipe['recipeId']}/delete")
                            if delete_req.status_code == 200:
                                st.success("Recipe deleted successfully.")
                            else:
                                st.error("Could not delete recipe.")
