import asyncio
from aiogram import executor
from aiogram import types
from load_all import bot, dp
from handlers import DBCommands
from keyboards import ListOfButtons
from filters import *
from config import admin_id

db = DBCommands()
chat_id = -408750395

async def answer():
    row = await db.last_question()
    if row is not None:
        answer = row["answer"]
        text = f"Правильный ответ на предыдущий вопрос: {answer}"
        await bot.send_message(chat_id, text)
        if row["topic"] == "ЕГЭ":
            await bot.edit_message_reply_markup(row["chat_id"], row["message_id"])
        

async def pub():
    question = await db.get_random_question()
    if question["topic"] == "ЕГЭ":      
        keyboard = ListOfButtons(
            text=["А", "Б", "В","Г"],
            callback=["А", "Б", "В", "Г"],
            align = [2,2]
        ).inline_keyboard
        message = await bot.send_photo(chat_id, photo = question["body"], reply_markup=keyboard)
    else:
        message = await bot.send_photo(chat_id, photo = question["body"])
    await db.save_published_question(chat_id, question["quest_id"], message["message_id"])

loop = asyncio.get_event_loop()
loop.run_until_complete(answer())
loop.run_until_complete(pub())
loop.run_until_complete(bot.close())
loop.stop()


 