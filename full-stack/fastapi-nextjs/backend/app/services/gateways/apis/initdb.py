import sys
from pathlib import Path

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker
from sqlmodel import Session, SQLModel, create_engine
from sqlmodel.ext.asyncio import session
from sqlalchemy.exc import IntegrityError

current_file = Path(__file__).resolve()
parent_directory = current_file.parent
project_directory = parent_directory.parent

sys.path.insert(0, str(project_directory))

from app.services.gateways.apis.database import (
    create_db_and_tables,
    create_town_and_people,
    get_db
)

def create_database_for_tests():
    db = next(get_db())
    create_db_and_tables()
    try:
        create_town_and_people(db)
    except (IntegrityError, Exception) as e:
        print(e)
        pass

create_database_for_tests()
