import asyncio
from aiogram import executor

from config import admin_id
from load_all import bot


# Подождем пока запустится база данных...

async def on_startup(dp):
await asyncio.sleep(10)
await create_db()

async def on_shutdown(dp):
    await bot.close()

if __name__ == '__main__':
    from handlers import dp

    executor.start_polling(dp, on_shutdown=on_shutdown)
