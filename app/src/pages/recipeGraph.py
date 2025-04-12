import logging
import requests
import pandas as pd
import matplotlib.pyplot as plt
import streamlit as st
from modules.nav import SideBarLinks

logger = logging.getLogger(__name__)

# --- Page Configuration ---
st.set_page_config(page_title="Recipe Insights", page_icon="📊", layout="wide")

# --- Title & Intro ---
st.title("📅 Recipe Posting Trends")
st.markdown("Explore how recipes have been posted over time and the distribution across categories.")

# --- API Base URL ---
API_URL = "http://web-api:4000/"

# --- Helper Functions ---
def fetch_recipes_by_date():
    try:
        res = requests.get(f"{API_URL}/recipes/posted-over-time")
        res.raise_for_status()
        return pd.DataFrame(res.json())
    except requests.exceptions.RequestException as e:
        logger.error(f"Error fetching recipe data by date: {e}")
        st.error("Failed to fetch recipe data by date.")
        return pd.DataFrame()

def fetch_recipes_by_category():
    try:
        res = requests.get(f"{API_URL}/recipebycategory")
        res.raise_for_status()
        return pd.DataFrame(res.json())
    except requests.exceptions.RequestException as e:
        logger.error(f"Error fetching recipe data by category: {e}")
        st.error("Failed to fetch recipe data by category.")
        return pd.DataFrame()

# --- Layout for Side-by-Side Charts ---
col1, col2 = st.columns(2)

# --- Chart 1: Recipes Over Time ---
with col1:
    st.subheader("📈 Recipes Over Time")
    df_date = fetch_recipes_by_date()
    if not df_date.empty:
        df_date['date'] = pd.to_datetime(df_date['date'])
        df_date = df_date.sort_values('date')

        fig, ax = plt.subplots()
        ax.plot(df_date['date'], df_date['count'], marker='o', linestyle='-', linewidth=2)
        ax.set_xlabel("Date")
        ax.set_ylabel("Number of Recipes")
        ax.set_title("Recipes Posted Over Time")
        plt.xticks(rotation=45)
        st.pyplot(fig)
    else:
        st.info("No recipe posting data available.")

# --- Chart 2: Recipes by Category ---
with col2:
    st.subheader("📊 Recipes by Category")
    df_cat = fetch_recipes_by_category()
    if not df_cat.empty:
        fig, ax = plt.subplots(figsize=(10, 5))
        ax.bar(df_cat['categoryName'], df_cat['count'], width=0.5)
        ax.set_xlabel("Category")
        ax.set_ylabel("Number of Recipes")
        ax.set_title("Recipes per Category")
        plt.xticks(rotation=45, ha='right', fontsize=9)
        st.pyplot(fig)
    else:
        st.info("No category data available.")
