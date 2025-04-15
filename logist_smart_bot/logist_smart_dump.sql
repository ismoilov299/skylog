--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: language; Type: TABLE; Schema: public; Owner: akbarov
--

CREATE TABLE public.language (
    id integer NOT NULL,
    lang character varying(10) NOT NULL,
    code text NOT NULL,
    message text NOT NULL,
    is_deleted boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.language OWNER TO akbarov;

--
-- Name: language_id_seq; Type: SEQUENCE; Schema: public; Owner: akbarov
--

CREATE SEQUENCE public.language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.language_id_seq OWNER TO akbarov;

--
-- Name: language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akbarov
--

ALTER SEQUENCE public.language_id_seq OWNED BY public.language.id;


--
-- Name: message; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message text,
    timer integer,
    status boolean DEFAULT true,
    send_count_in_day integer DEFAULT 0,
    send_count_all integer DEFAULT 0,
    phone character varying(20),
    is_deleted boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    last_send_at timestamp without time zone,
    created_by integer,
    updated_at timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.message OWNER TO postgres;

--
-- Name: message_group; Type: TABLE; Schema: public; Owner: akbarov
--

CREATE TABLE public.message_group (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    folder character varying(50) NOT NULL,
    link text NOT NULL,
    is_active boolean DEFAULT true,
    is_deleted boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer
);


ALTER TABLE public.message_group OWNER TO akbarov;

--
-- Name: message_group_id_seq; Type: SEQUENCE; Schema: public; Owner: akbarov
--

CREATE SEQUENCE public.message_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.message_group_id_seq OWNER TO akbarov;

--
-- Name: message_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akbarov
--

ALTER SEQUENCE public.message_group_id_seq OWNED BY public.message_group.id;


--
-- Name: message_group_user; Type: TABLE; Schema: public; Owner: akbarov
--

CREATE TABLE public.message_group_user (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message_id integer,
    message_group_id integer NOT NULL,
    is_deleted boolean,
    created_at timestamp without time zone,
    created_by integer NOT NULL,
    updated_at timestamp without time zone,
    updated_by integer,
    checked boolean
);


ALTER TABLE public.message_group_user OWNER TO akbarov;

--
-- Name: message_group_user_id_seq; Type: SEQUENCE; Schema: public; Owner: akbarov
--

CREATE SEQUENCE public.message_group_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.message_group_user_id_seq OWNER TO akbarov;

--
-- Name: message_group_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: akbarov
--

ALTER SEQUENCE public.message_group_user_id_seq OWNED BY public.message_group_user.id;


--
-- Name: message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.message_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.message_id_seq OWNER TO postgres;

--
-- Name: message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.message_id_seq OWNED BY public.message.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    phone character varying(50) NOT NULL,
    password character varying(300) NOT NULL,
    chat_id bigint NOT NULL,
    lang character varying(10) NOT NULL,
    role character varying(300) NOT NULL,
    publish_day integer,
    is_active boolean,
    is_deleted boolean,
    created_at timestamp with time zone,
    created_by integer,
    updated_at timestamp with time zone,
    updated_by integer
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: language id; Type: DEFAULT; Schema: public; Owner: akbarov
--

ALTER TABLE ONLY public.language ALTER COLUMN id SET DEFAULT nextval('public.language_id_seq'::regclass);


--
-- Name: message id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message ALTER COLUMN id SET DEFAULT nextval('public.message_id_seq'::regclass);


--
-- Name: message_group id; Type: DEFAULT; Schema: public; Owner: akbarov
--

ALTER TABLE ONLY public.message_group ALTER COLUMN id SET DEFAULT nextval('public.message_group_id_seq'::regclass);


--
-- Name: message_group_user id; Type: DEFAULT; Schema: public; Owner: akbarov
--

ALTER TABLE ONLY public.message_group_user ALTER COLUMN id SET DEFAULT nextval('public.message_group_user_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: language; Type: TABLE DATA; Schema: public; Owner: akbarov
--

COPY public.language (id, lang, code, message, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
1	uz	LOGIN	Kirish	f	2025-03-17 21:28:06.393292	1	\N	\N
2	uz	REGISTER	Ro'yxatdan o'tish	f	2025-03-17 21:28:06.393292	1	\N	\N
3	en	LOGIN	Login	f	2025-03-17 21:28:06.393292	1	\N	\N
4	en	REGISTER	Register	f	2025-03-17 21:28:06.393292	1	\N	\N
5	ru	LOGIN	Вход	f	2025-03-17 21:28:06.393292	1	\N	\N
6	ru	REGISTER	Регистрация	f	2025-03-17 21:28:06.393292	1	\N	\N
7	Uzbek 🇺🇿	REGISTER	Ro'yxatdan o'tish	f	2025-03-17 21:32:36.913817	1	\N	\N
8	Uzbek 🇺🇿	LOGIN	Kirish	f	2025-03-17 21:32:36.913817	1	\N	\N
9	English 🇬🇧	REGISTER	Register	f	2025-03-17 21:32:36.913817	1	\N	\N
10	English 🇬🇧	LOGIN	Login	f	2025-03-17 21:32:36.913817	1	\N	\N
11	Russian 🇷🇺	REGISTER	Регистрация	f	2025-03-17 21:32:36.913817	1	\N	\N
12	Russian 🇷🇺	LOGIN	Вход	f	2025-03-17 21:32:36.913817	1	\N	\N
14	Uzbek 🇺🇿	CHOOSE_ONE_FROM_THIS_SECTION	Iltimos, quyidagi bo'limlardan birini tanlang:	f	2025-03-17 21:43:07.724319	1	\N	\N
15	English 🇬🇧	CHOOSE_ONE_FROM_THIS_SECTION	Please select one of the following sections:	f	2025-03-17 21:43:07.724319	1	\N	\N
16	Russian 🇷🇺	CHOOSE_ONE_FROM_THIS_SECTION	Пожалуйста, выберите один из следующих разделов:	f	2025-03-17 21:43:07.724319	1	\N	\N
17	Uzbek 🇺🇿	ENTER_YOUR_FIRST_NAME	Iltimos ismingizni kiriting:	f	2025-03-17 21:44:04.776551	1	\N	\N
18	English 🇬🇧	ENTER_YOUR_FIRST_NAME	Please enter your first name:	f	2025-03-17 21:44:04.776551	1	\N	\N
19	Russian 🇷🇺	ENTER_YOUR_FIRST_NAME	Пожалуйста, введите ваше имя:	f	2025-03-17 21:44:04.776551	1	\N	\N
20	Uzbek 🇺🇿	ENTER_YOUR_LAST_NAME	Iltimos familiyangizni kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
21	Uzbek 🇺🇿	SEND_YOUR_CONTACT	Iltimos kontakt ma'lumotingizni yuboring:	f	2025-03-17 21:47:17.118952	1	\N	\N
22	Uzbek 🇺🇿	ENTER_YOUR_PASSWORD	Iltimos parolni kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
23	Uzbek 🇺🇿	SUCCESSFULLY_REGISTERED	Siz muvaffaqiyatli ro'yxatdan o'tdingiz!	f	2025-03-17 21:47:17.118952	1	\N	\N
24	Uzbek 🇺🇿	YOU_ARE_ALREADY_REGISTERED	Siz allaqachon ro'yxatdan o'tgansiz!	f	2025-03-17 21:47:17.118952	1	\N	\N
25	Uzbek 🇺🇿	USER_NOT_FOUND	Foydalanuvchi topilmadi!	f	2025-03-17 21:47:17.118952	1	\N	\N
26	Uzbek 🇺🇿	YOU_IS_NOT_ACTIVE	Sizning hisobingiz faol emas. Faollashtirish uchun "Faollashtirish" tugmasini bosing.	f	2025-03-17 21:47:17.118952	1	\N	\N
28	Uzbek 🇺🇿	ENTER_YOUR_MESSAGE	Xabaringizni kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
29	Uzbek 🇺🇿	ENTER_YOUR_EDITED_MESSAGE	Tahrirlangan xabaringizni kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
30	Uzbek 🇺🇿	SUBSCRIBE	Obuna bo'ling	f	2025-03-17 21:47:17.118952	1	\N	\N
31	Uzbek 🇺🇿	WAIT_TEXT	Iltimos kuting...	f	2025-03-17 21:47:17.118952	1	\N	\N
32	Uzbek 🇺🇿	CORRECT_OR_INCORRECT	To'g'ri yoki noto'g'ri?	f	2025-03-17 21:47:17.118952	1	\N	\N
33	Uzbek 🇺🇿	SELECT_THIS_GROUPS	Ushbu guruhlarni tanlang	f	2025-03-17 21:47:17.118952	1	\N	\N
34	Uzbek 🇺🇿	WRONG_MESSAGE	Noto'g'ri xabar!	f	2025-03-17 21:47:17.118952	1	\N	\N
35	Uzbek 🇺🇿	SUCCESSFULLY_SELECTED_GROUPS	Guruhlar muvaffaqiyatli tanlandi!	f	2025-03-17 21:47:17.118952	1	\N	\N
36	Uzbek 🇺🇿	CHOOSE_TIMER	Timerini tanlang:	f	2025-03-17 21:47:17.118952	1	\N	\N
37	Uzbek 🇺🇿	SUCCESSFULLY_CREATED_YOUR_MESSAGE	Xabaringiz muvaffaqiyatli yaratildi!	f	2025-03-17 21:47:17.118952	1	\N	\N
38	Uzbek 🇺🇿	PLEASE_SELECT_TIMER	Iltimos timerini tanlang!	f	2025-03-17 21:47:17.118952	1	\N	\N
39	Uzbek 🇺🇿	PLEASE_SELECT_GROUPS	Iltimos guruhlarni tanlang!	f	2025-03-17 21:47:17.118952	1	\N	\N
40	Uzbek 🇺🇿	BACK_HOME_MENU	Bosh menyuga qaytish	f	2025-03-17 21:47:17.118952	1	\N	\N
41	Uzbek 🇺🇿	ENTER_CARGO_FROM	Yukni qayerdan yuborasiz?	f	2025-03-17 21:47:17.118952	1	\N	\N
42	Uzbek 🇺🇿	ENTER_CARGO_TO	Yukni qayerga yuborasiz?	f	2025-03-17 21:47:17.118952	1	\N	\N
43	Uzbek 🇺🇿	CHOOSE_CARGO_TYPE	Yuk turini tanlang:	f	2025-03-17 21:47:17.118952	1	\N	\N
44	Uzbek 🇺🇿	CHOOSE_ONE_OF_THE_CARGOS	Yukni tanlang:	f	2025-03-17 21:47:17.118952	1	\N	\N
45	Uzbek 🇺🇿	BACK	Orqaga	f	2025-03-17 21:47:17.118952	1	\N	\N
46	Uzbek 🇺🇿	ENTER_MESSAGE_ID	Xabar ID raqamini kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
47	Uzbek 🇺🇿	FIRST_NAME	Ism	f	2025-03-17 21:47:17.118952	1	\N	\N
48	Uzbek 🇺🇿	LAST_NAME	Familiya	f	2025-03-17 21:47:17.118952	1	\N	\N
49	Uzbek 🇺🇿	PHONE_NUMBER	Telefon raqami	f	2025-03-17 21:47:17.118952	1	\N	\N
50	Uzbek 🇺🇿	PUBLISH_DAY	Chop etish kuni	f	2025-03-17 21:47:17.118952	1	\N	\N
51	Uzbek 🇺🇿	DAY	kun	f	2025-03-17 21:47:17.118952	1	\N	\N
52	Uzbek 🇺🇿	GOODBYE	Xayr!	f	2025-03-17 21:47:17.118952	1	\N	\N
53	Uzbek 🇺🇿	YOU_HAVE_2FA	Sizda 2FA bormi?	f	2025-03-17 21:47:17.118952	1	\N	\N
54	Uzbek 🇺🇿	ENTER_YOUR_PASSWORD_TG	Telegram parolingizni kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
56	Uzbek 🇺🇿	ENTER_YOUR_CODE	Kodingizni kiriting:	f	2025-03-17 21:47:17.118952	1	\N	\N
57	Uzbek 🇺🇿	SELECT_FOLDER	Papkani tanlang:	f	2025-03-17 21:47:17.118952	1	\N	\N
58	English 🇬🇧	ENTER_YOUR_LAST_NAME	Please enter your last name:	f	2025-03-17 21:47:17.118952	1	\N	\N
59	English 🇬🇧	SEND_YOUR_CONTACT	Please send your contact:	f	2025-03-17 21:47:17.118952	1	\N	\N
60	English 🇬🇧	ENTER_YOUR_PASSWORD	Please enter your password:	f	2025-03-17 21:47:17.118952	1	\N	\N
61	English 🇬🇧	SUCCESSFULLY_REGISTERED	You have been successfully registered!	f	2025-03-17 21:47:17.118952	1	\N	\N
62	English 🇬🇧	YOU_ARE_ALREADY_REGISTERED	You are already registered!	f	2025-03-17 21:47:17.118952	1	\N	\N
63	English 🇬🇧	USER_NOT_FOUND	User not found!	f	2025-03-17 21:47:17.118952	1	\N	\N
64	English 🇬🇧	YOU_IS_NOT_ACTIVE	Your account is not active. Press "Activate" to activate it.	f	2025-03-17 21:47:17.118952	1	\N	\N
66	Russian 🇷🇺	ENTER_YOUR_LAST_NAME	Пожалуйста, введите вашу фамилию:	f	2025-03-17 21:47:17.118952	1	\N	\N
67	Russian 🇷🇺	SEND_YOUR_CONTACT	Пожалуйста, отправьте свой контакт:	f	2025-03-17 21:47:17.118952	1	\N	\N
68	Russian 🇷🇺	ENTER_YOUR_PASSWORD	Пожалуйста, введите ваш пароль:	f	2025-03-17 21:47:17.118952	1	\N	\N
69	Russian 🇷🇺	SUCCESSFULLY_REGISTERED	Вы успешно зарегистрировались!	f	2025-03-17 21:47:17.118952	1	\N	\N
65	English 🇬🇧	HOME_MENU	Welcome to Skylog Dispatching Bot 😊	f	2025-03-17 21:47:17.118952	1	\N	\N
70	Russian 🇷🇺	YOU_ARE_ALREADY_REGISTERED	Вы уже зарегистрированы!	f	2025-03-17 21:47:17.118952	1	\N	\N
71	Russian 🇷🇺	USER_NOT_FOUND	Пользователь не найден!	f	2025-03-17 21:47:17.118952	1	\N	\N
72	Russian 🇷🇺	YOU_IS_NOT_ACTIVE	Ваша учетная запись не активна. Нажмите "Активировать", чтобы активировать ее.	f	2025-03-17 21:47:17.118952	1	\N	\N
75	English 🇬🇧	YES	Yes	f	2025-03-17 21:49:35.055895	1	\N	\N
76	English 🇬🇧	NO	No	f	2025-03-17 21:49:35.055895	1	\N	\N
77	English 🇬🇧	ACTIVATE	Activate	f	2025-03-17 21:49:35.055895	1	\N	\N
78	English 🇬🇧	AUTO_MESSAGE	Auto Message	f	2025-03-17 21:49:35.055895	1	\N	\N
79	English 🇬🇧	PROFILE	Profile	f	2025-03-17 21:49:35.055895	1	\N	\N
80	English 🇬🇧	SEARCH_CARGO	Search Cargo	f	2025-03-17 21:49:35.055895	1	\N	\N
81	English 🇬🇧	HISTORY	History	f	2025-03-17 21:49:35.055895	1	\N	\N
82	English 🇬🇧	JOIN_GROUP	Join Group	f	2025-03-17 21:49:35.055895	1	\N	\N
83	English 🇬🇧	CHANGE_LANGUAGE	Change Language	f	2025-03-17 21:49:35.055895	1	\N	\N
84	English 🇬🇧	LOGOUT	Logout	f	2025-03-17 21:49:35.055895	1	\N	\N
85	English 🇬🇧	STOP	Stop	f	2025-03-17 21:49:35.055895	1	\N	\N
86	English 🇬🇧	DONE	Done	f	2025-03-17 21:49:35.055895	1	\N	\N
87	English 🇬🇧	BACK	Back	f	2025-03-17 21:49:35.055895	1	\N	\N
88	English 🇬🇧	MINUTE_30	30 minutes	f	2025-03-17 21:49:35.055895	1	\N	\N
89	English 🇬🇧	MINUTE_45	45 minutes	f	2025-03-17 21:49:35.055895	1	\N	\N
90	English 🇬🇧	MINUTE_60	60 minutes	f	2025-03-17 21:49:35.055895	1	\N	\N
91	English 🇬🇧	AWNING	Awning	f	2025-03-17 21:49:35.055895	1	\N	\N
92	English 🇬🇧	REF	Refrigerator	f	2025-03-17 21:49:35.055895	1	\N	\N
93	English 🇬🇧	ISOTHERM	Isotherm	f	2025-03-17 21:49:35.055895	1	\N	\N
94	English 🇬🇧	BACK_TO_HOME_MENU	Back to Home Menu	f	2025-03-17 21:49:35.055895	1	\N	\N
95	English 🇬🇧	EDIT_TEXT	Edit Text	f	2025-03-17 21:49:35.055895	1	\N	\N
96	English 🇬🇧	EDIT_GROUP	Edit Group	f	2025-03-17 21:49:35.055895	1	\N	\N
97	English 🇬🇧	EDIT_TIMER	Edit Timer	f	2025-03-17 21:49:35.055895	1	\N	\N
98	English 🇬🇧	START	Start	f	2025-03-17 21:49:35.055895	1	\N	\N
99	English 🇬🇧	NEXT	Next	f	2025-03-17 21:49:35.055895	1	\N	\N
100	English 🇬🇧	PREVIOUS	Previous	f	2025-03-17 21:49:35.055895	1	\N	\N
101	English 🇬🇧	SELECT_ALL	Select All	f	2025-03-17 21:49:35.055895	1	\N	\N
102	Russian 🇷🇺	YES	Да	f	2025-03-17 21:49:35.055895	1	\N	\N
103	Russian 🇷🇺	NO	Нет	f	2025-03-17 21:49:35.055895	1	\N	\N
104	Russian 🇷🇺	ACTIVATE	Активировать	f	2025-03-17 21:49:35.055895	1	\N	\N
105	Russian 🇷🇺	AUTO_MESSAGE	Авто сообщение	f	2025-03-17 21:49:35.055895	1	\N	\N
106	Russian 🇷🇺	PROFILE	Профиль	f	2025-03-17 21:49:35.055895	1	\N	\N
108	Russian 🇷🇺	HISTORY	История	f	2025-03-17 21:49:35.055895	1	\N	\N
109	Russian 🇷🇺	JOIN_GROUP	Присоединиться к группе	f	2025-03-17 21:49:35.055895	1	\N	\N
110	Russian 🇷🇺	CHANGE_LANGUAGE	Изменить язык	f	2025-03-17 21:49:35.055895	1	\N	\N
111	Russian 🇷🇺	LOGOUT	Выйти	f	2025-03-17 21:49:35.055895	1	\N	\N
112	Russian 🇷🇺	STOP	Остановить	f	2025-03-17 21:49:35.055895	1	\N	\N
113	Russian 🇷🇺	DONE	Готово	f	2025-03-17 21:49:35.055895	1	\N	\N
114	Russian 🇷🇺	BACK	Назад	f	2025-03-17 21:49:35.055895	1	\N	\N
115	Russian 🇷🇺	MINUTE_30	30 минут	f	2025-03-17 21:49:35.055895	1	\N	\N
116	Russian 🇷🇺	MINUTE_45	45 минут	f	2025-03-17 21:49:35.055895	1	\N	\N
117	Russian 🇷🇺	MINUTE_60	60 минут	f	2025-03-17 21:49:35.055895	1	\N	\N
121	Russian 🇷🇺	BACK_TO_HOME_MENU	Вернуться в главное меню	f	2025-03-17 21:49:35.055895	1	\N	\N
122	Russian 🇷🇺	EDIT_TEXT	Редактировать текст	f	2025-03-17 21:49:35.055895	1	\N	\N
123	Russian 🇷🇺	EDIT_GROUP	Редактировать группу	f	2025-03-17 21:49:35.055895	1	\N	\N
124	Russian 🇷🇺	EDIT_TIMER	Редактировать таймер	f	2025-03-17 21:49:35.055895	1	\N	\N
125	Russian 🇷🇺	START	Начать	f	2025-03-17 21:49:35.055895	1	\N	\N
126	Russian 🇷🇺	NEXT	Далее	f	2025-03-17 21:49:35.055895	1	\N	\N
127	Russian 🇷🇺	PREVIOUS	Предыдущий	f	2025-03-17 21:49:35.055895	1	\N	\N
128	Russian 🇷🇺	SELECT_ALL	Выбрать все	f	2025-03-17 21:49:35.055895	1	\N	\N
129	Uzbek 🇺🇿	ENTER_YOUR_EDITED_MESSAGE	Tahrirlangan xabaringizni kiriting:	f	2025-03-17 21:49:35.055895	1	\N	\N
130	English 🇬🇧	ENTER_YOUR_EDITED_MESSAGE	Enter your edited message:	f	2025-03-17 21:49:35.055895	1	\N	\N
131	Russian 🇷🇺	ENTER_YOUR_EDITED_MESSAGE	Введите отредактированное сообщение:	f	2025-03-17 21:49:35.055895	1	\N	\N
132	Uzbek 🇺🇿	ENTER_YOUR_MESSAGE	Xabaringizni kiriting:	f	2025-03-17 21:49:35.055895	1	\N	\N
133	English 🇬🇧	ENTER_YOUR_MESSAGE	Enter your message:	f	2025-03-17 21:49:35.055895	1	\N	\N
134	Russian 🇷🇺	ENTER_YOUR_MESSAGE	Введите ваше сообщение:	f	2025-03-17 21:49:35.055895	1	\N	\N
135	Uzbek 🇺🇿	CHOOSE_ONE_OF_THE_CARGOS	Yuklar ro'yxatidan tanlang:	f	2025-03-17 21:49:35.055895	1	\N	\N
136	English 🇬🇧	CHOOSE_ONE_OF_THE_CARGOS	Choose one of the cargos:	f	2025-03-17 21:49:35.055895	1	\N	\N
137	Russian 🇷🇺	CHOOSE_ONE_OF_THE_CARGOS	Выберите один из грузов:	f	2025-03-17 21:49:35.055895	1	\N	\N
138	Uzbek 🇺🇿	ENTER_MESSAGE_ID	Xabar ID raqamini kiriting:	f	2025-03-17 21:49:35.055895	1	\N	\N
139	English 🇬🇧	ENTER_MESSAGE_ID	Enter message ID:	f	2025-03-17 21:49:35.055895	1	\N	\N
140	Russian 🇷🇺	ENTER_MESSAGE_ID	Введите ID сообщения:	f	2025-03-17 21:49:35.055895	1	\N	\N
141	Russian 🇷🇺	SEND_CONTACT	Отправить контакт	f	2025-03-17 21:51:03.08957	1	\N	\N
142	Russian 🇷🇺	YOU_HAVE_2FA	У вас есть двухфакторная аутентификация?	f	2025-03-17 23:33:36.885344	1	\N	\N
73	Russian 🇷🇺	HOME_MENU	Добро пожаловать в Skylog Dispatching Bot 😊	f	2025-03-17 21:47:17.118952	1	\N	\N
119	Russian 🇷🇺	REF	Реф	f	2025-03-17 21:49:35.055895	1	\N	\N
107	Russian 🇷🇺	SEARCH_CARGO	Поиск груза 🔎	f	2025-03-17 21:49:35.055895	1	\N	\N
143	Uzbek 🇺🇿	YOU_HAVE_2FA	Sizda ikki faktorli autentifikatsiya bormi?	f	2025-03-17 23:33:36.885344	1	\N	\N
144	English 🇬🇧	YOU_HAVE_2FA	Do you have two-factor authentication?	f	2025-03-17 23:33:36.885344	1	\N	\N
145	Russian 🇷🇺	ENTER_YOUR_PASSWORD_TG	Введите пароль от вашего Telegram аккаунта:	f	2025-03-17 23:52:24.631193	1	\N	\N
146	Uzbek 🇺🇿	ENTER_YOUR_PASSWORD_TG	Telegram hisobingiz parolini kiriting:	f	2025-03-17 23:52:24.631193	1	\N	\N
147	English 🇬🇧	ENTER_YOUR_PASSWORD_TG	Enter your Telegram account password:	f	2025-03-17 23:52:24.631193	1	\N	\N
154	Russian 🇷🇺	CODE_EXPIRED_NEW_CODE_SENT	Код подтверждения истек. Новый код был отправлен.	f	2025-03-22 12:39:13.459072	1	\N	\N
156	English 🇬🇧	CODE_EXPIRED_NEW_CODE_SENT	Confirmation code has expired. A new code has been sent.	f	2025-03-22 12:39:13.459072	1	\N	\N
157	Russian 🇷🇺	TOO_MANY_ATTEMPTS	Слишком много попыток. Пожалуйста, попробуйте позже.	f	2025-03-22 12:51:19.008672	1	\N	\N
158	Uzbek 🇺🇿	TOO_MANY_ATTEMPTS	Juda ko'p urinishlar. Iltimos, keyinroq qayta urinib ko'ring.	f	2025-03-22 12:51:19.008672	1	\N	\N
159	English 🇬🇧	TOO_MANY_ATTEMPTS	Too many attempts. Please try again later.	f	2025-03-22 12:51:19.008672	1	\N	\N
160	Russian 🇷🇺	LOGIN_ERROR	Произошла ошибка при входе. Пожалуйста, попробуйте позже.	f	2025-03-22 12:51:19.008672	1	\N	\N
161	Uzbek 🇺🇿	LOGIN_ERROR	Kirish vaqtida xatolik yuz berdi. Iltimos, keyinroq qayta urinib ko'ring.	f	2025-03-22 12:51:19.008672	1	\N	\N
162	English 🇬🇧	LOGIN_ERROR	An error occurred during login. Please try again later.	f	2025-03-22 12:51:19.008672	1	\N	\N
163	Russian 🇷🇺	ACCOUNT_ACTIVATED	Ваш аккаунт активирован.	f	2025-03-22 12:54:20.763433	1	\N	\N
165	English 🇬🇧	ACCOUNT_ACTIVATED	Your account has been activated.	f	2025-03-22 12:54:20.763433	1	\N	\N
166	Russian 🇷🇺	CODE_EXPIRED	Код подтверждения истек. Пожалуйста, попробуйте авторизоваться заново.	f	2025-03-22 13:00:46.605413	1	\N	\N
167	Uzbek 🇺🇿	CODE_EXPIRED	Tasdiqlash kodi muddati tugadi. Iltimos, qaytadan kirshga urinib ko'ring.	f	2025-03-22 13:00:46.605413	1	\N	\N
168	English 🇬🇧	CODE_EXPIRED	Confirmation code has expired. Please try to login again.	f	2025-03-22 13:00:46.605413	1	\N	\N
169	Russian 🇷🇺	CODE_EXPIRED	Код подтверждения истек. Пожалуйста, попробуйте авторизоваться заново.	f	2025-03-22 13:09:03.798423	1	\N	\N
170	Uzbek 🇺🇿	CODE_EXPIRED	Tasdiqlash kodi muddati tugadi. Iltimos, qaytadan kirshga urinib ko'ring.	f	2025-03-22 13:09:03.798423	1	\N	\N
171	English 🇬🇧	CODE_EXPIRED	Confirmation code has expired. Please try to login again.	f	2025-03-22 13:09:03.798423	1	\N	\N
172	Russian 🇷🇺	SUBSCRIBE	ПОДПИСАТЬСЯ	f	2025-04-04 19:02:43.070559	1	\N	\N
173	Russian 🇷🇺	SUBSCRIBE	ПОДПИСАТЬСЯ	f	2025-04-04 19:07:40.853594	1	\N	\N
174	Russian 🇷🇺	SELECT_FOLDER	ВЫБЕРИТЕ ПАПКУ	f	2025-04-04 19:07:52.03666	1	\N	\N
175	English 🇬🇧	SUBSCRIBE	SUBSCRIBE	f	2025-04-04 22:21:37.676887	1	\N	\N
176	Russian 🇷🇺	SUBSCRIBE	ПОДПИСАТЬСЯ	f	2025-04-04 22:21:37.748743	1	\N	\N
177	Uzbek 🇺🇿	SUBSCRIBE	OBUNA BOʻLING	f	2025-04-04 22:21:37.750062	1	\N	\N
178	English 🇬🇧	SELECT_FOLDER	SELECT FOLDER	f	2025-04-04 22:21:37.750455	1	\N	\N
179	Russian 🇷🇺	SELECT_FOLDER	ВЫБЕРИТЕ ПАПКУ	f	2025-04-04 22:21:37.751118	1	\N	\N
180	Uzbek 🇺🇿	SELECT_FOLDER	PAPKANI TANLANG	f	2025-04-04 22:21:37.751534	1	\N	\N
181	English 🇬🇧	LANGUAGE_MENU	SELECT LANGUAGE	f	2025-04-04 22:21:37.751899	1	\N	\N
182	Russian 🇷🇺	LANGUAGE_MENU	ВЫБЕРИТЕ ЯЗЫК	f	2025-04-04 22:21:37.752263	1	\N	\N
183	Uzbek 🇺🇿	LANGUAGE_MENU	TILNI TANLANG	f	2025-04-04 22:21:37.752616	1	\N	\N
184	English 🇬🇧	CHOOSE_ONE_FROM_THIS_SECTION	CHOOSE ONE FROM THIS SECTION	f	2025-04-04 22:21:37.75335	1	\N	\N
185	Russian 🇷🇺	CHOOSE_ONE_FROM_THIS_SECTION	ВЫБЕРИТЕ ОДИН ИЗ ЭТОГО РАЗДЕЛА	f	2025-04-04 22:21:37.75372	1	\N	\N
186	English 🇬🇧	WAIT_TEXT	PLEASE WAIT...	f	2025-04-04 22:24:17.211346	1	\N	\N
187	Russian 🇷🇺	WAIT_TEXT	ПОДОЖДИТЕ...	f	2025-04-04 22:24:17.217611	1	\N	\N
188	Uzbek 🇺🇿	WAIT_TEXT	ILTIMOS KUTING...	f	2025-04-04 22:24:17.218156	1	\N	\N
189	English 🇬🇧	CORRECT_OR_INCORRECT	CORRECT OR INCORRECT	f	2025-04-04 22:28:04.903386	1	\N	\N
190	Russian 🇷🇺	CORRECT_OR_INCORRECT	ПРАВИЛЬНО ИЛИ НЕПРАВИЛЬНО	f	2025-04-04 22:28:04.909998	1	\N	\N
191	English 🇬🇧	SELECT_ALL	SELECT ALL	f	2025-04-04 22:32:32.233711	1	\N	\N
192	Russian 🇷🇺	SELECT_ALL	ВЫБРАТЬ ВСЕ	f	2025-04-04 22:32:32.239811	1	\N	\N
193	Uzbek 🇺🇿	SELECT_ALL	BARCHASINI TANLASH	f	2025-04-04 22:32:32.240649	1	\N	\N
194	English 🇬🇧	SUBSCRIBE	SUBSCRIBE	f	2025-04-04 22:45:00.799725	1	\N	\N
195	Russian 🇷🇺	SUBSCRIBE	ПОДПИСАТЬСЯ	f	2025-04-04 22:45:00.80639	1	\N	\N
196	Uzbek 🇺🇿	SUBSCRIBE	OBUNA BOʻLING	f	2025-04-04 22:45:00.806891	1	\N	\N
197	English 🇬🇧	SELECT_FOLDER	SELECT FOLDER	f	2025-04-04 22:45:00.807643	1	\N	\N
198	Russian 🇷🇺	SELECT_FOLDER	ВЫБЕРИТЕ ПАПКУ	f	2025-04-04 22:45:00.808063	1	\N	\N
199	Uzbek 🇺🇿	SELECT_FOLDER	PAPKANI TANLANG	f	2025-04-04 22:45:00.808484	1	\N	\N
200	English 🇬🇧	WAIT_TEXT	PLEASE WAIT...	f	2025-04-04 22:45:00.808897	1	\N	\N
201	Russian 🇷🇺	WAIT_TEXT	ПОДОЖДИТЕ...	f	2025-04-04 22:45:00.809286	1	\N	\N
202	Uzbek 🇺🇿	WAIT_TEXT	ILTIMOS KUTING...	f	2025-04-04 22:45:00.80961	1	\N	\N
203	English 🇬🇧	CORRECT_OR_INCORRECT	CORRECT OR INCORRECT	f	2025-04-04 22:45:00.809913	1	\N	\N
204	Russian 🇷🇺	CORRECT_OR_INCORRECT	ПРАВИЛЬНО ИЛИ НЕПРАВИЛЬНО	f	2025-04-04 22:45:00.810213	1	\N	\N
151	Russian 🇷🇺	ENTER_YOUR_CODE	Введите код подтверждения:\nПример: 1 2 3 4\nПримечание: Вводите цифры через пробел	f	2025-03-22 12:28:35.357844	1	\N	\N
152	Uzbek 🇺🇿	ENTER_YOUR_CODE	Tasdiqlash kodini kiriting:\nNamuna: 1 2 3 4\nEslatma: Raqamlarni orasida bo'sh joy qoldirib yozing	f	2025-03-22 12:28:35.357844	1	\N	\N
205	English 🇬🇧	NEXT	NEXT	f	2025-04-04 22:50:25.359521	1	\N	\N
206	Russian 🇷🇺	NEXT	ДАЛЕЕ	f	2025-04-04 22:50:25.375017	1	\N	\N
207	Uzbek 🇺🇿	NEXT	KEYINGI	f	2025-04-04 22:50:25.375533	1	\N	\N
208	English 🇬🇧	PREVIOUS	PREVIOUS	f	2025-04-04 22:50:25.375785	1	\N	\N
209	Russian 🇷🇺	PREVIOUS	ПРЕДЫДУЩИЙ	f	2025-04-04 22:50:25.376052	1	\N	\N
210	Uzbek 🇺🇿	PREVIOUS	OLDINGI	f	2025-04-04 22:50:25.376365	1	\N	\N
211	English 🇬🇧	SELECT_THIS_GROUPS	SELECT THESE GROUPS	f	2025-04-04 22:50:25.376677	1	\N	\N
212	Russian 🇷🇺	SELECT_THIS_GROUPS	ВЫБЕРИТЕ ЭТИ ГРУППЫ	f	2025-04-04 22:50:25.377022	1	\N	\N
213	Uzbek 🇺🇿	SELECT_THIS_GROUPS	BU GURUHLARNI TANLANG	f	2025-04-04 22:50:25.377361	1	\N	\N
214	English 🇬🇧	DONE	DONE	f	2025-04-04 22:54:34.919278	1	\N	\N
215	Russian 🇷🇺	DONE	ГОТОВО	f	2025-04-04 22:54:34.930226	1	\N	\N
217	English 🇬🇧	NEXT	NEXT	f	2025-04-04 22:54:34.932062	1	\N	\N
218	Russian 🇷🇺	NEXT	ДАЛЕЕ	f	2025-04-04 22:54:34.932986	1	\N	\N
219	Uzbek 🇺🇿	NEXT	KEYINGI	f	2025-04-04 22:54:34.933542	1	\N	\N
220	English 🇬🇧	SELECT_ALL	SELECT ALL	f	2025-04-04 22:54:34.93427	1	\N	\N
221	Russian 🇷🇺	SELECT_ALL	ВЫБРАТЬ ВСЕ	f	2025-04-04 22:54:34.935225	1	\N	\N
222	Uzbek 🇺🇿	SELECT_ALL	BARCHASINI TANLASH	f	2025-04-04 22:54:34.9357	1	\N	\N
223	English 🇬🇧	LANGUAGE_MENU	Please choose your language:	f	2025-04-05 01:10:48.300446	1	\N	\N
224	Russian 🇷🇺	LANGUAGE_MENU	Пожалуйста, выберите ваш язык:	f	2025-04-05 01:10:48.308546	1	\N	\N
225	Uzbek 🇺🇿	LANGUAGE_MENU	Iltimos, tilingizni tanlang:	f	2025-04-05 01:10:48.309046	1	\N	\N
226	English 🇬🇧	CHOOSE_ONE_FROM_THIS_SECTION	Choose one option from this section:	f	2025-04-05 01:10:48.309378	1	\N	\N
227	Russian 🇷🇺	CHOOSE_ONE_FROM_THIS_SECTION	Выберите один вариант из этого раздела:	f	2025-04-05 01:10:48.309651	1	\N	\N
228	Uzbek 🇺🇿	CHOOSE_ONE_FROM_THIS_SECTION	Ushbu bo'limdan bir variantni tanlang:	f	2025-04-05 01:10:48.309923	1	\N	\N
229	English 🇬🇧	ENTER_YOUR_FIRST_NAME	Enter your first name:	f	2025-04-05 01:10:48.310206	1	\N	\N
230	Russian 🇷🇺	ENTER_YOUR_FIRST_NAME	Введите ваше имя:	f	2025-04-05 01:10:48.310519	1	\N	\N
231	Uzbek 🇺🇿	ENTER_YOUR_FIRST_NAME	Ismingizni kiriting:	f	2025-04-05 01:10:48.310785	1	\N	\N
232	English 🇬🇧	ENTER_YOUR_LAST_NAME	Enter your last name:	f	2025-04-05 01:10:48.311047	1	\N	\N
233	Russian 🇷🇺	ENTER_YOUR_LAST_NAME	Введите вашу фамилию:	f	2025-04-05 01:10:48.311329	1	\N	\N
234	Uzbek 🇺🇿	ENTER_YOUR_LAST_NAME	Familiyangizni kiriting:	f	2025-04-05 01:10:48.311583	1	\N	\N
235	English 🇬🇧	SEND_YOUR_CONTACT	Send your contact number:	f	2025-04-05 01:10:48.311869	1	\N	\N
236	Russian 🇷🇺	SEND_YOUR_CONTACT	Отправьте ваш номер телефона:	f	2025-04-05 01:10:48.312142	1	\N	\N
237	Uzbek 🇺🇿	SEND_YOUR_CONTACT	Telefon raqamingizni yuboring:	f	2025-04-05 01:10:48.312396	1	\N	\N
238	English 🇬🇧	ENTER_YOUR_PASSWORD	Enter your password:	f	2025-04-05 01:10:48.312652	1	\N	\N
239	Russian 🇷🇺	ENTER_YOUR_PASSWORD	Введите ваш пароль:	f	2025-04-05 01:10:48.312907	1	\N	\N
240	Uzbek 🇺🇿	ENTER_YOUR_PASSWORD	Parolingizni kiriting:	f	2025-04-05 01:10:48.313187	1	\N	\N
241	English 🇬🇧	SUCCESSFULLY_REGISTERED	You have successfully registered!	f	2025-04-05 01:10:48.313437	1	\N	\N
242	Russian 🇷🇺	SUCCESSFULLY_REGISTERED	Вы успешно зарегистрированы!	f	2025-04-05 01:10:48.313689	1	\N	\N
243	Uzbek 🇺🇿	SUCCESSFULLY_REGISTERED	Siz muvaffaqiyatli ro'yxatdan o'tdingiz!	f	2025-04-05 01:10:48.31394	1	\N	\N
244	English 🇬🇧	YOU_ARE_ALREADY_REGISTERED	You are already registered!	f	2025-04-05 01:10:48.314206	1	\N	\N
245	Russian 🇷🇺	YOU_ARE_ALREADY_REGISTERED	Вы уже зарегистрированы!	f	2025-04-05 01:10:48.314486	1	\N	\N
246	Uzbek 🇺🇿	YOU_ARE_ALREADY_REGISTERED	Siz allaqachon ro'yxatdan o'tgansiz!	f	2025-04-05 01:10:48.314779	1	\N	\N
247	English 🇬🇧	USER_NOT_FOUND	User not found.	f	2025-04-05 01:10:48.315115	1	\N	\N
248	Russian 🇷🇺	USER_NOT_FOUND	Пользователь не найден.	f	2025-04-05 01:10:48.315384	1	\N	\N
249	Uzbek 🇺🇿	USER_NOT_FOUND	Foydalanuvchi topilmadi.	f	2025-04-05 01:10:48.31564	1	\N	\N
250	English 🇬🇧	YOU_IS_NOT_ACTIVE	Your account is not active.	f	2025-04-05 01:10:48.315927	1	\N	\N
251	Russian 🇷🇺	YOU_IS_NOT_ACTIVE	Ваш аккаунт не активирован.	f	2025-04-05 01:10:48.316187	1	\N	\N
252	Uzbek 🇺🇿	YOU_IS_NOT_ACTIVE	Hisobingiz faol emas.	f	2025-04-05 01:10:48.316469	1	\N	\N
253	English 🇬🇧	HOME_MENU	Welcome to the home menu!	f	2025-04-05 01:10:48.316767	1	\N	\N
254	Russian 🇷🇺	HOME_MENU	Добро пожаловать в главное меню!	f	2025-04-05 01:10:48.317134	1	\N	\N
255	Uzbek 🇺🇿	HOME_MENU	Bosh menyuga xush kelibsiz!	f	2025-04-05 01:10:48.31892	1	\N	\N
256	English 🇬🇧	ENTER_YOUR_MESSAGE	Enter your message:	f	2025-04-05 01:10:48.320429	1	\N	\N
257	Russian 🇷🇺	ENTER_YOUR_MESSAGE	Введите ваше сообщение:	f	2025-04-05 01:10:48.320714	1	\N	\N
258	Uzbek 🇺🇿	ENTER_YOUR_MESSAGE	Xabaringizni kiriting:	f	2025-04-05 01:10:48.320969	1	\N	\N
259	English 🇬🇧	ENTER_YOUR_EDITED_MESSAGE	Enter your edited message:	f	2025-04-05 01:10:48.321663	1	\N	\N
260	Russian 🇷🇺	ENTER_YOUR_EDITED_MESSAGE	Введите отредактированное сообщение:	f	2025-04-05 01:10:48.321934	1	\N	\N
261	Uzbek 🇺🇿	ENTER_YOUR_EDITED_MESSAGE	Tahrirlangan xabaringizni kiriting:	f	2025-04-05 01:10:48.322182	1	\N	\N
262	English 🇬🇧	SUBSCRIBE	Subscribe to the following groups:	f	2025-04-05 01:10:48.322476	1	\N	\N
263	Russian 🇷🇺	SUBSCRIBE	Подпишитесь на следующие группы:	f	2025-04-05 01:10:48.322757	1	\N	\N
264	Uzbek 🇺🇿	SUBSCRIBE	Quyidagi guruhlarga obuna bo'ling:	f	2025-04-05 01:10:48.323018	1	\N	\N
265	English 🇬🇧	SELECT_FOLDER	Select a folder:	f	2025-04-05 01:10:48.323266	1	\N	\N
266	Russian 🇷🇺	SELECT_FOLDER	Выберите папку:	f	2025-04-05 01:10:48.323545	1	\N	\N
267	Uzbek 🇺🇿	SELECT_FOLDER	Papkani tanlang:	f	2025-04-05 01:10:48.323802	1	\N	\N
268	English 🇬🇧	WAIT_TEXT	Please wait...	f	2025-04-05 01:10:48.324156	1	\N	\N
269	Russian 🇷🇺	WAIT_TEXT	Пожалуйста, подождите...	f	2025-04-05 01:10:48.325207	1	\N	\N
270	Uzbek 🇺🇿	WAIT_TEXT	Iltimos, kuting...	f	2025-04-05 01:10:48.325525	1	\N	\N
271	English 🇬🇧	CORRECT_OR_INCORRECT	Are these groups correct?	f	2025-04-05 01:10:48.325751	1	\N	\N
272	Russian 🇷🇺	CORRECT_OR_INCORRECT	Эти группы верны?	f	2025-04-05 01:10:48.325958	1	\N	\N
273	Uzbek 🇺🇿	CORRECT_OR_INCORRECT	Bu guruhlar to'g'rimi?	f	2025-04-05 01:10:48.327066	1	\N	\N
274	English 🇬🇧	SELECT_THIS_GROUPS	Select these groups:	f	2025-04-05 01:10:48.327301	1	\N	\N
275	Russian 🇷🇺	SELECT_THIS_GROUPS	Выберите эти группы:	f	2025-04-05 01:10:48.327519	1	\N	\N
276	Uzbek 🇺🇿	SELECT_THIS_GROUPS	Ushbu guruhlarni tanlang:	f	2025-04-05 01:10:48.327725	1	\N	\N
277	English 🇬🇧	WRONG_MESSAGE	Wrong input, try again.	f	2025-04-05 01:10:48.327929	1	\N	\N
278	Russian 🇷🇺	WRONG_MESSAGE	Неверный ввод, попробуйте снова.	f	2025-04-05 01:10:48.328132	1	\N	\N
279	Uzbek 🇺🇿	WRONG_MESSAGE	Noto'g'ri kiritish, qayta urinib ko'ring.	f	2025-04-05 01:10:48.328335	1	\N	\N
280	English 🇬🇧	SUCCESSFULLY_SELECTED_GROUPS	Groups successfully selected!	f	2025-04-05 01:10:48.328539	1	\N	\N
281	Russian 🇷🇺	SUCCESSFULLY_SELECTED_GROUPS	Группы успешно выбраны!	f	2025-04-05 01:10:48.328741	1	\N	\N
282	Uzbek 🇺🇿	SUCCESSFULLY_SELECTED_GROUPS	Guruhlar muvaffaqiyatli tanlandi!	f	2025-04-05 01:10:48.328944	1	\N	\N
283	English 🇬🇧	CHOOSE_TIMER	Choose a timer:	f	2025-04-05 01:10:48.329145	1	\N	\N
284	Russian 🇷🇺	CHOOSE_TIMER	Выберите таймер:	f	2025-04-05 01:10:48.329344	1	\N	\N
285	Uzbek 🇺🇿	CHOOSE_TIMER	Taymerni tanlang:	f	2025-04-05 01:10:48.329562	1	\N	\N
286	English 🇬🇧	SUCCESSFULLY_CREATED_YOUR_MESSAGE	Your message was successfully created!	f	2025-04-05 01:10:48.329763	1	\N	\N
287	Russian 🇷🇺	SUCCESSFULLY_CREATED_YOUR_MESSAGE	Ваше сообщение успешно создано!	f	2025-04-05 01:10:48.329964	1	\N	\N
288	Uzbek 🇺🇿	SUCCESSFULLY_CREATED_YOUR_MESSAGE	Xabaringiz muvaffaqiyatli yaratildi!	f	2025-04-05 01:10:48.330182	1	\N	\N
289	English 🇬🇧	PLEASE_SELECT_TIMER	Please select a timer first.	f	2025-04-05 01:10:48.330405	1	\N	\N
290	Russian 🇷🇺	PLEASE_SELECT_TIMER	Пожалуйста, сначала выберите таймер.	f	2025-04-05 01:10:48.330615	1	\N	\N
291	Uzbek 🇺🇿	PLEASE_SELECT_TIMER	Iltimos, avval taymerni tanlang.	f	2025-04-05 01:10:48.330823	1	\N	\N
292	English 🇬🇧	PLEASE_SELECT_GROUPS	Please select groups first.	f	2025-04-05 01:10:48.33103	1	\N	\N
293	Russian 🇷🇺	PLEASE_SELECT_GROUPS	Пожалуйста, сначала выберите группы.	f	2025-04-05 01:10:48.331236	1	\N	\N
294	Uzbek 🇺🇿	PLEASE_SELECT_GROUPS	Iltimos, avval guruhlarni tanlang.	f	2025-04-05 01:10:48.331457	1	\N	\N
295	English 🇬🇧	BACK_HOME_MENU	Back to home menu.	f	2025-04-05 01:10:48.331666	1	\N	\N
296	Russian 🇷🇺	BACK_HOME_MENU	Вернуться в главное меню.	f	2025-04-05 01:10:48.331869	1	\N	\N
297	Uzbek 🇺🇿	BACK_HOME_MENU	Bosh menyuga qaytish.	f	2025-04-05 01:10:48.33209	1	\N	\N
313	English 🇬🇧	FIRST_NAME	First Name	f	2025-04-05 01:10:48.335204	1	\N	\N
314	Russian 🇷🇺	FIRST_NAME	Имя	f	2025-04-05 01:10:48.335412	1	\N	\N
315	Uzbek 🇺🇿	FIRST_NAME	Ism	f	2025-04-05 01:10:48.335601	1	\N	\N
316	English 🇬🇧	LAST_NAME	Last Name	f	2025-04-05 01:10:48.335778	1	\N	\N
317	Russian 🇷🇺	LAST_NAME	Фамилия	f	2025-04-05 01:10:48.335953	1	\N	\N
318	Uzbek 🇺🇿	LAST_NAME	Familiya	f	2025-04-05 01:10:48.336128	1	\N	\N
319	English 🇬🇧	PHONE_NUMBER	Phone Number	f	2025-04-05 01:10:48.3363	1	\N	\N
320	Russian 🇷🇺	PHONE_NUMBER	Номер телефона	f	2025-04-05 01:10:48.3365	1	\N	\N
321	Uzbek 🇺🇿	PHONE_NUMBER	Telefon raqami	f	2025-04-05 01:10:48.336676	1	\N	\N
322	English 🇬🇧	PUBLISH_DAY	Publish Day	f	2025-04-05 01:10:48.336853	1	\N	\N
323	Russian 🇷🇺	PUBLISH_DAY	День публикации	f	2025-04-05 01:10:48.337028	1	\N	\N
324	Uzbek 🇺🇿	PUBLISH_DAY	Nashr kuni	f	2025-04-05 01:10:48.337199	1	\N	\N
325	English 🇬🇧	DAY	day	f	2025-04-05 01:10:48.337374	1	\N	\N
326	Russian 🇷🇺	DAY	день	f	2025-04-05 01:10:48.33756	1	\N	\N
327	Uzbek 🇺🇿	DAY	kun	f	2025-04-05 01:10:48.337746	1	\N	\N
328	English 🇬🇧	GOODBYE	Goodbye!	f	2025-04-05 01:10:48.337928	1	\N	\N
329	Russian 🇷🇺	GOODBYE	До свидания!	f	2025-04-05 01:10:48.338103	1	\N	\N
330	Uzbek 🇺🇿	GOODBYE	Xayr!	f	2025-04-05 01:10:48.338285	1	\N	\N
331	English 🇬🇧	ENTER_MESSAGE_ID	Enter message ID:	f	2025-04-05 01:10:48.338459	1	\N	\N
332	Russian 🇷🇺	ENTER_MESSAGE_ID	Введите ID сообщения:	f	2025-04-05 01:10:48.338643	1	\N	\N
333	Uzbek 🇺🇿	ENTER_MESSAGE_ID	Xabar ID sini kiriting:	f	2025-04-05 01:10:48.338811	1	\N	\N
334	English 🇬🇧	ALREADY_ACTIVATED	Your account is already activated!	f	2025-04-05 01:10:48.338982	1	\N	\N
335	Russian 🇷🇺	ALREADY_ACTIVATED	Ваш аккаунт уже активирован!	f	2025-04-05 01:10:48.339155	1	\N	\N
336	Uzbek 🇺🇿	ALREADY_ACTIVATED	Hisobingiz allaqachon faollashtirilgan!	f	2025-04-05 01:10:48.339347	1	\N	\N
337	English 🇬🇧	YOU_HAVE_2FA	Do you have 2FA enabled?	f	2025-04-05 01:10:48.339517	1	\N	\N
338	Russian 🇷🇺	YOU_HAVE_2FA	У вас включена двухфакторная аутентификация?	f	2025-04-05 01:10:48.339682	1	\N	\N
298	English 🇬🇧	ENTER_CARGO_FROM	The shipping address is 👇	f	2025-04-05 01:10:48.332341	1	\N	\N
304	English 🇬🇧	CHOOSE_CARGO_TYPE	Choose cargo type 👇	f	2025-04-05 01:10:48.333603	1	\N	\N
300	Uzbek 🇺🇿	ENTER_CARGO_FROM	Jo'natilish manzili 👇	f	2025-04-05 01:10:48.332796	1	\N	\N
301	English 🇬🇧	ENTER_CARGO_TO	The delivery address is👇	f	2025-04-05 01:10:48.333008	1	\N	\N
303	Uzbek 🇺🇿	ENTER_CARGO_TO	Yetkazilish manzili 👇	f	2025-04-05 01:10:48.333425	1	\N	\N
306	Uzbek 🇺🇿	CHOOSE_CARGO_TYPE	Yuk turini tanlang 👇	f	2025-04-05 01:10:48.333956	1	\N	\N
307	English 🇬🇧	CHOOSE_ONE_OF_THE_CARGOS	Choose one of the cargos 👇	f	2025-04-05 01:10:48.334131	1	\N	\N
309	Uzbek 🇺🇿	CHOOSE_ONE_OF_THE_CARGOS	Yuklardan birini tanlang 👇	f	2025-04-05 01:10:48.33448	1	\N	\N
310	English 🇬🇧	BACK	Back ⬅️	f	2025-04-05 01:10:48.33466	1	\N	\N
311	Russian 🇷🇺	BACK	Назад ⬅️	f	2025-04-05 01:10:48.33484	1	\N	\N
312	Uzbek 🇺🇿	BACK	Orqaga ⬅️	f	2025-04-05 01:10:48.33503	1	\N	\N
339	Uzbek 🇺🇿	YOU_HAVE_2FA	Sizda ikki faktorli autentifikatsiya yoqilganmi?	f	2025-04-05 01:10:48.339855	1	\N	\N
340	English 🇬🇧	ENTER_YOUR_PASSWORD_TG	Enter your Telegram password:	f	2025-04-05 01:10:48.340182	1	\N	\N
341	Russian 🇷🇺	ENTER_YOUR_PASSWORD_TG	Введите ваш пароль Telegram:	f	2025-04-05 01:10:48.340347	1	\N	\N
342	Uzbek 🇺🇿	ENTER_YOUR_PASSWORD_TG	Telegram parolingizni kiriting:	f	2025-04-05 01:10:48.340509	1	\N	\N
343	English 🇬🇧	ASK_LOGIN	Did you receive a login code?	f	2025-04-05 01:10:48.34068	1	\N	\N
344	Russian 🇷🇺	ASK_LOGIN	Вы получили код для входа?	f	2025-04-05 01:10:48.340841	1	\N	\N
345	Uzbek 🇺🇿	ASK_LOGIN	Kirish kodi keldimi?	f	2025-04-05 01:10:48.341021	1	\N	\N
346	English 🇬🇧	ENTER_YOUR_CODE	Enter your code:	f	2025-04-05 01:10:48.341199	1	\N	\N
347	Russian 🇷🇺	ENTER_YOUR_CODE	Введите ваш код:	f	2025-04-05 01:10:48.341384	1	\N	\N
348	Uzbek 🇺🇿	ENTER_YOUR_CODE	Kodingizni kiriting:	f	2025-04-05 01:10:48.341536	1	\N	\N
349	English 🇬🇧	TOO_MANY_ATTEMPTS	Too many attempts, please try again later.	f	2025-04-05 01:10:48.34168	1	\N	\N
350	Russian 🇷🇺	TOO_MANY_ATTEMPTS	Слишком много попыток, попробуйте позже.	f	2025-04-05 01:10:48.341832	1	\N	\N
351	Uzbek 🇺🇿	TOO_MANY_ATTEMPTS	Juda ko'p urinishlar, keyinroq qayta urinib ko'ring.	f	2025-04-05 01:10:48.341985	1	\N	\N
352	English 🇬🇧	CODE_EXPIRED	The code has expired.	f	2025-04-05 01:10:48.342157	1	\N	\N
353	Russian 🇷🇺	CODE_EXPIRED	Срок действия кода истек.	f	2025-04-05 01:10:48.34237	1	\N	\N
354	Uzbek 🇺🇿	CODE_EXPIRED	Kod muddati tugadi.	f	2025-04-05 01:10:48.342546	1	\N	\N
355	English 🇬🇧	LOGIN_ERROR	Login error, please try again.	f	2025-04-05 01:10:48.342707	1	\N	\N
356	Russian 🇷🇺	LOGIN_ERROR	Ошибка входа, попробуйте снова.	f	2025-04-05 01:10:48.342861	1	\N	\N
357	Uzbek 🇺🇿	LOGIN_ERROR	Kirishda xatolik, qayta urinib ko'ring.	f	2025-04-05 01:10:48.343014	1	\N	\N
375	Uzbek 🇺🇿	SEARCH_CARGO	Yuk qidirish 🔎	f	2025-04-10 20:33:10.219123	1	\N	\N
358	Uzbek 🇺🇿	AWNING	ТЕНТ	f	2025-04-10 20:33:10.194637	1	\N	\N
359	Uzbek 🇺🇿	REF	РЕФ	f	2025-04-10 20:33:10.202141	1	\N	\N
360	Uzbek 🇺🇿	ISOTHERM	ГРУЗ	f	2025-04-10 20:33:10.203684	1	\N	\N
361	Uzbek 🇺🇿	SEND_CONTACT	Kontaktni yuborish	f	2025-04-10 20:33:10.204613	1	\N	\N
362	uz	SEND_CONTACT	Kontaktni yuborish	f	2025-04-10 20:33:10.205338	1	\N	\N
363	Uzbek 🇺🇿	JOIN_GROUP	Guruhga qo'shilish	f	2025-04-10 20:33:10.206245	1	\N	\N
364	uz	JOIN_GROUP	Guruhga qo'shilish	f	2025-04-10 20:33:10.208204	1	\N	\N
365	Uzbek 🇺🇿	YES	Ha	f	2025-04-10 20:33:10.209061	1	\N	\N
366	uz	YES	Ha	f	2025-04-10 20:33:10.209987	1	\N	\N
367	Uzbek 🇺🇿	NO	Yo'q	f	2025-04-10 20:33:10.211117	1	\N	\N
368	uz	NO	Yo'q	f	2025-04-10 20:33:10.212582	1	\N	\N
369	Uzbek 🇺🇿	ACTIVATE	Faollashtirish	f	2025-04-10 20:33:10.214347	1	\N	\N
370	uz	ACTIVATE	Faollashtirish	f	2025-04-10 20:33:10.215461	1	\N	\N
371	Uzbek 🇺🇿	AUTO_MESSAGE	Avto xabar	f	2025-04-10 20:33:10.216105	1	\N	\N
372	uz	AUTO_MESSAGE	Avto xabar	f	2025-04-10 20:33:10.217045	1	\N	\N
373	Uzbek 🇺🇿	PROFILE	Profil	f	2025-04-10 20:33:10.217755	1	\N	\N
374	uz	PROFILE	Profil	f	2025-04-10 20:33:10.218363	1	\N	\N
376	uz	SEARCH_CARGO	Yuk qidirish	f	2025-04-10 20:33:10.220039	1	\N	\N
377	Uzbek 🇺🇿	HISTORY	Tarix	f	2025-04-10 20:33:10.220906	1	\N	\N
378	uz	HISTORY	Tarix	f	2025-04-10 20:33:10.221396	1	\N	\N
379	Uzbek 🇺🇿	CHANGE_LANGUAGE	Tilni o'zgartirish	f	2025-04-10 20:33:10.221842	1	\N	\N
380	uz	CHANGE_LANGUAGE	Tilni o'zgartirish	f	2025-04-10 20:33:10.222232	1	\N	\N
381	Uzbek 🇺🇿	LOGOUT	Chiqish	f	2025-04-10 20:33:10.222718	1	\N	\N
382	uz	LOGOUT	Chiqish	f	2025-04-10 20:33:10.223148	1	\N	\N
383	Uzbek 🇺🇿	STOP	To'xtatish	f	2025-04-10 20:33:10.223623	1	\N	\N
384	uz	STOP	To'xtatish	f	2025-04-10 20:33:10.224139	1	\N	\N
216	Uzbek 🇺🇿	DONE	Tayyor	f	2025-04-04 22:54:34.931158	1	2025-04-10 20:33:10.22474	1
385	uz	DONE	Tayyor	f	2025-04-10 20:33:10.226522	1	\N	\N
386	Uzbek 🇺🇿	MINUTE_30	30 daqiqa	f	2025-04-10 20:33:10.226944	1	\N	\N
387	uz	MINUTE_30	30 daqiqa	f	2025-04-10 20:33:10.227283	1	\N	\N
388	Uzbek 🇺🇿	MINUTE_45	45 daqiqa	f	2025-04-10 20:33:10.227615	1	\N	\N
389	uz	MINUTE_45	45 daqiqa	f	2025-04-10 20:33:10.228278	1	\N	\N
390	Uzbek 🇺🇿	MINUTE_60	60 daqiqa	f	2025-04-10 20:33:10.228641	1	\N	\N
391	uz	MINUTE_60	60 daqiqa	f	2025-04-10 20:33:10.229006	1	\N	\N
392	Uzbek 🇺🇿	BACK_TO_HOME_MENU	Bosh menyuga qaytish	f	2025-04-10 20:33:10.22941	1	\N	\N
393	uz	BACK_TO_HOME_MENU	Bosh menyuga qaytish	f	2025-04-10 20:33:10.22976	1	\N	\N
394	Uzbek 🇺🇿	EDIT_TEXT	Matnni tahrirlash	f	2025-04-10 20:33:10.230188	1	\N	\N
395	uz	EDIT_TEXT	Matnni tahrirlash	f	2025-04-10 20:33:10.230653	1	\N	\N
396	Uzbek 🇺🇿	EDIT_GROUP	Guruhni tahrirlash	f	2025-04-10 20:33:10.230983	1	\N	\N
397	uz	EDIT_GROUP	Guruhni tahrirlash	f	2025-04-10 20:33:10.231313	1	\N	\N
398	Uzbek 🇺🇿	EDIT_TIMER	Taymerni tahrirlash	f	2025-04-10 20:33:10.231879	1	\N	\N
399	uz	EDIT_TIMER	Taymerni tahrirlash	f	2025-04-10 20:33:10.232422	1	\N	\N
400	Uzbek 🇺🇿	START	Boshlash	f	2025-04-10 20:33:10.232745	1	\N	\N
401	uz	START	Boshlash	f	2025-04-10 20:33:10.233152	1	\N	\N
164	Uzbek 🇺🇿	ACCOUNT_ACTIVATED	Hisobingiz faollashtirildi.	f	2025-03-22 12:54:20.763433	1	2025-04-10 20:33:10.233724	1
402	uz	ACCOUNT_ACTIVATED	Hisobingiz faollashtirildi.	f	2025-04-10 20:33:10.234132	1	\N	\N
155	Uzbek 🇺🇿	CODE_EXPIRED_NEW_CODE_SENT	Tasdiqlash kodi muddati tugadi. Yangi kod yuborildi.	f	2025-03-22 12:39:13.459072	1	2025-04-10 20:33:10.234461	1
403	uz	CODE_EXPIRED_NEW_CODE_SENT	Tasdiqlash kodi muddati tugadi. Yangi kod yuborildi.	f	2025-04-10 20:33:10.235044	1	\N	\N
13	NONE	LANGUAGE_MENU	🇺🇿 Qaysi tilda davom ettiramiz?\nIltimos, tilni tanlang:\n\n🇷🇺 На каком языке продолжим?\nПожалуйста, выберите язык:\n\n🇬🇧 What language would you like to continue in?\nPlease select a language:	f	2025-03-17 21:41:55.12579	1	\N	\N
153	English 🇬🇧	ENTER_YOUR_CODE	Enter confirmation code:\nExample: 1 2 3 4\nNote: Type the numbers with spaces between them	f	2025-03-22 12:28:35.357844	1	\N	\N
118	Russian 🇷🇺	AWNING	Тент	f	2025-03-17 21:49:35.055895	1	\N	\N
120	Russian 🇷🇺	ISOTHERM	Груз	f	2025-03-17 21:49:35.055895	1	\N	\N
27	Uzbek 🇺🇿	HOME_MENU	Skylog Dispatching Bot'ga xush kelibsiz 😊	f	2025-03-17 21:47:17.118952	1	\N	\N
299	Russian 🇷🇺	ENTER_CARGO_FROM	Введите груз из 👇	f	2025-04-05 01:10:48.33258	1	\N	\N
302	Russian 🇷🇺	ENTER_CARGO_TO	Введите груз в 👇	f	2025-04-05 01:10:48.333217	1	\N	\N
305	Russian 🇷🇺	CHOOSE_CARGO_TYPE	Выберите тип фуры 👇	f	2025-04-05 01:10:48.333779	1	\N	\N
308	Russian 🇷🇺	CHOOSE_ONE_OF_THE_CARGOS	Выберите один из грузов 👇	f	2025-04-05 01:10:48.334306	1	\N	\N
404	English 🇬🇧	SEND_CONTACT	Send contact	f	2025-04-10 20:33:10.235044	1	\N	\N
\.


--
-- Data for Name: message; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.message (id, user_id, message, timer, status, send_count_in_day, send_count_all, phone, is_deleted, created_at, last_send_at, created_by, updated_at, updated_by) FROM stdin;
42	24	123321	30	t	0	0	+998951234400	f	2025-04-13 20:20:29.30068	2025-04-13 22:52:16.585315	24	\N	\N
35	6	123	30	t	0	0	998906830271	f	2025-04-12 18:10:47.965074	2025-04-12 18:11:03.649101	6	\N	\N
41	6	111	30	t	0	0	998906830271	f	2025-04-13 18:33:57.756556	2025-04-13 23:06:23.858852	6	\N	\N
36	6	123	30	t	0	0	998906830271	f	2025-04-12 19:01:29.074159	2025-04-12 19:01:53.890739	6	\N	\N
37	6	123 1	30	t	0	0	998906830271	f	2025-04-12 19:42:02.645422	2025-04-12 19:42:22.902977	6	\N	\N
38	6	123 2	30	t	0	0	998906830271	f	2025-04-13 12:48:06.14978	\N	6	\N	\N
39	6	123 12	30	t	0	0	998906830271	f	2025-04-13 14:20:48.770105	2025-04-13 14:21:08.634135	6	\N	\N
20	6	123	30	f	0	0	998906830271	f	2025-04-07 01:46:16.301751	\N	6	\N	\N
21	6	123	30	f	0	0	998906830271	f	2025-04-07 01:47:35.75052	\N	6	\N	\N
19	6	123	30	f	0	0	998906830271	f	2025-04-06 15:20:15.926143	2025-04-06 15:51:00.722663	6	\N	\N
40	6	123 1	30	t	0	0	998906830271	f	2025-04-13 17:36:03.055752	2025-04-13 17:36:19.767804	6	\N	\N
22	6	111	30	f	0	0	998906830271	f	2025-04-07 02:49:58.40499	\N	6	\N	\N
24	6	1212	30	f	0	0	998906830271	f	2025-04-07 02:55:37.874069	\N	6	\N	\N
25	6	123	30	f	0	0	998906830271	f	2025-04-12 14:13:57.826689	\N	6	\N	\N
26	6	123	30	f	0	0	998906830271	f	2025-04-12 14:19:16.953982	\N	6	\N	\N
27	6	123	30	f	0	0	998906830271	f	2025-04-12 14:21:33.20726	\N	6	\N	\N
23	6	1112	30	f	0	0	998906830271	f	2025-04-07 02:53:01.753147	\N	6	\N	\N
28	6	123	30	f	0	0	998906830271	f	2025-04-12 14:24:21.269048	\N	6	\N	\N
30	26	123	30	f	0	0	998951234400	f	2025-04-12 14:35:04.538583	\N	26	\N	\N
31	25	1234	30	t	0	0	998200007934	f	2025-04-12 14:35:14.546955	\N	25	\N	\N
32	26	123	30	t	0	0	998951234400	f	2025-04-12 14:39:31.897831	\N	26	\N	\N
29	6	123	30	f	0	0	998906830271	f	2025-04-12 14:27:28.485086	\N	6	\N	\N
33	6	123	30	f	0	0	998906830271	f	2025-04-12 16:34:46.577697	2025-04-12 16:34:47.220229	6	\N	\N
34	6	123	30	t	0	0	998906830271	f	2025-04-12 16:39:54.796968	2025-04-12 16:40:14.873805	6	\N	\N
\.


--
-- Data for Name: message_group; Type: TABLE DATA; Schema: public; Owner: akbarov
--

COPY public.message_group (id, name, folder, link, is_active, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
2	Логистика Казахстан и СНГ	Skylog-1	https://t.me/Kazsng	t	f	2025-04-05 02:36:38.920637	1	\N	\N
3	Yuk Rossiya---Uzbekistan	Skylog-1	https://t.me/logistikauzru	t	f	2025-04-05 02:36:38.920642	1	\N	\N
5	Yõlga hamroh.Taksi Zomin Jizzax	Skylog-1	https://t.me/yolgahamroh96	t	f	2025-04-05 22:38:15.833115	1	\N	\N
6	GRUZ KARVON | Грузы международных и международных.	Skylog-1	https://t.me/gruz_logistika_transport_pitak	t	f	2025-04-05 22:38:15.833175	1	\N	\N
7	Грузоперевозки Казахстан и СНГ	Skylog-1	https://t.me/dellakz	t	f	2025-04-05 22:38:15.833215	1	\N	\N
8	Грузы ЕВРОПА-АЗИЯ	Skylog-1	https://t.me/transeuazia	t	f	2025-04-05 22:38:15.83325	1	\N	\N
9	Логистика Тент.Реф.Куб 🎯	Skylog-1	https://t.me/logistika_ru	t	f	2025-04-05 22:38:15.833287	1	\N	\N
10	Логистика UZ.KZ.RUS.EVRO 🇺🇿 🇰🇿 🇷🇺	Skylog-1	https://t.me/logistic_truck	t	f	2025-04-05 22:38:15.833337	1	\N	\N
11	🇷🇺ГРУЗЫ🇷🇺	Skylog-1	https://t.me/gruzoperevozku_ru	t	f	2025-04-05 22:38:15.83337	1	\N	\N
12	,,РОССИЯ УЗБЕКИСТАН УЗБЕКИСТАН РОССИЯ''	Skylog-1	https://t.me/UZ_RUS_XALQARO_YUKLARI	t	f	2025-04-05 22:38:15.833402	1	\N	\N
13	ЛОГИСТИКА УЗБЕКИСТАНА	Skylog-1	https://t.me/LOGISTIKA_UZBEKISTANA	t	f	2025-04-05 22:38:15.833434	1	\N	\N
14	YUK🎯markazi |🇺🇿 mahalliy	Skylog-1	https://t.me/yukmarkazi_furalar	t	f	2025-04-05 22:38:15.833472	1	\N	\N
15	UZBEKISTAN YUK MARKAZI🇺🇿	Skylog-1	https://t.me/uzbekiston_2022	t	f	2025-04-05 22:38:15.833525	1	\N	\N
16	Tуркия Узбекистан	Skylog-1	https://t.me/turklogist	t	f	2025-04-05 22:38:15.833556	1	\N	\N
17	Logistika.uz🇺🇿РЕФ	Skylog-1	https://t.me/logistika_uzbb	t	f	2025-04-05 22:38:15.833588	1	\N	\N
18	Перевозки OCAS.PL Евразия	Skylog-1	https://t.me/gryzovik	t	f	2025-04-05 22:38:15.833618	1	\N	\N
19	Попутные грузы (ЧАТ)	Skylog-1	https://t.me/poputno_gruz	t	f	2025-04-05 22:38:15.833649	1	\N	\N
20	Грузоперевозки | Поиск груза | RU	Skylog-1	https://t.me/gruz_ru	t	f	2025-04-05 22:38:15.83368	1	\N	\N
21	@yuk_markazi_YUKBOR	Skylog-1	https://t.me/yuk_markazi_pitak_uz	t	f	2025-04-05 22:38:15.833711	1	\N	\N
22	BarakaYuklari	Skylog-1	https://t.me/BarakaYuklari	t	f	2025-04-05 22:38:15.833742	1	\N	\N
23	VODIY SAMARQAND YANGI GRUPPA🚚🚛	Skylog-1	https://t.me/yuktawiw	t	f	2025-04-05 22:38:15.833774	1	\N	\N
24	Yuk🎯Bor🌍Yuk Markazi	Skylog-1	https://t.me/Yuk_bor_Yuk	t	f	2025-04-05 22:38:15.833805	1	\N	\N
25	120 Паравоз Перевозки	Skylog-1	https://t.me/group120paravoz	t	f	2025-04-05 22:38:15.83384	1	\N	\N
26	ЛОГИСТИКА С.Н.Г	Skylog-1	https://t.me/logisticcargo	t	f	2025-04-05 22:38:15.833871	1	\N	\N
27	ReeSoul Logistics	Skylog-1	https://t.me/Yuklar_markazi	t	f	2025-04-05 22:38:15.833901	1	\N	\N
28	ЛОГИСТИКА МАРКАЗИ ️️ 🇺🇿🇷🇺🇺🇸	Skylog-1	https://t.me/uzblogist_around_world	t	f	2025-04-05 22:38:15.833932	1	\N	\N
29	Рефы и тентовки. Ибраш	Skylog-1	https://t.me/reftentibrash	t	f	2025-04-05 22:38:15.833963	1	\N	\N
30	Логистика // Грузоперевозки междугородные/международные	Skylog-1	https://t.me/perevozkipouzb	t	f	2025-04-05 22:38:15.833993	1	\N	\N
31	O'zbekiston Bo'ylab	Skylog-1	https://t.me/uzb_taxsi	t	f	2025-04-05 22:38:15.834023	1	\N	\N
33	Fura || Yuk Markazi	Skylog-1	https://t.me/Fura_yuk_markazii	t	f	2025-04-05 22:38:15.834083	1	\N	\N
34	Международные🎯Грузы🌍🌎🌏	Skylog-1	https://t.me/logistika_1	t	f	2025-04-05 22:38:15.834115	1	\N	\N
35	ГРУЗОПЕРЕВОЗКИ ЕВРАЗИЯ	Skylog-1	https://t.me/gryzsng	t	f	2025-04-05 22:38:15.834145	1	\N	\N
36	Della ™- Грузы и Транспорт	Skylog-1	https://t.me/dellauz	t	f	2025-04-05 22:38:15.834176	1	\N	\N
37	Toshkent yuklari	Skylog-1	https://t.me/VodiyStarTrans	t	f	2025-04-05 22:38:15.834206	1	\N	\N
38	🌎✈️ Yuk🎯Markazi 🚛 🌍	Skylog-1	https://t.me/Yuk_Markaazi	t	f	2025-04-05 22:38:15.834233	1	\N	\N
39	Yuk markazi, yuk gruppa, Caravan logistic	Skylog-1	https://t.me/CARAVANUZBEKISTAN	t	f	2025-04-05 22:38:15.834259	1	\N	\N
40	Авто Грузы России	Skylog-1	https://t.me/avtocargo	t	f	2025-04-05 22:38:15.834284	1	\N	\N
41	Грузоперевозки логистика	Skylog-1	https://t.me/trucking1	t	f	2025-04-05 22:38:15.834309	1	\N	\N
42	Транс Атлас	Skylog-1	https://t.me/transatlas	t	f	2025-04-05 22:38:15.834335	1	\N	\N
43	Toshkent-Vodiy yuk markazi	Skylog-1	https://t.me/fargona_toshkent_samarqand_yuk	t	f	2025-04-05 22:38:15.83436	1	\N	\N
44	LAND GRUZER	Skylog-1	https://t.me/LAND_GRUZER	t	f	2025-04-05 22:38:15.834385	1	\N	\N
45	ГРУЗОПЕРЕВОЗКИ	Skylog-1	https://t.me/gruzoperevozochki	t	f	2025-04-05 22:38:15.83441	1	\N	\N
46	Узбек Транс	Skylog-1	https://t.me/yuk_tashish_xizmatlari	t	f	2025-04-05 22:38:15.834435	1	\N	\N
47	Yuk🇺🇿 Petak🇺🇿🚚🚛🚦	Skylog-1	https://t.me/shafiyorlar	t	f	2025-04-05 22:38:15.834466	1	\N	\N
48	Транспорт и логистика	Skylog-1	https://t.me/Logistikagroup	t	f	2025-04-05 22:38:15.834491	1	\N	\N
49	Логистика🎯Юк маркази🌏	Skylog-1	https://t.me/Yuk_Markaz_Furalar	t	f	2025-04-05 22:38:15.834517	1	\N	\N
50	🚚ISUZUGA FURAGA YUK BOR-🚚 ФУРАГА ИСУЗУГА ЮК БОР - ЕСТЬ ГРУЗ🚛	Skylog-1	https://t.me/yukfuragabor_FargonaToshkent	t	f	2025-04-05 22:38:15.834544	1	\N	\N
51	GRUZON - ГРУЗОПЕРЕВОЗКИ 🚛 🚚	Skylog-1	https://t.me/gruzonuz	t	f	2025-04-05 22:38:15.834571	1	\N	\N
52	Logistika	Skylog-1	https://t.me/uzbekistan_rassiya_ru_uz	t	f	2025-04-05 22:38:15.834596	1	\N	\N
53	Yuk tashish, грузоперевозки🇺🇿🇷🇺🇰🇿🇹🇷	Skylog-1	https://t.me/logistika_fura	t	f	2025-04-05 22:38:15.834631	1	\N	\N
54	TiRpark🎯LOGiSTiC 🌍	Skylog-1	https://t.me/TiRpark_logistika1	t	f	2025-04-05 22:38:15.834657	1	\N	\N
55	@YUK_SENTR🇺🇿	Skylog-1	https://t.me/YUK_SENTR	t	f	2025-04-05 22:38:15.834684	1	\N	\N
56	ГРУЗОПЕРЕВОЗКИ | СНГ | ЕС | АЗИЯ | ЧАТ	Skylog-1	https://t.me/rucargoru	t	f	2025-04-05 22:38:15.834709	1	\N	\N
57	𝐋𝐎𝐆𝐈𝐒𝐓𝐈𝐂 𝐀𝐔𝐓𝐎 𝐌𝐍𝐎𝐒	Skylog-1	https://t.me/perevozka_uzb_rf1	t	f	2025-04-05 22:38:15.834735	1	\N	\N
58	Логистика Казахстан и СНГ	Skylog-1	https://t.me/Kazsng	t	f	2025-04-05 22:38:15.83476	1	\N	\N
59	Международная логистика TIR	Skylog-1	https://t.me/logistika_777	t	f	2025-04-05 22:38:15.834786	1	\N	\N
60	Грузоперевозки по России (Перевозка 24) грузовые перевозки, фура, газель дальнобойщик, заказы перевозка грузов	Skylog-1	https://t.me/gruzoperevozkivrussia	t	f	2025-04-05 22:38:15.834812	1	\N	\N
61	🏘🕋🕌 VODIY YUKLAR 🏘🕋🕌	Skylog-1	https://t.me/MIR_FURAYUKLAR	t	f	2025-04-05 22:38:15.834838	1	\N	\N
62	Международные грузоперевозки	Skylog-1	https://t.me/Transportationuz	t	f	2025-04-05 22:38:15.834863	1	\N	\N
63	МИР ГРУЗОПЕРЕВОЗОК	Skylog-1	https://t.me/specgruz_express	t	f	2025-04-05 22:38:15.834889	1	\N	\N
64	Перевозка товаров Россия Узбекистан Таджикистан	Skylog-1	https://t.me/pervozk1	t	f	2025-04-05 22:38:15.834914	1	\N	\N
65	Yuk markazi Buxoro Toshkent Fura isuzu yuk tashish xizmati	Skylog-1	https://t.me/buxoro_yuk_tashish_xizmatlari	t	f	2025-04-05 22:38:15.83494	1	\N	\N
66	Грузоперевозки - Россия🚛	Skylog-1	https://t.me/gruzoperevozkiRU_choogl	t	f	2025-04-05 22:38:15.834972	1	\N	\N
67	TRUCKERS	Skylog-1	https://t.me/dalnoboichat	t	f	2025-04-05 22:38:15.834997	1	\N	\N
68	🚛YUK MARKAZI🚛	Skylog-1	https://t.me/yuk_logistika	t	f	2025-04-05 22:38:15.835026	1	\N	\N
69	Yuk baza	Skylog-1	https://t.me/yuk_baza	t	f	2025-04-05 22:38:15.83505	1	\N	\N
70	Международные грузоперевозки!	Skylog-1	https://t.me/gruzoperevozkilogistics	t	f	2025-04-05 22:38:15.835076	1	\N	\N
71	Logistic Tajikistan 2025	Skylog-1	https://t.me/gruz2020indira	t	f	2025-04-05 22:38:15.835101	1	\N	\N
72	Международная логистика	Skylog-1	https://t.me/Russian_logistics	t	f	2025-04-05 22:38:15.835126	1	\N	\N
73	Yuk Rossiya---Uzbekistan	Skylog-1	https://t.me/logistikauzru	t	f	2025-04-05 22:38:15.83515	1	\N	\N
74	Международные грузоперевозки (Перевозка 24) грузовые перевозки, фура, дальнобойщик, заказы перевозка груза	Skylog-1	https://t.me/internationalcargotransport	t	f	2025-04-05 22:38:15.835176	1	\N	\N
75	Грузоперевозки по РФ	Skylog-1	https://t.me/gruzivozim	t	f	2025-04-05 22:38:15.835201	1	\N	\N
76	Мировая Перевозка	Skylog-1	https://t.me/logistic01_gruz_mir	t	f	2025-04-05 22:38:15.835225	1	\N	\N
77	ПЕРЕВОЗЧИК	Skylog-1	https://t.me/OOLIONGROUP	t	f	2025-04-05 22:38:15.835251	1	\N	\N
78	ПЕРЕВОЗКА 2016👍	Skylog-1	https://t.me/Pervozka	t	f	2025-04-05 22:38:15.835277	1	\N	\N
79	Логистика США ЭВРОПА Международная Логистика	Skylog-1	https://t.me/logistics_chat	t	f	2025-04-05 22:38:15.835302	1	\N	\N
80	Грузоперевозки КАЗАХСТАН	Skylog-1	https://t.me/perevozka_gruzov_logistika_kz	t	f	2025-04-05 22:38:15.835328	1	\N	\N
81	Yuk tashish xizmati🚛🚚	Skylog-1	https://t.me/yukbor7	t	f	2025-04-05 22:38:15.835353	1	\N	\N
82	ГРУЗОПЕРЕВОЗКИ РОССИЯ	Skylog-1	https://t.me/gruzoperevozki_rossiya	t	f	2025-04-05 22:38:15.83538	1	\N	\N
83	ПОИСК ГРУЗ 🇷🇺🇪🇺🇹🇷🇹🇲🇺🇿🇹🇯🇰🇿🇰🇬🇧🇾🇦🇿🇺🇦🇬🇪🇦🇲	Skylog-1	https://t.me/world_deliver	t	f	2025-04-05 22:38:15.83541	1	\N	\N
84	🇺🇿 ЮК 🚚 ГРУППА 🚛	Skylog-1	https://t.me/yuk95	t	f	2025-04-05 22:38:15.835436	1	\N	\N
85	Yuk UZB	Skylog-1	https://t.me/logistika_yuk	t	f	2025-04-05 22:38:15.835461	1	\N	\N
86	Грузовые перевозки. Грузчики. Логистика	Skylog-1	https://t.me/perevozkakz	t	f	2025-04-05 22:38:15.835486	1	\N	\N
87	Европа - СНГ. KZ,UZ,TR,UA,AZ,🇪🇺🇹🇷🇰🇿🇰🇬🇦🇿🇺🇿🇺🇦🇮🇷🇱🇹🇧🇾🇲🇳	Skylog-1	https://t.me/LOGISTWAR	t	f	2025-04-05 22:38:15.835513	1	\N	\N
88	Биржа Грузоперевозки Чат	Skylog-1	https://t.me/logistika_gruzoperevozka	t	f	2025-04-05 22:38:15.835544	1	\N	\N
89	Logistic's_24	Skylog-1	https://t.me/Logistics_24	t	f	2025-04-05 22:38:15.83557	1	\N	\N
90	YUK TASHISH XIZMATI L🇺🇿🇺🇿🇺🇿🇺🇿🇺🇿 IM GLOBALTRUCK LOGISTIC	Skylog-1	https://t.me/liderlagist	t	f	2025-04-05 22:38:15.835597	1	\N	\N
91	WORLD LOGISTIC & ЛОГИСТИКА МИРА	Skylog-1	https://t.me/worldlogist	t	f	2025-04-05 22:38:15.835622	1	\N	\N
92	🚚🚛ТЕНТ РЕФ ЮК ТАШИШ 🇺🇿 🇷🇺	Skylog-1	https://t.me/tent_ref_yuktashish	t	f	2025-04-05 22:38:15.835648	1	\N	\N
93	Trak uz	Skylog-1	https://t.me/Trak_uz	t	f	2025-04-05 22:38:15.835673	1	\N	\N
94	ШАФЁРЛАР_УЧУН_ЮК_ГРУППАСИ	Skylog-1	https://t.me/FURA_UZB_24	t	f	2025-04-05 22:38:15.835698	1	\N	\N
95	Грузоперевозки	Skylog-1	https://t.me/gruz16dokument	t	f	2025-04-05 22:38:15.835723	1	\N	\N
96	Грузоперевозки (TTS)	Skylog-1	https://t.me/TransTechSystem	t	f	2025-04-05 22:38:15.835749	1	\N	\N
97	ТЕНТ, РЕФ, ИЗОТЕРМА	Skylog-1	https://t.me/TentRefIzoterm	t	f	2025-04-05 22:38:15.835774	1	\N	\N
98	DODA YUK DUNYO BOYLAB	Skylog-1	https://t.me/ZAKAS_GURUPPA_DODO	t	f	2025-04-05 22:38:15.835799	1	\N	\N
99	Pitak.kz	Skylog-1	https://t.me/pitak_kz_gruzoperevozki	t	f	2025-04-05 22:38:15.835824	1	\N	\N
100	Перевозки	Skylog-1	https://t.me/Botrans96group	t	f	2025-04-05 22:38:15.835849	1	\N	\N
101	Грузы и транспорта по Европе и СНГ 🚚	Skylog-1	https://t.me/allcargoinfo	t	f	2025-04-05 22:38:15.835876	1	\N	\N
102	🚚 YUK MARKAZI 🚛	Skylog-1	https://t.me/yukmarkazigruppa	t	f	2025-04-05 22:38:15.835901	1	\N	\N
103	🚚 ИСУЗУ РЕФ УЗБЕКИСТОН БУЙЛАБ🚚	Skylog-1	https://t.me/gruzref	t	f	2025-04-05 22:38:15.97798	1	\N	\N
104	Чат WorldTransit - Импорт, ВЭД, логистика	Skylog-1	https://t.me/worldtransit_chat	t	f	2025-04-05 22:38:15.978172	1	\N	\N
105	🌎ТРАНСПОРТ ГРУЗЫ ЛОГИСТИКА🌍	Skylog-1	https://t.me/onlytgl	t	f	2025-04-05 22:38:15.978313	1	\N	\N
106	Logistika.uz🇺🇿РЕФ	Skylog-2	https://t.me/logistika_uzbb	t	f	2025-04-05 22:39:04.633625	1	\N	\N
107	GRUZ KARVON | Грузы международных и международных.	Skylog-2	https://t.me/gruz_logistika_transport_pitak	t	f	2025-04-05 22:39:04.633775	1	\N	\N
108	Попутные грузы (ЧАТ)	Skylog-2	https://t.me/poputno_gruz	t	f	2025-04-05 22:39:04.633893	1	\N	\N
109	ЛОГИСТИКА С.Н.Г	Skylog-2	https://t.me/logisticcargo	t	f	2025-04-05 22:39:04.63429	1	\N	\N
110	UZBEKISTAN YUK MARKAZI🇺🇿	Skylog-2	https://t.me/uzbekiston_2022	t	f	2025-04-05 22:39:04.635412	1	\N	\N
111	🇺🇿 ЮК 🚚 ГРУППА 🚛	Skylog-2	https://t.me/yuk95	t	f	2025-04-05 22:39:04.63552	1	\N	\N
169	🏘🕋🕌 VODIY YUKLAR 🏘🕋🕌	Skylog-2	https://t.me/MIR_FURAYUKLAR	t	f	2025-04-05 22:39:04.637006	1	\N	\N
225	Международный_Груз	Skylog-3	https://t.me/Gruz_perevozk	t	f	2025-04-05 22:42:50.568475	1	\N	\N
112	Грузоперевозки по России (Перевозка 24) грузовые перевозки, фура, газель дальнобойщик, заказы перевозка грузов	Skylog-2	https://t.me/gruzoperevozkivrussia	t	f	2025-04-05 22:39:04.635593	1	\N	\N
113	Tуркия Узбекистан	Skylog-2	https://t.me/turklogist	t	f	2025-04-05 22:39:04.635624	1	\N	\N
114	Грузоперевозки | Поиск груза | RU	Skylog-2	https://t.me/gruz_ru	t	f	2025-04-05 22:39:04.635735	1	\N	\N
115	Toshkent-Vodiy yuk markazi	Skylog-2	https://t.me/fargona_toshkent_samarqand_yuk	t	f	2025-04-05 22:39:04.635837	1	\N	\N
116	Грузоперевозки логистика	Skylog-2	https://t.me/trucking1	t	f	2025-04-05 22:39:04.635919	1	\N	\N
117	Логистика // Грузоперевозки междугородные/международные	Skylog-2	https://t.me/perevozkipouzb	t	f	2025-04-05 22:39:04.636021	1	\N	\N
118	ЛОГИСТИКА УЗБЕКИСТАНА	Skylog-2	https://t.me/LOGISTIKA_UZBEKISTANA	t	f	2025-04-05 22:39:04.636083	1	\N	\N
119	Перевозки OCAS.PL Евразия	Skylog-2	https://t.me/gryzovik	t	f	2025-04-05 22:39:04.636115	1	\N	\N
120	BarakaYuklari	Skylog-2	https://t.me/BarakaYuklari	t	f	2025-04-05 22:39:04.636136	1	\N	\N
121	Yuk markazi, yuk gruppa, Caravan logistic	Skylog-2	https://t.me/CARAVANUZBEKISTAN	t	f	2025-04-05 22:39:04.636154	1	\N	\N
122	,,РОССИЯ УЗБЕКИСТАН УЗБЕКИСТАН РОССИЯ''	Skylog-2	https://t.me/UZ_RUS_XALQARO_YUKLARI	t	f	2025-04-05 22:39:04.636171	1	\N	\N
123	Логистика Тент.Реф.Куб 🎯	Skylog-2	https://t.me/logistika_ru	t	f	2025-04-05 22:39:04.636189	1	\N	\N
124	@YUK_SENTR🇺🇿	Skylog-2	https://t.me/YUK_SENTR	t	f	2025-04-05 22:39:04.636206	1	\N	\N
125	Yuk tashish xizmati🚛🚚	Skylog-2	https://t.me/yukbor7	t	f	2025-04-05 22:39:04.636223	1	\N	\N
126	120 Паравоз Перевозки	Skylog-2	https://t.me/group120paravoz	t	f	2025-04-05 22:39:04.636239	1	\N	\N
127	Логистика Казахстан и СНГ	Skylog-2	https://t.me/Kazsng	t	f	2025-04-05 22:39:04.636255	1	\N	\N
128	TRUCKERS	Skylog-2	https://t.me/dalnoboichat	t	f	2025-04-05 22:39:04.63627	1	\N	\N
129	VODIY SAMARQAND YANGI GRUPPA🚚🚛	Skylog-2	https://t.me/yuktawiw	t	f	2025-04-05 22:39:04.636287	1	\N	\N
130	Yuk🎯Bor🌍Yuk Markazi	Skylog-2	https://t.me/Yuk_bor_Yuk	t	f	2025-04-05 22:39:04.636303	1	\N	\N
131	ЛОГИСТИКА МАРКАЗИ ️️ 🇺🇿🇷🇺🇺🇸	Skylog-2	https://t.me/uzblogist_around_world	t	f	2025-04-05 22:39:04.63632	1	\N	\N
132	Транспорт и логистика	Skylog-2	https://t.me/Logistikagroup	t	f	2025-04-05 22:39:04.636336	1	\N	\N
133	ГРУЗОПЕРЕВОЗКИ	Skylog-2	https://t.me/gruzoperevozochki	t	f	2025-04-05 22:39:04.636352	1	\N	\N
134	TiRpark🎯LOGiSTiC 🌍	Skylog-2	https://t.me/TiRpark_logistika1	t	f	2025-04-05 22:39:04.636369	1	\N	\N
135	Логистика UZ.KZ.RUS.EVRO 🇺🇿 🇰🇿 🇷🇺	Skylog-2	https://t.me/logistic_truck	t	f	2025-04-05 22:39:04.636384	1	\N	\N
136	Транс Атлас	Skylog-2	https://t.me/transatlas	t	f	2025-04-05 22:39:04.6364	1	\N	\N
137	Fura Yuk Markazi	Skylog-2	https://t.me/fura_yukk_markazi	t	f	2025-04-05 22:39:04.636416	1	\N	\N
138	Грузы ЕВРОПА-АЗИЯ	Skylog-2	https://t.me/transeuazia	t	f	2025-04-05 22:39:04.636431	1	\N	\N
139	ПЕРЕВОЗКА 2016👍	Skylog-2	https://t.me/Pervozka	t	f	2025-04-05 22:39:04.63645	1	\N	\N
140	🌎✈️ Yuk🎯Markazi 🚛 🌍	Skylog-2	https://t.me/Yuk_Markaazi	t	f	2025-04-05 22:39:04.636469	1	\N	\N
141	Перевозка товаров Россия Узбекистан Таджикистан	Skylog-2	https://t.me/pervozk1	t	f	2025-04-05 22:39:04.636486	1	\N	\N
142	Узбек Транс	Skylog-2	https://t.me/yuk_tashish_xizmatlari	t	f	2025-04-05 22:39:04.636501	1	\N	\N
143	Логистика🎯Юк маркази🌏	Skylog-2	https://t.me/Yuk_Markaz_Furalar	t	f	2025-04-05 22:39:04.636518	1	\N	\N
144	𝐋𝐎𝐆𝐈𝐒𝐓𝐈𝐂 𝐀𝐔𝐓𝐎 𝐌𝐍𝐎𝐒	Skylog-2	https://t.me/perevozka_uzb_rf1	t	f	2025-04-05 22:39:04.636533	1	\N	\N
145	🇷🇺ГРУЗЫ🇷🇺	Skylog-2	https://t.me/gruzoperevozku_ru	t	f	2025-04-05 22:39:04.63655	1	\N	\N
146	ГРУЗОПЕРЕВОЗКИ РОССИЯ	Skylog-2	https://t.me/gruzoperevozki_rossiya	t	f	2025-04-05 22:39:04.636568	1	\N	\N
147	ГРУЗОПЕРЕВОЗКИ ЕВРАЗИЯ	Skylog-2	https://t.me/gryzsng	t	f	2025-04-05 22:39:04.636584	1	\N	\N
148	Международные🎯Грузы🌍🌎🌏	Skylog-2	https://t.me/logistika_1	t	f	2025-04-05 22:39:04.6366	1	\N	\N
149	Fura || Yuk Markazi	Skylog-2	https://t.me/Fura_yuk_markazii	t	f	2025-04-05 22:39:04.63664	1	\N	\N
150	Грузоперевозки Казахстан и СНГ	Skylog-2	https://t.me/dellakz	t	f	2025-04-05 22:39:04.636656	1	\N	\N
151	Грузоперевозки КАЗАХСТАН	Skylog-2	https://t.me/perevozka_gruzov_logistika_kz	t	f	2025-04-05 22:39:04.636673	1	\N	\N
152	Logistika	Skylog-2	https://t.me/uzbekistan_rassiya_ru_uz	t	f	2025-04-05 22:39:04.636689	1	\N	\N
153	LAND GRUZER	Skylog-2	https://t.me/LAND_GRUZER	t	f	2025-04-05 22:39:04.636705	1	\N	\N
154	Yõlga hamroh.Taksi Zomin Jizzax	Skylog-2	https://t.me/yolgahamroh96	t	f	2025-04-05 22:39:04.636721	1	\N	\N
155	YUK🎯markazi |🇺🇿 mahalliy	Skylog-2	https://t.me/yukmarkazi_furalar	t	f	2025-04-05 22:39:04.636737	1	\N	\N
156	@yuk_markazi_YUKBOR	Skylog-2	https://t.me/yuk_markazi_pitak_uz	t	f	2025-04-05 22:39:04.636752	1	\N	\N
157	ReeSoul Logistics	Skylog-2	https://t.me/Yuklar_markazi	t	f	2025-04-05 22:39:04.636768	1	\N	\N
158	Рефы и тентовки. Ибраш	Skylog-2	https://t.me/reftentibrash	t	f	2025-04-05 22:39:04.636783	1	\N	\N
159	O'zbekiston Bo'ylab	Skylog-2	https://t.me/uzb_taxsi	t	f	2025-04-05 22:39:04.636798	1	\N	\N
160	Della ™- Грузы и Транспорт	Skylog-2	https://t.me/dellauz	t	f	2025-04-05 22:39:04.636813	1	\N	\N
161	Toshkent yuklari	Skylog-2	https://t.me/VodiyStarTrans	t	f	2025-04-05 22:39:04.636828	1	\N	\N
162	Авто Грузы России	Skylog-2	https://t.me/avtocargo	t	f	2025-04-05 22:39:04.636844	1	\N	\N
163	Yuk🇺🇿 Petak🇺🇿🚚🚛🚦	Skylog-2	https://t.me/shafiyorlar	t	f	2025-04-05 22:39:04.636891	1	\N	\N
164	🚚ISUZUGA FURAGA YUK BOR-🚚 ФУРАГА ИСУЗУГА ЮК БОР - ЕСТЬ ГРУЗ🚛	Skylog-2	https://t.me/yukfuragabor_FargonaToshkent	t	f	2025-04-05 22:39:04.636925	1	\N	\N
165	GRUZON - ГРУЗОПЕРЕВОЗКИ 🚛 🚚	Skylog-2	https://t.me/gruzonuz	t	f	2025-04-05 22:39:04.636943	1	\N	\N
166	Yuk tashish, грузоперевозки🇺🇿🇷🇺🇰🇿🇹🇷	Skylog-2	https://t.me/logistika_fura	t	f	2025-04-05 22:39:04.636959	1	\N	\N
167	ГРУЗОПЕРЕВОЗКИ | СНГ | ЕС | АЗИЯ | ЧАТ	Skylog-2	https://t.me/rucargoru	t	f	2025-04-05 22:39:04.636975	1	\N	\N
168	Международная логистика TIR	Skylog-2	https://t.me/logistika_777	t	f	2025-04-05 22:39:04.63699	1	\N	\N
170	Международные грузоперевозки	Skylog-2	https://t.me/Transportationuz	t	f	2025-04-05 22:39:04.637021	1	\N	\N
171	МИР ГРУЗОПЕРЕВОЗОК	Skylog-2	https://t.me/specgruz_express	t	f	2025-04-05 22:39:04.637041	1	\N	\N
172	Yuk markazi Buxoro Toshkent Fura isuzu yuk tashish xizmati	Skylog-2	https://t.me/buxoro_yuk_tashish_xizmatlari	t	f	2025-04-05 22:39:04.637057	1	\N	\N
173	Грузоперевозки - Россия🚛	Skylog-2	https://t.me/gruzoperevozkiRU_choogl	t	f	2025-04-05 22:39:04.637076	1	\N	\N
174	🚛YUK MARKAZI🚛	Skylog-2	https://t.me/yuk_logistika	t	f	2025-04-05 22:39:04.637092	1	\N	\N
175	Yuk baza	Skylog-2	https://t.me/yuk_baza	t	f	2025-04-05 22:39:04.637108	1	\N	\N
176	Международные грузоперевозки!	Skylog-2	https://t.me/gruzoperevozkilogistics	t	f	2025-04-05 22:39:04.637123	1	\N	\N
177	Logistic Tajikistan 2025	Skylog-2	https://t.me/gruz2020indira	t	f	2025-04-05 22:39:04.637138	1	\N	\N
178	Международная логистика	Skylog-2	https://t.me/Russian_logistics	t	f	2025-04-05 22:39:04.637153	1	\N	\N
179	Yuk Rossiya---Uzbekistan	Skylog-2	https://t.me/logistikauzru	t	f	2025-04-05 22:39:04.637169	1	\N	\N
180	Международные грузоперевозки (Перевозка 24) грузовые перевозки, фура, дальнобойщик, заказы перевозка груза	Skylog-2	https://t.me/internationalcargotransport	t	f	2025-04-05 22:39:04.637186	1	\N	\N
181	Грузоперевозки по РФ	Skylog-2	https://t.me/gruzivozim	t	f	2025-04-05 22:39:04.637201	1	\N	\N
182	Мировая Перевозка	Skylog-2	https://t.me/logistic01_gruz_mir	t	f	2025-04-05 22:39:04.637217	1	\N	\N
183	ПЕРЕВОЗЧИК	Skylog-2	https://t.me/OOLIONGROUP	t	f	2025-04-05 22:39:04.637233	1	\N	\N
184	Логистика США ЭВРОПА Международная Логистика	Skylog-2	https://t.me/logistics_chat	t	f	2025-04-05 22:39:04.637249	1	\N	\N
185	ПОИСК ГРУЗ 🇷🇺🇪🇺🇹🇷🇹🇲🇺🇿🇹🇯🇰🇿🇰🇬🇧🇾🇦🇿🇺🇦🇬🇪🇦🇲	Skylog-2	https://t.me/world_deliver	t	f	2025-04-05 22:39:04.637269	1	\N	\N
186	Yuk UZB	Skylog-2	https://t.me/logistika_yuk	t	f	2025-04-05 22:39:04.637286	1	\N	\N
187	Грузовые перевозки. Грузчики. Логистика	Skylog-2	https://t.me/perevozkakz	t	f	2025-04-05 22:39:04.637301	1	\N	\N
188	Европа - СНГ. KZ,UZ,TR,UA,AZ,🇪🇺🇹🇷🇰🇿🇰🇬🇦🇿🇺🇿🇺🇦🇮🇷🇱🇹🇧🇾🇲🇳	Skylog-2	https://t.me/LOGISTWAR	t	f	2025-04-05 22:39:04.637321	1	\N	\N
189	Биржа Грузоперевозки Чат	Skylog-2	https://t.me/logistika_gruzoperevozka	t	f	2025-04-05 22:39:04.637337	1	\N	\N
190	Logistic's_24	Skylog-2	https://t.me/Logistics_24	t	f	2025-04-05 22:39:04.637353	1	\N	\N
191	YUK TASHISH XIZMATI L🇺🇿🇺🇿🇺🇿🇺🇿🇺🇿 IM GLOBALTRUCK LOGISTIC	Skylog-2	https://t.me/liderlagist	t	f	2025-04-05 22:39:04.637369	1	\N	\N
192	WORLD LOGISTIC & ЛОГИСТИКА МИРА	Skylog-2	https://t.me/worldlogist	t	f	2025-04-05 22:39:04.637385	1	\N	\N
193	🚚🚛ТЕНТ РЕФ ЮК ТАШИШ 🇺🇿 🇷🇺	Skylog-2	https://t.me/tent_ref_yuktashish	t	f	2025-04-05 22:39:04.637401	1	\N	\N
194	Trak uz	Skylog-2	https://t.me/Trak_uz	t	f	2025-04-05 22:39:04.637416	1	\N	\N
195	ШАФЁРЛАР_УЧУН_ЮК_ГРУППАСИ	Skylog-2	https://t.me/FURA_UZB_24	t	f	2025-04-05 22:39:04.637431	1	\N	\N
196	Грузоперевозки	Skylog-2	https://t.me/gruz16dokument	t	f	2025-04-05 22:39:04.637447	1	\N	\N
197	Грузоперевозки (TTS)	Skylog-2	https://t.me/TransTechSystem	t	f	2025-04-05 22:39:04.637462	1	\N	\N
198	ТЕНТ, РЕФ, ИЗОТЕРМА	Skylog-2	https://t.me/TentRefIzoterm	t	f	2025-04-05 22:39:04.637478	1	\N	\N
199	DODA YUK DUNYO BOYLAB	Skylog-2	https://t.me/ZAKAS_GURUPPA_DODO	t	f	2025-04-05 22:39:04.637501	1	\N	\N
200	Pitak.kz	Skylog-2	https://t.me/pitak_kz_gruzoperevozki	t	f	2025-04-05 22:39:04.637516	1	\N	\N
201	Перевозки	Skylog-2	https://t.me/Botrans96group	t	f	2025-04-05 22:39:04.637531	1	\N	\N
202	Грузы и транспорта по Европе и СНГ 🚚	Skylog-2	https://t.me/allcargoinfo	t	f	2025-04-05 22:39:04.637547	1	\N	\N
203	🚚 YUK MARKAZI 🚛	Skylog-2	https://t.me/yukmarkazigruppa	t	f	2025-04-05 22:39:04.637562	1	\N	\N
204	🚚 ИСУЗУ РЕФ УЗБЕКИСТОН БУЙЛАБ🚚	Skylog-2	https://t.me/gruzref	t	f	2025-04-05 22:39:04.800243	1	\N	\N
205	Чат WorldTransit - Импорт, ВЭД, логистика	Skylog-2	https://t.me/worldtransit_chat	t	f	2025-04-05 22:39:04.800301	1	\N	\N
206	🌎ТРАНСПОРТ ГРУЗЫ ЛОГИСТИКА🌍	Skylog-2	https://t.me/onlytgl	t	f	2025-04-05 22:39:04.800341	1	\N	\N
207	🇺🇿Далныйбой 🇺🇿 Олтиариқ🇷🇺	Skylog-3	https://t.me/DalniyboyOltiariq	t	f	2025-04-05 22:42:50.567822	1	\N	\N
208	ЛОГИСТИКА Международная	Skylog-3	https://t.me/logisticscargo	t	f	2025-04-05 22:42:50.567883	1	\N	\N
209	Truck Транспорт/Грузоперевозки/Логистика/Водители-UA-EU	Skylog-3	https://t.me/truck_world	t	f	2025-04-05 22:42:50.567925	1	\N	\N
210	Перевозки Cargoinfo.UZ🌎🚚📦	Skylog-3	https://t.me/EurAsiaGruz	t	f	2025-04-05 22:42:50.567964	1	\N	\N
211	ЛОГИСТИКА РФ , СНГ,Китай/Logistics Russia -China	Skylog-3	https://t.me/Logistika_all	t	f	2025-04-05 22:42:50.568	1	\N	\N
212	ANDIJON⁸²⁶TOSHKENT_ISUZU_YUK MARKAZI 🚛🚛🚚	Skylog-3	https://t.me/ANDIJON_ISUZU_Yuk_markazi	t	f	2025-04-05 22:42:50.568039	1	\N	\N
213	Юк МаРкаЗ… ²°²°	Skylog-3	https://t.me/yuk_bor_uzz	t	f	2025-04-05 22:42:50.568073	1	\N	\N
214	Yuk markazi |🇺🇿| Yuk bor	Skylog-3	https://t.me/Yuk_markazi_yuk_yukla	t	f	2025-04-05 22:42:50.568108	1	\N	\N
215	KGL	Skylog-3	https://t.me/furauzbb	t	f	2025-04-05 22:42:50.568141	1	\N	\N
216	🇸🇱 MobiGruz 🇸🇱	Skylog-3	https://t.me/Yukla24_uzb	t	f	2025-04-05 22:42:50.568178	1	\N	\N
217	YUK YUKLA	Skylog-3	https://t.me/yuk_yukla_markazi_pitak_Isuzu_uz	t	f	2025-04-05 22:42:50.568211	1	\N	\N
218	Global Freight Exchange	Skylog-3	https://t.me/globalfreightexchange	t	f	2025-04-05 22:42:50.568244	1	\N	\N
219	Логистика мира 🇺🇿🇰🇿🇰🇬🇳🇪🇷🇺🇹🇷🇵🇱🇺🇦	Skylog-3	https://t.me/logistika_s	t	f	2025-04-05 22:42:50.568278	1	\N	\N
220	Õzbekiston Osiyo Dunyo bõylab yuklar	Skylog-3	https://t.me/yuklar_uzb	t	f	2025-04-05 22:42:50.568311	1	\N	\N
221	Furalar balon markazi	Skylog-3	https://t.me/bekavto_uz	t	f	2025-04-05 22:42:50.568343	1	\N	\N
222	Международные грузоперевозка	Skylog-3	https://t.me/XALQARO_YUKLARI	t	f	2025-04-05 22:42:50.568376	1	\N	\N
223	"АКУМ" Грузоперевозки и Водители. Аккумуляторы. +998933931684	Skylog-3	https://t.me/akum_tashkent	t	f	2025-04-05 22:42:50.568409	1	\N	\N
224	🇺🇿YUK BOR🎯 UZB🇺🇿	Skylog-3	https://t.me/yukboruzb	t	f	2025-04-05 22:42:50.568443	1	\N	\N
226	🇺🇿 Logistika super UZB 🇺🇿	Skylog-3	https://t.me/Logistika_super_UZB	t	f	2025-04-05 22:42:50.568513	1	\N	\N
227	🇦🇿🇦🇿🇦🇿АЗЕРБАЙДЖАН ГРУЗОПЕРЕВОЗКИ🇦🇿🇦🇿🇦🇿	Skylog-3	https://t.me/AzerbaijanLogistics	t	f	2025-04-05 22:42:50.568547	1	\N	\N
228	Такси, Грузоперевозки Россия - Узбекистан	Skylog-3	https://t.me/Uz_7771	t	f	2025-04-05 22:42:50.568579	1	\N	\N
229	ХАЛКАРО ЮКЛАР🇺🇿	Skylog-3	https://t.me/S_N_G_RUS_GRUZ	t	f	2025-04-05 22:42:50.568613	1	\N	\N
230	Обрезная Доска ! Росиядан Узбекистонга Тахта ташиймиз.	Skylog-3	https://t.me/muhammadsaid74	t	f	2025-04-05 22:42:50.568645	1	\N	\N
231	Международный логистика 072	Skylog-3	https://t.me/logistika_072	t	f	2025-04-05 22:42:50.568678	1	\N	\N
232	Ўзбекистон бўйлаб	Skylog-3	https://t.me/uzbekiston_boylab_yuk	t	f	2025-04-05 22:42:50.56871	1	\N	\N
233	🇺🇿ShP_Logistic🚛🚚	Skylog-3	https://t.me/shp_logistic	t	f	2025-04-05 22:42:50.568743	1	\N	\N
234	✨🇺🇿Milliy Yuk Karvoni🇺🇿🐫✨	Skylog-3	https://t.me/milyukkar	t	f	2025-04-05 22:42:50.568776	1	\N	\N
235	TR- UZ LOGISTIKA	Skylog-3	https://t.me/UZB_TURK_LOGISTIKA_YUKMARKAZI	t	f	2025-04-05 22:42:50.568808	1	\N	\N
236	🚛Грузовые и Спецшины🚚 mega_baza	Skylog-3	https://t.me/gruzovie_i_specshini	t	f	2025-04-05 22:42:50.568841	1	\N	\N
237	Грузоперевозки Россия - СНГ	Skylog-3	https://t.me/gruzoperevozki_po_sng	t	f	2025-04-05 22:42:50.568873	1	\N	\N
238	TutGruz Перевозки Грузы Логистика	Skylog-3	https://t.me/TutGruz	t	f	2025-04-05 22:42:50.568906	1	\N	\N
239	📢 Della_uz 🚚	Skylog-3	https://t.me/della_uz	t	f	2025-04-05 22:42:50.568938	1	\N	\N
240	Yuk Markazi YukMarkazi ЮК МАРКАЗИ ЮКМАРКАЗИ 🌍🚛	Skylog-3	https://t.me/yukmarkaziuz_N1	t	f	2025-04-05 22:42:50.568971	1	\N	\N
241	YUK GRUPPASI	Skylog-3	https://t.me/isuzuchilar_uzb	t	f	2025-04-05 22:42:50.569003	1	\N	\N
242	Логистика🚛 Украина-Европа🇺🇦🇪🇺	Skylog-3	https://t.me/logistikaua	t	f	2025-04-05 22:42:50.569035	1	\N	\N
243	Логистика Европа СНГ Россия Турция Узбекистан Украина Беларусь Казахстан Таджикистан Киргизия	Skylog-3	https://t.me/logistika_sng_ru_mira_evro_azia	t	f	2025-04-05 22:42:50.569069	1	\N	\N
244	Logistik 🇹🇷🇷🇺🇺🇿🇰🇿🇦🇿🇺🇦	Skylog-3	https://t.me/asiyaeurologistics	t	f	2025-04-05 22:42:50.569105	1	\N	\N
245	Логистика Мира	Skylog-3	https://t.me/worldlogistic	t	f	2025-04-05 22:42:50.569137	1	\N	\N
246	АВТО ПЕРЕВОЗКИ ЛОГИСТИКА	Skylog-3	https://t.me/avtoperevozki	t	f	2025-04-05 22:42:50.569169	1	\N	\N
247	Great Road Logistics.1	Skylog-3	https://t.me/grt12buiop	t	f	2025-04-05 22:42:50.5692	1	\N	\N
248	🇺🇿CHEMPION LOGISTIC🇺🇿	Skylog-3	https://t.me/chempionlogistic	t	f	2025-04-05 22:42:50.569233	1	\N	\N
249	Логистика по России 🚚	Skylog-3	https://t.me/rossia1_2	t	f	2025-04-05 22:42:50.569265	1	\N	\N
250	Мировые грузы россия уз	Skylog-3	https://t.me/dalnoboy44	t	f	2025-04-05 22:42:50.569297	1	\N	\N
251	Логистика по всему миру	Skylog-3	https://t.me/logistics_companyN1	t	f	2025-04-05 22:42:50.569329	1	\N	\N
252	Юк ташиш хизмати/Грузоперевозка	Skylog-3	https://t.me/logisticsystem	t	f	2025-04-05 22:42:50.56936	1	\N	\N
253	ГРУЗОПЕРЕВОЗКИ СНГ	Skylog-3	https://t.me/LOGISTICA_UZBEKISTAN	t	f	2025-04-05 22:42:50.569392	1	\N	\N
254	🇷🇺РОССИЯ - 🇺🇿УЗБЕКИСТАН	Skylog-3	https://t.me/gruzoperevozka_1	t	f	2025-04-05 22:42:50.569426	1	\N	\N
255	Pitak.uz - Грузоперевозки	Skylog-3	https://t.me/pitakuz	t	f	2025-04-05 22:42:50.569458	1	\N	\N
256	"КРАСНОГОРСКИЙ" ЛОГИСТИКА ПО СНГ	Skylog-3	https://t.me/logisticaSNG	t	f	2025-04-05 22:42:50.569491	1	\N	\N
257	МИРОВЫЕ ГРУЗЫ	Skylog-3	https://t.me/DUNYO_BOYLAB_YUKLAR	t	f	2025-04-05 22:42:50.569523	1	\N	\N
258	🚢ПЕРЕВОЗКА ЗЕРНА🚛	Skylog-3	https://t.me/perevozkazerno	t	f	2025-04-05 22:42:50.569555	1	\N	\N
259	🇹🇷🇹🇷Турция логистика	Skylog-3	https://t.me/Turkishlogistic	t	f	2025-04-05 22:42:50.569587	1	\N	\N
260	Азия транспорт	Skylog-3	https://t.me/Trans_ru	t	f	2025-04-05 22:42:50.569619	1	\N	\N
261	Нозим-Трансгрупп🚚	Skylog-3	https://t.me/NozimTransgrupp	t	f	2025-04-05 22:42:50.569652	1	\N	\N
262	ONLINE LOGISTIKA	Skylog-3	https://t.me/online_bozori_yuk	t	f	2025-04-05 22:42:50.569683	1	\N	\N
263	🇺🇿Ўзбекистон бўйлаб юк маркази	Skylog-3	https://t.me/uzyuk77	t	f	2025-04-05 22:42:50.569716	1	\N	\N
264	КАВКАЗ 📦 ГРУЗЫ	Skylog-3	https://t.me/kavkaz_gruzi	t	f	2025-04-05 22:42:50.56975	1	\N	\N
265	Logistical Europe & Asia	Skylog-3	https://t.me/logistical_eu	t	f	2025-04-05 22:42:50.569782	1	\N	\N
266	грузы перевозки	Skylog-3	https://t.me/narimanismayilov	t	f	2025-04-05 22:42:50.569815	1	\N	\N
267	Транспортная компания	Skylog-3	https://t.me/transra	t	f	2025-04-05 22:42:50.569847	1	\N	\N
268	️ГРУЗОПЕРЕВОЗКИ	Skylog-3	https://t.me/MUSTANG_TRANS_KG	t	f	2025-04-05 22:42:50.569879	1	\N	\N
269	Grand silk road Logistics	Skylog-3	https://t.me/GSR_Logistics_N1	t	f	2025-04-05 22:42:50.569911	1	\N	\N
270	Логистика 🌎🌍🌏	Skylog-3	https://t.me/mejlogistika	t	f	2025-04-05 22:42:50.569945	1	\N	\N
271	Доставка грузов по РФ. Автомобильные перевозки	Skylog-3	https://t.me/TK_Express	t	f	2025-04-05 22:42:50.569978	1	\N	\N
272	🌐INTERNATIONAL LAODS📦XALQARO_YUKLAR	Skylog-3	https://t.me/international_loads	t	f	2025-04-05 22:42:50.57002	1	\N	\N
273	YUK🎯TRANS🇺🇿	Skylog-3	https://t.me/YUK_trans_Uzbb	t	f	2025-04-05 22:42:50.570053	1	\N	\N
274	🇹🇲Олот Транспорт🇺🇿	Skylog-3	https://t.me/olottransport	t	f	2025-04-05 22:42:50.570086	1	\N	\N
275	Бухара Логистика	Skylog-3	https://t.me/gruzsgn	t	f	2025-04-05 22:42:50.570119	1	\N	\N
276	Логистика грузоперевозки экспедирование	Skylog-3	https://t.me/gruzoperevozkiRu	t	f	2025-04-05 22:42:50.570152	1	\N	\N
277	CargoAutoTrans	Skylog-3	https://t.me/CargoAuto	t	f	2025-04-05 22:42:50.570184	1	\N	\N
278	МИРОВАЯ ПЕРЕВОЗКА	Skylog-3	https://t.me/mirovoy_gruz01	t	f	2025-04-05 22:42:50.570216	1	\N	\N
279	Gruzovik.uz Самосвалы Спецтехника и другие Грузовые автомобили, Автобазар.уз Авторынок.уз автоУзбекистан автоТашкент🚗🚐🚚🚙🚛	Skylog-3	https://t.me/gruzovik_uzb	t	f	2025-04-05 22:42:50.570274	1	\N	\N
280	🇺🇿Ⓛⓞⓖⓘⓢⓣⓘⓚⓐ🇷🇺	Skylog-3	https://t.me/logistikasite	t	f	2025-04-05 22:42:50.570308	1	\N	\N
281	ОЛТАРИК.Юук Транс	Skylog-3	https://t.me/oltiariq_yuk_tranc	t	f	2025-04-05 22:42:50.57034	1	\N	\N
282	Беларусь, перевозка грузы транспорт логистика TIR BY 🇧🇾 ООО ФеджиТрейд	Skylog-3	https://t.me/cargo_BY	t	f	2025-04-05 22:42:50.570393	1	\N	\N
283	Аграрные перевозки Украина| АГРО | UA | Логистика | Україна	Skylog-3	https://t.me/zernovoz_agro	t	f	2025-04-05 22:42:50.570426	1	\N	\N
284	🇺🇿Samarqand Vodiy yuk markazi🇺🇿	Skylog-3	https://t.me/isuzuuuu	t	f	2025-04-05 22:42:50.570468	1	\N	\N
285	Перевозка Зерна 🌾| Работа для Зерновозов 🌾| Логистика СельхозПродукции 🌾	Skylog-3	https://t.me/TransCorn	t	f	2025-04-05 22:42:50.570503	1	\N	\N
286	AZIYA GRUZ	Skylog-3	https://t.me/AZIYA_GRUZ	t	f	2025-04-05 22:42:50.570535	1	\N	\N
287	ЛОГИСТИКА 🌍🚚📦	Skylog-3	https://t.me/xalqaroyuklar	t	f	2025-04-05 22:42:50.570569	1	\N	\N
288	Dizel moylar filterlar asartimentla bor 100% orginal	Skylog-3	https://t.me/matorniy_maslo	t	f	2025-04-05 22:42:50.57062	1	\N	\N
289	UZBEKİSTON BOYLAB	Skylog-3	https://t.me/YUKMARKAZI_1	t	f	2025-04-05 22:42:50.570652	1	\N	\N
290	Logistic 🌍global group	Skylog-3	https://t.me/logisticsglobal	t	f	2025-04-05 22:42:50.570686	1	\N	\N
291	Международные грузоперевозки🌏	Skylog-3	https://t.me/furatut	t	f	2025-04-05 22:42:50.570719	1	\N	\N
292	Кашкадарё Юк Марказ🚛	Skylog-3	https://t.me/yukmarkazqashqadaryo	t	f	2025-04-05 22:42:50.570752	1	\N	\N
293	Грузы. Турция. Европа. Азия. Грузоперевозки. Заказы. Доставка.	Skylog-3	https://t.me/logtur	t	f	2025-04-05 22:42:50.570784	1	\N	\N
294	🇺🇿БУХОРО🇺🇿 исузу ЮК Ташиш хизмати🌏🌏🚛🚚🇺🇿🇺🇿	Skylog-3	https://t.me/BUXORO_TOSHKENT_YUK_TASHISH	t	f	2025-04-05 22:42:50.570821	1	\N	\N
295	Грузоперевозки РФ СНГ	Skylog-3	https://t.me/perevozki_ufo_msk	t	f	2025-04-05 22:42:50.570853	1	\N	\N
296	Вагоны и Грузы	Skylog-3	https://t.me/logistics1520com	t	f	2025-04-05 22:42:50.570886	1	\N	\N
297	𝐘𝐮𝐤 𝐌𝐚𝐫𝐤𝐚𝐳 2023 🇺🇿	Skylog-3	https://t.me/YUK_MARKAZ_2023	t	f	2025-04-05 22:42:50.570919	1	\N	\N
298	СПЕЦТЕХНИКА 24/7 Аренда / продажа / Грузоперевозки нерудных материалов СЕЛЬХОЗТЕХНИКА диагностика ГРУЗОВИКИ ЗАПЧАСТИ РЕМОНТ РФ	Skylog-3	https://t.me/HcOqxQ7MDbtiYzgy	t	f	2025-04-05 22:42:50.570953	1	\N	\N
299	Грузоперевозки | Поиск груза | BY	Skylog-3	https://t.me/gruz_by	t	f	2025-04-05 22:42:50.570989	1	\N	\N
300	Перевозки Cargoinfo.UZ🌎🚚📦	Skylog-4	https://t.me/EurAsiaGruz	t	f	2025-04-05 22:43:33.68187	1	\N	\N
301	грузы перевозки	Skylog-4	https://t.me/narimanismayilov	t	f	2025-04-05 22:43:33.681934	1	\N	\N
302	Truck Транспорт/Грузоперевозки/Логистика/Водители-UA-EU	Skylog-4	https://t.me/truck_world	t	f	2025-04-05 22:43:33.681977	1	\N	\N
303	TR- UZ LOGISTIKA	Skylog-4	https://t.me/UZB_TURK_LOGISTIKA_YUKMARKAZI	t	f	2025-04-05 22:43:33.682015	1	\N	\N
304	Обрезная Доска ! Росиядан Узбекистонга Тахта ташиймиз.	Skylog-4	https://t.me/muhammadsaid74	t	f	2025-04-05 22:43:33.68205	1	\N	\N
305	Логистика мира 🇺🇿🇰🇿🇰🇬🇳🇪🇷🇺🇹🇷🇵🇱🇺🇦	Skylog-4	https://t.me/logistika_s	t	f	2025-04-05 22:43:33.682086	1	\N	\N
306	Yuk markazi |🇺🇿| Yuk bor	Skylog-4	https://t.me/Yuk_markazi_yuk_yukla	t	f	2025-04-05 22:43:33.682121	1	\N	\N
307	ОЛТАРИК.Юук Транс	Skylog-4	https://t.me/oltiariq_yuk_tranc	t	f	2025-04-05 22:43:33.682155	1	\N	\N
308	✨🇺🇿Milliy Yuk Karvoni🇺🇿🐫✨	Skylog-4	https://t.me/milyukkar	t	f	2025-04-05 22:43:33.682189	1	\N	\N
309	ONLINE LOGISTIKA	Skylog-4	https://t.me/online_bozori_yuk	t	f	2025-04-05 22:43:33.682227	1	\N	\N
310	ЛОГИСТИКА Международная	Skylog-4	https://t.me/logisticscargo	t	f	2025-04-05 22:43:33.68226	1	\N	\N
311	ГРУЗОПЕРЕВОЗКИ СНГ	Skylog-4	https://t.me/LOGISTICA_UZBEKISTAN	t	f	2025-04-05 22:43:33.682293	1	\N	\N
312	🚛Грузовые и Спецшины🚚 mega_baza	Skylog-4	https://t.me/gruzovie_i_specshini	t	f	2025-04-05 22:43:33.682327	1	\N	\N
313	Grand silk road Logistics	Skylog-4	https://t.me/GSR_Logistics_N1	t	f	2025-04-05 22:43:33.682361	1	\N	\N
314	Аграрные перевозки Украина| АГРО | UA | Логистика | Україна	Skylog-4	https://t.me/zernovoz_agro	t	f	2025-04-05 22:43:33.682394	1	\N	\N
315	🇺🇿 Logistika super UZB 🇺🇿	Skylog-4	https://t.me/Logistika_super_UZB	t	f	2025-04-05 22:43:33.682428	1	\N	\N
316	"АКУМ" Грузоперевозки и Водители. Аккумуляторы. +998933931684	Skylog-4	https://t.me/akum_tashkent	t	f	2025-04-05 22:43:33.682462	1	\N	\N
317	АВТО ПЕРЕВОЗКИ ЛОГИСТИКА	Skylog-4	https://t.me/avtoperevozki	t	f	2025-04-05 22:43:33.682495	1	\N	\N
318	Грузы. Турция. Европа. Азия. Грузоперевозки. Заказы. Доставка.	Skylog-4	https://t.me/logtur	t	f	2025-04-05 22:43:33.682531	1	\N	\N
319	🇺🇿YUK BOR🎯 UZB🇺🇿	Skylog-4	https://t.me/yukboruzb	t	f	2025-04-05 22:43:33.682564	1	\N	\N
320	Транспортная компания	Skylog-4	https://t.me/transra	t	f	2025-04-05 22:43:33.682597	1	\N	\N
321	Логистика🚛 Украина-Европа🇺🇦🇪🇺	Skylog-4	https://t.me/logistikaua	t	f	2025-04-05 22:43:33.682634	1	\N	\N
322	Furalar balon markazi	Skylog-4	https://t.me/bekavto_uz	t	f	2025-04-05 22:43:33.682667	1	\N	\N
323	ЛОГИСТИКА РФ , СНГ,Китай/Logistics Russia -China	Skylog-4	https://t.me/Logistika_all	t	f	2025-04-05 22:43:33.682701	1	\N	\N
324	YUK YUKLA	Skylog-4	https://t.me/yuk_yukla_markazi_pitak_Isuzu_uz	t	f	2025-04-05 22:43:33.682733	1	\N	\N
325	YUK GRUPPASI	Skylog-4	https://t.me/isuzuchilar_uzb	t	f	2025-04-05 22:43:33.682766	1	\N	\N
326	Юк МаРкаЗ… ²°²°	Skylog-4	https://t.me/yuk_bor_uzz	t	f	2025-04-05 22:43:33.682798	1	\N	\N
327	МИРОВЫЕ ГРУЗЫ	Skylog-4	https://t.me/DUNYO_BOYLAB_YUKLAR	t	f	2025-04-05 22:43:33.68283	1	\N	\N
328	Беларусь, перевозка грузы транспорт логистика TIR BY 🇧🇾 ООО ФеджиТрейд	Skylog-4	https://t.me/cargo_BY	t	f	2025-04-05 22:43:33.682872	1	\N	\N
329	🇹🇲Олот Транспорт🇺🇿	Skylog-4	https://t.me/olottransport	t	f	2025-04-05 22:43:33.68291	1	\N	\N
330	МИРОВАЯ ПЕРЕВОЗКА	Skylog-4	https://t.me/mirovoy_gruz01	t	f	2025-04-05 22:43:33.682942	1	\N	\N
331	🇺🇿CHEMPION LOGISTIC🇺🇿	Skylog-4	https://t.me/chempionlogistic	t	f	2025-04-05 22:43:33.682975	1	\N	\N
439	Грузоперевозки по РФ. Чат компании ТК "АльфаПилот"	Skylog-5	https://t.me/m_logistik	t	f	2025-04-06 14:58:43.941193	1	\N	\N
332	🇦🇿🇦🇿🇦🇿АЗЕРБАЙДЖАН ГРУЗОПЕРЕВОЗКИ🇦🇿🇦🇿🇦🇿	Skylog-4	https://t.me/AzerbaijanLogistics	t	f	2025-04-05 22:43:33.683012	1	\N	\N
333	Нозим-Трансгрупп🚚	Skylog-4	https://t.me/NozimTransgrupp	t	f	2025-04-05 22:43:33.683046	1	\N	\N
334	YUK🎯TRANS🇺🇿	Skylog-4	https://t.me/YUK_trans_Uzbb	t	f	2025-04-05 22:43:33.683079	1	\N	\N
335	Логистика по всему миру	Skylog-4	https://t.me/logistics_companyN1	t	f	2025-04-05 22:43:33.683112	1	\N	\N
336	Pitak.uz - Грузоперевозки	Skylog-4	https://t.me/pitakuz	t	f	2025-04-05 22:43:33.683145	1	\N	\N
337	🇺🇿Ⓛⓞⓖⓘⓢⓣⓘⓚⓐ🇷🇺	Skylog-4	https://t.me/logistikasite	t	f	2025-04-05 22:43:33.683181	1	\N	\N
338	📢 Della_uz 🚚	Skylog-4	https://t.me/della_uz	t	f	2025-04-05 22:43:33.683215	1	\N	\N
339	🇷🇺РОССИЯ - 🇺🇿УЗБЕКИСТАН	Skylog-4	https://t.me/gruzoperevozka_1	t	f	2025-04-05 22:43:33.683248	1	\N	\N
340	🇺🇿ShP_Logistic🚛🚚	Skylog-4	https://t.me/shp_logistic	t	f	2025-04-05 22:43:33.683281	1	\N	\N
341	ХАЛКАРО ЮКЛАР🇺🇿	Skylog-4	https://t.me/S_N_G_RUS_GRUZ	t	f	2025-04-05 22:43:33.683314	1	\N	\N
342	Global Freight Exchange	Skylog-4	https://t.me/globalfreightexchange	t	f	2025-04-05 22:43:33.683347	1	\N	\N
343	Логистика по России 🚚	Skylog-4	https://t.me/rossia1_2	t	f	2025-04-05 22:43:33.683379	1	\N	\N
344	🇺🇿Далныйбой 🇺🇿 Олтиариқ🇷🇺	Skylog-4	https://t.me/DalniyboyOltiariq	t	f	2025-04-05 22:43:33.683413	1	\N	\N
345	Бухара Логистика	Skylog-4	https://t.me/gruzsgn	t	f	2025-04-05 22:43:33.683446	1	\N	\N
346	"КРАСНОГОРСКИЙ" ЛОГИСТИКА ПО СНГ	Skylog-4	https://t.me/logisticaSNG	t	f	2025-04-05 22:43:33.683479	1	\N	\N
347	🌐INTERNATIONAL LAODS📦XALQARO_YUKLAR	Skylog-4	https://t.me/international_loads	t	f	2025-04-05 22:43:33.683512	1	\N	\N
348	Yuk Markazi YukMarkazi ЮК МАРКАЗИ ЮКМАРКАЗИ 🌍🚛	Skylog-4	https://t.me/yukmarkaziuz_N1	t	f	2025-04-05 22:43:33.683546	1	\N	\N
349	ANDIJON⁸²⁶TOSHKENT_ISUZU_YUK MARKAZI 🚛🚛🚚	Skylog-4	https://t.me/ANDIJON_ISUZU_Yuk_markazi	t	f	2025-04-05 22:43:33.683579	1	\N	\N
350	Ўзбекистон бўйлаб	Skylog-4	https://t.me/uzbekiston_boylab_yuk	t	f	2025-04-05 22:43:33.683612	1	\N	\N
351	Международный_Груз	Skylog-4	https://t.me/Gruz_perevozk	t	f	2025-04-05 22:43:33.683644	1	\N	\N
352	Азия транспорт	Skylog-4	https://t.me/Trans_ru	t	f	2025-04-05 22:43:33.683677	1	\N	\N
353	Мировые грузы россия уз	Skylog-4	https://t.me/dalnoboy44	t	f	2025-04-05 22:43:33.683709	1	\N	\N
354	Логистика Мира	Skylog-4	https://t.me/worldlogistic	t	f	2025-04-05 22:43:33.683741	1	\N	\N
355	TutGruz Перевозки Грузы Логистика	Skylog-4	https://t.me/TutGruz	t	f	2025-04-05 22:43:33.683774	1	\N	\N
356	KGL	Skylog-4	https://t.me/furauzbb	t	f	2025-04-05 22:43:33.683806	1	\N	\N
357	🇸🇱 MobiGruz 🇸🇱	Skylog-4	https://t.me/Yukla24_uzb	t	f	2025-04-05 22:43:33.683839	1	\N	\N
358	Õzbekiston Osiyo Dunyo bõylab yuklar	Skylog-4	https://t.me/yuklar_uzb	t	f	2025-04-05 22:43:33.683872	1	\N	\N
359	Международные грузоперевозка	Skylog-4	https://t.me/XALQARO_YUKLARI	t	f	2025-04-05 22:43:33.683905	1	\N	\N
360	Такси, Грузоперевозки Россия - Узбекистан	Skylog-4	https://t.me/Uz_7771	t	f	2025-04-05 22:43:33.683937	1	\N	\N
361	Международный логистика 072	Skylog-4	https://t.me/logistika_072	t	f	2025-04-05 22:43:33.68397	1	\N	\N
362	Грузоперевозки Россия - СНГ	Skylog-4	https://t.me/gruzoperevozki_po_sng	t	f	2025-04-05 22:43:33.684002	1	\N	\N
363	Логистика Европа СНГ Россия Турция Узбекистан Украина Беларусь Казахстан Таджикистан Киргизия	Skylog-4	https://t.me/logistika_sng_ru_mira_evro_azia	t	f	2025-04-05 22:43:33.684036	1	\N	\N
364	Logistik 🇹🇷🇷🇺🇺🇿🇰🇿🇦🇿🇺🇦	Skylog-4	https://t.me/asiyaeurologistics	t	f	2025-04-05 22:43:33.684069	1	\N	\N
365	Great Road Logistics.1	Skylog-4	https://t.me/grt12buiop	t	f	2025-04-05 22:43:33.684103	1	\N	\N
366	Юк ташиш хизмати/Грузоперевозка	Skylog-4	https://t.me/logisticsystem	t	f	2025-04-05 22:43:33.684136	1	\N	\N
367	🚢ПЕРЕВОЗКА ЗЕРНА🚛	Skylog-4	https://t.me/perevozkazerno	t	f	2025-04-05 22:43:33.684169	1	\N	\N
368	🇹🇷🇹🇷Турция логистика	Skylog-4	https://t.me/Turkishlogistic	t	f	2025-04-05 22:43:33.684202	1	\N	\N
369	🇺🇿Ўзбекистон бўйлаб юк маркази	Skylog-4	https://t.me/uzyuk77	t	f	2025-04-05 22:43:33.684236	1	\N	\N
370	КАВКАЗ 📦 ГРУЗЫ	Skylog-4	https://t.me/kavkaz_gruzi	t	f	2025-04-05 22:43:33.684269	1	\N	\N
371	Logistical Europe & Asia	Skylog-4	https://t.me/logistical_eu	t	f	2025-04-05 22:43:33.684301	1	\N	\N
372	️ГРУЗОПЕРЕВОЗКИ	Skylog-4	https://t.me/MUSTANG_TRANS_KG	t	f	2025-04-05 22:43:33.684335	1	\N	\N
373	Логистика 🌎🌍🌏	Skylog-4	https://t.me/mejlogistika	t	f	2025-04-05 22:43:33.684368	1	\N	\N
374	Доставка грузов по РФ. Автомобильные перевозки	Skylog-4	https://t.me/TK_Express	t	f	2025-04-05 22:43:33.684401	1	\N	\N
375	Логистика грузоперевозки экспедирование	Skylog-4	https://t.me/gruzoperevozkiRu	t	f	2025-04-05 22:43:33.684437	1	\N	\N
376	CargoAutoTrans	Skylog-4	https://t.me/CargoAuto	t	f	2025-04-05 22:43:33.68447	1	\N	\N
377	Gruzovik.uz Самосвалы Спецтехника и другие Грузовые автомобили, Автобазар.уз Авторынок.уз автоУзбекистан автоТашкент🚗🚐🚚🚙🚛	Skylog-4	https://t.me/gruzovik_uzb	t	f	2025-04-05 22:43:33.684507	1	\N	\N
378	🇺🇿Samarqand Vodiy yuk markazi🇺🇿	Skylog-4	https://t.me/isuzuuuu	t	f	2025-04-05 22:43:33.68454	1	\N	\N
379	Перевозка Зерна 🌾| Работа для Зерновозов 🌾| Логистика СельхозПродукции 🌾	Skylog-4	https://t.me/TransCorn	t	f	2025-04-05 22:43:33.684578	1	\N	\N
380	AZIYA GRUZ	Skylog-4	https://t.me/AZIYA_GRUZ	t	f	2025-04-05 22:43:33.684611	1	\N	\N
381	ЛОГИСТИКА 🌍🚚📦	Skylog-4	https://t.me/xalqaroyuklar	t	f	2025-04-05 22:43:33.684645	1	\N	\N
382	Dizel moylar filterlar asartimentla bor 100% orginal	Skylog-4	https://t.me/matorniy_maslo	t	f	2025-04-05 22:43:33.684687	1	\N	\N
383	UZBEKİSTON BOYLAB	Skylog-4	https://t.me/YUKMARKAZI_1	t	f	2025-04-05 22:43:33.68472	1	\N	\N
384	Logistic 🌍global group	Skylog-4	https://t.me/logisticsglobal	t	f	2025-04-05 22:43:33.684754	1	\N	\N
385	Международные грузоперевозки🌏	Skylog-4	https://t.me/furatut	t	f	2025-04-05 22:43:33.684787	1	\N	\N
386	Кашкадарё Юк Марказ🚛	Skylog-4	https://t.me/yukmarkazqashqadaryo	t	f	2025-04-05 22:43:33.68482	1	\N	\N
387	🇺🇿БУХОРО🇺🇿 исузу ЮК Ташиш хизмати🌏🌏🚛🚚🇺🇿🇺🇿	Skylog-4	https://t.me/BUXORO_TOSHKENT_YUK_TASHISH	t	f	2025-04-05 22:43:33.684876	1	\N	\N
388	Грузоперевозки РФ СНГ	Skylog-4	https://t.me/perevozki_ufo_msk	t	f	2025-04-05 22:43:33.684909	1	\N	\N
389	Вагоны и Грузы	Skylog-4	https://t.me/logistics1520com	t	f	2025-04-05 22:43:33.684942	1	\N	\N
390	𝐘𝐮𝐤 𝐌𝐚𝐫𝐤𝐚𝐳 2023 🇺🇿	Skylog-4	https://t.me/YUK_MARKAZ_2023	t	f	2025-04-05 22:43:33.684975	1	\N	\N
391	СПЕЦТЕХНИКА 24/7 Аренда / продажа / Грузоперевозки нерудных материалов СЕЛЬХОЗТЕХНИКА диагностика ГРУЗОВИКИ ЗАПЧАСТИ РЕМОНТ РФ	Skylog-4	https://t.me/HcOqxQ7MDbtiYzgy	t	f	2025-04-05 22:43:33.685009	1	\N	\N
392	Грузоперевозки | Поиск груза | BY	Skylog-4	https://t.me/gruz_by	t	f	2025-04-05 22:43:33.685046	1	\N	\N
393	ReddeR.uz 🚛🚚ReddeR - платформа для владельцев грузов и транспортов	Skylog-5	https://t.me/yukgruppa_dunyo	t	f	2025-04-06 14:58:43.940085	1	\N	\N
394	🇺🇿🎄,YUK🎄🌎🎆MARKAZI🎯_2💯🇺🇿	Skylog-5	https://t.me/yukmarkazi2	t	f	2025-04-06 14:58:43.940127	1	\N	\N
395	Груз перевозки yuk markazi Карго Фрахт	Skylog-5	https://t.me/mycargo	t	f	2025-04-06 14:58:43.940159	1	\N	\N
396	"YUKBOR" ВСЕМИРНЫЕ ГРУЗОПЕРЕВОЗКИ 🇺🇿🇹🇷🇰🇿🇷🇺🇰🇬🇪🇺🇨🇵🇲🇽🇵🇰🇩🇪 DUNYO BOYLAB YUK TASHISH	Skylog-5	https://t.me/shax_1414	t	f	2025-04-06 14:58:43.940187	1	\N	\N
397	🇺🇿🇺🇿ONLINE_YUKMARKAZI🇺🇿🇺🇿	Skylog-5	https://t.me/yuk_uz_24	t	f	2025-04-06 14:58:43.940215	1	\N	\N
398	🇺🇿🚚 Yuk markazi🚚🇺🇿	Skylog-5	https://t.me/yukmarkazi_2022	t	f	2025-04-06 14:58:43.940241	1	\N	\N
399	LOGISTICA 🇺🇿🇹🇷🇷🇺🇪🇺	Skylog-5	https://t.me/LOGISTICAUZ	t	f	2025-04-06 14:58:43.940268	1	\N	\N
400	YUK markazi 🇺🇿	Skylog-5	https://t.me/YUKmarkazi_yuklar_shopirlar	t	f	2025-04-06 14:58:43.940291	1	\N	\N
401	RAVON KARVON LOGISTIC	Skylog-5	https://t.me/logistic_ravonkarvon_gruz	t	f	2025-04-06 14:58:43.940317	1	\N	\N
402	КирАдеН грузоперевозки	Skylog-5	https://t.me/KirAdeNlogistics	t	f	2025-04-06 14:58:43.94034	1	\N	\N
403	Юк маркази👍👍👍👍	Skylog-5	https://t.me/yuk_marka	t	f	2025-04-06 14:58:43.940362	1	\N	\N
404	Дальнобойщик УЗБЕКИСТАНА и СНГ. Куда едим где стоим?	Skylog-5	https://t.me/dalneboyuzsng	t	f	2025-04-06 14:58:43.940384	1	\N	\N
405	Логистика Азия Европа	Skylog-5	https://t.me/logistika_azia	t	f	2025-04-06 14:58:43.940407	1	\N	\N
406	Yuk markazi || Yuk Uzz	Skylog-5	https://t.me/yuk_markazi_yuk_uz	t	f	2025-04-06 14:58:43.940429	1	\N	\N
407	Транспорт Европа-Азия	Skylog-5	https://t.me/ileritranscomrussia	t	f	2025-04-06 14:58:43.940455	1	\N	\N
408	QUADROLATE LOGISTICS ABILITY LTD	Skylog-5	https://t.me/QUADROLATE_EN	t	f	2025-04-06 14:58:43.940477	1	\N	\N
409	СНГ Логистика . Таджикистан 2025 .1	Skylog-5	https://t.me/tug34	t	f	2025-04-06 14:58:43.940502	1	\N	\N
410	ГРУЗЫ от D.L.C. GROUP	Skylog-5	https://t.me/USLUGALOGISTIKA	t	f	2025-04-06 14:58:43.94053	1	\N	\N
411	Samarqand Toshkent va barcha yònalishlarga Yuk tashish xizmati	Skylog-5	https://t.me/yuktashishxizmatisam	t	f	2025-04-06 14:58:43.940554	1	\N	\N
412	ПЕРЕВОЗКА МЕЖДУНАРОДНЫЙ ЮК МАРКАЗИ ЙУК грузоперевозка	Skylog-5	https://t.me/PEREVOZKAuzKGruKZ	t	f	2025-04-06 14:58:43.940576	1	\N	\N
413	LOGIST GROUP	Skylog-5	https://t.me/Yuktashish2021	t	f	2025-04-06 14:58:43.940598	1	\N	\N
414	Логистика Международная 🌍	Skylog-5	https://t.me/Logistika_yuklar	t	f	2025-04-06 14:58:43.94062	1	\N	\N
415	Rossiya O'zbekiston Bo'ylab Yuk va Evakuator Xizmati🚖🚕	Skylog-5	https://t.me/ROSSIYA_UZB_YUKLAR	t	f	2025-04-06 14:58:43.940643	1	\N	\N
416	YUK BOR 🎯 UZ	Skylog-5	https://t.me/Yuk_bor_uzbtrans	t	f	2025-04-06 14:58:43.940665	1	\N	\N
417	🇷🇺 RUS🇹🇷TURK + Europe - LOGISTIKA	Skylog-5	https://t.me/UZB_RUS_TURK_LOGISTIKA	t	f	2025-04-06 14:58:43.94069	1	\N	\N
418	🇺🇿Yuk Tashish xizmati🇷🇺	Skylog-5	https://t.me/yuktashishxiz	t	f	2025-04-06 14:58:43.940713	1	\N	\N
419	🚛 Грузоперевозки 64, 164 🚚💰17. Саратов Россия	Skylog-5	https://t.me/perevozki164	t	f	2025-04-06 14:58:43.940737	1	\N	\N
420	🚚🇸🇱🇸🇱ЕВРОАЗИА ТУРАН ГРУЗОПЕРЕВОЗКИ🇩🇪🇩🇪🚚	Skylog-5	https://t.me/mejdunarodni_yukgurpa	t	f	2025-04-06 14:58:43.940763	1	\N	\N
421	ЛОГИСТИКА 🌏 No1🇷🇺🇺🇿🇰🇿🇦🇿🇦🇹🇧🇾🇵🇼🇹🇲🇹🇷🇹🇯🇰🇬🇪🇺🇻🇳	Skylog-5	https://t.me/Mir_Logistika_No1	t	f	2025-04-06 14:58:43.940787	1	\N	\N
422	Uzbekiston boylab 🇺🇿Ўзбекистон бўйлаб 🇺🇿	Skylog-5	https://t.me/uzbekistonboylabyukla	t	f	2025-04-06 14:58:43.94081	1	\N	\N
423	ISUZU.ЮК ГРУППА ФАКАТ💯	Skylog-5	https://t.me/isuzigrupa	t	f	2025-04-06 14:58:43.940833	1	\N	\N
424	TiRpark,🇺🇿🇺🇿🇹🇷🇹🇷🇺🇿 bu🇹🇷🇹🇷LOGISTIC🌏	Skylog-5	https://t.me/lagovb	t	f	2025-04-06 14:58:43.940858	1	\N	\N
425	FAYZ-LOGISTICS	Skylog-5	https://t.me/fayz_logistic	t	f	2025-04-06 14:58:43.940881	1	\N	\N
426	Грузоперевозки по Россия	Skylog-5	https://t.me/gruzoperevozki_rossia	t	f	2025-04-06 14:58:43.940904	1	\N	\N
427	Международная Логистика	Skylog-5	https://t.me/logistika_uzz	t	f	2025-04-06 14:58:43.940926	1	\N	\N
428	Tilis поиск грузов и транспорта	Skylog-5	https://t.me/tiliscom	t	f	2025-04-06 14:58:43.940951	1	\N	\N
429	Грузоперевозки РФ Чат	Skylog-5	https://t.me/gruzoperevozkiRusi	t	f	2025-04-06 14:58:43.940973	1	\N	\N
430	👉ЮК ГРУППАСИ👈	Skylog-5	https://t.me/pitak_guripasi_yuk_markazi	t	f	2025-04-06 14:58:43.940995	1	\N	\N
431	MING OTLIQ LOGISTIC	Skylog-5	https://t.me/logistikaN1	t	f	2025-04-06 14:58:43.941016	1	\N	\N
432	@OZBEKISTON BOYLAB YUK	Skylog-5	https://t.me/OZBEKISTONBOYLABYUK	t	f	2025-04-06 14:58:43.941037	1	\N	\N
433	Yuk Gruppa	Skylog-5	https://t.me/yuk_gruppa	t	f	2025-04-06 14:58:43.941058	1	\N	\N
434	🇺🇿 BENEFIT 🎯 LOGISTIC 🚚 YUK MARKAZI ®	Skylog-5	https://t.me/Yukmarkazi_lagistik_yukbor	t	f	2025-04-06 14:58:43.94108	1	\N	\N
435	Международные_🎯_ Грузь_🌍🌎🌏	Skylog-5	https://t.me/LOGISTIKA_24	t	f	2025-04-06 14:58:43.941103	1	\N	\N
436	Perevozki.uz	Skylog-5	https://t.me/perevozkinss	t	f	2025-04-06 14:58:43.941125	1	\N	\N
437	Грузовые перевозки Логистика Казахстан, Узбекистан, РФ. Логистика	Skylog-5	https://t.me/logistika_gruzov_dostavka	t	f	2025-04-06 14:58:43.941148	1	\N	\N
438	ДОЛИНА ПЕРЕВОЗКА	Skylog-5	https://t.me/VODIY_BOYLAB_YUKLAR	t	f	2025-04-06 14:58:43.941171	1	\N	\N
440	Friends logisticians	Skylog-5	https://t.me/friendslogisticians	t	f	2025-04-06 14:58:43.941215	1	\N	\N
441	Lardi-Trans.ge	Skylog-5	https://t.me/lardi_ge	t	f	2025-04-06 14:58:43.941236	1	\N	\N
442	🌍🚛 YUK MARKAZI. 🚛 🇸🇱 🇸🇱	Skylog-5	https://t.me/UZBE4	t	f	2025-04-06 14:58:43.941258	1	\N	\N
443	TURKIYA UZBEKISTON YUK MARKAZI	Skylog-5	https://t.me/TURKIYA_UZBEKISTON_GRUBA_N1	t	f	2025-04-06 14:58:43.941279	1	\N	\N
444	Международные грузоперевозки	Skylog-5	https://t.me/logisticpost	t	f	2025-04-06 14:58:43.941301	1	\N	\N
445	YUK TASHISH XIZMATLARI	Skylog-5	https://t.me/yuktashishxizmatlari	t	f	2025-04-06 14:58:43.941322	1	\N	\N
446	♾ ЮК ГРУППА ♾	Skylog-5	https://t.me/yuk_gruppa1	t	f	2025-04-06 14:58:43.941344	1	\N	\N
447	Грузы по России на Авто	Skylog-5	https://t.me/gruzytutRF	t	f	2025-04-06 14:58:43.941367	1	\N	\N
448	LOGISTIKA 🇪🇺 SNG	Skylog-5	https://t.me/LOGISTIKA_SNG	t	f	2025-04-06 14:58:43.94139	1	\N	\N
449	VseGruzy Грузоперевозки Груза Логистика Грузоперевозки по миру	Skylog-5	https://t.me/vsegruzy	t	f	2025-04-06 14:58:43.941413	1	\N	\N
450	📦 Yuk junatish(юк жунатиш) Перевозка таваров 🔞 🇺🇿	Skylog-5	https://t.me/Logistics_com	t	f	2025-04-06 14:58:43.941438	1	\N	\N
451	Мировая логистика🌎	Skylog-5	https://t.me/miruzperevozka	t	f	2025-04-06 14:58:43.941462	1	\N	\N
452	Грузы Китай Турция Россия Беларусь Узбекистан Казахстан Маньчжурия Хоргос Алашанькоу Европа трал негабарит площадка тент	Skylog-5	https://t.me/TvoiGruz	t	f	2025-04-06 14:58:43.941488	1	\N	\N
453	ООО "Транс-Логистик"	Skylog-5	https://t.me/translogisticspbru	t	f	2025-04-06 14:58:43.941512	1	\N	\N
454	ЛОГИСТИКА МЕЖДУНАРОДНЫЙ ПЕРЕВОЗКА	Skylog-5	https://t.me/bbmpy	t	f	2025-04-06 14:58:43.941535	1	\N	\N
455	MY GRUZ 🌍YAN🎯	Skylog-5	https://t.me/YANDEX_GRUZ_YUKMARKAZI_YUKLAR	t	f	2025-04-06 14:58:43.94156	1	\N	\N
456	Груз Центр 🇺🇿 международный логистика снг	Skylog-5	https://t.me/Yuk_Uzb_Rus	t	f	2025-04-06 14:58:43.941584	1	\N	\N
457	🚚YUK🎯MARKAZI🚛🇺🇿💯	Skylog-5	https://t.me/yukmarkazibuxoro	t	f	2025-04-06 14:58:43.941608	1	\N	\N
458	LOGiSTIKA&TRANSPORT	Skylog-5	https://t.me/yuk_markazi_pitaklar	t	f	2025-04-06 14:58:43.941632	1	\N	\N
459	TIRtrans - тент, трал, площадка, негабарит, реф, TIR cargo, груз, ООО ФеджиТрейд	Skylog-5	https://t.me/TIRtrans	t	f	2025-04-06 14:58:43.941657	1	\N	\N
460	EVRO ASIA BUXARA LOGISTIC	Skylog-5	https://t.me/evro_asia_buxara_logistic	t	f	2025-04-06 14:58:43.94168	1	\N	\N
461	Yuk Markazi 🇺🇿🚚🚛	Skylog-5	https://t.me/yuk_tashuvchi	t	f	2025-04-06 14:58:43.941704	1	\N	\N
462	Грузоперевозки РФ🇷🇺 и СНГ🇺🇦🇧🇾🇦🇲🇦🇩🇰🇿🇺🇿	Skylog-5	https://t.me/logisticarsi	t	f	2025-04-06 14:58:43.941729	1	\N	\N
463	LOGISTICS международный	Skylog-5	https://t.me/logistika_uz_ru_tr_kz_global_cng	t	f	2025-04-06 14:58:43.941752	1	\N	\N
464	🚛Грузовые перевозки по Узбекистану с Навои 🚛	Skylog-5	https://t.me/GruzovieperevozkipoUzbekistanu	t	f	2025-04-06 14:58:43.941776	1	\N	\N
465	Самарканд юк маркази	Skylog-5	https://t.me/anvarchik_93	t	f	2025-04-06 14:58:43.941803	1	\N	\N
466	Inter Cargo.uz Логистика🇺🇿🇰🇿🇷🇺	Skylog-5	https://t.me/intercargouzz	t	f	2025-04-06 14:58:43.941827	1	\N	\N
467	Грузоперевозки Логисты	Skylog-5	https://t.me/logist_rf	t	f	2025-04-06 14:58:43.941851	1	\N	\N
468	БУХОРО ИСУЗУ ТРАНС УЗБЕКИСТОН ва ДУНЁ БУЙЛАБ ЮКЛАР	Skylog-5	https://t.me/GURUZAVOYLAR	t	f	2025-04-06 14:58:43.941875	1	\N	\N
469	🚛 🚚 ROAD TRAIL 🚥 ГРУЗОПЕРЕВОЗКИ ЛОГИСТИКА 🚚 🚛	Skylog-5	https://t.me/road_trail_chat	t	f	2025-04-06 14:58:43.941899	1	\N	\N
470	ЭКСПОРТ И ИМПОРТ	Skylog-5	https://t.me/siz_uchun	t	f	2025-04-06 14:58:43.941923	1	\N	\N
471	Yuk markazi 🌐 Gruppa	Skylog-5	https://t.me/Yuk_markazi_Yuk_bor	t	f	2025-04-06 14:58:43.941948	1	\N	\N
472	Tr 🇹🇷 -Ua 🇺🇦 -Ru 🇷🇺 -Az 🇦🇿 -Kz 🇰🇿 -Ks 🇰🇬 - Ge 🇬🇪	Skylog-5	https://t.me/emirfrigo	t	f	2025-04-06 14:58:43.941972	1	\N	\N
473	🚛🚛YUKLAR GRUPPA🚛🚛🚛	Skylog-5	https://t.me/yuklar_gruppa	t	f	2025-04-06 14:58:43.941998	1	\N	\N
474	Груз и Догруз🇺🇿🇷🇺🇰🇿🇰🇬🇹🇯🇹🇷🇹🇲🇦🇿🇪🇺🇺🇦🇧🇾🇬🇪🇦🇲	Skylog-5	https://t.me/Gruzaperevozki_po_miru	t	f	2025-04-06 14:58:43.942022	1	\N	\N
475	XALQARO LOGİSTİK IMPORT EXPORT	Skylog-5	https://t.me/Xalqaro_logistika	t	f	2025-04-06 14:58:43.942046	1	\N	\N
476	🇺🇿Logistic Number 1®©™	Skylog-5	https://t.me/Salamovtransgroup	t	f	2025-04-06 14:58:43.94207	1	\N	\N
477	YUK MARKAZI	Skylog-5	https://t.me/yuk_markazii	t	f	2025-04-06 14:58:43.942093	1	\N	\N
478	ЎЗБЕКИСТОН БЎЙЛАБ ЮК	Skylog-5	https://t.me/YUKTASHUZB	t	f	2025-04-06 14:58:43.942117	1	\N	\N
479	ПЕРЕВОЗКА УЗБ-РУС-ТУРК	Skylog-5	https://t.me/perevoskamirn1	t	f	2025-04-06 14:58:43.942141	1	\N	\N
480	IM Global Truck Logistic...	Skylog-5	https://t.me/EAlogist	t	f	2025-04-06 14:58:43.942164	1	\N	\N
481	Узбекистон буйлаб Logistics group	Skylog-5	https://t.me/Uzbekiston_buylab	t	f	2025-04-06 14:58:43.942188	1	\N	\N
482	Yuk markazi Katta Uzbek trakti 🇸🇱🇸🇱 📢📢📢 🚛🚛🚛	Skylog-5	https://t.me/Katta_uzbek_trakti_yuk_markazi	t	f	2025-04-06 14:58:43.942212	1	\N	\N
483	Транспорт🚛 Грузы📦 грузоперевозки, логистика, cargo	Skylog-5	https://t.me/cargo_asia	t	f	2025-04-06 14:58:43.942237	1	\N	\N
484	Халкаро йуналиш Европа,СНГ!Эпи, электрон очередь🇺🇿🇺🇿🇰🇲🇨🇴🇨🇨🇨🇩🇨🇮🇨🇷🇩🇰🇩🇰🇨🇾🇨🇼🇨🇺🇨🇴🇨🇬🇨🇩	Skylog-5	https://t.me/logistika11	t	f	2025-04-06 14:58:43.942263	1	\N	\N
485	ГРУЗ	Skylog-5	https://t.me/Uzbekyukchilari	t	f	2025-04-06 14:58:43.942287	1	\N	\N
486	UZB🇺🇿 🚚 📦 LOGISTIKA Turkiya🇹🇷	Skylog-5	https://t.me/Ahmad77lagistik	t	f	2025-04-06 14:58:43.942313	1	\N	\N
487	LOADS TODAY - Грузоперевозки по Европе	Skylog-5	https://t.me/Loadstoday	t	f	2025-04-06 14:58:43.942335	1	\N	\N
488	Логистика Россия и СНГ	Skylog-5	https://t.me/logika86	t	f	2025-04-06 14:58:43.942356	1	\N	\N
489	ЯВЕЗУ-Грузоперевозки/Логистика	Skylog-5	https://t.me/YAVEZUGRUPP	t	f	2025-04-06 14:58:43.942377	1	\N	\N
490	Логистика АВТО 🚛	Skylog-5	https://t.me/logistics_avto	t	f	2025-04-06 14:58:43.942399	1	\N	\N
491	Аптека PROFF | Чат	Skylog-5	https://t.me/aptekaproff_ru_chat	t	f	2025-04-06 14:58:44.079625	1	\N	\N
492	Международная Логистика	Skylog-6	https://t.me/logistika_uzz	t	f	2025-04-06 14:59:22.584722	1	\N	\N
493	🇺🇿🚚 Yuk markazi🚚🇺🇿	Skylog-6	https://t.me/yukmarkazi_2022	t	f	2025-04-06 14:59:22.584781	1	\N	\N
494	LOGISTIKA 🇪🇺 SNG	Skylog-6	https://t.me/LOGISTIKA_SNG	t	f	2025-04-06 14:59:22.584814	1	\N	\N
495	Юк маркази👍👍👍👍	Skylog-6	https://t.me/yuk_marka	t	f	2025-04-06 14:59:22.584844	1	\N	\N
496	Груз Центр 🇺🇿 международный логистика снг	Skylog-6	https://t.me/Yuk_Uzb_Rus	t	f	2025-04-06 14:59:22.584874	1	\N	\N
497	Транспорт Европа-Азия	Skylog-6	https://t.me/ileritranscomrussia	t	f	2025-04-06 14:59:22.584903	1	\N	\N
498	👉ЮК ГРУППАСИ👈	Skylog-6	https://t.me/pitak_guripasi_yuk_markazi	t	f	2025-04-06 14:59:22.584934	1	\N	\N
499	YUK markazi 🇺🇿	Skylog-6	https://t.me/YUKmarkazi_yuklar_shopirlar	t	f	2025-04-06 14:59:22.584963	1	\N	\N
500	QUADROLATE LOGISTICS ABILITY LTD	Skylog-6	https://t.me/QUADROLATE_EN	t	f	2025-04-06 14:59:22.584991	1	\N	\N
501	Самарканд юк маркази	Skylog-6	https://t.me/anvarchik_93	t	f	2025-04-06 14:59:22.585019	1	\N	\N
502	🇺🇿🎄,YUK🎄🌎🎆MARKAZI🎯_2💯🇺🇿	Skylog-6	https://t.me/yukmarkazi2	t	f	2025-04-06 14:59:22.585048	1	\N	\N
503	MING OTLIQ LOGISTIC	Skylog-6	https://t.me/logistikaN1	t	f	2025-04-06 14:59:22.585075	1	\N	\N
504	🚛🚛YUKLAR GRUPPA🚛🚛🚛	Skylog-6	https://t.me/yuklar_gruppa	t	f	2025-04-06 14:59:22.585103	1	\N	\N
505	Логистика АВТО 🚛	Skylog-6	https://t.me/logistics_avto	t	f	2025-04-06 14:59:22.585131	1	\N	\N
506	🚚🇸🇱🇸🇱ЕВРОАЗИА ТУРАН ГРУЗОПЕРЕВОЗКИ🇩🇪🇩🇪🚚	Skylog-6	https://t.me/mejdunarodni_yukgurpa	t	f	2025-04-06 14:59:22.585159	1	\N	\N
507	Samarqand Toshkent va barcha yònalishlarga Yuk tashish xizmati	Skylog-6	https://t.me/yuktashishxizmatisam	t	f	2025-04-06 14:59:22.585188	1	\N	\N
508	🇺🇿Yuk Tashish xizmati🇷🇺	Skylog-6	https://t.me/yuktashishxiz	t	f	2025-04-06 14:59:22.585216	1	\N	\N
509	ДОЛИНА ПЕРЕВОЗКА	Skylog-6	https://t.me/VODIY_BOYLAB_YUKLAR	t	f	2025-04-06 14:59:22.585244	1	\N	\N
510	Rossiya O'zbekiston Bo'ylab Yuk va Evakuator Xizmati🚖🚕	Skylog-6	https://t.me/ROSSIYA_UZB_YUKLAR	t	f	2025-04-06 14:59:22.585274	1	\N	\N
511	Inter Cargo.uz Логистика🇺🇿🇰🇿🇷🇺	Skylog-6	https://t.me/intercargouzz	t	f	2025-04-06 14:59:22.585305	1	\N	\N
512	♾ ЮК ГРУППА ♾	Skylog-6	https://t.me/yuk_gruppa1	t	f	2025-04-06 14:59:22.585333	1	\N	\N
513	Perevozki.uz	Skylog-6	https://t.me/perevozkinss	t	f	2025-04-06 14:59:22.58536	1	\N	\N
514	ЛОГИСТИКА МЕЖДУНАРОДНЫЙ ПЕРЕВОЗКА	Skylog-6	https://t.me/bbmpy	t	f	2025-04-06 14:59:22.585391	1	\N	\N
515	Yuk Markazi 🇺🇿🚚🚛	Skylog-6	https://t.me/yuk_tashuvchi	t	f	2025-04-06 14:59:22.58542	1	\N	\N
516	КирАдеН грузоперевозки	Skylog-6	https://t.me/KirAdeNlogistics	t	f	2025-04-06 14:59:22.585448	1	\N	\N
517	Yuk Gruppa	Skylog-6	https://t.me/yuk_gruppa	t	f	2025-04-06 14:59:22.585475	1	\N	\N
518	БУХОРО ИСУЗУ ТРАНС УЗБЕКИСТОН ва ДУНЁ БУЙЛАБ ЮКЛАР	Skylog-6	https://t.me/GURUZAVOYLAR	t	f	2025-04-06 14:59:22.585506	1	\N	\N
519	ГРУЗ	Skylog-6	https://t.me/Uzbekyukchilari	t	f	2025-04-06 14:59:22.585534	1	\N	\N
520	Груз перевозки yuk markazi Карго Фрахт	Skylog-6	https://t.me/mycargo	t	f	2025-04-06 14:59:22.585562	1	\N	\N
521	Yuk markazi || Yuk Uzz	Skylog-6	https://t.me/yuk_markazi_yuk_uz	t	f	2025-04-06 14:59:22.585589	1	\N	\N
522	Грузоперевозки по РФ. Чат компании ТК "АльфаПилот"	Skylog-6	https://t.me/m_logistik	t	f	2025-04-06 14:59:22.585616	1	\N	\N
523	Дальнобойщик УЗБЕКИСТАНА и СНГ. Куда едим где стоим?	Skylog-6	https://t.me/dalneboyuzsng	t	f	2025-04-06 14:59:22.585644	1	\N	\N
524	LOGISTICS международный	Skylog-6	https://t.me/logistika_uz_ru_tr_kz_global_cng	t	f	2025-04-06 14:59:22.585671	1	\N	\N
525	Груз и Догруз🇺🇿🇷🇺🇰🇿🇰🇬🇹🇯🇹🇷🇹🇲🇦🇿🇪🇺🇺🇦🇧🇾🇬🇪🇦🇲	Skylog-6	https://t.me/Gruzaperevozki_po_miru	t	f	2025-04-06 14:59:22.585701	1	\N	\N
526	EVRO ASIA BUXARA LOGISTIC	Skylog-6	https://t.me/evro_asia_buxara_logistic	t	f	2025-04-06 14:59:22.585728	1	\N	\N
527	RAVON KARVON LOGISTIC	Skylog-6	https://t.me/logistic_ravonkarvon_gruz	t	f	2025-04-06 14:59:22.585755	1	\N	\N
528	VseGruzy Грузоперевозки Груза Логистика Грузоперевозки по миру	Skylog-6	https://t.me/vsegruzy	t	f	2025-04-06 14:59:22.585791	1	\N	\N
529	🚛 Грузоперевозки 64, 164 🚚💰17. Саратов Россия	Skylog-6	https://t.me/perevozki164	t	f	2025-04-06 14:59:22.585819	1	\N	\N
530	Yuk markazi Katta Uzbek trakti 🇸🇱🇸🇱 📢📢📢 🚛🚛🚛	Skylog-6	https://t.me/Katta_uzbek_trakti_yuk_markazi	t	f	2025-04-06 14:59:22.58585	1	\N	\N
531	ГРУЗЫ от D.L.C. GROUP	Skylog-6	https://t.me/USLUGALOGISTIKA	t	f	2025-04-06 14:59:22.585877	1	\N	\N
532	LOGISTICA 🇺🇿🇹🇷🇷🇺🇪🇺	Skylog-6	https://t.me/LOGISTICAUZ	t	f	2025-04-06 14:59:22.585905	1	\N	\N
533	MY GRUZ 🌍YAN🎯	Skylog-6	https://t.me/YANDEX_GRUZ_YUKMARKAZI_YUKLAR	t	f	2025-04-06 14:59:22.585932	1	\N	\N
534	Грузы Китай Турция Россия Беларусь Узбекистан Казахстан Маньчжурия Хоргос Алашанькоу Европа трал негабарит площадка тент	Skylog-6	https://t.me/TvoiGruz	t	f	2025-04-06 14:59:22.585962	1	\N	\N
535	LOGiSTIKA&TRANSPORT	Skylog-6	https://t.me/yuk_markazi_pitaklar	t	f	2025-04-06 14:59:22.585989	1	\N	\N
536	Логистика Россия и СНГ	Skylog-6	https://t.me/logika86	t	f	2025-04-06 14:59:22.586016	1	\N	\N
537	🇺🇿🇺🇿ONLINE_YUKMARKAZI🇺🇿🇺🇿	Skylog-6	https://t.me/yuk_uz_24	t	f	2025-04-06 14:59:22.586044	1	\N	\N
538	ReddeR.uz 🚛🚚ReddeR - платформа для владельцев грузов и транспортов	Skylog-6	https://t.me/yukgruppa_dunyo	t	f	2025-04-06 14:59:22.586076	1	\N	\N
539	📦 Yuk junatish(юк жунатиш) Перевозка таваров 🔞 🇺🇿	Skylog-6	https://t.me/Logistics_com	t	f	2025-04-06 14:59:22.586104	1	\N	\N
540	"YUKBOR" ВСЕМИРНЫЕ ГРУЗОПЕРЕВОЗКИ 🇺🇿🇹🇷🇰🇿🇷🇺🇰🇬🇪🇺🇨🇵🇲🇽🇵🇰🇩🇪 DUNYO BOYLAB YUK TASHISH	Skylog-6	https://t.me/shax_1414	t	f	2025-04-06 14:59:22.586138	1	\N	\N
541	ISUZU.ЮК ГРУППА ФАКАТ💯	Skylog-6	https://t.me/isuzigrupa	t	f	2025-04-06 14:59:22.586166	1	\N	\N
542	Международные_🎯_ Грузь_🌍🌎🌏	Skylog-6	https://t.me/LOGISTIKA_24	t	f	2025-04-06 14:59:22.586193	1	\N	\N
543	Грузоперевозки Логисты	Skylog-6	https://t.me/logist_rf	t	f	2025-04-06 14:59:22.58622	1	\N	\N
544	Узбекистон буйлаб Logistics group	Skylog-6	https://t.me/Uzbekiston_buylab	t	f	2025-04-06 14:59:22.586247	1	\N	\N
545	Грузоперевозки РФ🇷🇺 и СНГ🇺🇦🇧🇾🇦🇲🇦🇩🇰🇿🇺🇿	Skylog-6	https://t.me/logisticarsi	t	f	2025-04-06 14:59:22.586275	1	\N	\N
546	TiRpark,🇺🇿🇺🇿🇹🇷🇹🇷🇺🇿 bu🇹🇷🇹🇷LOGISTIC🌏	Skylog-6	https://t.me/lagovb	t	f	2025-04-06 14:59:22.586302	1	\N	\N
547	TIRtrans - тент, трал, площадка, негабарит, реф, TIR cargo, груз, ООО ФеджиТрейд	Skylog-6	https://t.me/TIRtrans	t	f	2025-04-06 14:59:22.58633	1	\N	\N
548	🚛 🚚 ROAD TRAIL 🚥 ГРУЗОПЕРЕВОЗКИ ЛОГИСТИКА 🚚 🚛	Skylog-6	https://t.me/road_trail_chat	t	f	2025-04-06 14:59:22.586358	1	\N	\N
549	🇺🇿Logistic Number 1®©™	Skylog-6	https://t.me/Salamovtransgroup	t	f	2025-04-06 14:59:22.586385	1	\N	\N
550	🇷🇺 RUS🇹🇷TURK + Europe - LOGISTIKA	Skylog-6	https://t.me/UZB_RUS_TURK_LOGISTIKA	t	f	2025-04-06 14:59:22.586413	1	\N	\N
551	🚛Грузовые перевозки по Узбекистану с Навои 🚛	Skylog-6	https://t.me/GruzovieperevozkipoUzbekistanu	t	f	2025-04-06 14:59:22.58644	1	\N	\N
552	🚚YUK🎯MARKAZI🚛🇺🇿💯	Skylog-6	https://t.me/yukmarkazibuxoro	t	f	2025-04-06 14:59:22.586468	1	\N	\N
553	ПЕРЕВОЗКА МЕЖДУНАРОДНЫЙ ЮК МАРКАЗИ ЙУК грузоперевозка	Skylog-6	https://t.me/PEREVOZKAuzKGruKZ	t	f	2025-04-06 14:59:22.586496	1	\N	\N
554	Халкаро йуналиш Европа,СНГ!Эпи, электрон очередь🇺🇿🇺🇿🇰🇲🇨🇴🇨🇨🇨🇩🇨🇮🇨🇷🇩🇰🇩🇰🇨🇾🇨🇼🇨🇺🇨🇴🇨🇬🇨🇩	Skylog-6	https://t.me/logistika11	t	f	2025-04-06 14:59:22.586525	1	\N	\N
555	YUK TASHISH XIZMATLARI	Skylog-6	https://t.me/yuktashishxizmatlari	t	f	2025-04-06 14:59:22.586556	1	\N	\N
556	Грузы по России на Авто	Skylog-6	https://t.me/gruzytutRF	t	f	2025-04-06 14:59:22.586584	1	\N	\N
557	ПЕРЕВОЗКА УЗБ-РУС-ТУРК	Skylog-6	https://t.me/perevoskamirn1	t	f	2025-04-06 14:59:22.586612	1	\N	\N
558	Lardi-Trans.ge	Skylog-6	https://t.me/lardi_ge	t	f	2025-04-06 14:59:22.586639	1	\N	\N
559	XALQARO LOGİSTİK IMPORT EXPORT	Skylog-6	https://t.me/Xalqaro_logistika	t	f	2025-04-06 14:59:22.586666	1	\N	\N
560	Грузоперевозки по Россия	Skylog-6	https://t.me/gruzoperevozki_rossia	t	f	2025-04-06 14:59:22.586694	1	\N	\N
561	Tr 🇹🇷 -Ua 🇺🇦 -Ru 🇷🇺 -Az 🇦🇿 -Kz 🇰🇿 -Ks 🇰🇬 - Ge 🇬🇪	Skylog-6	https://t.me/emirfrigo	t	f	2025-04-06 14:59:22.586726	1	\N	\N
562	Мировая логистика🌎	Skylog-6	https://t.me/miruzperevozka	t	f	2025-04-06 14:59:22.586754	1	\N	\N
563	LOGIST GROUP	Skylog-6	https://t.me/Yuktashish2021	t	f	2025-04-06 14:59:22.586781	1	\N	\N
564	Логистика Международная 🌍	Skylog-6	https://t.me/Logistika_yuklar	t	f	2025-04-06 14:59:22.586808	1	\N	\N
565	Логистика Азия Европа	Skylog-6	https://t.me/logistika_azia	t	f	2025-04-06 14:59:22.586835	1	\N	\N
566	YUK BOR 🎯 UZ	Skylog-6	https://t.me/Yuk_bor_uzbtrans	t	f	2025-04-06 14:59:22.586862	1	\N	\N
567	ЎЗБЕКИСТОН БЎЙЛАБ ЮК	Skylog-6	https://t.me/YUKTASHUZB	t	f	2025-04-06 14:59:22.586888	1	\N	\N
568	YUK MARKAZI	Skylog-6	https://t.me/yuk_markazii	t	f	2025-04-06 14:59:22.586915	1	\N	\N
569	Uzbekiston boylab 🇺🇿Ўзбекистон бўйлаб 🇺🇿	Skylog-6	https://t.me/uzbekistonboylabyukla	t	f	2025-04-06 14:59:22.586944	1	\N	\N
570	ООО "Транс-Логистик"	Skylog-6	https://t.me/translogisticspbru	t	f	2025-04-06 14:59:22.586971	1	\N	\N
571	Tilis поиск грузов и транспорта	Skylog-6	https://t.me/tiliscom	t	f	2025-04-06 14:59:22.586998	1	\N	\N
572	СНГ Логистика . Таджикистан 2025 .1	Skylog-6	https://t.me/tug34	t	f	2025-04-06 14:59:22.587044	1	\N	\N
573	ЛОГИСТИКА 🌏 No1🇷🇺🇺🇿🇰🇿🇦🇿🇦🇹🇧🇾🇵🇼🇹🇲🇹🇷🇹🇯🇰🇬🇪🇺🇻🇳	Skylog-6	https://t.me/Mir_Logistika_No1	t	f	2025-04-06 14:59:22.587072	1	\N	\N
574	FAYZ-LOGISTICS	Skylog-6	https://t.me/fayz_logistic	t	f	2025-04-06 14:59:22.587098	1	\N	\N
575	Грузоперевозки РФ Чат	Skylog-6	https://t.me/gruzoperevozkiRusi	t	f	2025-04-06 14:59:22.587125	1	\N	\N
576	@OZBEKISTON BOYLAB YUK	Skylog-6	https://t.me/OZBEKISTONBOYLABYUK	t	f	2025-04-06 14:59:22.587151	1	\N	\N
577	🇺🇿 BENEFIT 🎯 LOGISTIC 🚚 YUK MARKAZI ®	Skylog-6	https://t.me/Yukmarkazi_lagistik_yukbor	t	f	2025-04-06 14:59:22.587179	1	\N	\N
578	Грузовые перевозки Логистика Казахстан, Узбекистан, РФ. Логистика	Skylog-6	https://t.me/logistika_gruzov_dostavka	t	f	2025-04-06 14:59:22.587206	1	\N	\N
579	Friends logisticians	Skylog-6	https://t.me/friendslogisticians	t	f	2025-04-06 14:59:22.587233	1	\N	\N
580	🌍🚛 YUK MARKAZI. 🚛 🇸🇱 🇸🇱	Skylog-6	https://t.me/UZBE4	t	f	2025-04-06 14:59:22.58726	1	\N	\N
581	TURKIYA UZBEKISTON YUK MARKAZI	Skylog-6	https://t.me/TURKIYA_UZBEKISTON_GRUBA_N1	t	f	2025-04-06 14:59:22.587287	1	\N	\N
582	Международные грузоперевозки	Skylog-6	https://t.me/logisticpost	t	f	2025-04-06 14:59:22.587313	1	\N	\N
583	ЭКСПОРТ И ИМПОРТ	Skylog-6	https://t.me/siz_uchun	t	f	2025-04-06 14:59:22.58734	1	\N	\N
584	Yuk markazi 🌐 Gruppa	Skylog-6	https://t.me/Yuk_markazi_Yuk_bor	t	f	2025-04-06 14:59:22.587368	1	\N	\N
585	IM Global Truck Logistic...	Skylog-6	https://t.me/EAlogist	t	f	2025-04-06 14:59:22.587395	1	\N	\N
586	Транспорт🚛 Грузы📦 грузоперевозки, логистика, cargo	Skylog-6	https://t.me/cargo_asia	t	f	2025-04-06 14:59:22.587423	1	\N	\N
587	UZB🇺🇿 🚚 📦 LOGISTIKA Turkiya🇹🇷	Skylog-6	https://t.me/Ahmad77lagistik	t	f	2025-04-06 14:59:22.587451	1	\N	\N
588	LOADS TODAY - Грузоперевозки по Европе	Skylog-6	https://t.me/Loadstoday	t	f	2025-04-06 14:59:22.587477	1	\N	\N
589	ЯВЕЗУ-Грузоперевозки/Логистика	Skylog-6	https://t.me/YAVEZUGRUPP	t	f	2025-04-06 14:59:22.587504	1	\N	\N
590	Аптека PROFF | Чат	Skylog-6	https://t.me/aptekaproff_ru_chat	t	f	2025-04-06 14:59:22.757892	1	\N	\N
591	@Logistik_yuk_markaz🎯🌍🌐 ОФИЦИАЛЬНЫЙ	Skylog-7	https://t.me/yuk_markaz_gruz	t	f	2025-04-06 15:00:22.104947	1	\N	\N
592	Allians Logistik 🌏🚚🚛	Skylog-7	https://t.me/alyagruz	t	f	2025-04-06 15:00:22.105085	1	\N	\N
593	ДОГРУЗ, ПОИСК ГРУЗА, ПО ТЕРРИТОРИИ РОССИИ, ЕС и СНГ /// Cargo search on the territory of Russia, the EU and the CIS	Skylog-7	https://t.me/dogruzpoisk	t	f	2025-04-06 15:00:22.105182	1	\N	\N
594	Логистика Снг Европа Азия	Skylog-7	https://t.me/logistikasn	t	f	2025-04-06 15:00:22.105265	1	\N	\N
595	Грузоперевозки | ЮГ ЮФО СКФО	Skylog-7	https://t.me/RusGruz	t	f	2025-04-06 15:00:22.105345	1	\N	\N
596	European logistic	Skylog-7	https://t.me/european_logistics	t	f	2025-04-06 15:00:22.105423	1	\N	\N
597	Грузоперевозки зерновозам	Skylog-7	https://t.me/Zernovoz1	t	f	2025-04-06 15:00:22.105497	1	\N	\N
598	Amir_TIR_Park	Skylog-7	https://t.me/Amir_TIR_Park	t	f	2025-04-06 15:00:22.105571	1	\N	\N
599	🇺🇿🇺🇿🇺🇿🚦🚛🚨TIR PARK ГРУЗЫ-УЗБЕКИСТАН СНГ- ЕВРОПА -ЗАПЧАСТИ🚨🚛🚛🚦🛑🇺🇿🇺🇿🇺🇿	Skylog-7	https://t.me/DalnaboyUZInternational	t	f	2025-04-06 15:00:22.105649	1	\N	\N
600	Грузоперевозки 24/7.РФ 🇷🇺	Skylog-7	https://t.me/wezem	t	f	2025-04-06 15:00:22.105724	1	\N	\N
601	LOGISTIKA	Skylog-7	https://t.me/logistikaaa	t	f	2025-04-06 15:00:22.105816	1	\N	\N
\.


--
-- Data for Name: message_group_user; Type: TABLE DATA; Schema: public; Owner: akbarov
--

COPY public.message_group_user (id, user_id, message_id, message_group_id, is_deleted, created_at, created_by, updated_at, updated_by, checked) FROM stdin;
65	6	34	591	f	2025-04-12 16:40:10.947034	6	\N	\N	f
66	6	35	591	f	2025-04-12 18:10:58.975891	6	\N	\N	f
67	6	36	591	f	2025-04-12 19:01:48.421831	6	\N	\N	f
68	6	37	591	f	2025-04-12 19:42:18.887231	6	\N	\N	f
69	6	38	591	f	2025-04-13 12:48:17.844727	6	\N	\N	f
70	6	39	591	f	2025-04-13 14:21:03.345845	6	\N	\N	f
71	6	40	591	f	2025-04-13 17:36:15.496343	6	\N	\N	f
72	6	41	591	f	2025-04-13 18:34:15.789056	6	\N	\N	f
25	24	42	2	f	2025-04-09 23:39:13.053486	24	\N	\N	f
26	24	42	3	f	2025-04-09 23:39:13.053486	24	\N	\N	f
27	24	42	6	f	2025-04-09 23:39:13.053486	24	\N	\N	f
21	6	19	2	f	2025-04-06 15:20:52.332534	6	\N	\N	f
22	6	23	591	f	2025-04-07 02:53:36.889584	6	\N	\N	f
23	6	23	596	f	2025-04-07 02:53:36.889584	6	\N	\N	f
24	6	27	591	f	2025-04-07 02:56:09.14571	6	\N	\N	f
41	6	27	2	f	2025-04-10 21:20:55.877127	6	\N	\N	f
53	6	29	591	f	2025-04-12 14:27:44.180189	6	\N	\N	f
42	25	31	591	f	2025-04-12 14:06:07.242132	25	\N	\N	f
43	25	31	592	f	2025-04-12 14:06:07.242132	25	\N	\N	f
44	25	31	593	f	2025-04-12 14:06:07.242132	25	\N	\N	f
45	25	31	594	f	2025-04-12 14:06:07.242132	25	\N	\N	f
46	25	31	595	f	2025-04-12 14:06:07.242132	25	\N	\N	f
47	25	31	596	f	2025-04-12 14:06:07.242132	25	\N	\N	f
48	25	31	597	f	2025-04-12 14:06:07.242132	25	\N	\N	f
49	25	31	598	f	2025-04-12 14:06:07.242132	25	\N	\N	f
50	25	31	599	f	2025-04-12 14:06:07.242132	25	\N	\N	f
51	25	31	600	f	2025-04-12 14:06:07.242132	25	\N	\N	f
52	25	31	601	f	2025-04-12 14:06:07.242132	25	\N	\N	f
54	26	32	591	f	2025-04-12 14:34:05.798668	26	\N	\N	f
55	26	32	592	f	2025-04-12 14:34:05.798668	26	\N	\N	f
56	26	32	593	f	2025-04-12 14:34:05.798668	26	\N	\N	f
57	26	32	594	f	2025-04-12 14:34:05.798668	26	\N	\N	f
58	26	32	595	f	2025-04-12 14:34:05.798668	26	\N	\N	f
59	26	32	596	f	2025-04-12 14:34:05.798668	26	\N	\N	f
60	26	32	597	f	2025-04-12 14:34:05.798668	26	\N	\N	f
61	26	32	598	f	2025-04-12 14:34:05.798668	26	\N	\N	f
62	26	32	599	f	2025-04-12 14:34:05.798668	26	\N	\N	f
63	26	32	600	f	2025-04-12 14:34:05.798668	26	\N	\N	f
64	26	32	601	f	2025-04-12 14:34:05.798668	26	\N	\N	f
28	24	42	12	f	2025-04-09 23:39:13.053486	24	\N	\N	f
29	24	42	13	f	2025-04-09 23:39:13.053486	24	\N	\N	f
30	24	42	591	f	2025-04-09 23:41:39.153235	24	\N	\N	f
31	24	42	592	f	2025-04-09 23:41:39.153235	24	\N	\N	f
32	24	42	593	f	2025-04-09 23:41:39.153235	24	\N	\N	f
33	24	42	594	f	2025-04-09 23:41:39.153235	24	\N	\N	f
34	24	42	595	f	2025-04-09 23:41:39.153235	24	\N	\N	f
35	24	42	596	f	2025-04-09 23:41:39.153235	24	\N	\N	f
36	24	42	597	f	2025-04-09 23:41:39.153235	24	\N	\N	f
37	24	42	598	f	2025-04-09 23:41:39.153235	24	\N	\N	f
38	24	42	599	f	2025-04-09 23:41:39.153235	24	\N	\N	f
39	24	42	600	f	2025-04-09 23:41:39.153235	24	\N	\N	f
40	24	42	601	f	2025-04-09 23:41:39.153235	24	\N	\N	f
73	28	\N	2	f	2025-04-14 02:42:11.665519	28	\N	\N	f
74	28	\N	3	f	2025-04-14 02:42:11.665519	28	\N	\N	f
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, first_name, last_name, phone, password, chat_id, lang, role, publish_day, is_active, is_deleted, created_at, created_by, updated_at, updated_by) FROM stdin;
1	Admin	Adminov	99812345678	123	123456789	uz	ADMIN	\N	t	f	\N	\N	\N	\N
-1	System	User	99800000000	system	0	uz	SYSTEM	\N	t	f	\N	\N	\N	\N
25	Ислам	Зарипов	998200007934	123	7717082619	Russian 🇷🇺	STUDENT	0	t	f	\N	\N	\N	\N
8	Fathulla	Latipov	998977262700	123	575148251	Russian 🇷🇺	STUDENT	0	f	f	\N	\N	\N	\N
\.


--
-- Name: language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akbarov
--

SELECT pg_catalog.setval('public.language_id_seq', 403, true);


--
-- Name: message_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akbarov
--

SELECT pg_catalog.setval('public.message_group_id_seq', 601, true);


--
-- Name: message_group_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: akbarov
--

SELECT pg_catalog.setval('public.message_group_user_id_seq', 74, true);


--
-- Name: message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.message_id_seq', 42, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 29, true);


--
-- Name: language language_pkey; Type: CONSTRAINT; Schema: public; Owner: akbarov
--

ALTER TABLE ONLY public.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);


--
-- Name: message_group message_group_pkey; Type: CONSTRAINT; Schema: public; Owner: akbarov
--

ALTER TABLE ONLY public.message_group
    ADD CONSTRAINT message_group_pkey PRIMARY KEY (id);


--
-- Name: message_group_user message_group_user_pkey; Type: CONSTRAINT; Schema: public; Owner: akbarov
--

ALTER TABLE ONLY public.message_group_user
    ADD CONSTRAINT message_group_user_pkey PRIMARY KEY (id);


--
-- Name: message message_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message
    ADD CONSTRAINT message_pkey PRIMARY KEY (id);


--
-- Name: user user_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_phone_key UNIQUE (phone);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES public."user"(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO akbarov;


--
-- Name: TABLE message; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.message TO akbarov;


--
-- Name: SEQUENCE message_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.message_id_seq TO akbarov;


--
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."user" TO akbarov;


--
-- Name: SEQUENCE user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.user_id_seq TO akbarov;


--
-- PostgreSQL database dump complete
--

