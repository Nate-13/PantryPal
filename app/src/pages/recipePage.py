import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks
from datetime import datetime

def format_date(date_str):
    return datetime.strptime(date_str, "%a, %d %b %Y %H:%M:%S %Z").strftime("%B %d, %Y")

SideBarLinks()

recipe_id = st.session_state.get('recipeId', None)

if not recipe_id:
    st.warning("No recipe ID provided.")

left, right = st.columns(2)
with left:
    st.image("https://picsum.photos/id/159/700/700/?blur=10")
with right:
    recipe_req = requests.get(f"http://web-api:4000/recipe/{recipe_id}")

    if recipe_req.status_code != 200:
        st.error("Could not fetch recipe details.")
    else:
        recipe_data = recipe_req.json()[0]
        st.title(recipe_data['title'])
        st.write(recipe_data['description'])

    user_req = requests.get(f"http://web-api:4000/users/{recipe_data['chefId']}")
    if user_req.status_code != 200:
        st.error("Could not fetch user details.")
    else:
        user_data = user_req.json()[0]
        st.write(f"### 👩‍🍳 {user_data['username']}")
        # with st.button(f"### 👩‍🍳 {user_data['username']}"):
        #     # go to user page
        #     st.session_state['userId'] = user_data['userId']

    st.write("----")

    col1, col2, col3, col4 = st.columns(4)
    with col1:
        st.write(f"⏱️ {recipe_data['prepTime']} minutes")
    with col2:
        st.write(f"🍽️ {recipe_data['servings']} servings")
    with col3:
        st.write(f"🔥 {recipe_data['calories']} calories")
    with col4:
        st.write(f"📅 {format_date(recipe_data['datePosted'])}")
    st.write("----")

    ingredients_req = requests.get(f"http://web-api:4000/recipe/{recipe_id}/ingredients")
    if ingredients_req.status_code != 200:
        st.error("Could not fetch recipe ingredients.")
    else:
        ingredients_data = ingredients_req.json()
        st.write("### Ingredients")
        for ingredient in ingredients_data:
            st.write(f"- #### ```{ingredient['quantity']} {ingredient['unit']} {ingredient['name']}``` ") 

