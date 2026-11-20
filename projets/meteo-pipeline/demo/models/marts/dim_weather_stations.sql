-- =============================================================================
-- MODELE : dim_weather_stations
-- COUCHE : Marts — Dimension
-- ROLE   : Dimension des stations meteorologiques.
--          Integre les metadonnees completes des stations officielles
--          (InfoClimat) et amateurs (Weather Underground) conformement
--          aux specifications de la roadmap GreenCoop Forecast 2.0.
--          Cle primaire : station_id
-- =============================================================================

{{ config(materialized='table') }}

with stations as (
    select * from (values

        -- ------------------------------------------------------------------
        -- STATIONS INFOCLIMAT (reseau officiel francais)
        -- ------------------------------------------------------------------
        (
            '00052',
            'Bergues',
            'infoclimat',
            'officielle',
            'France',
            'Bergues',
            50.9681,
            2.4139,
            9,
            'Station InfoClimat',
            'InfoClimat v1',
            'InfoClimat — Reseau collaboratif de stations meteorologiques'
        ),
        (
            '000R5',
            'Hazebrouck',
            'infoclimat',
            'officielle',
            'France',
            'Hazebrouck',
            50.7239,
            2.5378,
            23,
            'Station InfoClimat',
            'InfoClimat v1',
            'InfoClimat — Reseau collaboratif de stations meteorologiques'
        ),
        (
            '07015',
            'Lille-Lesquin',
            'infoclimat',
            'officielle',
            'France',
            'Lille',
            50.5667,
            3.0833,
            47,
            'Station InfoClimat',
            'InfoClimat v1',
            'InfoClimat — Reseau collaboratif de stations meteorologiques'
        ),
        (
            'STATIC0010',
            'Armentieres',
            'infoclimat',
            'officielle',
            'France',
            'Armentieres',
            50.6892,
            2.8833,
            18,
            'Station InfoClimat',
            'InfoClimat v1',
            'InfoClimat — Reseau collaboratif de stations meteorologiques'
        ),

        -- ------------------------------------------------------------------
        -- STATIONS WEATHER UNDERGROUND (reseau amateur)
        -- Metadonnees issues de la fiche officielle WU de chaque station
        -- ------------------------------------------------------------------
        (
            'IICHTE19',
            'WeerstationBS',
            'weather_underground',
            'amateur',
            'Belgique',
            'Ichtegem',
            51.092,
            2.999,
            15,
            'other',
            'EasyWeatherV1.6.6',
            'Weather Underground — Reseau mondial de stations amateurs (PWS)'
        ),
        (
            'ILAMAD25',
            'La Madeleine',
            'weather_underground',
            'amateur',
            'France',
            'La Madeleine',
            50.659,
            3.070,
            23,
            'other',
            'EasyWeatherPro_V5.1.6',
            'Weather Underground — Reseau mondial de stations amateurs (PWS)'
        )

    ) as t(
        station_id,
        station_nom,
        source,
        type_station,
        pays,
        ville,
        latitude,
        longitude,
        elevation_m,
        hardware,
        software,
        source_description
    )
)

select * from stations