import streamlit as st
import requests
from modules.nav import SideBarLinks

API_BASE_USER = "http://web-api:4000/users"
API_BASE_RECIPES = "http://web-api:4000/user"

SideBarLinks()

st.write("### My Profile")
userId = st.session_state.get("userId", None)

if not userId:
    st.warning("Something went wrong. Please log in again.")
else:
    st.write(userId)