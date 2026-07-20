# This file is where the database engine lives This is how the app
# connects to postgres and hands ut sessions. It is dependent on
# settings.database_url from the config.py file.

from ..config import settings
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker


# Creating the Postgres database engine to manage db connectios.
engine = create_engine(settings.database_url)

# Creating sessionmaker to generate sessions used to query and modify data:
SessionLocal = sessionmaker(bind=engine)
