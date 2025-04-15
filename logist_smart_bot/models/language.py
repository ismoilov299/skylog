import sqlalchemy
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy import create_engine
#postgresql+psycopg2://akbarov:akbarov@localhost:5433/logist_smart
engine = create_engine(url="postgresql+psycopg2://skylog:skylog@localhost:5432/logist_smart", echo=True, pool_size=180, max_overflow=250)
class Base(DeclarativeBase):
    pass

Base.metadata.create_all(engine)

class Language(Base):
    __tablename__ = "language"

    id = sqlalchemy.Column(sqlalchemy.Integer(), primary_key=True)

    lang = sqlalchemy.Column(sqlalchemy.String(length=10), nullable=False)
    code = sqlalchemy.Column(sqlalchemy.Text(), nullable=False)
    message = sqlalchemy.Column(sqlalchemy.Text(), nullable=False)

    is_deleted = sqlalchemy.Column(sqlalchemy.Boolean(), default=True)
    created_at = sqlalchemy.Column(sqlalchemy.DateTime())
    created_by = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    updated_at = sqlalchemy.Column(sqlalchemy.DateTime())
    updated_by = sqlalchemy.Column(sqlalchemy.Integer())

    @staticmethod
    def get(lang: str, code: str) -> str:
        language = Language.metadata.tables.get("language")
        sel = language.select().where(Language.lang == lang, Language.code == code, Language.is_deleted == False)
        conn = engine.connect()
        res = conn.execute(sel)
        return res.fetchone()[3]

