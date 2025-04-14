import streamlit as st
import requests
from modules.nav import SideBarLinks

API_BASE_URL = "http://web-api:4000/c"  # Change if needed
st.set_page_config(page_title="Challenges", page_icon="💡", layout='wide')
SideBarLinks()

st.title("💡 Challenges")
st.markdown("Browse and claim recipe challenges.")
st.write("----")
 

# difficulty_filter = st.selectbox(
#     "Filter by difficulty", ["All", "Easy", "Medium", "Hard"], index=0
# )

search_query = st.text_input("Search by keywords")
st.write("----")

def fetch_challenges(difficulty=None):
    try:
        # url = f"{API_BASE_URL}/difficulty/{difficulty.lower()}" if difficulty and difficulty != "All" else f"{API_BASE_URL}/available"
        url = f"{API_BASE_URL}/available"
        response = requests.get(url)
        return response.json() if response.status_code == 200 else []
    except Exception as e:
        st.error(f"Error fetching challenges: {e}")
        return []


def claim_challenge(challenge_id, user_id):
    try:
        response = requests.put(
            f"{API_BASE_URL}/claim/{challenge_id}",
            json={"user_id": user_id}
        )
        if response.status_code == 200:
            st.success(f"Challenge successfully claimed!")
        else:
            st.error(f"Failed to claim challenge: {response.text}")
    except Exception as e:
        st.error(f"Error claiming challenge: {e}")


def update_status(challenge_id, new_status):
    try:
        response = requests.put(
            f"{API_BASE_URL}/status/{challenge_id}",
            json={"status": new_status}
        )
        if response.status_code != 200:
            st.error(f"Status update failed: {response.text}")
            
    except Exception as e:
        st.error(f"Error updating status: {e}")

def get_challenge_ingredients(challenge_id):
    try:
        response = requests.get(f"{API_BASE_URL}/{challenge_id}/ingredients")
        if response.status_code == 200:
            return response.json()
        else:
            st.error(f"Failed to fetch ingredients for challenge {challenge_id}: {response.text}")
            return []
    except Exception as e:
        st.error(f"Error fetching ingredients: {e}")
        return []

challenges = fetch_challenges()

if search_query:
    challenges = [c for c in challenges if search_query.lower() in c.get('description', '').lower()]

if challenges:
    for ch in challenges:
        st.write(f":blue-badge[{ingredient.get('name')}] " for ingredient in get_challenge_ingredients(ch.get('challengeId')))
        st.write(f"*{ch.get('description')}*")
        st.write(f"**Difficulty:** {ch.get('difficulty')}")
        
        # Claim section
        user_id = st.session_state.get('userId', None)
        if not user_id:
            st.warning("You need to log in to claim a challenge.")
        elif st.button(f"Claim Challenge", key=f"claim_{ch.get('challengeId')}"):
            if user_id:
                claim_challenge(ch.get('challengeId'), int(user_id))
                update_status(ch.get('challengeId'), 'In PROGRESS')
            else:
                st.warning("You need to log in to claim a challenge.")

            

        st.markdown("---")
else:
    st.info("No challenges found with the current filters.")

