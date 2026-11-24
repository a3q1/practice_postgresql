
-- 1) Создаем таблицу для хранения связей
CREATE TABLE culture_data.m2m_culture_palaces_clubs_tags (
    -- Внешний ключ на таблицу учреждений (тип integer, как и data.general.id)
    club_id  integer NOT NULL,
    
    -- Внешний ключ на таблицу тегов
    tag_id   integer NOT NULL,

    -- Составной первичный ключ (пара club_id + tag_id должна быть уникальной)
    CONSTRAINT m2m_pkey PRIMARY KEY (club_id, tag_id),

    -- Внешний ключ: ссылаемся на колонку "data.general.id" в таблице клубов
    CONSTRAINT fk_m2m_club FOREIGN KEY (club_id)
        REFERENCES culture_data.culture_palaces_clubs ("data.general.id") ON DELETE CASCADE,
        
    -- Внешний ключ: ссылаемся на id в таблице tags
    CONSTRAINT fk_m2m_tag FOREIGN KEY (tag_id)
        REFERENCES culture_data.tags (id) ON DELETE CASCADE
);
-- 2) Заполняем таблицу связей реальными данными
INSERT INTO culture_data.m2m_culture_palaces_clubs_tags (club_id, tag_id)
SELECT DISTINCT
    c."data.general.id" AS club_id,     
    t.id AS tag_id                      
FROM culture_data.culture_palaces_clubs c
CROSS JOIN LATERAL jsonb_array_elements_text(c."data.general.tags") AS tag_name
JOIN culture_data.tags t ON t.tag_name = tag_name
WHERE c."data.general.tags" IS NOT NULL 
  AND c."data.general.tags" <> '[]'::jsonb;
   

-- Индекс для быстрого поиска по ID учреждения
CREATE INDEX idx_m2m_club_id 
ON culture_data.m2m_culture_palaces_clubs_tags (club_id);

-- Индекс для быстрого поиска по ID тега
CREATE INDEX idx_m2m_tag_id 
ON culture_data.m2m_culture_palaces_clubs_tags (tag_id);