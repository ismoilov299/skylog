from sqlalchemy import create_engine, text
import datetime

# Ma'lumotlar bazasi ulanishi
engine = create_engine(
    url="postgresql+psycopg2://akbarov:akbarov@localhost:5433/logist_smart",
    echo=True,
    pool_size=180,
    max_overflow=250
)

# Yetishmayotgan o'zbek tilidagi tarjimalar
missing_uzbek_translations = {
    # Yuk turlari (rus tilidagi so'zlar saqlangan holda)
    "AWNING": {
        "Uzbek 🇺🇿": "ТЕНТ"
    },
    "REF": {
        "Uzbek 🇺🇿": "РЕФ"
    },
    "ISOTHERM": {
        "Uzbek 🇺🇿": "ГРУЗ"
    },
    # Tugmalar va boshqa elementlar
    "SEND_CONTACT": {
        "Uzbek 🇺🇿": "Kontaktni yuborish",
        "uz": "Kontaktni yuborish"
    },
    "JOIN_GROUP": {
        "Uzbek 🇺🇿": "Guruhga qo'shilish",
        "uz": "Guruhga qo'shilish"
    },
    "YES": {
        "Uzbek 🇺🇿": "Ha",
        "uz": "Ha"
    },
    "NO": {
        "Uzbek 🇺🇿": "Yo'q",
        "uz": "Yo'q"
    },
    "ACTIVATE": {
        "Uzbek 🇺🇿": "Faollashtirish",
        "uz": "Faollashtirish"
    },
    "AUTO_MESSAGE": {
        "Uzbek 🇺🇿": "Avto xabar",
        "uz": "Avto xabar"
    },
    "PROFILE": {
        "Uzbek 🇺🇿": "Profil",
        "uz": "Profil"
    },
    "SEARCH_CARGO": {
        "Uzbek 🇺🇿": "Yuk qidirish",
        "uz": "Yuk qidirish"
    },
    "HISTORY": {
        "Uzbek 🇺🇿": "Tarix",
        "uz": "Tarix"
    },
    "CHANGE_LANGUAGE": {
        "Uzbek 🇺🇿": "Tilni o'zgartirish",
        "uz": "Tilni o'zgartirish"
    },
    "LOGOUT": {
        "Uzbek 🇺🇿": "Chiqish",
        "uz": "Chiqish"
    },
    "STOP": {
        "Uzbek 🇺🇿": "To'xtatish",
        "uz": "To'xtatish"
    },
    "DONE": {
        "Uzbek 🇺🇿": "Tayyor",
        "uz": "Tayyor"
    },
    "MINUTE_30": {
        "Uzbek 🇺🇿": "30 daqiqa",
        "uz": "30 daqiqa"
    },
    "MINUTE_45": {
        "Uzbek 🇺🇿": "45 daqiqa",
        "uz": "45 daqiqa"
    },
    "MINUTE_60": {
        "Uzbek 🇺🇿": "60 daqiqa",
        "uz": "60 daqiqa"
    },
    "BACK_TO_HOME_MENU": {
        "Uzbek 🇺🇿": "Bosh menyuga qaytish",
        "uz": "Bosh menyuga qaytish"
    },
    "EDIT_TEXT": {
        "Uzbek 🇺🇿": "Matnni tahrirlash",
        "uz": "Matnni tahrirlash"
    },
    "EDIT_GROUP": {
        "Uzbek 🇺🇿": "Guruhni tahrirlash",
        "uz": "Guruhni tahrirlash"
    },
    "EDIT_TIMER": {
        "Uzbek 🇺🇿": "Taymerni tahrirlash",
        "uz": "Taymerni tahrirlash"
    },
    "START": {
        "Uzbek 🇺🇿": "Boshlash",
        "uz": "Boshlash"
    },
    "ACCOUNT_ACTIVATED": {
        "Uzbek 🇺🇿": "Hisobingiz faollashtirildi.",
        "uz": "Hisobingiz faollashtirildi."
    },
    "CODE_EXPIRED_NEW_CODE_SENT": {
        "Uzbek 🇺🇿": "Tasdiqlash kodi muddati tugadi. Yangi kod yuborildi.",
        "uz": "Tasdiqlash kodi muddati tugadi. Yangi kod yuborildi."
    }
}

