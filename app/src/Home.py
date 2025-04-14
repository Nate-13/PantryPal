##################################################
# This is the main/entry-point file for the 
# sample application for your project
##################################################

# Set up basic logging infrastructure
import logging
logging.basicConfig(format='%(filename)s:%(lineno)s:%(levelname)s -- %(message)s', level=logging.INFO)
logger = logging.getLogger(__name__)

# import the main streamlit library as well
# as SideBarLinks function from src/modules folder
import streamlit as st
from modules.nav import SideBarLinks

# streamlit supports reguarl and wide layout (how the controls
# are organized/displayed on the screen).
st.set_page_config(layout = 'wide', page_title="Home", page_icon="🏠")

# If a user is at this page, we assume they are not 
# authenticated.  So we change the 'authenticated' value
# in the streamlit session_state to false. 
if "authenticated" not in st.session_state:
    st.session_state['authenticated'] = False

# Use the SideBarLinks function from src/modules/nav.py to control
# the links displayed on the left-side panel. 
# IMPORTANT: ensure src/.streamlit/config.toml sets
# showSidebarNavigation = false in the [client] section
SideBarLinks(show_home=True)

# ***************************************************
#    The major content of this page
# ***************************************************

# set the title of the page and provide a simple prompt. 
logger.info("Loading the Home page of the PantryPal")
st.title('PantryPal Login') 
st.write('\n\n')
st.write('### Hi! As which user would you like to log in?')

# For each of the user personas for which we are implementing
# functionality, we put a button on the screen that the user 
# can click to MIMIC logging in as that mock user. 

if st.button("Act as Milo, a home-cook.", 
            type = 'primary', 
            use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'homecook'
    st.session_state['first_name'] = 'Milo'
    st.session_state['userId'] = 3
    logger.info("Logging in as home-cook Persona")
    st.switch_page('pages/pantrypal_home.py') # change to homecook main page

if st.button('Act as Isabel, a chef and blogger', 
            type = 'primary', 
            use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'chef'
    st.session_state['first_name'] = 'Isabel'
    st.session_state['userId'] = 1
    st.switch_page('pages/pantrypal_home.py') # change to chef home page
    logger.info("Logging in as chef")

if st.button('Act as Robert, a culinary student.', 
            type = 'primary', 
            use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'student'
    st.session_state['first_name'] = 'Robert'
    st.session_state['userId'] = 2
    st.switch_page('pages/challengespage.py') # make robert landing page or same homepage
    logger.info("Logging in as student")

if st.button('Act as Elna, a system administrator.', 
            type = 'primary', 
            use_container_width=True):
    st.session_state['authenticated'] = True
    st.session_state['role'] = 'administrator'
    st.session_state['first_name'] = 'Elna'
    st.switch_page('pages/22_Challenge_Rq.py') # change to elna home page
    logger.info("Logging in as administrator")

