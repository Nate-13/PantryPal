import streamlit as st
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

st.set_page_config(page_title="About", page_icon="📑")

SideBarLinks()

st.write("# About this App")

st.markdown (
    """
    This is a demo app for PantryPal for the CS 3200 Course Project.  

    PantryPal is a data-driven recipe app that helps users discover and share new recipes based
    on the ingredients they already have in their kitchens. Unlike traditional recipe websites, our platform
    encourages users to cook creatively and in a way that minimizes food waste by using leftover ingredients
    from their pantry. Our app also creates interactive recipe challenges that target culinary students
    or adventurous home-cooks who are looking to think outside the box for their next recipe creation
    and contribute to the app's ingredient-driven recipe database. These challenges present a set of
    unique ingredients, and task the user to create a new dish based on these ingredients. These
    challenges are created based on previously failed user searches on our platform, which allows
    the app to constantly improve itself and its database of recipes.

    Our app addresses many of the pain points in cooking, notably, finding recipes that contain ingredients
    that the user already has. Ingredient data isn't stored directly inside a recipe allowing for smarter
    ingredient-based recipe lookups. This makes it easy for home-cooks to find recipes that they are able
    to make, easy for chefs to upload recipes that users will be able to find, and for culinary students
    to improve their creative cooking skills through structured challenges. 

    """
        )