# Ma'lumotlarni ma'lumotlar bazasiga qo'shish
try:
    with engine.connect() as connection:
        for code, translations in missing_uzbek_translations.items():
            for lang, message in translations.items():
                # Avval shu til va kod kombinatsiyasi mavjud yoki yo'qligini tekshiramiz
                result = connection.execute(
                    text("SELECT id FROM language WHERE lang = :lang AND code = :code"),
                    {"lang": lang, "code": code}
                ).fetchone()

                if result:
                    # Mavjud bo'lsa, yangilaymiz
                    connection.execute(
                        text("""
                            UPDATE language 
                            SET message = :message, 
                                updated_at = :updated_at, 
                                updated_by = :updated_by 
                            WHERE lang = :lang AND code = :code
                        """),
                        {
                            "lang": lang,
                            "code": code,
                            "message": message,
                            "updated_at": datetime.datetime.now(),
                            "updated_by": 1
                        }
                    )
                    print(f"Yangilandi: {lang} - {code}")
                else:
                    # Mavjud bo'lmasa, yangisini qo'shamiz
                    connection.execute(
                        text("""
                            INSERT INTO language (lang, code, message, is_deleted, created_at, created_by)
                            VALUES (:lang, :code, :message, :is_deleted, :created_at, :created_by)
                        """),
                        {
                            "lang": lang,
                            "code": code,
                            "message": message,
                            "is_deleted": False,
                            "created_at": datetime.datetime.now(),
                            "created_by": 1
                        }
                    )
                    print(f"Qo'shildi: {lang} - {code}")

        connection.commit()
    print("Barcha yetishmayotgan o'zbek tilidagi tarjimalar muvaffaqiyatli qo'shildi!")
except Exception as e:
    print(f"Xatolik yuz berdi: {e}")

