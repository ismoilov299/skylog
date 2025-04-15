from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import create_engine

engine = create_engine(url="postgresql+psycopg2://skylog:skylog@localhost:5432/logist_smart", echo=True, pool_size=180, max_overflow=250)
class Base(DeclarativeBase):
    pass

Base.metadata.create_all(engine)
