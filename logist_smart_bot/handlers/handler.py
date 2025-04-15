import pytz
from states import state
from keyboards import keyboard
from configs.bot_config import bot, dp
from datetime import datetime, timedelta
from telethon.sync import TelegramClient
from datetime import datetime, timedelta
from telethon.tl.types.auth import SentCode
from configs import filters, settings, utils
from telethon.errors.rpcerrorlist import SessionPasswordNeededError, PhoneCodeExpiredError, PhoneCodeInvalidError
from aiogram.types import Message, CallbackQuery, ContentType
from models import language, user, message, message_group, message_group_user
from services.scheduler import schedule_message, cancel_scheduled_message
utc = pytz.UTC


async def send_message_to_groups_30():
    message_list = message.Message.list()
    for msg in message_list:
        now = datetime.now()
        now_plus_30 = msg[10] + timedelta(minutes=30)
        now_plus_45 = msg[10] + timedelta(minutes=45)
        now_plus_60 = msg[10] + timedelta(minutes=60)
        if msg[3] == 30 and now_plus_30 <= now:
            message_group_user_list = message_group_user.MessageGroupUser.list_user_id(msg[1])
            for msg_group_user in message_group_user_list:
                if msg_group_user[2] == msg[0]:
                    msg_group = message_group.MessageGroup.get(msg_group_user[3])
                    try:
                        async with TelegramClient(msg[7], api_id=24963729,
                                                  api_hash="1bab3b9c3675227b43619d2175bd6990") as client:
                            await client.send_message(msg_group[3], msg[2])
                            await message.Message.change_send_time(msg[0])
                            await client.disconnect()
                    except:
                        await client.disconnect()
                        continue
        elif msg[3] == 45 and now_plus_45 <= now:
            message_group_user_list = message_group_user.MessageGroupUser.list_user_id(msg[1])
            for msg_group_user in message_group_user_list:
                if msg_group_user[2] == msg[0]:
                    msg_group = message_group.MessageGroup.get(msg_group_user[3])
                    try:
                        async with TelegramClient(msg[7], api_id=24963729,
                                                  api_hash="1bab3b9c3675227b43619d2175bd6990") as client:
                            await client.send_message(msg_group[3], msg[2])
                            await message.Message.change_send_time(msg[0])
                            await client.disconnect()
                    except:
                        await client.disconnect()
                        continue
        elif msg[3] == 60 and now_plus_60 <= now:
            message_group_user_list = message_group_user.MessageGroupUser.list_user_id(msg[1])
            for msg_group_user in message_group_user_list:
                if msg_group_user[2] == msg[0]:
                    msg_group = message_group.MessageGroup.get(msg_group_user[3])
                    try:
                        async with TelegramClient(msg[7], api_id=24963729,
                                                  api_hash="1bab3b9c3675227b43619d2175bd6990") as client:
                            await client.send_message(msg_group[3], msg[2])
                            await message.Message.change_send_time(msg[0])
                            await client.disconnect()
                    except:
                        await client.disconnect()
                        continue
    return None


@dp.message_handler(commands=['start'])
async def start_command(msg: Message) -> None:
    s = state.State("LANGUAGE_MENU", {}, msg.chat.id)
    state.append(s)
    text = language.Language.get("NONE", "LANGUAGE_MENU")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_language_manu())


@dp.message_handler(filters.CheckState("LANGUAGE_MENU"),
                    lambda msg: msg.text in ["English " + settings.EN_STIK, "Russian " + settings.RU_STIK,
                                             "Uzbek " + settings.UZ_STIK])
async def auth_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"LANG": msg.text})
    s = state.State("AUTH_MENU", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(msg.text, "CHOOSE_ONE_FROM_THIS_SECTION")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(msg.text))


@dp.message_handler(filters.CheckState("AUTH_MENU"), filters.CheckWord("REGISTER"))
async def register_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("REGISTER_FIRST_NAME", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_FIRST_NAME")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("REGISTER_FIRST_NAME"))
async def register_first_name_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    data.update({"FIRST_NAME": msg.text})
    s = state.State("REGISTER_LAST_NAME", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_LAST_NAME")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("REGISTER_LAST_NAME"))
async def register_last_name_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    data.update({"LAST_NAME": msg.text})
    s = state.State("REGISTER_PHONE", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "SEND_YOUR_CONTACT")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_contact_menu(lang))


@dp.message_handler(filters.CheckState("REGISTER_PHONE"), content_types=ContentType.CONTACT)
async def register_phone_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    data.update({"PHONE_NUMBER": msg.contact.phone_number})
    s = state.State("REGISTER_PASSWORD", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_PASSWORD")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("REGISTER_PASSWORD"))
async def register_password_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    first_name = data.get("FIRST_NAME")
    last_name = data.get("LAST_NAME")
    phone_number = data.get("PHONE_NUMBER")
    password = msg.text
    lang = data.get("LANG")
    s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
    state.append(s)
    res = user.User.register(first_name, last_name, phone_number, password, lang, msg.chat.id)
    if res:
        text = language.Language.get(lang, "SUCCESSFULLY_REGISTERED")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
    else:
        text = language.Language.get(lang, "YOU_ARE_ALREADY_REGISTERED")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))


@dp.message_handler(filters.CheckState("AUTH_MENU"), filters.CheckWord("LOGIN"))
async def login_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    print(lang)
    s = state.State("LOGIN_PHONE", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "SEND_YOUR_CONTACT")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_contact_menu(lang))


@dp.message_handler(filters.CheckState("LOGIN_PHONE"), content_types=ContentType.CONTACT)
async def login_phone_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    data.update({"PHONE_NUMBER": msg.contact.phone_number})
    s = state.State("ENTER_YOUR_PASSWORD", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_PASSWORD")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("ENTER_YOUR_PASSWORD"))
async def login_password_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    password = msg.text
    res = user.User.login(phone, password)
    if res == "NO" or res == "ADMIN" or res == "RECEPTION":
        s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
        state.append(s)
        text = language.Language.get(lang, "USER_NOT_FOUND")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
    elif res == "NOT_ACTIVE":
        s = state.State("ACTIVATE_MENU", data, msg.chat.id)
        state.append(s)
        user.User.set_chat_id_by_phone(msg.chat.id, phone)
        text = language.Language.get(lang, "YOU_IS_NOT_ACTIVE")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_active_menu(lang))
    elif res == "STUDENT":
        s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
        state.append(s)
        text = language.Language.get(lang, "HOME_MENU")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("AUTO_MESSAGE"))
async def home_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("AUTO_MESSAGE", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_MESSAGE")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("AUTO_MESSAGE"))
async def auto_message_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"MESSAGE": msg.text})
    lang = data.get("LANG")
    s = state.State("YOUR_MESSAGE", data, msg.chat.id)
    state.append(s)
    await bot.send_message(msg.chat.id, msg.text, reply_markup=keyboard.get_message_student_menu(lang))


@dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "edit_text")
async def edit_text_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    s = state.State("AUTO_MESSAGE", data, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_EDITED_MESSAGE")
    await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "edit_group")
async def edit_group_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    s = state.State("EDIT_GROUP", data, call.message.chat.id)
    state.append(s)
    text1 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/qkvbibwxr45jMjAy"
    text2 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/YZRlMKksb1tjN2Ji"
    text3 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/dKoivNKHADUxMzgy"
    text4 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/CqTjXbzl6oJkMDAy"
    text5 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/3CoyHeRvosBhNDAy"
    text6 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/_99iSOEIXvFiNDcy"
    text7 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/MwmUGfiNNqc3Zjli"
    await bot.send_message(call.message.chat.id, text1, reply_markup=keyboard.remove_menu)
    await bot.send_message(call.message.chat.id, text2, reply_markup=keyboard.remove_menu)
    await bot.send_message(call.message.chat.id, text3, reply_markup=keyboard.remove_menu)
    await bot.send_message(call.message.chat.id, text4, reply_markup=keyboard.remove_menu)
    await bot.send_message(call.message.chat.id, text5, reply_markup=keyboard.remove_menu)
    await bot.send_message(call.message.chat.id, text6, reply_markup=keyboard.remove_menu)
    await bot.send_message(call.message.chat.id, text7, reply_markup=keyboard.get_done_student_menu(lang))


@dp.message_handler(filters.CheckStateList(["EDIT_GROUP", "JOIN_GROUP"]), filters.CheckWord("DONE"))
async def select_folder(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("SELECT_FOLDER", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "SELECT_FOLDER")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_folder(lang))


