
-- 1) Создаем последовательность (счетчик) для будущего первичного ключа
CREATE SEQUENCE culture_data.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

-- 2) Создаем таблицу tags 
CREATE TABLE culture_data.tags (
    -- Первичный ключ с автоинкрементом из счетчика
    id          integer      NOT NULL DEFAULT nextval('culture_data.tags_id_seq'),
    tag_name    text         NOT NULL,
    created_at  timestamptz  NOT NULL DEFAULT now(),
    CONSTRAINT tags_pkey PRIMARY KEY (id),
    CONSTRAINT tags_tag_name_unique UNIQUE (tag_name)
);

-- 3) Привязываем счетчик к таблице (чтобы удалялся вместе с ней)
ALTER SEQUENCE culture_data.tags_id_seq
    OWNED BY culture_data.tags.id;