# from sqlalchemy import create_engine, text
# import datetime
#
# # Ma'lumotlar bazasi ulanishi
# engine = create_engine(
#     url="postgresql+psycopg2://akbarov:akbarov@localhost:5433/logist_smart",
#     echo=True,
#     pool_size=180,
#     max_overflow=250
# )
#
# # Language data
# language_data = {
#     "LANGUAGE_MENU": {
#         "English 🇬🇧": "Please choose your language:",
#         "Russian 🇷🇺": "Пожалуйста, выберите ваш язык:",
#         "Uzbek 🇺🇿": "Iltimos, tilingizni tanlang:"
#     },
#     "CHOOSE_ONE_FROM_THIS_SECTION": {
#         "English 🇬🇧": "Choose one option from this section:",
#         "Russian 🇷🇺": "Выберите один вариант из этого раздела:",
#         "Uzbek 🇺🇿": "Ushbu bo'limdan bir variantni tanlang:"
#     },
#     "ENTER_YOUR_FIRST_NAME": {
#         "English 🇬🇧": "Enter your first name:",
#         "Russian 🇷🇺": "Введите ваше имя:",
#         "Uzbek 🇺🇿": "Ismingizni kiriting:"
#     },
#     "ENTER_YOUR_LAST_NAME": {
#         "English 🇬🇧": "Enter your last name:",
#         "Russian 🇷🇺": "Введите вашу фамилию:",
#         "Uzbek 🇺🇿": "Familiyangizni kiriting:"
#     },
#     "SEND_YOUR_CONTACT": {
#         "English 🇬🇧": "Send your contact number:",
#         "Russian 🇷🇺": "Отправьте ваш номер телефона:",
#         "Uzbek 🇺🇿": "Telefon raqamingizni yuboring:"
#     },
#     "ENTER_YOUR_PASSWORD": {
#         "English 🇬🇧": "Enter your password:",
#         "Russian 🇷🇺": "Введите ваш пароль:",
#         "Uzbek 🇺🇿": "Parolingizni kiriting:"
#     },
#     "SUCCESSFULLY_REGISTERED": {
#         "English 🇬🇧": "You have successfully registered!",
#         "Russian 🇷🇺": "Вы успешно зарегистрированы!",
#         "Uzbek 🇺🇿": "Siz muvaffaqiyatli ro'yxatdan o'tdingiz!"
#     },
#     "YOU_ARE_ALREADY_REGISTERED": {
#         "English 🇬🇧": "You are already registered!",
#         "Russian 🇷🇺": "Вы уже зарегистрированы!",
#         "Uzbek 🇺🇿": "Siz allaqachon ro'yxatdan o'tgansiz!"
#     },
#     "USER_NOT_FOUND": {
#         "English 🇬🇧": "User not found.",
#         "Russian 🇷🇺": "Пользователь не найден.",
#         "Uzbek 🇺🇿": "Foydalanuvchi topilmadi."
#     },
#     "YOU_IS_NOT_ACTIVE": {
#         "English 🇬🇧": "Your account is not active.",
#         "Russian 🇷🇺": "Ваш аккаунт не активирован.",
#         "Uzbek 🇺🇿": "Hisobingiz faol emas."
#     },
#     "HOME_MENU": {
#         "English 🇬🇧": "Welcome to the home menu!",
#         "Russian 🇷🇺": "Добро пожаловать в главное меню!",
#         "Uzbek 🇺🇿": "Bosh menyuga xush kelibsiz!"
#     },
#     "ENTER_YOUR_MESSAGE": {
#         "English 🇬🇧": "Enter your message:",
#         "Russian 🇷🇺": "Введите ваше сообщение:",
#         "Uzbek 🇺🇿": "Xabaringizni kiriting:"
#     },
#     "ENTER_YOUR_EDITED_MESSAGE": {
#         "English 🇬🇧": "Enter your edited message:",
#         "Russian 🇷🇺": "Введите отредактированное сообщение:",
#         "Uzbek 🇺🇿": "Tahrirlangan xabaringizni kiriting:"
#     },
#     "SUBSCRIBE": {
#         "English 🇬🇧": "Subscribe to the following groups:",
#         "Russian 🇷🇺": "Подпишитесь на следующие группы:",
#         "Uzbek 🇺🇿": "Quyidagi guruhlarga obuna bo'ling:"
#     },
#     "SELECT_FOLDER": {
#         "English 🇬🇧": "Select a folder:",
#         "Russian 🇷🇺": "Выберите папку:",
#         "Uzbek 🇺🇿": "Papkani tanlang:"
#     },
#     "WAIT_TEXT": {
#         "English 🇬🇧": "Please wait...",
#         "Russian 🇷🇺": "Пожалуйста, подождите...",
#         "Uzbek 🇺🇿": "Iltimos, kuting..."
#     },
#     "CORRECT_OR_INCORRECT": {
#         "English 🇬🇧": "Are these groups correct?",
#         "Russian 🇷🇺": "Эти группы верны?",
#         "Uzbek 🇺🇿": "Bu guruhlar to'g'rimi?"
#     },
#     "SELECT_THIS_GROUPS": {
#         "English 🇬🇧": "Select these groups:",
#         "Russian 🇷🇺": "Выберите эти группы:",
#         "Uzbek 🇺🇿": "Ushbu guruhlarni tanlang:"
#     },
#     "WRONG_MESSAGE": {
#         "English 🇬🇧": "Wrong input, try again.",
#         "Russian 🇷🇺": "Неверный ввод, попробуйте снова.",
#         "Uzbek 🇺🇿": "Noto'g'ri kiritish, qayta urinib ko'ring."
#     },
#     "SUCCESSFULLY_SELECTED_GROUPS": {
#         "English 🇬🇧": "Groups successfully selected!",
#         "Russian 🇷🇺": "Группы успешно выбраны!",
#         "Uzbek 🇺🇿": "Guruhlar muvaffaqiyatli tanlandi!"
#     },
#     "CHOOSE_TIMER": {
#         "English 🇬🇧": "Choose a timer:",
#         "Russian 🇷🇺": "Выберите таймер:",
#         "Uzbek 🇺🇿": "Taymerni tanlang:"
#     },
#     "SUCCESSFULLY_CREATED_YOUR_MESSAGE": {
#         "English 🇬🇧": "Your message was successfully created!",
#         "Russian 🇷🇺": "Ваше сообщение успешно создано!",
#         "Uzbek 🇺🇿": "Xabaringiz muvaffaqiyatli yaratildi!"
#     },
#     "PLEASE_SELECT_TIMER": {
#         "English 🇬🇧": "Please select a timer first.",
#         "Russian 🇷🇺": "Пожалуйста, сначала выберите таймер.",
#         "Uzbek 🇺🇿": "Iltimos, avval taymerni tanlang."
#     },
#     "PLEASE_SELECT_GROUPS": {
#         "English 🇬🇧": "Please select groups first.",
#         "Russian 🇷🇺": "Пожалуйста, сначала выберите группы.",
#         "Uzbek 🇺🇿": "Iltimos, avval guruhlarni tanlang."
#     },
#     "BACK_HOME_MENU": {
#         "English 🇬🇧": "Back to home menu.",
#         "Russian 🇷🇺": "Вернуться в главное меню.",
#         "Uzbek 🇺🇿": "Bosh menyuga qaytish."
#     },
#     "ENTER_CARGO_FROM": {
#         "English 🇬🇧": "Enter cargo origin:",
#         "Russian 🇷🇺": "Введите пункт отправления груза:",
#         "Uzbek 🇺🇿": "Yuk jo'natish joyini kiriting:"
#     },
#     "ENTER_CARGO_TO": {
#         "English 🇬🇧": "Enter cargo destination:",
#         "Russian 🇷🇺": "Введите пункт назначения груза:",
#         "Uzbek 🇺🇿": "Yuk yetkazib berish joyini kiriting:"
#     },
#     "CHOOSE_CARGO_TYPE": {
#         "English 🇬🇧": "Choose cargo type:",
#         "Russian 🇷🇺": "Выберите тип груза:",
#         "Uzbek 🇺🇿": "Yuk turini tanlang:"
#     },
#     "CHOOSE_ONE_OF_THE_CARGOS": {
#         "English 🇬🇧": "Choose one of the cargos:",
#         "Russian 🇷🇺": "Выберите один из грузов:",
#         "Uzbek 🇺🇿": "Yuklardan birini tanlang:"
#     },
#     "BACK": {
#         "English 🇬🇧": "Back",
#         "Russian 🇷🇺": "Назад",
#         "Uzbek 🇺🇿": "Orqaga"
#     },
#     "FIRST_NAME": {
#         "English 🇬🇧": "First Name",
#         "Russian 🇷🇺": "Имя",
#         "Uzbek 🇺🇿": "Ism"
#     },
#     "LAST_NAME": {
#         "English 🇬🇧": "Last Name",
#         "Russian 🇷🇺": "Фамилия",
#         "Uzbek 🇺🇿": "Familiya"
#     },
#     "PHONE_NUMBER": {
#         "English 🇬🇧": "Phone Number",
#         "Russian 🇷🇺": "Номер телефона",
#         "Uzbek 🇺🇿": "Telefon raqami"
#     },
#     "PUBLISH_DAY": {
#         "English 🇬🇧": "Publish Day",
#         "Russian 🇷🇺": "День публикации",
#         "Uzbek 🇺🇿": "Nashr kuni"
#     },
#     "DAY": {
#         "English 🇬🇧": "day",
#         "Russian 🇷🇺": "день",
#         "Uzbek 🇺🇿": "kun"
#     },
#     "GOODBYE": {
#         "English 🇬🇧": "Goodbye!",
#         "Russian 🇷🇺": "До свидания!",
#         "Uzbek 🇺🇿": "Xayr!"
#     },
#     "ENTER_MESSAGE_ID": {
#         "English 🇬🇧": "Enter message ID:",
#         "Russian 🇷🇺": "Введите ID сообщения:",
#         "Uzbek 🇺🇿": "Xabar ID sini kiriting:"
#     },
#     "ALREADY_ACTIVATED": {
#         "English 🇬🇧": "Your account is already activated!",
#         "Russian 🇷🇺": "Ваш аккаунт уже активирован!",
#         "Uzbek 🇺🇿": "Hisobingiz allaqachon faollashtirilgan!"
#     },
#     "YOU_HAVE_2FA": {
#         "English 🇬🇧": "Do you have 2FA enabled?",
#         "Russian 🇷🇺": "У вас включена двухфакторная аутентификация?",
#         "Uzbek 🇺🇿": "Sizda ikki faktorli autentifikatsiya yoqilganmi?"
#     },
#     "ENTER_YOUR_PASSWORD_TG": {
#         "English 🇬🇧": "Enter your Telegram password:",
#         "Russian 🇷🇺": "Введите ваш пароль Telegram:",
#         "Uzbek 🇺🇿": "Telegram parolingizni kiriting:"
#     },
#     "ASK_LOGIN": {
#         "English 🇬🇧": "Did you receive a login code?",
#         "Russian 🇷🇺": "Вы получили код для входа?",
#         "Uzbek 🇺🇿": "Kirish kodi keldimi?"
#     },
#     "ENTER_YOUR_CODE": {
#         "English 🇬🇧": "Enter your code:",
#         "Russian 🇷🇺": "Введите ваш код:",
#         "Uzbek 🇺🇿": "Kodingizni kiriting:"
#     },
#     "TOO_MANY_ATTEMPTS": {
#         "English 🇬🇧": "Too many attempts, please try again later.",
#         "Russian 🇷🇺": "Слишком много попыток, попробуйте позже.",
#         "Uzbek 🇺🇿": "Juda ko'p urinishlar, keyinroq qayta urinib ko'ring."
#     },
#     "CODE_EXPIRED": {
#         "English 🇬🇧": "The code has expired.",
#         "Russian 🇷🇺": "Срок действия кода истек.",
#         "Uzbek 🇺🇿": "Kod muddati tugadi."
#     },
#     "LOGIN_ERROR": {
#         "English 🇬🇧": "Login error, please try again.",
#         "Russian 🇷🇺": "Ошибка входа, попробуйте снова.",
#         "Uzbek 🇺🇿": "Kirishda xatolik, qayta urinib ko'ring."
#     }
# }
#
# # Jadvalga ma'lumotlarni qo‘shish
# with engine.connect() as connection:
#     for code, translations in language_data.items():
#         for lang, message in translations.items():
#             connection.execute(
#                 text("""
#                     INSERT INTO language (lang, code, message, is_deleted, created_at, created_by)
#                     VALUES (:lang, :code, :message, :is_deleted, :created_at, :created_by)
#                     ON CONFLICT DO NOTHING
#                 """),
#                 {
#                     "lang": lang,
#                     "code": code,
#                     "message": message,
#                     "is_deleted": False,
#                     "created_at": datetime.datetime.now(),
#                     "created_by": 1  # created_by 1 sifatida o‘zgartirildi
#                 }
#             )
#     connection.commit()
#
# print("All language entries added successfully!")

