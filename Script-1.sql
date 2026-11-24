-- Создаем счетчик последовательности 
CREATE SEQUENCE IF NOT EXISTS culture_data.culture_palaces_clubs_id_seq;

-- Привязываем счетчик к колонке data.general.id 
ALTER TABLE culture_data.culture_palaces_clubs 
ALTER COLUMN "data.general.id" SET DEFAULT nextval('culture_data.culture_palaces_clubs_id_seq');

-- Добавляем первичный ключ (с защитой от дублей)
DO $$ 
BEGIN 
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'culture_palaces_clubs_pkey') THEN 
        ALTER TABLE culture_data.culture_palaces_clubs ADD CONSTRAINT culture_palaces_clubs_pkey PRIMARY KEY ("data.general.id"); 
    END IF; 
END $$;

-- Добавляем ограничение NOT NULL
ALTER TABLE culture_data.culture_palaces_clubs 
ALTER COLUMN "data.general.name" SET NOT NULL;

-- Добавляем ограничение NOT NULL на колонку с ID
ALTER TABLE culture_data.culture_palaces_clubs 
ALTER COLUMN "data.general.id" SET NOT NULL;

-- Удаление всех записей, кроме Вологодской области
DELETE FROM culture_data.culture_palaces_clubs
WHERE "data.general.address.fullAddress" NOT LIKE '%Вологодская область%';

-- Устанавливаем расширение PostGIS для работы с картами
CREATE EXTENSION IF NOT EXISTS postgis;

-- Создаем новую колонку geom типа geometry
ALTER TABLE culture_data.culture_palaces_clubs
ADD COLUMN IF NOT EXISTS geom geometry(Point, 4326);

-- Преобразуем JSON с координатами в геометрию и заполняем колонку geom
UPDATE culture_data.culture_palaces_clubs
SET geom = ST_GeomFromGeoJSON("data.general.address.mapPosition"::text)
WHERE "data.general.address.mapPosition" IS NOT NULL
  AND "data.general.address.mapPosition"::text != '';

-- Извлекаем уникальные теги 
INSERT INTO culture_data.tags (tag_name)
SELECT DISTINCT tag
FROM culture_data.culture_palaces_clubs,
LATERAL jsonb_array_elements_text("data.general.tags"::jsonb) AS tag
WHERE "data.general.tags" IS NOT NULL;

SELECT * FROM culture_data.culture_palaces_clubs LIMIT 1;





