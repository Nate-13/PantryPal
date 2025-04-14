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

def fetch_request_ingredients(request_id):
    try:
        r = requests.get(f"{API_BASE}/c/requests/{request_id}/ingredients")
        if r.status_code == 200:
            return r.json()
        else:
            logger.warning(f"Failed to fetch ingredients for request {request_id}")
            return []
    except Exception as e:
        logger.error(f"Error fetching ingredients: {e}")
        return []

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
            try:
                ing_resp = requests.get(f"{API_BASE}/c/{req['requestID']}/ingredients")
                ing_resp.raise_for_status()
                ingredients = ing_resp.json()

                if ingredients:
                    for i in ingredients:
                        st.write(f":blue-badge[{i['name']}]", unsafe_allow_html=True)
                else:
                    st.info("No ingredients listed for this request.")
            except Exception as e:
                st.warning("Failed to fetch ingredients for this request.")
                st.exception(e)

            # Action buttons
            col1, col2 = st.columns(2)
            with col1:
                if st.button("Approve", key=f"approve_{req['requestID']}"):
                    approve = requests.put(
                        f"{API_BASE}/c/requests/{req['requestID']}/approve"
                    )
                    if approve.status_code == 200:
                        st.success(f"Request {req['requestID']} approved!")
                        st.rerun()
            with col2:
                if st.button("Deny", key=f"deny_{req['requestID']}"):
                    deny = requests.put(
                        f"{API_BASE}/c/requests/{req['requestID']}/decline"
                    )
                    if deny.status_code == 200:
                        st.error(f"Request {req['requestID']} denied!")
                        st.rerun()

            st.markdown("---")
else:
    st.error("Failed to load challenge requests from the server.")