# add group to db
# from sqlalchemy import create_engine, text
# import datetime
# #
# engine = create_engine(
#     url="postgresql+psycopg2://akbarov:akbarov@localhost:5433/logist_smart",
#     echo=True,
#     pool_size=180,
#     max_overflow=250
# )
#
# groups_to_add = [
#     {
#         "name": "Логистика Казахстан и СНГ",
#         "folder": "Skylog-1",
#         "link": "https://t.me/Kazsng",
#         "is_active": True,
#         "is_deleted": False,
#         "created_at": datetime.datetime.now(),
#         "created_by": 1
#     },
#     {
#         "name": "Yuk Rossiya---Uzbekistan",
#         "folder": "Skylog-1",
#         "link": "https://t.me/logistikauzru",
#         "is_active": True,
#         "is_deleted": False,
#         "created_at": datetime.datetime.now(),
#         "created_by": 1
#     },
#     {
#         "name": "Group3",
#         "folder": "Skylog-1",
#         "link": "https://t.me/group3",
#         "is_active": True,
#         "is_deleted": False,
#         "created_at": datetime.datetime.now(),
#         "created_by": 1
#     }
# ]
#
# with engine.connect() as connection:
#     for group in groups_to_add:
#         connection.execute(
#             text("""
#                 INSERT INTO message_group (name, folder, link, is_active, is_deleted, created_at, created_by)
#                 VALUES (:name, :folder, :link, :is_active, :is_deleted, :created_at, :created_by)
#                 ON CONFLICT DO NOTHING
#             """),
#             group
#         )
#     connection.commit()
#
# print("Groups added successfully!")
#
#
# from sqlalchemy import create_engine, MetaData, Table, Column, Integer, Boolean, DateTime
# import datetime  # datetime modulini import qilamiz
#
# metadata = MetaData()
#
# message_group_user_table = Table(
#     'message_group_user', metadata,
#     Column('id', Integer, primary_key=True),
#     Column('user_id', Integer, nullable=False),
#     Column('message_id', Integer),
#     Column('message_group_id', Integer, nullable=False),
#     Column('is_deleted', Boolean, default=True),
#     Column('created_at', DateTime, default=datetime.datetime.now),  # DateTime.now o‘rniga datetime.datetime.now
#     Column('created_by', Integer, nullable=False),
#     Column('updated_at', DateTime),
#     Column('updated_by', Integer),
#     Column('checked', Boolean, default=False)
# )
#
# metadata.create_all(engine)
#
# print("message_group_user table created successfully!")