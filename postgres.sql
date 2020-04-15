DROP TABLE IF EXISTS "answers";
CREATE TABLE "public"."answers" (
    "chat_id" integer NOT NULL,
    "user_id" integer NOT NULL,
    "quest_id" integer NOT NULL,
    "points" integer NOT NULL,
    "pubdate" timestamp NOT NULL,
    CONSTRAINT "answers_quest_id_user_id_chat_id" PRIMARY KEY ("quest_id", "user_id", "chat_id")
) WITH (oids = false);

INSERT INTO "answers" ("chat_id", "user_id", "quest_id", "points", "pubdate") VALUES
(-408750395,	279723948,	1,	1,	'2020-04-15 09:41:42.836673'),
(-408750395,	279723948,	2,	1,	'2020-04-15 09:42:23.340487'),
(-408750395,	279723948,	6,	1,	'2020-04-15 11:44:47.03139'),
(-408750395,	279723948,	4,	1,	'2020-04-15 11:49:19.828384'),
(-408750395,	279723948,	0,	1,	'2020-04-13 20:23:50.501455'),
(-408750395,	393784565,	4,	1,	'2020-04-14 19:45:23.366259');

DROP TABLE IF EXISTS "publications";
CREATE TABLE "public"."publications" (
    "chat_id" integer NOT NULL,
    "quest_id" integer NOT NULL,
    "pubdate" timestamp NOT NULL,
    "message_id" integer NOT NULL,
    CONSTRAINT "publications_chat_id_quest_id_pubdate" PRIMARY KEY ("chat_id", "quest_id", "pubdate")
) WITH (oids = false);

INSERT INTO "publications" ("chat_id", "quest_id", "pubdate", "message_id") VALUES
(-408750395,	6,	'2020-04-15 11:44:32.759775',	2418),
(-408750395,	4,	'2020-04-15 11:49:13.010954',	2425),
(-408750395,	6,	'2020-04-15 11:49:26.482496',	2429),
(-408750395,	6,	'2020-04-15 11:49:36.677939',	2433),
(-408750395,	1,	'2020-04-15 11:50:56.050984',	2441),
(-408750395,	4,	'2020-04-15 11:51:05.307814',	2445),
(-408750395,	2,	'2020-04-15 11:51:11.133938',	2449),
(-408750395,	5,	'2020-04-15 11:51:16.385145',	2452);

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
(6,	'Труд',	'https://quizurok.s3-eu-west-1.amazonaws.com/Urok+Quiz+11+%D0%B4%D0%B5%D0%BA%D0%B0%D0%B1%D1%80%D1%8F+(10).jpg',	8,	'тирамису');

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
(279723948,	'Isavnina',	'Senya Isavnina',	NULL,	1,	4);