@dp.message_handler(filters.CheckState("SELECT_FOLDER"),
                    lambda msg: msg.text in ["Skylog-1", "Skylog-2", "Skylog-3", "Skylog-4", "Skylog-5", "Skylog-6",
                                             "Skylog-7"])
async def select_fol(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"PAGE": 0})
    data.update({"folder": msg.text})
    lang = data.get("LANG")
    s = state.State("GROUP_BTN", data, msg.chat.id)
    state.append(s)
    wait_text = language.Language.get(lang, "WAIT_TEXT")
    await bot.send_message(msg.chat.id, wait_text, reply_markup=keyboard.remove_menu)
    my_groups = await utils.get_my_groups(msg.chat.id, msg.text)
    text = language.Language.get(lang, "CORRECT_OR_INCORRECT")
    await bot.send_message(msg.chat.id, text,
                           reply_markup=await keyboard.get_add_group_student_menu(lang, 0, msg.chat.id, my_groups))
    await bot.send_message(msg.chat.id, language.Language.get(lang, "SELECT_THIS_GROUPS"),
                           reply_markup=keyboard.get_done_student_menu(lang))


@dp.callback_query_handler(filters.CheckStateWithCall("GROUP_BTN"))
async def group_btn_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    folder = data.get("folder")
    my_groups = await utils.get_my_groups(call.message.chat.id, folder)
    if call.data in my_groups:
        group_list: list = data.get("GROUP_LIST", [])
        if call.data in group_list:
            group_list.remove(call.data)
            data.update({"GROUP_LIST": group_list})
        else:
            group_list.append(call.data)
            data.update({"GROUP_LIST": group_list})
        s = state.State("GROUP_BTN", data, call.message.chat.id)
        state.append(s)
        page = data.get("PAGE")
        await bot.edit_message_reply_markup(call.message.chat.id, message_id=call.message.message_id,
                                            reply_markup=await keyboard.get_add_group_student_menu(lang, page,
                                                                                                   call.message.chat.id,
                                                                                                   my_groups))
        return None
    elif call.data == "prev":
        page = data.get("PAGE") - 1
        data.update({"PAGE": page})
        s = state.State("GROUP_BTN", data, call.message.chat.id)
        state.append(s)
        await bot.edit_message_reply_markup(call.message.chat.id, message_id=call.message.message_id,
                                            reply_markup=await keyboard.get_add_group_student_menu(lang, page,
                                                                                                   call.message.chat.id,
                                                                                                   my_groups))
    elif call.data == "next":
        page = data.get("PAGE") + 1
        data.update({"PAGE": page})
        s = state.State("GROUP_BTN", data, call.message.chat.id)
        state.append(s)
        await bot.edit_message_reply_markup(call.message.chat.id, message_id=call.message.message_id,
                                            reply_markup=await keyboard.get_add_group_student_menu(lang, page,
                                                                                                   call.message.chat.id,
                                                                                                   my_groups))
    elif call.data == "select_all":
        group_list: list = data.get("GROUP_LIST", [])
        page = data.get("PAGE")
        for m_g in my_groups:
            group_list.append(m_g)
        data.update({"GROUP_LIST": group_list})
        s = state.State("GROUP_BTN", data, call.message.chat.id)
        state.append(s)
        await bot.edit_message_reply_markup(call.message.chat.id, message_id=call.message.message_id,
                                            reply_markup=await keyboard.get_add_group_student_menu(lang, page,
                                                                                                   call.message.chat.id,
                                                                                                   my_groups))
    else:
        text = language.Language.get(lang, "WRONG_MESSAGE")
        await bot.send_message(call.message.chat.id, text)
        return None


@dp.message_handler(filters.CheckState("GROUP_BTN"), filters.CheckWord("DONE"))
async def group_done_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")

    phone = data.get("PHONE_NUMBER")
    user_id = user.User.get_id_by_phone(phone)
    message_group_user.MessageGroupUser.add_groups_to_user(user_id, msg.chat.id)
    text1 = language.Language.get(lang, "SUCCESSFULLY_SELECTED_GROUPS")

    text2 = data.get("MESSAGE")
    if text2 is None:
        s = state.State("HOME_MENU", data, msg.chat.id)
        state.append(s)
        text2 = language.Language.get(lang, "HOME_MENU")
        await bot.send_message(msg.chat.id, text1, reply_markup=keyboard.remove_menu)
        await bot.send_message(msg.chat.id, text2, reply_markup=keyboard.get_home_student_menu(lang))
    else:
        s = state.State("YOUR_MESSAGE", data, msg.chat.id)
        state.append(s)
        await bot.send_message(msg.chat.id, text1, reply_markup=keyboard.remove_menu)
        await bot.send_message(msg.chat.id, text2, reply_markup=keyboard.get_message_student_menu(lang))


@dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "edit_timer")
async def edit_timer_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    s = state.State("EDIT_TIMER", data, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_TIMER")
    await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_timer_student_menu(lang))


async def handle_timer_selection(msg: Message, timer_value: int) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")

    try:
        user_id = user.User.get_id_by_phone(phone)
        mess = data.get("MESSAGE")

        res = await message.Message.create(user_id, mess, timer_value, phone)
        data.update({"MESSAGE_ID": res[0]})

        s = state.State("YOUR_MESSAGE", data, msg.chat.id)
        state.append(s)
        text = language.Language.get(lang, "SUCCESSFULLY_CREATED_YOUR_MESSAGE")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
        await bot.send_message(msg.chat.id, mess, reply_markup=keyboard.get_message_student_menu(lang))
    except Exception as e:
        error_text = f"Error: {str(e)}"
        await bot.send_message(msg.chat.id, error_text)


@dp.message_handler(filters.CheckState("EDIT_TIMER"), filters.CheckWord("MINUTE_30"))
async def start_time_student_30_minute(msg: Message) -> None:
    await handle_timer_selection(msg, 30)


@dp.message_handler(filters.CheckState("EDIT_TIMER"), filters.CheckWord("MINUTE_45"))
async def start_time_student_45_minute(msg: Message) -> None:
    await handle_timer_selection(msg, 45)


@dp.message_handler(filters.CheckState("EDIT_TIMER"), filters.CheckWord("MINUTE_60"))
async def start_time_student_60_minute(msg: Message) -> None:
    await handle_timer_selection(msg, 60)




@dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "start")
async def start_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    message_id = data.get("MESSAGE_ID")

    if message_id is None:
        text = language.Language.get(lang, "PLEASE_SELECT_TIMER")
        s = state.State("EDIT_TIMER", data, call.message.chat.id)
        state.append(s)
        await bot.send_message(
            call.message.chat.id,
            text,
            reply_markup=keyboard.get_timer_student_menu(lang)
        )
        return None

    group_list = data.get("GROUP_LIST", [])

    if group_list:
        try:
            mess = data.get("MESSAGE")
            phone = data.get("PHONE_NUMBER")
            user_id = user.User.get_id_by_phone(phone)

            await message.Message.change_status(user_id, message_id, True, mess, phone)
            await schedule_message(user_id, mess, data.get("timer", 30), phone, message_id)

            data_for_home = {
                "LANG": lang,
                "role": "STUDENT",
                "PHONE_NUMBER": phone,
                "folder": data.get("folder")
            }

            s = state.State("HOME_MENU", data_for_home, call.message.chat.id)
            state.append(s)

            text = language.Language.get(lang, "BACK_HOME_MENU")
            await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
        except Exception as e:
            error_text = f"Xabarni faollashtirishda xatolik: {str(e)}"
            await bot.send_message(call.message.chat.id, error_text, reply_markup=keyboard.get_home_student_menu(lang))
    else:
        folder = data.get("folder")
        if folder is None:
            s = state.State("SELECT_FOLDER", data, call.message.chat.id)
            state.append(s)
            text = language.Language.get(lang, "SELECT_FOLDER")
            await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_folder(lang))
        else:
            s = state.State("GROUP_BTN", data, call.message.chat.id)
            state.append(s)

            wait_text = language.Language.get(lang, "WAIT_TEXT")
            await bot.send_message(call.message.chat.id, wait_text, reply_markup=keyboard.remove_menu)

            try:
                my_groups = await utils.get_my_groups(call.message.chat.id, folder)
                correct_text = language.Language.get(lang, "CORRECT_OR_INCORRECT")
                await bot.send_message(
                    call.message.chat.id,
                    correct_text,
                    reply_markup=await keyboard.get_add_group_student_menu(lang, 0, call.message.chat.id, my_groups)
                )
                await bot.send_message(
                    call.message.chat.id,
                    language.Language.get(lang, "SELECT_THIS_GROUPS"),
                    reply_markup=keyboard.get_done_student_menu(lang)
                )
            except Exception as e:
                error_text = f"Guruhlarni yuklashda xatolik: {str(e)}"
                await bot.send_message(call.message.chat.id, error_text)


@dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("SEARCH_CARGO"))
async def search_cargo_from_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"MESSAGE_PAGE": 1})
    lang = data.get("LANG")
    s = state.State("SEARCH_CARGO_FROM", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_CARGO_FROM")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("SEARCH_CARGO_FROM"))
async def search_cargo_to_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"CARGO_FROM": msg.text})
    lang = data.get("LANG")
    s = state.State("SEARCH_CARGO_TO", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_CARGO_TO")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("SEARCH_CARGO_TO"))
async def search_cargo_type_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"CARGO_TO": msg.text})
    lang = data.get("LANG")
    s = state.State("SEARCH_CARGO", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_CARGO_TYPE")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_cargo_type_menu(lang))


@dp.message_handler(filters.CheckState("SEARCH_CARGO"), filters.CheckWordList(["ISOTHERM", "REF", "AWNING"]))
async def search_cargo_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"CARGO_TYPE": msg.text})

    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    cargo_from = data.get("CARGO_FROM")
    cargo_from = cargo_from.lower()
    cargo_to = data.get("CARGO_TO")
    cargo_to = cargo_to.lower()
    cargo_type = msg.text
    cargo_type = cargo_type.lower()
    message_page = data.get("MESSAGE_PAGE")

    date = datetime.now() - timedelta(days=1)
    folder = data.get("folder", "Skylog-1")

    wait_text = language.Language.get(lang, "WAIT_TEXT")
    await bot.send_message(msg.chat.id, wait_text, reply_markup=keyboard.remove_menu)

    message_group_list = await utils.get_my_groups(msg.chat.id, folder)
    mes_list = []
    async with TelegramClient(session=phone, api_id=24963729, api_hash="1bab3b9c3675227b43619d2175bd6990") as client:
        await client.connect()
        for msg_group in message_group_list:
            message_counter = 0
            async for ms in client.iter_messages(msg_group, min_id=1):
                message_counter = message_counter + 1
                date = date.replace(tzinfo=utc)
                ms.date = ms.date.replace(tzinfo=utc)
                if ms.message is None:
                    continue
                for msss in mes_list:
                    if ms.message == msss.message:
                        mes_list.remove(msss)

                messa = ms.message.lower()
                res1 = messa.find(cargo_from)
                res2 = messa.find(cargo_to)
                res3 = messa.find(cargo_type)
                if ms.date >= date and res1 != -1 and res2 != -1 and res3 != -1:
                    mes_list.append(ms)

                if len(mes_list) == message_page * 5:
                    break

                if message_counter == 300:
                    break

        await client.disconnect()

    s = state.State("SEARCH_CARGO", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_ONE_OF_THE_CARGOS")
    text += f"\nPage: {message_page}"
    await bot.send_message(msg.chat.id, text,
                           reply_markup=await keyboard.get_cargo_menu(lang, mes_list, message_page, cargo_from,
                                                                      cargo_to, phone))


@dp.callback_query_handler(filters.CheckStateWithCall("SEARCH_CARGO"), lambda call: call.data == "next")
async def search_cargo_next_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    page = data.get("MESSAGE_PAGE") + 1
    data.update({"MESSAGE_PAGE": page})

    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    cargo_from = data.get("CARGO_FROM")
    cargo_from = cargo_from.lower()
    cargo_to = data.get("CARGO_TO")
    cargo_to = cargo_to.lower()
    cargo_type = data.get("CARGO_TYPE")
    cargo_type = cargo_type.lower()

    date = datetime.now() - timedelta(days=1)
    folder = data.get("folder", "Skylog-1")

    wait_text = language.Language.get(lang, "WAIT_TEXT")
    await bot.send_message(call.message.chat.id, wait_text, reply_markup=keyboard.remove_menu)

    message_group_list = await utils.get_my_groups(call.message.chat.id, folder)

    mes_list = []
    async with TelegramClient(session=phone, api_id=24963729, api_hash="1bab3b9c3675227b43619d2175bd6990") as client:
        await client.connect()
        for msg_group in message_group_list:
            message_counter = 0
            async for ms in client.iter_messages(msg_group, min_id=1):
                message_counter = message_counter + 1
                date = date.replace(tzinfo=utc)
                ms.date = ms.date.replace(tzinfo=utc)
                if ms.message is None:
                    continue
                for msss in mes_list:
                    if ms.message == msss.message:
                        mes_list.remove(msss)

                messa = ms.message.lower()
                res1 = messa.find(cargo_from)
                res2 = messa.find(cargo_to)
                res3 = messa.find(cargo_type)
                if ms.date >= date and res1 != -1 and res2 != -1 and res3 != -1:
                    mes_list.append(ms)

                if len(mes_list) == page * 5:
                    break

                if message_counter == 300:
                    break
        await client.disconnect()

    s = state.State("SEARCH_CARGO", data, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_ONE_OF_THE_CARGOS")
    text += f"\nPage: {page}"
    await bot.edit_message_text(text, call.message.chat.id, message_id=call.message.message_id,
                                reply_markup=await keyboard.get_cargo_menu(lang, mes_list, page, cargo_from, cargo_to,
                                                                           phone))


@dp.callback_query_handler(filters.CheckStateWithCall("SEARCH_CARGO"), lambda call: call.data == "prev")
async def search_cargo_prev_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    page = data.get("MESSAGE_PAGE") - 1
    data.update({"MESSAGE_PAGE": page})

    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    cargo_from = data.get("CARGO_FROM")
    cargo_from = cargo_from.lower()
    cargo_to = data.get("CARGO_TO")
    cargo_to = cargo_to.lower()
    cargo_type = data.get("CARGO_TYPE")
    cargo_type = cargo_type.lower()
    message_page = data.get("MESSAGE_PAGE")

    date = datetime.now() - timedelta(days=1)
    folder = data.get("folder", "Skylog-1")

    wait_text = language.Language.get(lang, "WAIT_TEXT")
    await bot.send_message(call.message.chat.id, wait_text, reply_markup=keyboard.remove_menu)

    message_group_list = await utils.get_my_groups(call.message.chat.id, folder)

    mes_list = []
    async with TelegramClient(session=phone, api_id=24963729, api_hash="1bab3b9c3675227b43619d2175bd6990") as client:
        await client.connect()
        for msg_group in message_group_list:
            message_counter = 0
            async for ms in client.iter_messages(msg_group, min_id=1):
                message_counter = message_counter + 1
                date = date.replace(tzinfo=utc)
                ms.date = ms.date.replace(tzinfo=utc)
                if ms.message is None:
                    continue
                for msss in mes_list:
                    if ms.message == msss.message:
                        mes_list.remove(msss)

                messa = ms.message.lower()
                res1 = messa.find(cargo_from)
                res2 = messa.find(cargo_to)
                res3 = messa.find(cargo_type)
                if ms.date >= date and res1 != -1 and res2 != -1 and res3 != -1:
                    mes_list.append(ms)

                if len(mes_list) == message_page * 5:
                    break
                if message_counter == 300:
                    break
        await client.disconnect()

    s = state.State("SEARCH_CARGO", data, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_ONE_OF_THE_CARGOS")
    text += f"\nPage: {page}"
    await bot.edit_message_text(text, call.message.chat.id, message_id=call.message.message_id,
                                reply_markup=await keyboard.get_cargo_menu(lang, mes_list, page, cargo_from, cargo_to,
                                                                           phone))


@dp.callback_query_handler(filters.CheckStateWithCall("SEARCH_CARGO"), lambda call: call.data == "back")
async def search_cargo_back_message(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "BACK")
    await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("HISTORY"))
async def message_history_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    user_id = user.User.get_id_by_phone(phone)
    s = state.State("HISTORY", data, msg.chat.id)
    state.append(s)

    messages = message.Message.list_by_user_id(user_id)
    for ms in messages:
        text = f"""ID: {ms[0]}
Message: {ms[2]}
Timer: {ms[3]}
Status: {ms[4]}"""
        if ms[4] == True:
            await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_stop_message_menu(lang))
        else:
            await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
    text = language.Language.get(lang, "BACK")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_history_back_menu(lang))


