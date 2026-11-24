UPDATE culture_data.culture_palaces_clubs
SET geom = ST_GeomFromGeoJSON(
    "data.general.address.mapPosition"::text
)
WHERE "data.general.address.mapPosition" IS NOT NULL
  AND "data.general.address.mapPosition"::text <> 'null';