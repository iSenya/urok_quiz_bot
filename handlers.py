from aiogram import types
from asyncpg import Connection, Record
from asyncpg.exceptions import UniqueViolationError
from aiogram.types import Message, CallbackQuery
from keyboards import ListOfButtons
from config import admin_id
from filters import *
from datetime import datetime, timedelta
from load_all import bot, dp, db

from fuzzywuzzy import fuzz
from fuzzywuzzy import process

class DBCommands:
    GET_CURRENT_QUEST_ID = "SELECT quest_id FROM publications ORDER BY pubdate DESC LIMIT 1"
    pool: Connection = db
    ADD_NEW_USER_REFERRAL = "INSERT INTO users(user_id, username, full_name, referral) " \
                            "VALUES ($1, $2, $3, $4) RETURNING id"
    ADD_NEW_USER = "INSERT INTO users(user_id, username, full_name) VALUES ($1, $2, $3) RETURNING id"
    COUNT_USERS = "SELECT COUNT(*) FROM users"
    GET_ID = "SELECT id FROM users WHERE user_id = $1"
    CHECK_REFERRALS = "SELECT user_id FROM users WHERE referral=" \
                      "(SELECT id FROM users WHERE user_id=$1)"
    CHECK_BALANCE = "SELECT SUM(points) AS balance FROM answers WHERE user_id = $1"
    MORE = "UPDATE users SET balance=balance+$1 WHERE user_id = $2"
    CHECK_ANSWER = "SELECT q.answer FROM questions AS q INNER JOIN publications AS p ON q.quest_id = p.quest_id ORDER BY p.pubdate DESC LIMIT 1"
    GET_RANDOM_QUESTION = "SELECT body, quest_id, topic FROM questions WHERE quest_id NOT IN (SELECT quest_id FROM answers WHERE pubdate > $1) ORDER BY RANDOM() LIMIT 1"
    SAVE_PUBLISHED_QUESTION = "INSERT INTO publications(chat_id, quest_id, pubdate, message_id) VALUES ($1, $2, current_timestamp, $3)"
    ADD_POINTS = "INSERT INTO answers(chat_id, user_id, quest_id, points, pubdate) VALUES ($1, $2, $3, $4, current_timestamp)"
    CHECK_POINTS_EGE = "SELECT COUNT(*) FROM answers WHERE user_id = $1 AND quest_id = $2"
    CHECK_POINTS_S = "SELECT COUNT(*) FROM answers WHERE user_id = $1 AND quest_id = $2 AND points > 0"
    LAST_QUESTION = "SELECT p.chat_id, p.quest_id, p.pubdate, q.answer, q.topic, p.message_id FROM publications AS p INNER JOIN questions AS q ON p.quest_id = q.quest_id ORDER BY p.pubdate DESC LIMIT 1"
    TOP_10 = "SELECT user_id, chat_id, SUM(points) as balance FROM answers GROUP BY user_id, chat_id ORDER BY balance DESC LIMIT 10"

    async def add_new_user(self, referral=None):
        user = types.User.get_current()

        user_id = user.id
        username = user.username
        full_name = user.full_name
        args = user_id, username, full_name

        if referral:
            args += (int(referral),)
            command = self.ADD_NEW_USER_REFERRAL
        else:
            command = self.ADD_NEW_USER

        try:
            record_id = await self.pool.fetchval(command, *args)
            return record_id
        except UniqueViolationError:
            pass
    
    async def get_current_quest_id(self):
        return await self.pool.fetchval(self.GET_CURRENT_QUEST_ID)
        
    async def count_users(self):
        record: Record = await self.pool.fetchval(self.COUNT_USERS)
        return record

    async def get_id(self):
        command = self.GET_ID
        user_id = types.User.get_current().id
        return await self.pool.fetchval(command, user_id)

    async def check_referrals(self):
        user_id = types.User.get_current().id
        command = self.CHECK_REFERRALS
        rows = await self.pool.fetch(command, user_id)
        return ", ".join([
            f"{num + 1}. " + (await bot.get_chat(user["user_id"])).get_mention(as_html=True)
            for num, user in enumerate(rows)
        ])

    async def check_balance(self):
        command = self.CHECK_BALANCE
        user_id = types.User.get_current().id
        return await self.pool.fetchval(command, user_id)
    
    async def top_10(self):
        return await self.pool.fetch(self.TOP_10)

    async def get_random_question(self):
        row = await self.pool.fetchrow(self.GET_RANDOM_QUESTION, datetime.utcnow() - timedelta(minutes = 1))
        return row
    
    async def save_published_question(self, chat_id, quest_id, message_id):
        publication = await self.pool.fetchrow(self.SAVE_PUBLISHED_QUESTION, chat_id, quest_id, message_id)
        return publication

    async def last_question(self):
        publish_answer = await self.pool.fetchrow(self.LAST_QUESTION)
        return publish_answer
    
    async def check_answer(self):
        command = self.CHECK_ANSWER
        return await self.pool.fetchval(command)
    
    async def add_points(self, points):
        command = self.ADD_POINTS
        chat_id = types.Chat.get_current().id
        user_id = types.User.get_current().id
        quest_id = await self.get_current_quest_id()
        return await self.pool.fetchval(command, chat_id, user_id, quest_id, points)

    async def check_points(self, isEGE):
        if isEGE:
            command = self.CHECK_POINTS_EGE
        else:
            command = self.CHECK_POINTS_S
        chat_id = types.Chat.get_current().id
        user_id = types.User.get_current().id
        quest_id = await self.get_current_quest_id()
        return await self.pool.fetchval(command, user_id, quest_id)

    # async def more(self, money):
    #     command = self.MORE
    #     user_id = types.User.get_current().id
    #     return await self.pool.fetchval(command, money, user_id)


