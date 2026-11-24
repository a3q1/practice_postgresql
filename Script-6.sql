
INSERT INTO culture_data.tags (tag_name)
SELECT DISTINCT 
       jsonb_array_elements("data.general.tags")::text 
FROM culture_data.culture_palaces_clubs
WHERE "data.general.tags" IS NOT NULL 
  AND "data.general.tags" <> '[]'::jsonb; -- Пропускаем пустые массивы