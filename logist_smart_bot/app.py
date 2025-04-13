import asyncio
import logging
from aiogram import executor
from configs.bot_config import dp, bot

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def on_startup(dp):
    logger.info("===== BOT ISHGA TUSHIRILMOQDA =====")
    try:
        from services.scheduler import start_redis_scheduler
        scheduler_task = await start_redis_scheduler()
        logger.info(f"Redis scheduler task yaratildi: {scheduler_task}")
    except Exception as e:
        logger.error(f"Redis scheduler ishga tushirishda xatolik: {str(e)}")
        import traceback
        logger.error(traceback.format_exc())


async def on_shutdown(dp):
    logger.info("Bot to'xtatilmoqda...")
    try:
        from services.telegram import close_telegram_clients
        from configs.redis_config import close_redis_connection
        await close_telegram_clients()
        await close_redis_connection()
        logger.info("Bot to'xtatildi")
    except Exception as e:
        logger.error(f"Botni to'xtatishda xatolik: {str(e)}")


if __name__ == '__main__':
    logging.basicConfig(level=logging.DEBUG)

    try:
        from handlers import handler

        print("Bot handlers loaded successfully")
        executor.start_polling(dp, skip_updates=False)
    except Exception as e:
        print(f"Critical error: {str(e)}")
        import traceback

        traceback.print_exc()