db = DBCommands()

@dp.message_handler(commands=["start"])
async def register_user(message: types.Message):
    chat_id = types.Chat.get_current().id
    user_id = message.from_user.id
    referral = message.get_args()
    id = await db.add_new_user(referral=referral)
    count_users = await db.count_users()

    text = ""
    if not id:
        id = await db.get_id()
    else:
        text += "Записал в базу! "

    bot_username = (await bot.me).username
    bot_link = f"https://t.me/{bot_username}?start={id}"
    balance = await db.check_balance()
    text += f"""
Сейчас играют {count_users} человек/а!
Добавиться в бот: {bot_link}

"""

    await bot.send_message(chat_id, text)

async def check_button(call: CallbackQuery):
    answer = await db.check_answer()
    user_id = call.from_user.id
    text1 = "Вы уже отвечали на этот вопрос."
    text2 = "Ваш баланс увеличился на 1 балл."
    text3 = "Неверно"
    is_answered = await db.check_points(True)
    if is_answered:
        await bot.send_message(user_id, text1)
    elif call.data == answer:
        await db.add_points(1)
        await bot.send_message(user_id, text2)
    else:
        await db.add_points(0)
        await bot.send_message(user_id, text3)     

@dp.message_handler(commands=["referrals"])
async def check_referrals(message: types.Message):
    referrals = await db.check_referrals()
    text = f"Ваши рефералы:\n{referrals}"

    await message.answer(text)

@dp.message_handler(commands=["balance"])
async def balance(message: Message):
    user_id = message.from_user.id
    balance = await db.check_balance()

    text = f"""
    Ваш баланс: {balance} балла/ов
    """
    await bot.send_message(user_id, text)

@dp.message_handler(commands=["stat"])
async def stat(message: Message):
    top_10 = [dict(rec) for rec in await db.top_10()]
    chat_id = types.Chat.get_current().id
    for user in top_10:
        try:
            user["username"] = (await types.Chat.get_current().get_member(user["user_id"])).user.username
        except:
            user["username"] = "Аноним"
    text = "Top-10 учеников: \n"
    for index, user in enumerate(top_10):
        text+= f"{index+1}. @{user['username']}: {user['balance']}\n"
    
    await bot.send_message(chat_id, text)

@dp.message_handler(commands=["help"])
async def help(message: types.Message):
    chat_id = types.Chat.get_current().id
    bot_username = (await bot.me).username
    bot_link = f"https://t.me/{bot_username}"
    text = f"Привет! Добро пожаловать в чат квиза UrOk!\nОтветы бот принимает после знака "/", либо нажатием на кнопку А, Б, В, Г \nПроверить статистику чата: \n/stat\nПроверить свой баланс(в ЛС): \n/balance\nПригласить друга: \n{bot_link}\nХэштег в соцсетях: \n#quizurok\nFacebook: \nhttps://www.facebook.com/urokhelsinki/\nДонаты на добро: \n+358504723648\n(MobilePay, Revolut)"
    await bot.send_message(chat_id, text)

# @dp.message_handler(commands=["more"])
# async def more(message: types.Message):
#     photo = await db.get_random_question()
#     if db.topic == "ЕГЭ":      
#         keyboard = ListOfButtons(
#             text=["А", "Б", "В","Г"],
#             callback=["А", "Б", "В", "Г"],
#             align = [2,2]
#         ).inline_keyboard
#         await message.reply_photo(photo=photo, reply_markup=keyboard)
#     else:
#         await message.reply_photo(photo=photo)

@dp.message_handler(text_startswith="/")
async def answer(message: Message):
    user_answer = message.text[1:]
    answer = await db.check_answer()
    user_id = message.from_user.id
    chat_id = message.chat.id
    text1 = "Вы уже отвечали правильно."
    text2 = f" Правильный ответ: {answer}.\nВаш баланс не изменился."
    text3 = "Неверно"
    text4 = "Да" 
    is_answered = await db.check_points(False)
    await bot.delete_message(message.chat.id, message.message_id)
    username = message.from_user.username 
    if is_answered:
        await bot.send_message(user_id, text1 + text2)
    elif fuzz.ratio(user_answer.lower(), answer) >= 80 or fuzz.token_sort_ratio(user_answer.lower(), answer) >= 80:
        await db.add_points(1)
        await bot.send_message(message.chat.id, f"@{username}, вы ответили верно")
    else:
        await bot.send_message(user_id, text2)

@dp.callback_query_handler(Button("А"))
async def с_btn1(call: CallbackQuery):
    await check_button(call)
    await call.answer()

@dp.callback_query_handler(Button("Б"))
async def с_btn2(call: CallbackQuery):
    await check_button(call)
    await call.answer() 

@dp.callback_query_handler(Button("В"))
async def с_btn3(call: CallbackQuery): 
    await check_button(call)
    await call.answer()
    
@dp.callback_query_handler(Button("Г"))
async def с_btn4(call: CallbackQuery):
    await check_button(call)
    await call.answer()
