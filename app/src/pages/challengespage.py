import streamlit as st
import requests

API_BASE_URL = "http://web-api:4000/c"  # Change if needed

st.title("🧠 Available Challenges")
st.markdown("Browse, filter, claim, or update the status of challenges.")

if st.button("📈 View Recipe Report"):

    st.switch_page("pages/recipeGraph.py")
    st.session_state["report_button"] = True 

# difficulty_filter = st.selectbox(
#     "Filter by difficulty", ["All", "Easy", "Medium", "Hard"], index=0
# )

search_query = st.text_input("Search by keyword in description")


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
            st.success(f"Challenge {challenge_id} successfully claimed!")
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
        if response.status_code == 200:
            st.success(f"Challenge {challenge_id} updated to '{new_status}'!")
        else:
            st.error(f"Status update failed: {response.text}")
    except Exception as e:
        st.error(f"Error updating status: {e}")


challenges = fetch_challenges()

if search_query:
    challenges = [c for c in challenges if search_query.lower() in c.get('description', '').lower()]

if challenges:
    for ch in challenges:
        with st.container():
            st.subheader(f"Challenge ID: {ch.get('challengeId')}")
            st.write(f"**Description:** {ch.get('description')}")
            st.write(f"**Difficulty:** {ch.get('difficulty')}")

            # Claim section
            user_id = st.text_input(f"Enter your User ID to claim challenge {ch.get('challengeId')}:", key=f"user_{ch.get('challengeId')}")
            if st.button(f"Claim Challenge {ch.get('challengeId')}", key=f"claim_{ch.get('challengeId')}"):
                if user_id:
                    claim_challenge(ch.get('challengeId'), int(user_id))
                else:
                    st.warning("Please enter your user ID.")

            # Status update section
            status_options = ["in progress", "completed"]
            new_status = st.selectbox(f"Update status for challenge {ch.get('challengeId')}:", status_options, key=f"status_{ch.get('challengeId')}")
            if st.button(f"Update Status", key=f"update_{ch.get('challengeId')}"):
                update_status(ch.get('challengeId'), new_status)

            st.markdown("---")
else:
    st.info("No challenges found with the current filters.")

