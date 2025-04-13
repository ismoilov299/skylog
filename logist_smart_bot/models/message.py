import sqlalchemy
from datetime import datetime
from configs.database_config import Base, engine
from models.message_group import MessageGroup
from models.message_group_user import MessageGroupUser

class Message(Base):
    __tablename__ = "message"

    id = sqlalchemy.Column(sqlalchemy.Integer(), primary_key=True)
    user_id = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    message = sqlalchemy.Column(sqlalchemy.Text(), nullable=False)
    timer = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    status = sqlalchemy.Column(sqlalchemy.Boolean(), default=True)
    send_count_in_day = sqlalchemy.Column(sqlalchemy.Integer())
    send_count_all = sqlalchemy.Column(sqlalchemy.BigInteger())
    phone = sqlalchemy.Column(sqlalchemy.String(length=13), nullable=False)
    is_deleted = sqlalchemy.Column(sqlalchemy.Boolean(), default=True)
    created_at = sqlalchemy.Column(sqlalchemy.DateTime())
    last_send_at = sqlalchemy.Column(sqlalchemy.DateTime())
    created_by = sqlalchemy.Column(sqlalchemy.Integer(), nullable=False)
    updated_at = sqlalchemy.Column(sqlalchemy.DateTime())
    updated_by = sqlalchemy.Column(sqlalchemy.Integer())

    @staticmethod
    async def create(user_id: int, message: str, timer: int, phone: str) -> int:
        message_table = Message.metadata.tables.get("message")
        now = datetime.now()
        ins = message_table.insert().values(
            user_id=user_id,
            message=message,
            timer=timer,
            status=False,
            send_count_in_day=0,
            send_count_all=0,
            created_by=user_id,
            is_deleted=False,
            phone=phone,
            created_at=now,
            last_send_at=None
        ).returning(Message.id)
        with engine.connect() as conn:
            res = conn.execute(ins)
            conn.commit()
            message_id = res.fetchone()[0]

        from services.scheduler import  schedule_message
        await schedule_message(user_id, message, timer, phone, message_id)
        return [message_id]

    @staticmethod
    async def change_status(user_id: int, message_id: int, status: bool, mess: str, phone: str) -> None:
        message_table = Message.metadata.tables.get("message")
        message_group_user_table = MessageGroupUser.metadata.tables.get("message_group_user")
        timer = 0

        with engine.connect() as conn:
            ins = message_table.update().values(status=status).where(Message.id == message_id)
            conn.execute(ins)

            upd = message_group_user_table.update().values(message_id=message_id).where(
                MessageGroupUser.user_id == user_id,
                MessageGroupUser.message_id == None
            )
            conn.execute(upd)

            if status:
                msg = conn.execute(
                    message_table.select().where(Message.id == message_id)
                ).fetchone()
                if msg:
                    timer = msg[3]

            conn.commit()

        if status:
            from services.scheduler import schedule_message

            await schedule_message(user_id, mess, timer, phone, message_id)

    @staticmethod
    async def change_send_time(message_id: int) -> None:
        message_table = Message.metadata.tables.get("message")
        now = datetime.now()
        ins = message_table.update().values(last_send_at=now).where(Message.id == message_id)
        with engine.connect() as conn:
            conn.execute(ins)
            conn.commit()

    @staticmethod
    def set_status(user_id: int, message_id: int, status: bool) -> None:
        message_table = Message.metadata.tables.get("message")
        upd = message_table.update().values(status=status).where(
            Message.user_id == user_id,
            Message.id == message_id,
            Message.is_deleted == False
        )
        with engine.connect() as conn:
            conn.execute(upd)
            conn.commit()

    @staticmethod
    def list() -> list:
        message_table = Message.metadata.tables.get("message")
        sel = message_table.select().where(Message.is_deleted == False, Message.status == True)
        with engine.connect() as conn:
            return conn.execute(sel).fetchall()

    @staticmethod
    def list_to_lambda() -> list:
        msg_list = []
        message_table = Message.metadata.tables.get("message")
        sel = message_table.select().where(Message.is_deleted == False)
        with engine.connect() as conn:
            res = conn.execute(sel)
            l_m = res.fetchall()
            for l in l_m:
                msg_list.append(l[0])
            return msg_list

    @staticmethod
    def list_by_user_id(user_id: int) -> list:
        message_table = Message.metadata.tables.get("message")
        sel = message_table.select().where(Message.is_deleted == False, Message.user_id == user_id)
        with engine.connect() as conn:
            return conn.execute(sel).fetchall()