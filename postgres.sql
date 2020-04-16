DROP TABLE IF EXISTS "answers";
CREATE TABLE "public"."answers" (
    "chat_id" bigint NOT NULL,
    "user_id" integer NOT NULL,
    "quest_id" integer NOT NULL,
    "points" integer NOT NULL,
    "pubdate" timestamp NOT NULL,
    CONSTRAINT "answers_quest_id_user_id_chat_id" PRIMARY KEY ("quest_id", "user_id", "chat_id")
) WITH (oids = false);

INSERT INTO "answers" ("chat_id", "user_id", "quest_id", "points", "pubdate") VALUES
(-1001459093310,	393784565,	6,	0,	'2020-04-15 20:52:38.566992'),
(-1001459093310,	279723948,	6,	1,	'2020-04-15 21:03:59.954446'),
(-1001459093310,	279723948,	5,	1,	'2020-04-15 21:04:45.240081'),
(-1001459093310,	393784565,	5,	1,	'2020-04-15 21:58:06.055298'),
(-1001459093310,	908229290,	5,	1,	'2020-04-16 05:06:31.46941'),
(-1001459093310,	279723948,	11,	1,	'2020-04-16 09:38:22.264774'),
(-1001459093310,	908229290,	11,	1,	'2020-04-16 09:38:41.973496'),
(-1001459093310,	1067878660,	11,	1,	'2020-04-16 09:42:45.302822');

DROP TABLE IF EXISTS "publications";
CREATE TABLE "public"."publications" (
    "chat_id" bigint NOT NULL,
    "quest_id" integer NOT NULL,
    "pubdate" timestamp NOT NULL,
    "message_id" integer NOT NULL,
    CONSTRAINT "publications_chat_id_quest_id_pubdate" PRIMARY KEY ("chat_id", "quest_id", "pubdate")
) WITH (oids = false);

INSERT INTO "publications" ("chat_id", "quest_id", "pubdate", "message_id") VALUES
(-1001459093310,	6,	'2020-04-15 20:44:26.94715',	311),
(-1001459093310,	5,	'2020-04-15 21:04:43.20799',	318),
(-1001459093310,	11,	'2020-04-16 09:37:56.151897',	345);

DROP TABLE IF EXISTS "questions";
DROP SEQUENCE IF EXISTS questions_id_seq;
CREATE SEQUENCE questions_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."questions" (
    "quest_id" bigint NOT NULL,
    "topic" text,
    "body" text,
    "id" integer DEFAULT nextval('questions_id_seq') NOT NULL,
    "answer" text,
    CONSTRAINT "questions_id_uindex" UNIQUE ("id"),
    CONSTRAINT "questions_pk" PRIMARY KEY ("quest_id")
) WITH (oids = false);

INSERT INTO "questions" ("quest_id", "topic", "body", "id", "answer") VALUES
(1,	'иняз',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(1).jpg',	1,	'подоить корову'),
(3,	'ЕГЭ',	'https://quizurok.s3-eu-west-1.amazonaws.com/8fa5818e-7834-48aa-a5c7-3d7d27516012.jpeg',	4,	'В'),
(2,	'ЕГЭ',	'https://quizurok.s3-eu-west-1.amazonaws.com/9bf95698-3311-4cbe-b7e0-ecd3180eeded.jpeg',	2,	'Г'),
(4,	'Сексуальное воспитание',	'https://quizurok.s3-eu-west-1.amazonaws.com/8e21b09e-b9d0-4518-bd5b-23fa5c09ef01.jpeg',	6,	'свечу'),
(5,	'ЕГЭ',	'https://quizurok.s3-eu-west-1.amazonaws.com/5c6a5121-7afe-4312-b1b0-522f0e4d627c.jpeg',	7,	'А'),
(6,	'Труд',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(10).jpg',	8,	'тирамису'),
(7,	'Труд',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(11).jpg',	3,	'табурета'),
(8,	'Труд',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(12).jpg',	5,	'швейная машинка'),
(9,	'Труд',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(13).jpg',	9,	'крепдешин'),
(10,	'География',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(14).jpg',	10,	'остров'),
(11,	'География',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(15).jpg',	12,	'Иван Федорович Крузенштерн'),
(12,	'Окружающий мир',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(16).jpg',	14,	'может только еж'),
(13,	'Физика',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(17).jpg',	15,	'ампер'),
(14,	'Окружающий мир',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(18).jpg',	16,	'собаки'),
(15,	'Окружающий мир',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(19).jpg',	17,	'пони'),
(16,	'География',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(2).jpg',	18,	'аэропорт'),
(17,	'История',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(20).jpg',	19,	'слониха'),
(18,	'Биология',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(21).jpg',	20,	'кукушки'),
(19,	'Биология',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(22).jpg',	21,	'зеркало'),
(20,	'Физика',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(23).jpg',	22,	'кот ученый'),
(21,	'Физика',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(24).jpg',	23,	'снеговик'),
(22,	'Физика',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(25).jpg',	24,	'Гагарину'),
(23,	'Химия',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(26).jpg',	25,	'Золотой'),
(24,	'ИЗО',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(27).jpg',	26,	'мадонна'),
(25,	'МХК',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(28).jpg',	27,	'я шагаю по москве'),
(26,	'МХК',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(29).jpg',	29,	'селфи-палку'),
(27,	'Литература',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(3).jpg',	30,	'агнии барто');

DROP TABLE IF EXISTS "users";
DROP SEQUENCE IF EXISTS users_id_seq;
CREATE SEQUENCE users_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1;

CREATE TABLE "public"."users" (
    "user_id" bigint NOT NULL,
    "username" text,
    "full_name" text,
    "referral" integer,
    "id" integer DEFAULT nextval('users_id_seq') NOT NULL,
    "balance" integer DEFAULT '0' NOT NULL,
    CONSTRAINT "users_id_uindex" UNIQUE ("id"),
    CONSTRAINT "users_pk" PRIMARY KEY ("user_id")
) WITH (oids = false);

INSERT INTO "users" ("user_id", "username", "full_name", "referral", "id", "balance") VALUES
(279723948,	'Isavnina',	'Senya Isavnina',	NULL,	1,	4),
(169901241,	NULL,	'Anna Grek',	NULL,	3,	0),
(908229290,	'sdolotom',	'Alexander Berezhnoy',	NULL,	4,	0),
(1067878660,	NULL,	'Anna W',	NULL,	5,	0);

-- 2020-04-16 09:54:26.586061+00
