import streamlit as st
import requests
from modules.nav import SideBarLinks

API_BASE = "http://web-api:4000/c"
st.set_page_config(page_title="My Challenges", page_icon="✅", layout="wide")
SideBarLinks()

st.title("My Challenges")

user_id = st.session_state.get("userId")
response = requests.get(f"{API_BASE}/user/{user_id}/challenges")
challenges = response.json()

for c in challenges:
    challenge_id = c.get("challengeId")
    description = c.get("description")
    status_value = c.get("status")
    difficulty = c.get("difficulty") or "Not Set"
    created_at = c.get("createdAt")

    with st.expander(f" **{description}** (Status: {status_value})"):
        st.write(f"Difficulty: {difficulty}")
        st.write(f"Claimed on: {created_at}")

        status = st.selectbox(
            "Update Status",
            ["UNCLAIMED", "IN PROGRESS", "COMPLETED"],
            index=0,
            key=f"status-{challenge_id}"
        )

        update_button = st.button("Update Status", key=f"btn-{challenge_id}")
        if update_button:
            requests.put(
                f"{API_BASE}/status/{challenge_id}",
                json={"status": status}
            )
            st.success("Updated")


