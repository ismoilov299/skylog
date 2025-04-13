import json
import logging
import asyncio
from datetime import datetime, timedelta
import traceback

logger = logging.getLogger(__name__)

SCHEDULED_MESSAGES_KEY = "scheduled_messages"
_scheduler_task = None


async def schedule_message(user_id, message_text, timer, phone, message_id):
    from configs.redis_config import get_redis_client
    from services.telegram import send_message_to_group

    try:
        # Darhol xabarni yuborish
        await send_message_to_group(user_id, message_id, message_text, phone)
        logger.info(f"Xabar {message_id} darhol jo'natildi")

        # Keyingi yuborish vaqtini hisoblash
        next_send_time = int((datetime.now() + timedelta(minutes=timer)).timestamp())

        # Xabar ma'lumotlarini tayyorlash
        message_data = {
            "user_id": user_id,
            "message": message_text,
            "timer": timer,
            "phone": phone,
            "message_id": message_id,
            "scheduled_at": next_send_time
        }

        # Redis bilan ishlash
        redis = await get_redis_client()

        # Mavjud xabarlarni tekshirish va o'chirish
        all_items = await redis.zrange(SCHEDULED_MESSAGES_KEY, 0, -1)
        for item in all_items:
            try:
                existing_data = json.loads(item)
                if existing_data.get("message_id") == message_id:
                    await redis.zrem(SCHEDULED_MESSAGES_KEY, item)
                    logger.info(f"Xabar {message_id} ning oldingi nusxasi o'chirildi")
            except:
                continue

        # Yangi xabarni saqlash
        serialized_data = json.dumps(message_data)
        result = await redis.zadd(SCHEDULED_MESSAGES_KEY, {serialized_data: next_send_time})

        # Redis-dagi xabarlarni log qilish
        all_scheduled = await redis.zrange(SCHEDULED_MESSAGES_KEY, 0, -1, withscores=True)
        logger.info(f"Redis-dagi rejalar soni: {len(all_scheduled)}")
        for item, score in all_scheduled:
            try:
                item_data = json.loads(item)
                if int(item_data.get("message_id")) == int(message_id):
                    logger.info(
                        f"Xabar {message_id} Redis-ga saqlandi, rejalashtirish vaqti: {datetime.fromtimestamp(score)}")
            except:
                continue

        # Xabarni jo'natilganini qayd qilish
        from models.message import Message
        await Message.change_send_time(message_id)

        # Scheduler ishga tushirilganini tekshirish
        global _scheduler_task
        if _scheduler_task is None or _scheduler_task.done():
            logger.warning("Scheduler task mavjud emas yoki to'xtagan, qayta ishga tushirilmoqda!")
            _scheduler_task = asyncio.create_task(process_scheduled_messages())

        return True
    except Exception as e:
        logger.error(f"Xabarni rejalashtirish xatoligi: {str(e)}")
        logger.error(traceback.format_exc())
        return False


async def cancel_scheduled_message(message_id):
    try:
        from configs.redis_config import get_redis_client
        redis = await get_redis_client()

        # Barcha rejalashtirilgan xabarlarni olish
        all_scheduled = await redis.zrange(SCHEDULED_MESSAGES_KEY, 0, -1)

        # message_id bo'yicha topib o'chirish
        found = False
        for item in all_scheduled:
            try:
                message_data = json.loads(item)
                if int(message_data.get("message_id")) == int(message_id):
                    await redis.zrem(SCHEDULED_MESSAGES_KEY, item)
                    found = True
                    logger.info(f"Xabar {message_id} rejadan o'chirildi")
            except:
                continue

        if not found:
            logger.warning(f"Xabar {message_id} rejada topilmadi")

        return True
    except Exception as e:
        logger.error(f"Xabarni bekor qilishda xatolik: {str(e)}")
        logger.error(traceback.format_exc())
        return False