@dp.message_handler(filters.CheckState("HISTORY"), filters.CheckWord("BACK"))
async def back_history_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("HOME_MENU", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "BACK")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.callback_query_handler(filters.CheckStateWithCall("HISTORY"), lambda call: call.data == "stop")
async def history_menu(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    s = state.State("HISTORY_STOP", data, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_MESSAGE_ID")
    await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("HISTORY_STOP"))
async def history_stop_menu(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    user_id = user.User.get_id_by_phone(phone)
    s = state.State("HOME_MENU", data, msg.chat.id)
    state.append(s)

    messages = message.Message.list_by_user_id(user_id)
    for ms in messages:
        if str(ms[0]) == msg.text:
            message.Message.set_status(user_id, ms[0], False)
    text = language.Language.get(lang, "HOME_MENU")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("PROFILE"))
async def profile_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    s = state.State("PROFILE", data, msg.chat.id)
    state.append(s)

    u = user.User.get_by_phone(phone)
    info = language.Language.get(lang, "FIRST_NAME") + f": {u[1]}\n"
    info += language.Language.get(lang, "LAST_NAME") + f": {u[2]}\n"
    info += language.Language.get(lang, "PHONE_NUMBER") + f": {u[3]}\n"
    info += language.Language.get(lang, "PUBLISH_DAY") + f": {u[8]} " + language.Language.get(lang, "DAY")
    text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
    await bot.send_message(msg.chat.id, info)
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_profile_menu(lang))


@dp.message_handler(filters.CheckState("PROFILE"), filters.CheckWord("CHANGE_LANGUAGE"))
async def profile_change_language_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    s = state.State("PROFILE_CHANGE_LANGUAGE", data, msg.chat.id)
    state.append(s)
    text = language.Language.get("NONE", "LANGUAGE_MENU")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_language_manu())


@dp.message_handler(filters.CheckState("PROFILE_CHANGE_LANGUAGE"),
                    lambda msg: msg.text in ["English " + settings.EN_STIK, "Russian " + settings.RU_STIK,
                                             "Uzbek " + settings.UZ_STIK])
async def profile_change_language_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"LANG": msg.text})
    lang = msg.text
    s = state.State("PROFILE", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_profile_menu(lang))


@dp.message_handler(filters.CheckState("PROFILE"), filters.CheckWord("LOGOUT"))
async def profile_logout_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "GOODBYE")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))


@dp.message_handler(filters.CheckState("PROFILE"), filters.CheckWord("BACK"))
async def profile_back_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("HOME_MENU", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("JOIN_GROUP"))
async def join_group_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("JOIN_GROUP", data, msg.chat.id)
    state.append(s)
    text1 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/qkvbibwxr45jMjAy"
    text2 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/YZRlMKksb1tjN2Ji"
    text3 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/dKoivNKHADUxMzgy"
    text4 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/CqTjXbzl6oJkMDAy"
    text5 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/3CoyHeRvosBhNDAy"
    text6 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/_99iSOEIXvFiNDcy"
    text7 = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + "https://t.me/addlist/MwmUGfiNNqc3Zjli"
    await bot.send_message(msg.chat.id, text1, reply_markup=keyboard.remove_menu)
    await bot.send_message(msg.chat.id, text2, reply_markup=keyboard.remove_menu)
    await bot.send_message(msg.chat.id, text3, reply_markup=keyboard.remove_menu)
    await bot.send_message(msg.chat.id, text4, reply_markup=keyboard.remove_menu)
    await bot.send_message(msg.chat.id, text5, reply_markup=keyboard.remove_menu)
    await bot.send_message(msg.chat.id, text6, reply_markup=keyboard.remove_menu)
    await bot.send_message(msg.chat.id, text7, reply_markup=keyboard.get_done_student_menu(lang))


@dp.message_handler(filters.CheckState("ACTIVATE_MENU"), filters.CheckWord("ACTIVATE"))
async def activate_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("HAVE_2FA", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "YOU_HAVE_2FA")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_question_menu(lang))


@dp.message_handler(filters.CheckState("HAVE_2FA"), filters.CheckWord("YES"))
async def have_2fa_yes(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    phone = data.get("PHONE_NUMBER")
    client = await utils.get_client(phone)
    await client.connect()

    # res: SentCode = await client.send_code_request(phone)
    client.session.save()
    await client.disconnect()
    # data.update({"HASH": res.phone_code_hash})
    lang = data.get("LANG")
    s = state.State("ENTER_ACTIVATE_PASSWORD", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_PASSWORD_TG")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("HAVE_2FA"), filters.CheckWord("NO"))
async def have_2fa_NO(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    phone = data.get("PHONE_NUMBER")
    client = await utils.get_client(phone)
    await client.connect()
    res: SentCode = await client.send_code_request(phone)
    client.session.save()
    await client.disconnect()
    data.update({"HASH": res.phone_code_hash})
    lang = data.get("LANG")
    s = state.State("ENTER_ACTIVATE_CODE", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "ENTER_YOUR_CODE")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)


@dp.message_handler(filters.CheckState("ENTER_ACTIVATE_PASSWORD"))
async def enter_activate_password_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    data.update({"PASSWORD": msg.text})
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    client = await utils.get_client(phone)

    try:
        await client.connect()
        res: SentCode = await client.send_code_request(phone)
        data["HASH"] = res.phone_code_hash
        s = state.State("ENTER_ACTIVATE_CODE", data, msg.chat.id)
        state.append(s)

        text = language.Language.get(lang, "ENTER_YOUR_CODE")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)

    except Exception as e:
        error_text = f"Kod yuborishda xatolik: {str(e)}"
        await bot.send_message(msg.chat.id, error_text)
        back_state = state.State("LANGUAGE_MENU", {"LANG": lang}, msg.chat.id)
        state.append(back_state)
    finally:
        try:
            if client.is_connected():
                await client.disconnect()
        except:
            pass


@dp.message_handler(filters.CheckState("ENTER_ACTIVATE_CODE"))
async def enter_activate_code_message(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    phone = data.get("PHONE_NUMBER")
    password = data.get("PASSWORD", "")
    hash = data.get("HASH")
    raw_code = msg.text.strip()

    # Проверяем, есть ли пробелы в введённом коде
    if ' ' in raw_code:
        # Если пробелы есть, используем код как есть
        final_code = raw_code
    else:
        # Если пробелов нет, добавляем их между цифрами
        clean_code = ''.join(c for c in raw_code if c.isdigit())  # Убираем всё, кроме цифр
        if len(clean_code) != 5:
            await bot.send_message(msg.chat.id, "Kod noto'g'ri formatda. Iltimos, 5 ta raqamli kodni kiriting.")
            return
        final_code = ' '.join(clean_code[i] for i in range(len(clean_code)))  # Добавляем пробелы

    print(f"Введённый код: {raw_code}")
    print(f"Финальный код для входа: {final_code}")

    client = await utils.get_client(phone)
    await client.connect()

    try:
        # Пробуем войти с кодом в формате с пробелами
        await client.sign_in(phone=phone, code=final_code, phone_code_hash=hash)
        success = True
    except SessionPasswordNeededError:
        # Если требуется пароль 2FA
        try:
            await client.sign_in(password=password)
            success = True
        except Exception as e:
            success = False
            error_msg = f"Parol xatosi: {str(e)}"
    except Exception as e:
        success = False
        error_msg = f"Kod bilan kirishda xato: {str(e)}"

    if success:
        await client.disconnect()
        user.User.change_active(phone, msg.chat.id)
        s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
        state.append(s)
        text = language.Language.get(lang, "HOME_MENU")
        await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
    else:
        await client.disconnect()
        s = state.State("LANGUAGE_MENU", {"PHONE_NUMBER": phone, "LANG": lang}, msg.chat.id)
        state.append(s)
        error_text = language.Language.get(lang, "LOGIN_ERROR") or "Kirish paytida xatolik yuz berdi. Iltimos qayta urinib ko'ring."
        await bot.send_message(msg.chat.id, f"{error_text}\nXato: {error_msg}")

# @dp.message_handler(filters.CheckState("ENTER_ACTIVATE_CODE"))
# async def enter_activate_code_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#     password = data.get("PASSWORD", "")
#     hash = data.get("HASH")
#     s = state.State("LANGUAGE_MENU", {"PHONE_NUMBER": phone, "LANG": lang}, msg.chat.id)
#     state.append(s)
#     client = await utils.get_client(phone)
#     await client.connect()
#     clean_code = ''.join(c for c in msg.text if c.isdigit())
#     print(msg.text, 'code')
#
#     # Probel bilan ajratilgan kod yaratish - "12345" => "1 2 3 4 5"
#     spaced_code = ' '.join(clean_code)
#     print(spaced_code,'spaced_code')
#     try:
#         await client.sign_in(phone=phone, code=str(spaced_code), phone_code_hash=hash)
#     except SessionPasswordNeededError as e:
#         await client.sign_in(password=str(password))
#         await client.disconnect()
#     await client.disconnect()
#     user.User.change_active(phone, msg.chat.id)
#
#     s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "HOME_MENU")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.message_handler(filters.CheckWord("BACK_TO_HOME_MENU"))
async def word_back_to_home_menu_student(msg: Message) -> None:
    data = state.get_data(msg.chat.id)
    lang = data.get("LANG")
    s = state.State("HOME_MENU", data, msg.chat.id)
    state.append(s)
    text = language.Language.get(lang, "HOME_MENU")
    await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


@dp.callback_query_handler(lambda call: call.data == "back_to_home_menu")
async def call_back_to_home_menu_student(call: CallbackQuery) -> None:
    data = state.get_data(call.message.chat.id)
    lang = data.get("LANG")
    s = state.State("HOME_MENU", data, call.message.chat.id)
    state.append(s)
    text = language.Language.get(lang, "HOME_MENU")
    await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))


