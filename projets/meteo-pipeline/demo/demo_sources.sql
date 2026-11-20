BEGIN;

CREATE SCHEMA IF NOT EXISTS publicraw;

CREATE TABLE IF NOT EXISTS publicraw._airbyte_raw_infoclimat_raw (
    _airbyte_data jsonb NOT NULL
);

CREATE TABLE IF NOT EXISTS publicraw._airbyte_raw_ichtegem_raw (
    _airbyte_data jsonb NOT NULL
);

CREATE TABLE IF NOT EXISTS publicraw._airbyte_raw_la_madeleine_raw (
    _airbyte_data jsonb NOT NULL
);

-- Remplacement du jeu fictif uniquement dans la base locale de démonstration.
TRUNCATE
    publicraw._airbyte_raw_infoclimat_raw,
    publicraw._airbyte_raw_ichtegem_raw,
    publicraw._airbyte_raw_la_madeleine_raw;

-- 4 stations × 48 heures = 192 relevés fictifs.
WITH releves AS (
    SELECT
        station_id,
        jsonb_agg(
            jsonb_build_object(
                'dh_utc', to_char(
                    timestamp '2024-10-01 00:00:00'
                    + n * interval '1 hour',
                    'YYYY-MM-DD HH24:MI:SS'
                ),
                'temperature', 12.0 + (n % 12) * 0.5,
                'humidite', 65 + (n % 15),
                'pression', 1013,
                'vent_moyen', 10,
                'vent_rafales', 18,
                'vent_direction', 180,
                'pluie_1h', 0.2,
                'point_de_rosee', 8
            ) ORDER BY n
        ) AS mesures
    FROM (
        VALUES ('00052'), ('000R5'), ('07015'), ('STATIC0010')
    ) AS stations(station_id)
    CROSS JOIN generate_series(0, 47) AS heures(n)
    GROUP BY station_id
)
INSERT INTO publicraw._airbyte_raw_infoclimat_raw
SELECT jsonb_build_object(
    'is_simulated', true,
    'hourly', jsonb_object_agg(station_id, mesures)
)
FROM releves;

-- 2 relevés fictifs par station Weather Underground.
-- Les noms des clés correspondent exactement aux modèles staging.
INSERT INTO publicraw._airbyte_raw_ichtegem_raw
SELECT jsonb_build_object(
    'is_simulated', true,
    'Time', heure,
    'Temperature', '59.0 F',
    'Humidity', '70 %',
    'Pressure', '29.92 in',
    'Speed', '5.0 mph',
    'Gust', '8.0 mph',
    'Precip. Rate.', '0.0 in',
    'Dew Point', '50.0 F'
)
FROM (VALUES ('08:00'), ('09:00')) AS t(heure);

INSERT INTO publicraw._airbyte_raw_la_madeleine_raw
SELECT jsonb_build_object(
    'is_simulated', true,
    'Time', heure,
    'Temperature', '62.6 F',
    'Humidity', '65 %',
    'Pressure', '30.0 in',
    'Speed', '4.0 mph',
    'Gust', '7.0 mph',
    'Precip. Rate.', '0.0 in',
    'Dew Point', '51.8 F'
)
FROM (VALUES ('08:00'), ('09:00')) AS t(heure);

COMMIT;