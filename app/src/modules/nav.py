# Idea borrowed from https://github.com/fsmosca/sample-streamlit-authenticator

# This file has function to add certain functionality to the left side bar of the app

import streamlit as st


#### ------------------------ General ------------------------
def HomeNav():
    st.sidebar.page_link("Home.py", label="Home", icon="🏠")


def AboutPageNav():
    st.sidebar.page_link("pages/30_About.py", label="About", icon="📑")

def pantry_pal_home_nav():
    st.sidebar.page_link(
        "pages/pantrypal_home.py", label="PantryPal Home", icon="🥕"
    )

#### ------------------------ HomeCook ------------------------
def user_profile_nav():
    st.sidebar.page_link(
        "pages/my_profile.py", label="My Profile", icon="👤" # change to user profile page when made
    )

#### ------------------------ Chef ------------------------

def new_recipe_nav():
    st.sidebar.page_link(
        "pages/newRecipe.py", label="New Recipe", icon="🍽️" # change to new recipe page when made
    )

#### ------------------------ Student ------------------------
def recipe_challenges():
    st.sidebar.page_link(
        "pages/challengespage.py", label="Challenges", icon="💡"
    )

def student_challenges():
    st.sidebar.page_link(
        "pages/student_challenge.py", label="My Challenges", icon="✅"
    )

#### ------------------------ System Admin Role ------------------------
def recipereviews():
    st.sidebar.page_link("pages/admin-review-review.py", label="Review Monitor", icon="🖥️")

def recipereport():
    st.sidebar.page_link("pages/recipeGraph.py", label="Reports", icon="📊")

def challengeReview():
    st.sidebar.page_link("pages/22_Challenge_Rq.py", label="Challenge Approval", icon="📝")


# --------------------------------Links Function -----------------------------------------------
def SideBarLinks(show_home=False):
    """
    This function handles adding links to the sidebar of the app based upon the logged-in user's role, which was put in the streamlit session_state object when logging in.
    """

    # add a logo to the sidebar always
    st.sidebar.image("assets/logo.png", width=150)

    # If there is no logged in user, redirect to the Home (Landing) page
    if "authenticated" not in st.session_state:
        st.session_state.authenticated = False
        st.switch_page("Home.py")
        


    # Show the other page navigators depending on the users' role.
    if st.session_state["authenticated"]:
        HomeNav()
        # Show World Bank Link and Map Demo Link if the user is a political strategy advisor role.
        if st.session_state["role"] == "homecook":
            pantry_pal_home_nav()
            user_profile_nav()

        # If the user role is usaid worker, show the Api Testing page
        if st.session_state["role"] == "chef":
            pantry_pal_home_nav()
            user_profile_nav()
            new_recipe_nav()

        if st.session_state["role"] == "student":
            pantry_pal_home_nav()
            recipe_challenges()
            student_challenges()
            user_profile_nav()
            new_recipe_nav()

        # If the user is an administrator, give them access to the administrator pages
        if st.session_state["role"] == "administrator":
            recipereviews()
            recipereport()
            challengeReview()
    else:
        HomeNav()

    # Always show the About page at the bottom of the list of links
    AboutPageNav()

    if st.session_state["authenticated"]:
        # Always show a logout button if there is a logged in user
        if st.sidebar.button("Logout"):
            del st.session_state["role"]
            del st.session_state["authenticated"]
            st.switch_page("Home.py")
