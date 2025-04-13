# `database-files` Folder

TODO: Put some notes here about how this works. include how to re-bootstrap the db.

This folder contains the SQL script for creating and populating the PantryPal database. It includes all necessary schema definitions, relationships, and default data to bootstrap the database.

## Files

- **`PantryPalDatabase.sql`**: The main SQL script that:
  - Drops the existing database (if any).
  - Creates the `PantryPal` database and its tables.
  - Defines relationships between tables.
  - Inserts default data for users, recipes, ingredients, and more.

## How to Bootstrap the Database

Follow these steps to set up or reset the database:

1. **Ensure MySQL is Installed**:
   Make sure you have MySQL installed and running on your system.

2. **Run the docker containers**:
   run the command `docker compose -f docker-compose-testing.yaml up -d`
   or `docker compose -f docker-compose.yaml up -d`

The database containers will be constructed. Verify in docker that they were created without errors.

- **Default Data**: The script includes a set of default data for testing purposes, such as users, 200 recipes, ingredients, and challenges.
