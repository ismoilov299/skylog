from datetime import datetime

import sqlalchemy
from models.message_group import MessageGroup
from states import state
from configs.database_config import Base, engine


class MessageGroupUser(Base):
    __tablename__ = "message_group_user"

    id = sqlalchemy.Column(sqlalchemy.Integer(), primary_key=True)
    user_id = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    message_id = sqlalchemy.Column(sqlalchemy.Integer())
    message_group_id = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    is_deleted = sqlalchemy.Column(sqlalchemy.Boolean(), default=True)
    created_at = sqlalchemy.Column(sqlalchemy.DateTime())
    created_by = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    updated_at = sqlalchemy.Column(sqlalchemy.DateTime())
    updated_by = sqlalchemy.Column(sqlalchemy.Integer())
    checked = sqlalchemy.Column(sqlalchemy.Boolean(), default=False)

    @staticmethod
    def add_groups_to_user(user_id: int, chat_id: int) -> None:
        message_group_user = MessageGroupUser.metadata.tables.get("message_group_user")
        data = state.get_data(chat_id)
        group_list = data.get("GROUP_LIST", [])
        now = datetime.now()  # Joriy sana va vaqt

        with engine.connect() as conn:
            for group in group_list:
                group_model = MessageGroup.get_id_by_link(group)
                if group_model is None:
                    continue
                sel = message_group_user.select().where(
                    MessageGroupUser.user_id == user_id,
                    MessageGroupUser.is_deleted == False,
                    MessageGroupUser.message_group_id == group_model[0],
                    MessageGroupUser.message_id == None
                )
                res = conn.execute(sel).fetchone()
                if res is None:
                    ins = message_group_user.insert().values(
                        user_id=user_id,
                        message_group_id=group_model[0],
                        is_deleted=False,
                        created_by=user_id,
                        created_at=now  # Yaratilgan vaqtni kiritish
                    )
                    conn.execute(ins)
            conn.commit()

    @staticmethod
    def list_by_user_id(user_id: int, page: int) -> list:
        message_group_user = MessageGroupUser.metadata.tables.get("message_group_user")
        sel = message_group_user.select().where(
            MessageGroupUser.user_id == user_id,
            MessageGroupUser.is_deleted == False
        ).limit(5).offset(page * 5)
        with engine.connect() as conn:
            return conn.execute(sel).fetchall()

    @staticmethod
    def list_user_id(user_id: int) -> list:
        message_group_user = MessageGroupUser.metadata.tables.get("message_group_user")
        sel = message_group_user.select().where(
            MessageGroupUser.user_id == user_id,
            MessageGroupUser.is_deleted == False
        )
        with engine.connect() as conn:
            return conn.execute(sel).fetchall()

    @staticmethod
    def set_check(message_group_id: int) -> None:
        message_group_user = MessageGroupUser.metadata.tables.get("message_group_user")
        with engine.connect() as conn:
            sel = message_group_user.select().where(
                MessageGroupUser.message_group_id == message_group_id,
                MessageGroupUser.is_deleted == False
            )
            sel_res = conn.execute(sel).fetchone()
            if sel_res is None:
                return
            if sel_res.checked:
                upd = message_group_user.update().values(checked=False).where(
                    MessageGroupUser.message_group_id == message_group_id,
                    MessageGroupUser.is_deleted == False
                )
            else:
                upd = message_group_user.update().values(checked=True).where(
                    MessageGroupUser.message_group_id == message_group_id,
                    MessageGroupUser.is_deleted == False
                )
            conn.execute(upd)
            conn.commit()