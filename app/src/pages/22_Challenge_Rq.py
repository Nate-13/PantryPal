import logging
logger = logging.getLogger(__name__)
import streamlit as st
from modules.nav import SideBarLinks
import requests

st.set_page_config(layout = 'wide')

SideBarLinks()

st.title('Challenge Requests Page')

API_BASE = "http://web-api:4000"

st.header("Pending Challenge Requests")
response = requests.get(f"{API_BASE}/c/requests/not-reviewed")

if response.status_code == 200:
    requests_data = response.json()
    if not requests_data:
        st.success("No pending challenge requests!")
    else:
        for req in requests_data:
            st.subheader(f"Request ID: {req['requestID']}")
            st.write(f"Requested By: {req['requestedById']}")
            st.write(f"Submitted On: {req['dateSubmitted']}")
            st.write(f"Description:\n\n{req['description']}")

            col1, col2 = st.columns(2)
            with col1:
                if st.button("Approve", key=f"approve_{req['requestID']}"):
                    approve = requests.put(
                        f"{API_BASE}/requests/{req['requestID']}/approve"
                    )
                    if approve.status_code == 200:
                        st.success(f"Request {req['requestID']} approved!")
            with col2:
                if st.button("Deny", key=f"deny_{req['requestID']}"):
                    deny = requests.put(
                        f"{API_BASE}/requests/{req['requestID']}/decline"
                    )
                    if deny.status_code == 200:
                        st.error(f"Request {req['requestID']} denied!")

            st.markdown("---")