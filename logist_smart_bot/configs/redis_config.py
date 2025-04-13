import logging
import redis.asyncio as redis

logger = logging.getLogger(__name__)

REDIS_HOST = "localhost"
REDIS_PORT = 6379
REDIS_DB = 0
REDIS_PASSWORD = None
REDIS_URL = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_DB}"

_redis_pool = None


async def get_redis_client():
    global _redis_pool

    if _redis_pool is None:
        try:
            _redis_pool = redis.Redis(
                host=REDIS_HOST,
                port=REDIS_PORT,
                db=REDIS_DB,
                password=REDIS_PASSWORD,
                decode_responses=True
            )

            await _redis_pool.ping()
        except Exception as e:
            logger.error(f"Redis bilan ulanishda xatolik: {str(e)}")
            raise

    return _redis_pool


async def close_redis_connection():
    global _redis_pool

    if _redis_pool is not None:
        await _redis_pool.close()
        _redis_pool = None
        logger.info("Redis ulanishi yopildi")