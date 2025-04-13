# PantryPal | CS 3200 Project 2025

PantryPal is a data-driven recipe app that helps users discover and share new recipes based
on the ingredients they already have in their kitchens. Unlike traditional recipe websites, our platform
encourages users to cook creatively and in a way that minimizes food waste by using leftover ingredients
from their pantry. Our app also creates interactive recipe challenges that target culinary students
or adventurous home-cooks who are looking to think outside the box for their next recipe creation
and contribute to the app's ingredient-driven recipe database. These challenges present a set of
unique ingredients, and task the user to create a new dish based on these ingredients. These
challenges are created based on previously failed user searches on our platform, which allows
the app to constantly improve itself and its database of recipes.

Our app addresses many of the pain points in cooking, notably, finding recipes that contain ingredients
that the user already has. Ingredient data isn't stored directly inside a recipe allowing for smarter
ingredient-based recipe lookups. This makes it easy for home-cooks to find recipes that they are able
to make, easy for chefs to upload recipes that users will be able to find, and for culinary students
to improve their creative cooking skills through structured challenges.

Currently, there are three major components that will each run in their own Docker Containers:

- Streamlit App in the `./app` directory
- Flask REST api in the `./api` directory
- MySQL Database that will be initialized with SQL script files from the `./database-files` directory

## How to Fork and Run PantryPal on Your Own Computer

To set up PantryPal on your local machine, follow these steps:

### Prerequisites

Ensure you have the following installed on your computer:

- [Docker](https://www.docker.com/)
- [Git](https://git-scm.com/)
- Python 3.8 or higher
- pip (Python package manager)

### Steps to Fork and Clone the Repository

1. Navigate to the [PantryPal GitHub repository](https://github.com/Nate-13/PantryPal).
2. Click the "Fork" button in the top-right corner to create your own copy of the repository.
3. Clone your forked repository to your local machine.
4. Navigate into the project directory in the terminal/command prompt
5. Create a .env file based on the .env.template found in the api folder

### Running PantryPal Locally

1. Build and start the Docker containers:

   run the command `docker compose -f docker-compose.yaml up -d`

   This will set up the Streamlit app, RestAPI, and MySQL database.

2. Ensure that all continers are running properly on your machine.

3. Access the application:
   - Open your browser and navigate to `http://localhost:8501` to view the Streamlit app.
   - The Flask API will be running at `http://localhost:4000`.

You are now ready to explore PantryPal!
