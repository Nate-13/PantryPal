import streamlit as st
import requests
import pandas as pd

API_BASE = "http://web-api:4000/recipes"

st.set_page_config(page_title="Review Browser", layout="wide")
st.title("📝 Recipe Review Browser")

def fetch_reviews():
    try:
        res = requests.get(f"{API_BASE}/reviews")
        return pd.DataFrame(res.json()) if res.status_code == 200 else pd.DataFrame()
    except Exception as e:
        st.error("❌ Failed to load reviews.")
        return pd.DataFrame()
    

reviews_df = fetch_reviews()

if reviews_df.empty:
    st.info("No reviews found.")
else:
    for _, row in reviews_df.iterrows():
        with st.container(border=True):
            st.markdown(f"### ⭐️ {row['rating']} - {row['username']} on _{row['recipeTitle']}_")
            st.write(row['description'])
            st.caption(f"Posted on {row['datePosted']} — 👍 {row['upVotes']} | 👎 {row['downVotes']}")
            st.markdown("---")
