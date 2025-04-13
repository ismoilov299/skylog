import logging
import asyncio
from telethon.sync import TelegramClient
from configs import utils

logger = logging.getLogger(__name__)

_client_cache = {}


async def send_message_to_group(user_id, message_id, message_text, phone):
    from models import message_group, message_group_user

    client = await get_telegram_client(phone)
    try:
        await client.connect()
        if not await client.is_user_authorized():
            logger.warning(f"Foydalanuvchi {phone} avtorizatsiya qilinmagan")
            return False

        message_group_user_list = message_group_user.MessageGroupUser.list_user_id(user_id)
        success_count = 0

        for msg_group_user in message_group_user_list:
            if msg_group_user[2] == message_id:
                msg_group = message_group.MessageGroup.get(msg_group_user[3])
                try:
                    await client.send_message(msg_group[3], message_text)
                    success_count += 1
                    logger.info(f"Xabar {message_id} guruhga yuborildi: {msg_group[3]}")
                except Exception as e:
                    logger.error(f"Guruhga xabar yuborishda xatolik: {str(e)}")

        return success_count > 0
    except Exception as e:
        logger.error(f"Xabar yuborishda xatolik: {str(e)}")
        return False
    finally:
        try:
            await client.disconnect()
        except:
            pass


async def get_telegram_client(phone):
    global _client_cache

    if phone in _client_cache:
        client = _client_cache[phone]
        if client.is_connected():
            return client
        del _client_cache[phone]

    client = await utils.get_client(phone)
    _client_cache[phone] = client
    return client


async def close_telegram_clients():
    global _client_cache

    for phone, client in _client_cache.items():
        try:
            if client.is_connected():
                await client.disconnect()
        except:
            pass

    _client_cache = {}