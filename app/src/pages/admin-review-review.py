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

# Optional: filter/search bar
with st.expander("🔍 Filter reviews"):
    selected_rating = st.slider("Minimum rating", 0, 5, 0)
    keyword = st.text_input("Search by keyword in review or recipe title")

# Apply filters
if not reviews_df.empty:
    reviews_df = reviews_df[reviews_df["rating"] >= selected_rating]
    if keyword:
        reviews_df = reviews_df[reviews_df["description"].str.contains(keyword, case=False, na=False) |
                                reviews_df["recipeTitle"].str.contains(keyword, case=False, na=False)]

if reviews_df.empty:
    st.info("No reviews matched your filter.")
else:
    for _, row in reviews_df.iterrows():
        with st.container(border=True):
            st.markdown(f"### ⭐️ {row['rating']} - {row['username']} on _{row['recipeTitle']}_")
            st.write(row['description'])
            st.caption(f"Posted on {row['datePosted']} — 👍 {row['upVotes']} | 👎 {row['downVotes']}")

            if st.button("🗑 Delete", key=f"del_{row['reviewId']}"):
                res = requests.delete(f"{API_BASE}/reviews/{row['reviewId']}")
                if res.status_code == 200:
                    st.success(f"Review {row['reviewId']} deleted. Please refresh to update.")
                else:
                    st.error("Failed to delete review.")

            st.markdown("---")