st.write("----")
instructions = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Blandit quis suspendisse aliquet nisi sodales consequat magna. Sem placerat in id cursus mi pretium tellus. Finibus facilisis dapibus etiam interdum tortor ligula congue. Sed diam urna tempor pulvinar vivamus fringilla lacus. Porta elementum a enim euismod quam justo lectus. Nisl malesuada lacinia integer nunc posuere ut hendrerit. Imperdiet mollis nullam volutpat porttitor ullamcorper rutrum gravida. Ad litora torquent per conubia nostra inceptos himenaeos. Ornare sagittis vehicula praesent dui felis venenatis ultrices. Dis parturient montes nascetur ridiculus mus donec rhoncus. Potenti ultricies habitant morbi senectus netus suscipit auctor. Maximus eget fermentum odio phasellus non purus est. Platea dictumst lorem ipsum dolor sit amet consectetur. Dictum risus blandit quis suspendisse aliquet nisi sodales. Vitae pellentesque sem placerat in id cursus mi. Luctus nibh finibus facilisis dapibus etiam interdum tortor. Eu aenean sed diam urna tempor pulvinar vivamus. Tincidunt nam porta elementum a enim euismod quam. Iaculis massa nisl malesuada lacinia integer nunc posuere. Velit aliquam imperdiet mollis nullam volutpat porttitor ullamcorper. Taciti sociosqu ad litora torquent per conubia nostra. Primis vulputate ornare sagittis vehicula praesent dui felis. Et magnis dis parturient montes nascetur ridiculus mus. Accumsan maecenas potenti ultricies habitant morbi senectus netus. Mattis scelerisque maximus eget fermentum odio phasellus non. Hac habitasse platea dictumst lorem ipsum dolor sit. Vestibulum fusce dictum risus blandit quis suspendisse aliquet. Ex sapien vitae pellentesque sem placerat in id. Neque at luctus nibh finibus facilisis dapibus etiam. Tempus leo eu aenean sed diam urna tempor. Viverra ac tincidunt nam porta elementum a enim. Bibendum egestas iaculis massa nisl malesuada lacinia integer. Arcu dignissim velit aliquam imperdiet mollis nullam volutpat. Class aptent taciti sociosqu ad litora torquent per. Turpis fames primis vulputate ornare sagittis vehicula praesent. Natoque penatibus et magnis dis parturient montes nascetur. Feugiat tristique accumsan maecenas potenti ultricies habitant morbi. Nulla molestie mattis scelerisque maximus eget fermentum odio. Cubilia curae hac habitasse platea dictumst lorem ipsum. Mauris pharetra vestibulum fusce dictum risus blandit quis. Quisque faucibus ex sapien vitae pellentesque sem placerat. Ante condimentum neque at luctus nibh finibus facilisis. Duis convallis tempus leo eu aenean sed diam. Sollicitudin erat viverra ac tincidunt nam porta elementum. Nec metus bibendum egestas iaculis massa nisl malesuada. Commodo augue arcu dignissim velit aliquam imperdiet mollis. Semper vel class aptent taciti sociosqu ad litora. Cras eleifend turpis fames primis vulputate ornare sagittis. Orci varius natoque penatibus et magnis dis parturient. Proin libero feugiat tristique accumsan maecenas potenti ultricies. Eros lobortis nulla molestie mattis scelerisque maximus eget. Curabitur facilisi cubilia curae hac habitasse platea dictumst. Efficitur laoreet mauris pharetra vestibulum fusce dictum risus. Adipiscing elit quisque faucibus ex sapien vitae pellentesque. Consequat magna ante condimentum neque at luctus nibh. Pretium tellus duis convallis tempus leo eu aenean. Ligula congue sollicitudin erat viverra ac tincidunt nam. Fringilla lacus nec metus bibendum egestas iaculis massa. Justo lectus commodo augue arcu dignissim velit aliquam. Ut hendrerit semper vel class aptent taciti sociosqu. Rutrum gravida cras eleifend turpis fames primis vulputate. Inceptos himenaeos orci varius natoque penatibus et magnis. Venenatis ultrices proin libero feugiat tristique accumsan maecenas. Donec rhoncus eros lobortis nulla molestie mattis scelerisque. Suscipit auctor curabitur facilisi cubilia curae hac habitasse. Purus est efficitur laoreet mauris pharetra vestibulum fusce. Amet consectetur adipiscing elit quisque faucibus ex sapien. Nisi sodales consequat magna ante condimentum neque at. Cursus mi pretium tellus duis convallis tempus leo. Interdum tortor ligula congue sollicitudin erat viverra ac. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Euismod quam justo lectus commodo augue arcu dignissim. Nunc posuere ut hendrerit semper vel class aptent. Porttitor ullamcorper rutrum gravida cras eleifend turpis fames. Conubia nostra inceptos himenaeos orci varius natoque penatibus. Dui felis venenatis ultrices proin libero feugiat tristique. Ridiculus mus donec rhoncus eros lobortis nulla molestie. Senectus netus suscipit auctor curabitur facilisi cubilia curae. Phasellus non purus est efficitur laoreet mauris pharetra. Dolor sit amet consectetur adipiscing elit quisque faucibus. Suspendisse aliquet nisi sodales consequat magna ante condimentum. In id cursus mi pretium tellus duis convallis. Dapibus etiam interdum tortor ligula congue sollicitudin erat. Urna tempor pulvinar vivamus fringilla lacus nec metus. Aenim euismod quam justo lectus commodo augue. Lacinia integer nunc posuere ut hendrerit semper vel. Nullam volutpat porttitor ullamcorper rutrum gravida cras eleifend. Torquent per conubia nostra inceptos himenaeos orci varius. Vehicula praesent dui felis venenatis ultrices proin libero. Montes nascetur ridiculus mus donec rhoncus eros lobortis. Habitant morbi senectus netus suscipit auctor curabitur facilisi. Fermentum odio phasellus non purus est efficitur laoreet. Lorem ipsum dolor sit amet consectetur adipiscing elit. Blandit quis suspendisse aliquet nisi sodales consequat magna. Sem placerat in id cursus mi pretium tellus. Finibus facilisis dapibus etiam interdum tortor ligula congue. Sed diam urna tempor pulvinar vivamus fringilla lacus. Porta elementum a enim euismod quam justo lectus. Nisl malesuada lacinia integer nunc posuere ut hendrerit."
st.write("### Instructions")
st.write(instructions)
st.write("----")
st.write("### Reviews")

avg_rating = requests.get(f"http://web-api:4000/recipe/{recipe_id}/avg-rating")
if avg_rating.status_code != 200:
    st.error("Could not fetch average rating.")
else:
    avg_rating_data = avg_rating.json()[0]
    if avg_rating_data and avg_rating_data['avg_rating'] is not None:
        avg_rating_rounded = round(float(avg_rating_data['avg_rating']), 1)
        avg_rating_display = int(avg_rating_rounded) if avg_rating_rounded.is_integer() else avg_rating_rounded
        st.write(f"### **Average Rating:** {avg_rating_display}/5 ⭐")

with st.expander("📝 Write a review"):
    review = st.text_area("Write your review here:")
    rating = st.slider("Rate this recipe", 1, 5)
    if st.button("Submit"):
        review_data = {
            "userId": st.session_state.get('userID', 1),
            "recipeId": recipe_id,
            "description": review,
            "rating": rating
        }
        response = requests.post(f"http://web-api:4000/recipe/{recipe_id}/review", json=review_data)
        if response.status_code == 200:
            st.success("Review submitted successfully!")
        else:
            st.error("Failed to submit review.")

reviews_req = requests.get(f"http://web-api:4000/recipe/{recipe_id}/reviews")
if reviews_req.status_code != 200:
    st.error("Could not fetch recipe reviews.")
else:
    reviews_data = reviews_req.json()
    if not reviews_data:
        st.write("No reviews yet!")
    else:
        for review in reviews_data:
            with st.container():
                st.write("----")
                st.write(f"**👤 {review['username']}**  " + f"{'⭐' * int(review['rating'])}" + f"  *Posted on {format_date(review['datePosted'])}*")
                st.write(review['description'])


