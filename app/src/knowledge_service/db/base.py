# Separating the Base class to establish clear separation of responsibilities
# Als, Base does not need engine.
# Base can be imported without always importing or initializing the engine.
# Allows us to test models separate from DB connectivity
# Makes it easier for us to use models with Alembic migrations

from sqlalchemy.orm import DeclarativeBase

class Base(DeclarativeBase):
    """
    Base is the common parent class all ORM models will inherit from.
    It also holds sqlalchemy's metadata.
    This allows SQLAlchemy to use that inheritance to recognize
    those classes as database models and map them to tables in the DB
    """
    pass