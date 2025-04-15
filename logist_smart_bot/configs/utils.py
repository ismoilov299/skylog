from states import state
from models import message_group
from telethon.sync import TelegramClient

async def get_client(phone: str) -> TelegramClient:
    client = TelegramClient(session=phone, api_id=24963729, api_hash="1bab3b9c3675227b43619d2175bd6990")

    return client


# configs/utils.py
async def get_my_groups(chat_id: int, folder: str) -> list:
    groups = []
    data = state.get_data(chat_id)
    phone = data.get("PHONE_NUMBER")
    if not phone:
        print(f"Error: Telefon raqami topilmadi (chat_id: {chat_id})")
        return groups

    msg_group_list = message_group.MessageGroup.list(folder)
    client: TelegramClient = await get_client(phone)
    try:
        await client.connect()
        if not await client.is_user_authorized():
            print(f"Foydalanuvchi {phone} avtorizatsiya qilinmagan. Kod so'ralmoqda...")
            return groups

        print(f"Guruhlarni olish boshlandi (folder: {folder})...")
        for msg_group in msg_group_list:
            try:
                result = await client.get_entity(msg_group[3])
                if not result.left:
                    groups.append(msg_group[3])
            except Exception as e:
                print(f"Guruhni olishda xatolik ({msg_group[3]}): {str(e)}")
                continue
    except Exception as e:
        print(f"TelegramClient bilan ulanishda xatolik: {str(e)}")
    finally:
        await client.disconnect()

    print(f"Guruhlarni olish yakunlandi: {groups}")
    return groups
