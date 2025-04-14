import streamlit as st
import requests
from modules.nav import SideBarLinks

API_BASE_USER = "http://web-api:4000/users"

SideBarLinks()

st.write("### My Profile")
userId = st.session_state.get("userId", None)

if not userId:
    st.warning("Something went wrong. Please log in again.")
else:
    user_req = requests.get(API_BASE_USER + f"/{userId}")
    if user_req.status_code != 200:
        st.error("Could not fetch user details.")
    else:
        left, right = st.columns([2, 2])
        with left:
            st.image("https://placehold.co/600x600")
        with right:
            user_data = user_req.json()[0]
            username = st.text_input("Username", value=user_data['username'])
            first_name = st.text_input("First Name", value=user_data['firstName'])
            last_name = st.text_input("Last Name", value=user_data['lastName'])
            email = st.text_input("Email", value=user_data['email'])
            bio = st.text_area("Bio", value=user_data['bio'])

            if st.button("Update Profile"):
                user_data = {
                "userId": userId,
                "username": username,
                "firstName": first_name,
                "lastName": last_name,
                "email": email,
                "bio": bio
                }
                update_req = requests.put(f"{API_BASE_USER}", json=user_data)
                if update_req.status_code == 200:
                    st.success("Profile updated successfully.")
                else:
                    st.error("Could not update profile.")

        st.write("----")
        st.header("My Recipes")
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