async def process_scheduled_messages():
    logger.info("===== XABARLARNI QAYTA ISHLASH JARAYONI BOSHLANDI =====")
    logger.info(f"Joriy vaqt: {datetime.now()}")

    # Har 5 daqiqada xato bo'lmasa ham log yozamiz
    last_heartbeat = datetime.now()

    while True:
        try:
            # Har 5 daqiqada "hayotiylik" signalini yuborish
            now = datetime.now()
            if (now - last_heartbeat).total_seconds() > 300:  # 5 daqiqa
                logger.info(f"===== SCHEDULER ISHLAYAPTI ===== Joriy vaqt: {now}")
                last_heartbeat = now

            # Redis va boshqa kerakli importlar
            from configs.redis_config import get_redis_client
            from services.telegram import send_message_to_group
            from models.message import Message
            from configs.database_config import engine  # Engine bu yerdan import qiling

            redis = await get_redis_client()
            current_time = int(datetime.now().timestamp())

            # Vaqti kelgan xabarlarni olish
            try:
                scheduled = await redis.zrangebyscore(SCHEDULED_MESSAGES_KEY, min=0, max=current_time)
                if scheduled:
                    logger.info(f"{len(scheduled)} ta rejalashtirilgan xabar topildi. Vaqt: {datetime.now()}")
            except Exception as re:
                logger.error(f"Redis-dan xabarlarni olishda xatolik: {str(re)}")
                logger.error(traceback.format_exc())
                await asyncio.sleep(30)
                continue

            for item in scheduled:
                try:
                    message_data = json.loads(item)
                    user_id = message_data["user_id"]
                    message_text = message_data["message"]
                    timer = message_data["timer"]
                    phone = message_data["phone"]
                    message_id = message_data["message_id"]

                    logger.info(f"Xabar {message_id} qayta ishlanmoqda, vaqt: {datetime.now()}")

                    # Redis-dan joriy rejalashtirishni o'chirish
                    removed = await redis.zrem(SCHEDULED_MESSAGES_KEY, item)
                    logger.info(f"Redis-dan {message_id} o'chirildi: {removed}")

                    # Ma'lumotlar bazasidan xabar statusini tekshirish
                    message_table = Message.metadata.tables.get("message")
                    with engine.connect() as conn:  # Message.engine o'rniga engine ishlatiladi
                        query = message_table.select().where(
                            Message.id == message_id,
                            Message.is_deleted == False
                        )
                        result = conn.execute(query).fetchone()

                        # Agar xabar topilmasa, keyingisiga o'tish
                        if not result:
                            logger.warning(f"Xabar {message_id} ma'lumotlar bazasida topilmadi")
                            continue

                        is_active = result[4]  # status maydonining indeksi
                        logger.info(f"Xabar {message_id} statusi: {is_active}")

                        # Agar xabar faol bo'lmasa, keyingisiga o'tish
                        if not is_active:
                            logger.info(f"Xabar {message_id} faol emas, o'tkazib yuborildi")
                            continue

                    # Xabarni yuborish
                    logger.info(f"Xabar {message_id} yuborilmoqda...")
                    success = await send_message_to_group(user_id, message_id, message_text, phone)

                    if success:
                        # Xabarni yuborgan so'ng vaqtni yangilash
                        await Message.change_send_time(message_id)

                        # Qayta rejalashtirish
                        next_send_time = int((datetime.now() + timedelta(minutes=timer)).timestamp())
                        await redis.zadd(SCHEDULED_MESSAGES_KEY, {json.dumps(message_data): next_send_time})
                        logger.info(f"Xabar {message_id} yuborildi va {timer} daqiqadan so'ng qayta rejalashtirildi")
                    else:
                        logger.warning(f"Xabar {message_id} yuborilmadi, 1 daqiqadan so'ng qayta uriniladi")
                        next_send_time = int((datetime.now() + timedelta(minutes=1)).timestamp())
                        await redis.zadd(SCHEDULED_MESSAGES_KEY, {json.dumps(message_data): next_send_time})
                except Exception as e:
                    logger.error(f"Xabarni qayta ishlashda xatolik: {str(e)}")
                    logger.error(traceback.format_exc())

            # Kutish vaqti
            if not scheduled:
                await asyncio.sleep(30)  # Xabarlar bo'lmasa, 30 soniya kutish
            else:
                await asyncio.sleep(5)  # Xabarlar bo'lsa, tezroq tekshirish
        except Exception as e:
            logger.error(f"Redis scheduler xatolik: {str(e)}")
            logger.error(traceback.format_exc())
            await asyncio.sleep(30)  # Xatolik bo'lsa uzoqroq kutish


async def start_redis_scheduler():
    logger.info("===== REDIS SCHEDULER ISHGA TUSHIRILMOQDA =====")

    try:
        # Redis-ga ulanish testini amalga oshirish
        from configs.redis_config import get_redis_client
        redis = await get_redis_client()
        await redis.ping()
        logger.info("Redis serveriga ulanish muvaffaqiyatli!")

        # Redis-dagi barcha xabarlarni tekshirish
        all_items = await redis.zrange(SCHEDULED_MESSAGES_KEY, 0, -1, withscores=True)
        if all_items:
            logger.info(f"Redis-da {len(all_items)} ta xabar mavjud")
            for item, score in all_items:
                try:
                    item_data = json.loads(item)
                    logger.info(
                        f"Redis-da xabar {item_data.get('message_id')} topildi, vaqti: {datetime.fromtimestamp(score)}")
                except:
                    continue
        else:
            logger.info("Redis-da hech qanday xabar yo'q")

        # Global o'zgaruvchi orqali task saqlash
        global _scheduler_task
        if _scheduler_task is not None and not _scheduler_task.done():
            logger.info("Scheduler task allaqachon ishlayapti, yangi task yaratish shart emas")
            return _scheduler_task

        # Background task yaratish
        _scheduler_task = asyncio.create_task(process_scheduled_messages())
        logger.info("===== REDIS SCHEDULER MUVAFFAQIYATLI ISHGA TUSHIRILDI =====")

        # Task statusini tekshirish
        await asyncio.sleep(1)
        if _scheduler_task.done():
            if _scheduler_task.exception():
                logger.error(f"Redis scheduler task xatolik bilan to'xtadi: {_scheduler_task.exception()}")
                logger.error(traceback.format_exc())
                raise _scheduler_task.exception()
            else:
                logger.error("Redis scheduler task kutilmaganda to'xtadi!")
                raise Exception("Task kutilmaganda to'xtadi")
        else:
            logger.info("Redis scheduler task muvaffaqiyatli ishlamoqda")

        return _scheduler_task
    except Exception as e:
        logger.error(f"Redis schedulerni ishga tushirishda xatolik: {str(e)}")
        logger.error(traceback.format_exc())
        raise