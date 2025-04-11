import logging
logger = logging.getLogger(__name__)
import streamlit as st
import requests
from streamlit_extras.app_logo import add_logo
from modules.nav import SideBarLinks

SideBarLinks()

recipe_id = st.session_state.get('recipeId', None)

if not recipe_id:
    st.warning("No recipe ID provided.")

recipe_req = requests.get(f"http://web-api:4000/recipe/{recipe_id}")

if recipe_req.status_code != 200:
    st.error("Could not fetch recipe details.")
else:
    recipe_data = recipe_req.json()[0]
    st.title(recipe_data['title'])
    st.write(recipe_data['description'])

user_req = requests.get(f"http://web-api:4000/user/{recipe_data['userId']}")

ingredients_req = requests.get(f"http://web-api:4000/recipe/{recipe_id}/ingredients")
if ingredients_req.status_code != 200:
    st.error("Could not fetch recipe ingredients.")
else:
    ingredients_data = ingredients_req.json()
    st.write("### Ingredients")
    for ingredient in ingredients_data:
        st.write(f"- {ingredient['name']} {ingredient['quantity']} {ingredient['unit']}") 

instructions = "Lorem ipsum dolor sit amet consectetur adipiscing elit. Blandit quis suspendisse aliquet nisi sodales consequat magna. Sem placerat in id cursus mi pretium tellus. Finibus facilisis dapibus etiam interdum tortor ligula congue. Sed diam urna tempor pulvinar vivamus fringilla lacus. Porta elementum a enim euismod quam justo lectus. Nisl malesuada lacinia integer nunc posuere ut hendrerit. Imperdiet mollis nullam volutpat porttitor ullamcorper rutrum gravida. Ad litora torquent per conubia nostra inceptos himenaeos. Ornare sagittis vehicula praesent dui felis venenatis ultrices. Dis parturient montes nascetur ridiculus mus donec rhoncus. Potenti ultricies habitant morbi senectus netus suscipit auctor. Maximus eget fermentum odio phasellus non purus est. Platea dictumst lorem ipsum dolor sit amet consectetur. Dictum risus blandit quis suspendisse aliquet nisi sodales. Vitae pellentesque sem placerat in id cursus mi. Luctus nibh finibus facilisis dapibus etiam interdum tortor. Eu aenean sed diam urna tempor pulvinar vivamus. Tincidunt nam porta elementum a enim euismod quam. Iaculis massa nisl malesuada lacinia integer nunc posuere. Velit aliquam imperdiet mollis nullam volutpat porttitor ullamcorper. Taciti sociosqu ad litora torquent per conubia nostra. Primis vulputate ornare sagittis vehicula praesent dui felis. Et magnis dis parturient montes nascetur ridiculus mus. Accumsan maecenas potenti ultricies habitant morbi senectus netus. Mattis scelerisque maximus eget fermentum odio phasellus non. Hac habitasse platea dictumst lorem ipsum dolor sit. Vestibulum fusce dictum risus blandit quis suspendisse aliquet. Ex sapien vitae pellentesque sem placerat in id. Neque at luctus nibh finibus facilisis dapibus etiam. Tempus leo eu aenean sed diam urna tempor. Viverra ac tincidunt nam porta elementum a enim. Bibendum egestas iaculis massa nisl malesuada lacinia integer. Arcu dignissim velit aliquam imperdiet mollis nullam volutpat. Class aptent taciti sociosqu ad litora torquent per. Turpis fames primis vulputate ornare sagittis vehicula praesent. Natoque penatibus et magnis dis parturient montes nascetur. Feugiat tristique accumsan maecenas potenti ultricies habitant morbi. Nulla molestie mattis scelerisque maximus eget fermentum odio. Cubilia curae hac habitasse platea dictumst lorem ipsum. Mauris pharetra vestibulum fusce dictum risus blandit quis. Quisque faucibus ex sapien vitae pellentesque sem placerat. Ante condimentum neque at luctus nibh finibus facilisis. Duis convallis tempus leo eu aenean sed diam. Sollicitudin erat viverra ac tincidunt nam porta elementum. Nec metus bibendum egestas iaculis massa nisl malesuada. Commodo augue arcu dignissim velit aliquam imperdiet mollis. Semper vel class aptent taciti sociosqu ad litora. Cras eleifend turpis fames primis vulputate ornare sagittis. Orci varius natoque penatibus et magnis dis parturient. Proin libero feugiat tristique accumsan maecenas potenti ultricies. Eros lobortis nulla molestie mattis scelerisque maximus eget. Curabitur facilisi cubilia curae hac habitasse platea dictumst. Efficitur laoreet mauris pharetra vestibulum fusce dictum risus. Adipiscing elit quisque faucibus ex sapien vitae pellentesque. Consequat magna ante condimentum neque at luctus nibh. Pretium tellus duis convallis tempus leo eu aenean. Ligula congue sollicitudin erat viverra ac tincidunt nam. Fringilla lacus nec metus bibendum egestas iaculis massa. Justo lectus commodo augue arcu dignissim velit aliquam. Ut hendrerit semper vel class aptent taciti sociosqu. Rutrum gravida cras eleifend turpis fames primis vulputate. Inceptos himenaeos orci varius natoque penatibus et magnis. Venenatis ultrices proin libero feugiat tristique accumsan maecenas. Donec rhoncus eros lobortis nulla molestie mattis scelerisque. Suscipit auctor curabitur facilisi cubilia curae hac habitasse. Purus est efficitur laoreet mauris pharetra vestibulum fusce. Amet consectetur adipiscing elit quisque faucibus ex sapien. Nisi sodales consequat magna ante condimentum neque at. Cursus mi pretium tellus duis convallis tempus leo. Interdum tortor ligula congue sollicitudin erat viverra ac. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Euismod quam justo lectus commodo augue arcu dignissim. Nunc posuere ut hendrerit semper vel class aptent. Porttitor ullamcorper rutrum gravida cras eleifend turpis fames. Conubia nostra inceptos himenaeos orci varius natoque penatibus. Dui felis venenatis ultrices proin libero feugiat tristique. Ridiculus mus donec rhoncus eros lobortis nulla molestie. Senectus netus suscipit auctor curabitur facilisi cubilia curae. Phasellus non purus est efficitur laoreet mauris pharetra. Dolor sit amet consectetur adipiscing elit quisque faucibus. Suspendisse aliquet nisi sodales consequat magna ante condimentum. In id cursus mi pretium tellus duis convallis. Dapibus etiam interdum tortor ligula congue sollicitudin erat. Urna tempor pulvinar vivamus fringilla lacus nec metus. Aenim euismod quam justo lectus commodo augue. Lacinia integer nunc posuere ut hendrerit semper vel. Nullam volutpat porttitor ullamcorper rutrum gravida cras eleifend. Torquent per conubia nostra inceptos himenaeos orci varius. Vehicula praesent dui felis venenatis ultrices proin libero. Montes nascetur ridiculus mus donec rhoncus eros lobortis. Habitant morbi senectus netus suscipit auctor curabitur facilisi. Fermentum odio phasellus non purus est efficitur laoreet. Lorem ipsum dolor sit amet consectetur adipiscing elit. Blandit quis suspendisse aliquet nisi sodales consequat magna. Sem placerat in id cursus mi pretium tellus. Finibus facilisis dapibus etiam interdum tortor ligula congue. Sed diam urna tempor pulvinar vivamus fringilla lacus. Porta elementum a enim euismod quam justo lectus. Nisl malesuada lacinia integer nunc posuere ut hendrerit."
st.write("### Instructions")
st.write(instructions)

