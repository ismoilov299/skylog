import asyncio
import logging
import os
from aiogram import Bot, Dispatcher, types
from aiogram.dispatcher.filters import Command
from aiogram.contrib.fsm_storage.memory import MemoryStorage
from telethon import TelegramClient
from telethon.errors import SessionPasswordNeededError, PhoneCodeInvalidError
from sqlalchemy import create_engine, Column, Integer, String, Boolean, DateTime
from sqlalchemy.orm import DeclarativeBase, Session
import datetime

# Logging sozlamalari
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler("bot.log"),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Bot sozlamalari
API_TOKEN = '7818286135:AAEAVxqQbWXM1osPBMw3ScNX1KqNKTaAf3k'
API_ID = '24963729'
API_HASH = '1bab3b9c3675227b43619d2175bd6990'

# Telefon raqami qattiq belgilangan
PHONE = '+998906830271'

# Sessiya fayli yo‘li
SESSION_PATH = f"/Users/ismoilov299/Downloads/logist_smart/logist_smart_bot/{PHONE.lstrip('+')}.session"

# Ma'lumotlar bazasiga ulanish
try:
    engine = create_engine(
        url="postgresql+psycopg2://akbarov:akbarov@localhost:5433/logist_smart",
        echo=True,
        pool_size=180,
        max_overflow=250
    )
    logger.info("Ma'lumotlar bazasiga ulanish muvaffaqiyatli sozlandi")
except Exception as e:
    logger.error(f"Ma'lumotlar bazasiga ulanishda xatolik: {str(e)}")
    raise

# Base klassi
class Base(DeclarativeBase):
    pass

# MessageGroup modeli
class MessageGroup(Base):
    __tablename__ = "message_group"

    id = Column(Integer, primary_key=True)
    name = Column(String(255))
    folder = Column(String(255))
    link = Column(String(255))
    is_active = Column(Boolean, default=True)
    is_deleted = Column(Boolean, default=False)
    created_at = Column(DateTime)
    created_by = Column(Integer)

# Base.metadata.create_all(engine) ni chaqirish
try:
    Base.metadata.create_all(engine)
    logger.info("Jadval tuzilmalari muvaffaqiyatli yaratildi")
except Exception as e:
    logger.error(f"Jadval tuzilmalari yaratishda xatolik: {str(e)}")
    raise

# Bot va Dispatcher ni sozlash
bot = Bot(token=API_TOKEN)
storage = MemoryStorage()
dp = Dispatcher(bot, storage=storage)

# Telegram guruhlarini olish funksiyasi
async def get_telegram_groups(phone: str):
    logger.info(f"Telefon raqami bilan guruhlarni olish boshlandi: {phone}")
    try:
        # Sessiya fayli yo‘lini tekshirish
        if not os.path.exists(SESSION_PATH):
            logger.error(f"Sessiya fayli topilmadi: {SESSION_PATH}")
            raise FileNotFoundError(f"Sessiya fayli topilmadi: {SESSION_PATH}")

        async with TelegramClient(SESSION_PATH, API_ID, API_HASH) as client:
            logger.info("TelegramClient ulandi")
            if not await client.is_user_authorized():
                logger.info(f"Sessiya avtorizatsiyasi yo‘q, tasdiqlash kodi so‘ralmoqda: {phone}")
                await client.send_code_request(phone)
                raise ValueError("Sessiya avtorizatsiyasi yo‘q. Iltimos, /login komandasi orqali tasdiqlash kodini kiriting.")

            groups = []
            async for dialog in client.iter_dialogs():
                if dialog.is_group:
                    logger.info(f"Guruh topildi: {dialog.name}")
                    group_data = {
                        "name": dialog.name,
                        "folder": "Skylog-7",
                        "link": f"https://t.me/{dialog.entity.username}" if dialog.entity.username else "Link yo'q",
                        "is_active": True,
                        "is_deleted": False,
                        "created_at": datetime.datetime.now(),
                        "created_by": 1
                    }
                    groups.append(group_data)
            logger.info(f"Topilgan guruhlar soni: {len(groups)}")
            return groups
    except Exception as e:
        logger.error(f"Guruhlarni olishda xatolik: {str(e)}")
        raise

# Guruhlarni ma'lumotlar bazasiga qo'shish funksiyasi (ORM ishlatilmoqda)
def add_groups_to_db(groups):
    logger.info("Guruhlarni ma'lumotlar bazasiga qo'shish boshlandi (ORM)")
    try:
        with Session(engine) as session:
            for group in groups:
                logger.info(f"Guruh qo'shilmoqda: {group['name']}")
                message_group = MessageGroup(
                    name=group['name'],
                    folder=group['folder'],
                    link=group['link'],
                    is_active=group['is_active'],
                    is_deleted=group['is_deleted'],
                    created_at=group['created_at'],
                    created_by=group['created_by']
                )
                session.add(message_group)
            session.commit()
        logger.info("Guruhlar muvaffaqiyatli qo'shildi")
    except Exception as e:
        logger.error(f"Ma'lumotlar bazasiga qo'shishda xatolik: {str(e)}")
        raise

# /add_group komandasi uchun handler
@dp.message_handler(commands=['add_group'])
async def add_group_command(message: types.Message):
    chat_id = message.chat.id
    logger.info(f"/add_group komandasi qabul qilindi, chat_id: {chat_id}")

    try:
        # Telefon raqami qattiq belgilangan
        phone = PHONE
        logger.info(f"Telefon raqami ishlatilmoqda: {phone}")

        # Telegramdan guruhlar ro'yxatini olish
        groups = await get_telegram_groups(phone)
        logger.info(f"Guruhlarni olish yakunlandi, topilgan guruhlar: {len(groups)}")

        if not groups:
            logger.info(f"Hech qanday guruh topilmadi, chat_id: {chat_id}")
            await message.reply("Siz hech qanday guruhda qatnashmaysiz.")
            return

        # Guruhlarni ma'lumotlar bazasiga qo'shish
        add_groups_to_db(groups)
        logger.info(f"Guruhlar ma'lumotlar bazasiga qo'shildi, chat_id: {chat_id}")
        await message.reply("Guruhlar muvaffaqiyatli 'Skylog-7' folderiga qo'shildi!")

    except Exception as e:
        logger.error(f"Xatolik yuz berdi: {str(e)}, chat_id: {chat_id}")
        await message.reply(f"Xatolik yuz berdi: {str(e)}")

# Botni ishga tushirish
async def on_startup(_):
    logger.info("Bot ishga tushdi!")

if __name__ == '__main__':
    from aiogram import executor
    executor.start_polling(dp, skip_updates=True, on_startup=on_startup)