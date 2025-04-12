import logging
logger = logging.getLogger(__name__)

import streamlit as st
from modules.nav import SideBarLinks

import streamlit as st
import requests
import pandas as pd
import matplotlib.pyplot as plt

st.title("📅 Recipes Posted Over Time")

API_URL = "http://web-api:4000/"  # Adjust as needed

def fetch_recipes_by_date():
    res = requests.get(f"{API_URL}/recipes/posted-over-time")
    if res.status_code == 200:
        return pd.DataFrame(res.json())
    else:
        st.error("Failed to fetch recipe data.")
        return pd.DataFrame()

df = fetch_recipes_by_date()

if not df.empty:
    df['date'] = pd.to_datetime(df['date'])  # Ensure proper datetime format
    df = df.sort_values('date')

    fig, ax = plt.subplots()
    ax.plot(df['date'], df['count'], marker='o')
    ax.set_xlabel("Date")
    ax.set_ylabel("Number of Recipes")
    ax.set_title("Recipes Posted Over Time")
    plt.xticks(rotation=45)
    st.pyplot(fig)
else:
    st.info("No data to show.")

def fetch_num_recipes_by_CAT():
    res = requests.get(f"{API_URL}/recipebycategory")
    if res.status_code == 200:
        return pd.DataFrame(res.json())
    else:
        st.error("Failed to fetch recipe data.")
        return pd.DataFrame()

df = fetch_num_recipes_by_CAT()

if not df.empty:
    st.subheader("Number of Recipes by Category")

    fig, ax = plt.subplots()
    ax.bar(df['categoryName'], df['count'])
    ax.set_xlabel("Category")
    ax.set_ylabel("Number of Recipes")
    ax.set_title("Recipes per category")
    plt.xticks(fontsize=7)
    plt.xticks(rotation=45)
    st.pyplot(fig)
else:
    st.info("No data to show.")