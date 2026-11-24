-- Устанавливаем расширение PostGIS для работы с картами
CREATE EXTENSION IF NOT EXISTS postgis;

-- Создаем новую колонку geom типа geometry
ALTER TABLE culture_data.culture_palaces_clubs
ADD COLUMN IF NOT EXISTS geom geometry(Point, 4326);