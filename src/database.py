"""
Database connection and session management.

Read DATABASE_URL from environment variable.
Create SQLAlchemy engine and session.
Provide a dependency for FastAPI to get a DB session.
"""

# TODO: Implement database connection here
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, DeclarativeBase

DATABASE_URL = os.environ["DATABASE_URL"]
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)


class Base(DeclarativeBase):
    pass


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()