# import logging
# import aiogram
# import pytz
# import telethon
# from states import state
# from keyboards import keyboard
# from configs.bot_config import bot, dp
# from datetime import datetime, timedelta
# from telethon.sync import TelegramClient
# from telethon.tl.types.auth import SentCode
# from configs import filters, settings, utils
# from telethon.errors.rpcerrorlist import SessionPasswordNeededError
# from aiogram.types import Message, CallbackQuery, ContentType
# from models import language, user, message, message_group, message_group_user
# from services.scheduler import schedule_message, cancel_scheduled_message
#
#
# API_ID = 24963729
# API_HASH = "1bab3b9c3675227b43619d2175bd6990"
# UTC = pytz.UTC
#
# import logging
# logger = logging.getLogger(__name__)
#
#
#
# @dp.message_handler(commands=['start'])
# async def start_command(msg: Message) -> None:
#     s = state.State("LANGUAGE_MENU", {}, msg.chat.id)
#     state.append(s)
#     text = language.Language.get("NONE", "LANGUAGE_MENU")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_language_manu())
#
#
# @dp.message_handler(filters.CheckState("LANGUAGE_MENU"),
#                     lambda msg: msg.text in ["English " + settings.EN_STIK, "Russian " + settings.RU_STIK,
#                                              "Uzbek " + settings.UZ_STIK])
# async def auth_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"LANG": msg.text})
#     s = state.State("AUTH_MENU", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(msg.text, "CHOOSE_ONE_FROM_THIS_SECTION")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(msg.text))
#
#
# @dp.message_handler(filters.CheckState("AUTH_MENU"), filters.CheckWord("REGISTER"))
# async def register_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("REGISTER_FIRST_NAME", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_FIRST_NAME")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("REGISTER_FIRST_NAME"))
# async def register_first_name_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     data.update({"FIRST_NAME": msg.text})
#     s = state.State("REGISTER_LAST_NAME", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_LAST_NAME")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("REGISTER_LAST_NAME"))
# async def register_last_name_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     data.update({"LAST_NAME": msg.text})
#     s = state.State("REGISTER_PHONE", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "SEND_YOUR_CONTACT")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_contact_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("REGISTER_PHONE"), content_types=ContentType.CONTACT)
# async def register_phone_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     data.update({"PHONE_NUMBER": msg.contact.phone_number})
#     s = state.State("REGISTER_PASSWORD", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_PASSWORD")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("REGISTER_PASSWORD"))
# async def register_password_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     first_name = data.get("FIRST_NAME")
#     last_name = data.get("LAST_NAME")
#     phone_number = data.get("PHONE_NUMBER")
#     password = msg.text
#     lang = data.get("LANG")
#     s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#     state.append(s)
#
#     try:
#         res = user.User.register(first_name, last_name, phone_number, password, lang, msg.chat.id)
#         if res:
#             text = language.Language.get(lang, "SUCCESSFULLY_REGISTERED")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#         else:
#             text = language.Language.get(lang, "YOU_ARE_ALREADY_REGISTERED")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#     except Exception as e:
#         text = language.Language.get(lang, "REGISTRATION_ERROR")
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("AUTH_MENU"), filters.CheckWord("LOGIN"))
# async def login_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("LOGIN_PHONE", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "SEND_YOUR_CONTACT")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_contact_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("LOGIN_PHONE"), content_types=ContentType.CONTACT)
# async def login_phone_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     data.update({"PHONE_NUMBER": msg.contact.phone_number})
#     s = state.State("ENTER_YOUR_PASSWORD", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_PASSWORD")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("ENTER_YOUR_PASSWORD"))
# async def login_password_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#     password = msg.text
#
#     try:
#         res = user.User.login(phone, password)
#
#         if res == "NO" or res == "ADMIN" or res == "RECEPTION":
#             s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#             state.append(s)
#             text = language.Language.get(lang, "USER_NOT_FOUND")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#         elif res == "NOT_ACTIVE":
#             s = state.State("ACTIVATE_MENU", data, msg.chat.id)
#             state.append(s)
#             user.User.set_chat_id_by_phone(msg.chat.id, phone)
#             text = language.Language.get(lang, "YOU_IS_NOT_ACTIVE")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_active_menu(lang))
#         elif res == "STUDENT":
#             s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
#             state.append(s)
#             text = language.Language.get(lang, "HOME_MENU")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#     except Exception as e:
#         text = language.Language.get(lang, "LOGIN_ERROR")
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("AUTO_MESSAGE"))
# async def home_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("AUTO_MESSAGE", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_MESSAGE")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("AUTO_MESSAGE"))
# async def auto_message_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"MESSAGE": msg.text})
#     lang = data.get("LANG")
#     s = state.State("YOUR_MESSAGE", data, msg.chat.id)
#     state.append(s)
#     await bot.send_message(msg.chat.id, msg.text, reply_markup=keyboard.get_message_student_menu(lang))
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "edit_text")
# async def edit_text_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     s = state.State("AUTO_MESSAGE", data, call.message.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_EDITED_MESSAGE")
#     await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "edit_group")
# async def edit_group_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     s = state.State("EDIT_GROUP", data, call.message.chat.id)
#     state.append(s)
#
#     links = [
#         "https://t.me/addlist/qkvbibwxr45jMjAy",
#         "https://t.me/addlist/YZRlMKksb1tjN2Ji",
#         "https://t.me/addlist/dKoivNKHADUxMzgy",
#         "https://t.me/addlist/CqTjXbzl6oJkMDAy",
#         "https://t.me/addlist/3CoyHeRvosBhNDAy",
#         "https://t.me/addlist/_99iSOEIXvFiNDcy",
#         "https://t.me/addlist/MwmUGfiNNqc3Zjli"
#     ]
#
#     for link in links[:-1]:
#         text = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + link
#         await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.remove_menu)
#
#     text = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + links[-1]
#     await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_done_student_menu(lang))
#
#
# @dp.message_handler(filters.CheckStateList(["EDIT_GROUP", "JOIN_GROUP"]), filters.CheckWord("DONE"))
# async def select_folder(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("SELECT_FOLDER", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "SELECT_FOLDER")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_folder(lang))
#
#
# @dp.message_handler(filters.CheckState("SELECT_FOLDER"),
#                     lambda msg: msg.text in ["Skylog-1", "Skylog-2", "Skylog-3", "Skylog-4", "Skylog-5", "Skylog-6",
#                                              "Skylog-7"])
# async def select_fol(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"PAGE": 0})
#     data.update({"folder": msg.text})
#     lang = data.get("LANG")
#     s = state.State("GROUP_BTN", data, msg.chat.id)
#     state.append(s)
#     wait_text = language.Language.get(lang, "WAIT_TEXT")
#     await bot.send_message(msg.chat.id, wait_text, reply_markup=keyboard.remove_menu)
#
#     try:
#         my_groups = await utils.get_my_groups(msg.chat.id, msg.text)
#         text = language.Language.get(lang, "CORRECT_OR_INCORRECT")
#         await bot.send_message(msg.chat.id, text,
#                                reply_markup=await keyboard.get_add_group_student_menu(lang, 0, msg.chat.id, my_groups))
#         await bot.send_message(msg.chat.id, language.Language.get(lang, "SELECT_THIS_GROUPS"),
#                                reply_markup=keyboard.get_done_student_menu(lang))
#     except Exception as e:
#         error_text = f"Guruhlarni yuklashda xatolik: {str(e)}"
#         await bot.send_message(msg.chat.id, error_text)
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("GROUP_BTN"))
# async def group_btn_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     folder = data.get("folder")
#
#     try:
#         my_groups = await utils.get_my_groups(call.message.chat.id, folder)
#         if not my_groups:
#             await bot.send_message(call.message.chat.id, "Guruhlar topilmadi!")
#             return
#
#         current_page = data.get("PAGE", 0)
#         new_page = current_page
#         group_list = data.get("GROUP_LIST", [])
#
#         if call.data in my_groups:
#             if call.data in group_list:
#                 group_list.remove(call.data)
#             else:
#                 group_list.append(call.data)
#             group_list = list(set(group_list))
#             data.update({"GROUP_LIST": group_list})
#         elif call.data == "prev":
#             new_page = max(0, current_page - 1)
#             data.update({"PAGE": new_page})
#         elif call.data == "next":
#             new_page = current_page + 1
#             data.update({"PAGE": new_page})
#         elif call.data == "select_all":
#             group_list = list(set(group_list + my_groups))
#             data.update({"GROUP_LIST": group_list})
#         else:
#             text = language.Language.get(lang, "WRONG_MESSAGE")
#             await bot.send_message(call.message.chat.id, text)
#             return
#
#         s = state.State("GROUP_BTN", data, call.message.chat.id)
#         state.append(s)
#
#         new_keyboard = await keyboard.get_add_group_student_menu(lang, new_page, call.message.chat.id, my_groups)
#         try:
#             await bot.edit_message_reply_markup(
#                 call.message.chat.id,
#                 message_id=call.message.message_id,
#                 reply_markup=new_keyboard
#             )
#         except aiogram.utils.exceptions.MessageNotModified:
#             pass
#     except Exception as e:
#         await bot.send_message(call.message.chat.id, f"Guruhlarni yangilashda xatolik: {str(e)}")
#
#
# @dp.message_handler(filters.CheckState("GROUP_BTN"), filters.CheckWord("DONE"))
# async def group_done_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#
#     try:
#         user_id = user.User.get_id_by_phone(phone)
#         group_list = data.get("GROUP_LIST", [])
#
#         message_group_user.MessageGroupUser.add_groups_to_user(user_id, msg.chat.id)
#         text1 = language.Language.get(lang, "SUCCESSFULLY_SELECTED_GROUPS")
#         text2 = data.get("MESSAGE")
#
#         if text2 is None:
#             s = state.State("HOME_MENU", data, msg.chat.id)
#             state.append(s)
#             text2 = language.Language.get(lang, "HOME_MENU")
#             await bot.send_message(msg.chat.id, text1, reply_markup=keyboard.remove_menu)
#             await bot.send_message(msg.chat.id, text2, reply_markup=keyboard.get_home_student_menu(lang))
#         else:
#             s = state.State("YOUR_MESSAGE", data, msg.chat.id)
#             state.append(s)
#             await bot.send_message(msg.chat.id, text1, reply_markup=keyboard.remove_menu)
#             await bot.send_message(msg.chat.id, text2, reply_markup=keyboard.get_message_student_menu(lang))
#     except Exception as e:
#         await bot.send_message(msg.chat.id, f"Guruhlarni qo'shishda xatolik: {str(e)}")
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "edit_timer")
# async def edit_timer_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     s = state.State("EDIT_TIMER", data, call.message.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "CHOOSE_TIMER")
#     await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_timer_student_menu(lang))
#
#
# async def handle_timer_selection(msg: Message, timer_value: int) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#
#     try:
#         user_id = user.User.get_id_by_phone(phone)
#         mess = data.get("MESSAGE")
#
#         res = await message.Message.create(user_id, mess, timer_value, phone)
#         data.update({"MESSAGE_ID": res[0]})
#
#         s = state.State("YOUR_MESSAGE", data, msg.chat.id)
#         state.append(s)
#         text = language.Language.get(lang, "SUCCESSFULLY_CREATED_YOUR_MESSAGE")
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#         await bot.send_message(msg.chat.id, mess, reply_markup=keyboard.get_message_student_menu(lang))
#     except Exception as e:
#         error_text = f"Xabar yaratishda xatolik: {str(e)}"
#         await bot.send_message(msg.chat.id, error_text)
#
#
# @dp.message_handler(filters.CheckState("EDIT_TIMER"), filters.CheckWord("MINUTE_30"))
# async def start_time_student_30_minute(msg: Message) -> None:
#     await handle_timer_selection(msg, 30)
#
#
# @dp.message_handler(filters.CheckState("EDIT_TIMER"), filters.CheckWord("MINUTE_45"))
# async def start_time_student_45_minute(msg: Message) -> None:
#     await handle_timer_selection(msg, 45)
#
#
# @dp.message_handler(filters.CheckState("EDIT_TIMER"), filters.CheckWord("MINUTE_60"))
# async def start_time_student_60_minute(msg: Message) -> None:
#     await handle_timer_selection(msg, 60)
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("YOUR_MESSAGE"), lambda call: call.data == "start")
# async def start_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     message_id = data.get("MESSAGE_ID")
#
#     if message_id is None:
#         text = language.Language.get(lang, "PLEASE_SELECT_TIMER")
#         s = state.State("EDIT_TIMER", data, call.message.chat.id)
#         state.append(s)
#         await bot.send_message(
#             call.message.chat.id,
#             text,
#             reply_markup=keyboard.get_timer_student_menu(lang)
#         )
#         return None
#
#     group_list = data.get("GROUP_LIST", [])
#
#     if group_list:
#         try:
#             mess = data.get("MESSAGE")
#             phone = data.get("PHONE_NUMBER")
#             user_id = user.User.get_id_by_phone(phone)
#
#             await message.Message.change_status(user_id, message_id, True, mess, phone)
#             await schedule_message(user_id, mess, data.get("timer", 30), phone, message_id)
#
#             data_for_home = {
#                 "LANG": lang,
#                 "role": "STUDENT",
#                 "PHONE_NUMBER": phone,
#                 "folder": data.get("folder")
#             }
#
#             s = state.State("HOME_MENU", data_for_home, call.message.chat.id)
#             state.append(s)
#
#             text = language.Language.get(lang, "BACK_HOME_MENU")
#             await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#         except Exception as e:
#             error_text = f"Xabarni faollashtirishda xatolik: {str(e)}"
#             await bot.send_message(call.message.chat.id, error_text, reply_markup=keyboard.get_home_student_menu(lang))
#     else:
#         folder = data.get("folder")
#         if folder is None:
#             s = state.State("SELECT_FOLDER", data, call.message.chat.id)
#             state.append(s)
#             text = language.Language.get(lang, "SELECT_FOLDER")
#             await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_folder(lang))
#         else:
#             s = state.State("GROUP_BTN", data, call.message.chat.id)
#             state.append(s)
#
#             wait_text = language.Language.get(lang, "WAIT_TEXT")
#             await bot.send_message(call.message.chat.id, wait_text, reply_markup=keyboard.remove_menu)
#
#             try:
#                 my_groups = await utils.get_my_groups(call.message.chat.id, folder)
#                 correct_text = language.Language.get(lang, "CORRECT_OR_INCORRECT")
#                 await bot.send_message(
#                     call.message.chat.id,
#                     correct_text,
#                     reply_markup=await keyboard.get_add_group_student_menu(lang, 0, call.message.chat.id, my_groups)
#                 )
#                 await bot.send_message(
#                     call.message.chat.id,
#                     language.Language.get(lang, "SELECT_THIS_GROUPS"),
#                     reply_markup=keyboard.get_done_student_menu(lang)
#                 )
#             except Exception as e:
#                 error_text = f"Guruhlarni yuklashda xatolik: {str(e)}"
#                 await bot.send_message(call.message.chat.id, error_text)
#
#
# @dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("SEARCH_CARGO"))
# async def search_cargo_from_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"MESSAGE_PAGE": 1})
#     lang = data.get("LANG")
#     s = state.State("SEARCH_CARGO_FROM", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_CARGO_FROM")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
# @dp.message_handler(filters.CheckState("SEARCH_CARGO_FROM"))
# async def search_cargo_to_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"CARGO_FROM": msg.text})
#     lang = data.get("LANG")
#     s = state.State("SEARCH_CARGO_TO", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_CARGO_TO")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("SEARCH_CARGO_TO"))
# async def search_cargo_type_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"CARGO_TO": msg.text})
#     lang = data.get("LANG")
#     s = state.State("SEARCH_CARGO", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "CHOOSE_CARGO_TYPE")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_cargo_type_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("SEARCH_CARGO"), filters.CheckWordList(["ISOTHERM", "REF", "AWNING"]))
# async def search_cargo_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"CARGO_TYPE": msg.text})
#     await perform_cargo_search(msg, data, data.get("MESSAGE_PAGE", 1))
#
#
# async def perform_cargo_search(message_obj, data, page):
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#     cargo_from = data.get("CARGO_FROM", "").lower()
#     cargo_to = data.get("CARGO_TO", "").lower()
#     cargo_type = data.get("CARGO_TYPE", "").lower()
#     folder = data.get("folder", "Skylog-1")
#
#     date = datetime.now() - timedelta(days=1)
#
#     wait_text = language.Language.get(lang, "WAIT_TEXT")
#     await bot.send_message(message_obj.chat.id, wait_text, reply_markup=keyboard.remove_menu)
#
#     try:
#         message_group_list = await utils.get_my_groups(message_obj.chat.id, folder)
#         mes_list = []
#
#         async with TelegramClient(session=phone, api_id=API_ID, api_hash=API_HASH) as client:
#             for msg_group in message_group_list:
#                 message_counter = 0
#                 try:
#                     async for ms in client.iter_messages(msg_group, min_id=1):
#                         message_counter += 1
#
#                         date_utc = date.replace(tzinfo=UTC)
#                         ms_date_utc = ms.date.replace(tzinfo=UTC)
#
#                         if not ms.message:
#                             continue
#
#                         for existing_msg in mes_list[:]:
#                             if ms.message == existing_msg.message:
#                                 mes_list.remove(existing_msg)
#                                 break
#
#                         msg_text = ms.message.lower()
#                         contains_from = cargo_from in msg_text
#                         contains_to = cargo_to in msg_text
#                         contains_type = cargo_type in msg_text
#
#                         if ms_date_utc >= date_utc and contains_from and contains_to and contains_type:
#                             mes_list.append(ms)
#
#                         if len(mes_list) >= page * 5:
#                             break
#
#                         if message_counter >= 300:
#                             break
#                 except Exception as e:
#                     continue
#
#         s = state.State("SEARCH_CARGO", data, message_obj.chat.id)
#         state.append(s)
#         text = language.Language.get(lang, "CHOOSE_ONE_OF_THE_CARGOS")
#         text += f"\nPage: {page}"
#
#         keyboard_markup = await keyboard.get_cargo_menu(lang, mes_list, page, cargo_from, cargo_to, phone)
#
#         if isinstance(message_obj, Message):
#             await bot.send_message(message_obj.chat.id, text, reply_markup=keyboard_markup)
#         else:
#             await bot.edit_message_text(text, message_obj.chat.id, message_id=message_obj.message_id,
#                                         reply_markup=keyboard_markup)
#     except Exception as e:
#         error_text = f"Yukni qidirishda xatolik: {str(e)}"
#         await bot.send_message(message_obj.chat.id, error_text)
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("SEARCH_CARGO"), lambda call: call.data == "next")
# async def search_cargo_next_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     page = data.get("MESSAGE_PAGE", 1) + 1
#     data.update({"MESSAGE_PAGE": page})
#     await perform_cargo_search(call.message, data, page)
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("SEARCH_CARGO"), lambda call: call.data == "prev")
# async def search_cargo_prev_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     page = max(1, data.get("MESSAGE_PAGE", 1) - 1)
#     data.update({"MESSAGE_PAGE": page})
#     await perform_cargo_search(call.message, data, page)
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("SEARCH_CARGO"), lambda call: call.data == "back")
# async def search_cargo_back_message(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#     s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, call.message.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "BACK")
#     await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("HISTORY"))
# async def message_history_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#
#     try:
#         user_id = user.User.get_id_by_phone(phone)
#         s = state.State("HISTORY", data, msg.chat.id)
#         state.append(s)
#
#         messages = message.Message.list_by_user_id(user_id)
#         if not messages:
#             await bot.send_message(msg.chat.id, language.Language.get(lang, "NO_MESSAGES"))
#             text = language.Language.get(lang, "BACK")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_history_back_menu(lang))
#             return
#
#         for ms in messages:
#             text = f"""ID: {ms[0]}
# Message: {ms[2]}
# Timer: {ms[3]}
# Status: {ms[4]}"""
#             if ms[4] == True:
#                 await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_stop_message_menu(lang))
#             else:
#                 await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#         text = language.Language.get(lang, "BACK")
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_history_back_menu(lang))
#     except Exception as e:
#         error_text = f"Xabarlar tarixini olishda xatolik: {str(e)}"
#         await bot.send_message(msg.chat.id, error_text, reply_markup=keyboard.get_history_back_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("HISTORY"), filters.CheckWord("BACK"))
# async def back_history_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("HOME_MENU", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "BACK")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#
#
# @dp.callback_query_handler(filters.CheckStateWithCall("HISTORY"), lambda call: call.data == "stop")
# async def history_menu(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     s = state.State("HISTORY_STOP", data, call.message.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_MESSAGE_ID")
#     await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("HISTORY_STOP"))
# async def history_stop_menu(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#
#     try:
#         user_id = user.User.get_id_by_phone(phone)
#         s = state.State("HOME_MENU", data, msg.chat.id)
#         state.append(s)
#
#         message_id = msg.text.strip()
#         if not message_id.isdigit():
#             await bot.send_message(msg.chat.id, language.Language.get(lang, "INVALID_MESSAGE_ID"))
#             text = language.Language.get(lang, "HOME_MENU")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#             return
#
#         messages = message.Message.list_by_user_id(user_id)
#         found = False
#         for ms in messages:
#             if str(ms[0]) == message_id:
#                 message.Message.set_status(user_id, ms[0], False)
#                 await cancel_scheduled_message(ms[0])
#                 found = True
#                 break
#
#         if found:
#             await bot.send_message(msg.chat.id, language.Language.get(lang, "MESSAGE_STOPPED"))
#         else:
#             await bot.send_message(msg.chat.id, language.Language.get(lang, "MESSAGE_NOT_FOUND"))
#
#         text = language.Language.get(lang, "HOME_MENU")
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#     except Exception as e:
#         error_text = f"Xabarni to'xtatishda xatolik: {str(e)}"
#         await bot.send_message(msg.chat.id, error_text, reply_markup=keyboard.get_home_student_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("PROFILE"))
# async def profile_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#     s = state.State("PROFILE", data, msg.chat.id)
#     state.append(s)
#
#     try:
#         u = user.User.get_by_phone(phone)
#         if not u:
#             await bot.send_message(msg.chat.id, language.Language.get(lang, "USER_NOT_FOUND"))
#             s = state.State("HOME_MENU", data, msg.chat.id)
#             state.append(s)
#             await bot.send_message(msg.chat.id, language.Language.get(lang, "HOME_MENU"),
#                                    reply_markup=keyboard.get_home_student_menu(lang))
#             return
#
#         info = language.Language.get(lang, "FIRST_NAME") + f": {u[1]}\n"
#         info += language.Language.get(lang, "LAST_NAME") + f": {u[2]}\n"
#         info += language.Language.get(lang, "PHONE_NUMBER") + f": {u[3]}\n"
#         info += language.Language.get(lang, "PUBLISH_DAY") + f": {u[8]} " + language.Language.get(lang, "DAY")
#
#         text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
#         await bot.send_message(msg.chat.id, info)
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_profile_menu(lang))
#     except Exception as e:
#         error_text = f"Profil ma'lumotlarini olishda xatolik: {str(e)}"
#         await bot.send_message(msg.chat.id, error_text, reply_markup=keyboard.get_home_student_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("PROFILE"), filters.CheckWord("CHANGE_LANGUAGE"))
# async def profile_change_language_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     s = state.State("PROFILE_CHANGE_LANGUAGE", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get("NONE", "LANGUAGE_MENU")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_language_manu())
#
#
# @dp.message_handler(filters.CheckState("PROFILE_CHANGE_LANGUAGE"),
#                     lambda msg: msg.text in ["English " + settings.EN_STIK, "Russian " + settings.RU_STIK,
#                                              "Uzbek " + settings.UZ_STIK])
# async def profile_change_language_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"LANG": msg.text})
#     lang = msg.text
#     s = state.State("PROFILE", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_profile_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("PROFILE"), filters.CheckWord("LOGOUT"))
# async def profile_logout_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "GOODBYE")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("PROFILE"), filters.CheckWord("BACK"))
# async def profile_back_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("HOME_MENU", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("HOME_MENU"), filters.CheckWord("JOIN_GROUP"))
# async def join_group_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("JOIN_GROUP", data, msg.chat.id)
#     state.append(s)
#
#     links = [
#         "https://t.me/addlist/qkvbibwxr45jMjAy",
#         "https://t.me/addlist/YZRlMKksb1tjN2Ji",
#         "https://t.me/addlist/dKoivNKHADUxMzgy",
#         "https://t.me/addlist/CqTjXbzl6oJkMDAy",
#         "https://t.me/addlist/3CoyHeRvosBhNDAy",
#         "https://t.me/addlist/_99iSOEIXvFiNDcy",
#         "https://t.me/addlist/MwmUGfiNNqc3Zjli"
#     ]
#
#     for link in links[:-1]:
#         text = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + link
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#     text = language.Language.get(lang, "SUBSCRIBE") + "\n\n" + links[-1]
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_done_student_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("ACTIVATE_MENU"), filters.CheckWord("ACTIVATE"))
# async def activate_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("HAVE_2FA", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "YOU_HAVE_2FA")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_question_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("HAVE_2FA"), filters.CheckWord("YES"))
# async def have_2fa_yes(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     phone = data.get("PHONE_NUMBER")
#     client = await utils.get_client(phone)
#     await client.connect()
#     res: SentCode = await client.send_code_request(phone)
#     client.session.save()
#     await client.disconnect()
#     data.update({"HASH": res.phone_code_hash})
#     lang = data.get("LANG")
#     s = state.State("ENTER_ACTIVATE_PASSWORD", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_PASSWORD_TG")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("HAVE_2FA"), filters.CheckWord("NO"))
# async def have_2fa_NO(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     phone = data.get("PHONE_NUMBER")
#     client = await utils.get_client(phone)
#     await client.connect()
#     res: SentCode = await client.send_code_request(phone)
#     client.session.save()
#     await client.disconnect()
#     data.update({"HASH": res.phone_code_hash})
#     lang = data.get("LANG")
#     s = state.State("ASK_LOGIN", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ASK_LOGIN")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_question_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("ENTER_ACTIVATE_PASSWORD"))
# async def enter_activate_password_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     data.update({"PASSWORD": msg.text})
#     lang = data.get("LANG")
#     s = state.State("ASK_LOGIN", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ASK_LOGIN")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_question_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("ASK_LOGIN"), filters.CheckWord("YES"))
# async def ask_login_yes(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("ENTER_ACTIVATE_CODE", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "ENTER_YOUR_CODE")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.remove_menu)
#
#
# @dp.message_handler(filters.CheckState("ASK_LOGIN"), filters.CheckWord("NO"))
# async def ask_login_no(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "CHOOSE_ONE_FROM_THIS_SECTION")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#
# @dp.message_handler(filters.CheckState("ENTER_ACTIVATE_CODE"))
# async def enter_activate_code_message(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     phone = data.get("PHONE_NUMBER")
#     password = data.get("PASSWORD", "")
#     hash_value = data.get("HASH")
#
#     clean_code = ''.join(c for c in msg.text if c.isdigit())
#
#
#     try:
#         client = await utils.get_client(phone)
#         await client.connect()
#
#         try:
#             await client.sign_in(phone=phone, code=msg.text, phone_code_hash=hash_value)
#             print("Successfully signed in with code")
#
#             await client.disconnect()
#             user.User.change_active(phone, msg.chat.id)
#
#             s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
#             state.append(s)
#             text = language.Language.get(lang, "HOME_MENU")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#
#         except telethon.errors.rpcerrorlist.SessionPasswordNeededError:
#             print("2FA detected, trying to sign in with password")
#
#             try:
#                 await client.sign_in(password=password)
#                 print("Successfully signed in with password")
#
#                 await client.disconnect()
#                 user.User.change_active(phone, msg.chat.id)
#
#                 s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
#                 state.append(s)
#                 text = language.Language.get(lang, "HOME_MENU")
#                 await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#
#             except Exception as e:
#                 print(f"Error during password sign in: {str(e)}")
#                 await client.disconnect()
#
#                 s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#                 state.append(s)
#                 text = language.Language.get(lang, "LOGIN_ERROR")
#                 await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#         except Exception as e:
#             print(f"Error during code sign in: {str(e)}")
#             await client.disconnect()
#
#             s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#             state.append(s)
#             text = language.Language.get(lang, "LOGIN_ERROR")
#             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#     except Exception as e:
#         print(f"General error: {str(e)}")
#
#         try:
#             client.disconnect()
#         except:
#             pass
#
#         s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
#         state.append(s)
#         text = language.Language.get(lang, "LOGIN_ERROR")
#         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
# # @dp.message_handler(filters.CheckState("ENTER_ACTIVATE_CODE"))
# # async def enter_activate_code_message(msg: Message) -> None:
# #     data = state.get_data(msg.chat.id)
# #     lang = data.get("LANG")
# #     phone = data.get("PHONE_NUMBER")
# #     password = data.get("PASSWORD", "")
# #     hash_value = data.get("HASH")
# #     retry_count = data.get("RETRY_COUNT", 0)
# #
# #     print(f"Received code: '{msg.text}'")
# #
# #     # Kodni tozalash
# #     clean_code = ''.join(c for c in msg.text if c.isdigit())
# #     print(f"Cleaned code: '{clean_code}'")
# #
# #     if not clean_code:
# #         print("Code is empty after cleaning")
# #         await bot.send_message(msg.chat.id, "Iltimos, raqam ko'rinishidagi kodni kiriting")
# #         return
# #
# #     print(f"Retry count: {retry_count}")
# #     if retry_count >= 2:
# #         s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
# #         state.append(s)
# #         text = language.Language.get(lang, "TOO_MANY_ATTEMPTS")
# #         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
# #         return
# #
# #     try:
# #         print(f"Getting client for phone: {phone}")
# #         client = await utils.get_client(phone)
# #         print("Connecting to Telegram...")
# #         await client.connect()
# #
# #         try:
# #             print(f"Signing in with code: {clean_code}, hash: {hash_value}")
# #             await client.sign_in(phone=phone, code=clean_code, phone_code_hash=hash_value)
# #             print("Successfully signed in")
# #             await client.disconnect()
# #
# #             print(f"Activating user with phone: {phone}")
# #             user.User.change_active(phone, msg.chat.id)
# #
# #             s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
# #             state.append(s)
# #             text = language.Language.get(lang, "HOME_MENU")
# #             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
# #         except telethon.errors.rpcerrorlist.PhoneCodeExpiredError as e:
# #             print(f"PhoneCodeExpiredError: {e}")
# #             data.update({"RETRY_COUNT": retry_count + 1})
# #             s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
# #             state.append(s)
# #             text = language.Language.get(lang, "CODE_EXPIRED")
# #             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
# #             await client.disconnect()
# #         except SessionPasswordNeededError:
# #             print(f"SessionPasswordNeededError, trying to sign in with password: {password}")
# #             try:
# #                 await client.sign_in(password=str(password))
# #                 print("Successfully signed in with password")
# #                 await client.disconnect()
# #                 user.User.change_active(phone, msg.chat.id)
# #                 s = state.State("HOME_MENU", {"LANG": lang, "role": "STUDENT", "PHONE_NUMBER": phone}, msg.chat.id)
# #                 state.append(s)
# #                 text = language.Language.get(lang, "HOME_MENU")
# #                 await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
# #             except Exception as e:
# #                 print(f"Error signing in with password: {e}")
# #                 await client.disconnect()
# #                 s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
# #                 state.append(s)
# #                 text = language.Language.get(lang, "LOGIN_ERROR")
# #                 await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
# #         except Exception as e:
# #             print(f"Other error during sign in: {e}")
# #             await client.disconnect()
# #             s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
# #             state.append(s)
# #             text = language.Language.get(lang, "LOGIN_ERROR")
# #             await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
# #     except Exception as e:
# #         print(f"Error before sign in: {e}")
# #         try:
# #             await client.disconnect()
# #         except:
# #             pass
# #         s = state.State("AUTH_MENU", {"LANG": lang}, msg.chat.id)
# #         state.append(s)
# #         text = language.Language.get(lang, "LOGIN_ERROR")
# #         await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_auth_menu(lang))
#
#
# @dp.message_handler(filters.CheckWord("BACK_TO_HOME_MENU"))
# async def word_back_to_home_menu_student(msg: Message) -> None:
#     data = state.get_data(msg.chat.id)
#     lang = data.get("LANG")
#     s = state.State("HOME_MENU", data, msg.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "HOME_MENU")
#     await bot.send_message(msg.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))
#
#
# @dp.callback_query_handler(lambda call: call.data == "back_to_home_menu")
# async def call_back_to_home_menu_student(call: CallbackQuery) -> None:
#     data = state.get_data(call.message.chat.id)
#     lang = data.get("LANG")
#     s = state.State("HOME_MENU", data, call.message.chat.id)
#     state.append(s)
#     text = language.Language.get(lang, "HOME_MENU")
#     await bot.send_message(call.message.chat.id, text, reply_markup=keyboard.get_home_student_menu(lang))