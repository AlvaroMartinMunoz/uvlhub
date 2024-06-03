#!/bin/sh
set -e

# Initialize migrations only if the migrations directory doesn't exist
if [ ! -d "migrations/versions" ]; then
    # Initialize the migration repository
    flask db init
fi

# Mark the database as up-to-date with the most recent migration
flask db stamp head

# Generate new migration files by comparing the database schema to the models
flask db migrate

# Apply the new migrations to the database
flask db upgrade

# Start the application using Gunicorn, binding it to port 80
# Set the logging level to info and the timeout to 3600 seconds
exec gunicorn --bind 0.0.0.0:80 app:app --log-level info --timeout 3600
