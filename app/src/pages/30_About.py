import streamlit as st
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

st.write("# About this App")

st.markdown (
    """
    This is a demo app for PantryPal for the CS 3200 Course Project.  

    PantryPal is an ingredient-driven recipe app. 
    """
        )
