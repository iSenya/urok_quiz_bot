create table if not exists users
(
    user_id   bigint            not null
        constraint users_pk
            primary key,
    username  text,
    full_name text,
    referral  integer,
    id        serial            not null,
    balance   integer default 0 not null
);

alter table users
    owner to postgres;

create unique index users_id_uindex
    on users (id);

create table if not exists questions
(
    quest_id   bigint            not null
        constraint questions_pk
            primary key,
    topic     text,
    body      text,
    id        serial            not null,
    answer    text
);

alter table questions
    owner to postgres;

create unique index if not exists questions_id_uindex
    on questions (id);

create table if not exists answers


     chat_id      bigint,
     quest_id     integer,
     user_id      integer,
     points       integer,
     PRIMARY KEY (chat_id, quest_id, user_id)
     CONSTRAINT "answers_quest_id_user_id_chat_id"
 );

 alter table users
     owner to postgres;
