from states import state
from models import message_group
from telethon.sync import TelegramClient

async def get_client(phone: str) -> TelegramClient:
    client = TelegramClient(session=phone, api_id=24963729, api_hash="1bab3b9c3675227b43619d2175bd6990")
    # client = TelegramClient(session=phone, api_id=17318060, api_hash="3e0c641eac76986f24681c0fb828f450")

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
            # Kodni avtomatik kiritish yoki foydalanuvchidan so'rash logikasi qo'shilishi mumkin
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

# from telethon.sync import TelegramClient
# from telethon.errors import SessionPasswordNeededError
# from states import state
# from models import message_group
#
#
# async def get_client(phone: str) -> TelegramClient:
#     client = TelegramClient(session=phone, api_id=4743580, api_hash="dcbddeb926e163e3568d42652f929936")
#     return client
#
#
# async def get_my_groups(chat_id: int, folder: str) -> list:
#     groups = []
#     data = state.get_data(chat_id)
#     phone = data.get("PHONE_NUMBER")
#     if not phone:
#         print("Ошибка: Номер телефона не найден в данных состояния")
#         return groups
#
#     client: TelegramClient = await get_client(phone)
#     try:
#         await client.connect()
#
#         # Проверяем, авторизован ли пользователь
#         if not await client.is_user_authorized():
#             try:
#                 # Запрашиваем код авторизации
#                 code_response = await client.send_code_request(phone)
#                 code = input(f"Введите код, отправленный на номер {phone}: ")
#                 await client.sign_in(phone, code, phone_code_hash=code_response.phone_code_hash)
#             except SessionPasswordNeededError:
#                 password = input("Введите пароль двухфакторной аутентификации: ")
#                 await client.sign_in(password=password)
#             except Exception as e:
#                 print(f"Ошибка авторизации: {e}")
#                 await client.disconnect()
#                 return groups
#
#         # Получаем список групп
#         msg_group_list = message_group.MessageGroup.list(folder)
#         for msg_group in msg_group_list:
#             try:
#                 result = await client.get_entity(msg_group[3])
#                 if not result.left:  # Проверяем, что пользователь не покинул группу
#                     groups.append(msg_group[3])
#             except Exception as e:
#                 print(f"Ошибка при получении группы {msg_group[3]}: {e}")
#                 continue
#
#         await client.disconnect()
#     except Exception as e:
#         print(f"Критическая ошибка: {e}")
#         await client.disconnect()
#
#     return groups