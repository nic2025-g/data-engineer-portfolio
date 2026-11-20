-- =============================================================================
-- MODELE : fact_weather
-- COUCHE : Marts — Table de faits (schema en etoile)
-- ROLE   : Centralise tous les releves meteorologiques avec leurs mesures.
--          Relie les dimensions via station_id et source.
--          Filtre les releves sans horodatage (donnees WU incompletes)
--          pour garantir l'unicite de fact_id et la qualite des donnees.
-- =============================================================================

{{ config(materialized='table') }}

with unified as (
    -- On filtre les releves sans horodatage (Weather Underground sans date)
    select * from {{ ref('int_meteo_unified') }}
    where horodatage is not null
),

stations as (
    select station_id
    from {{ ref('dim_weather_stations') }}
),

final as (
    select
        -- Cle surrogate unique par releve
        u.station_id || '_' ||
        to_char(u.horodatage, 'YYYYMMDDHH24MISS') || '_' ||
        u.source                                as fact_id,

        -- Cle de dimension
        u.station_id,

        -- Mesures meteorologiques
        u.horodatage,
        u.temperature_c,
        u.humidite_pct,
        u.pression_hpa,
        u.vent_moyen_kmh,
        u.vent_rafales_kmh,
        u.vent_direction_deg,
        u.pluie_1h_mm,
        u.point_rosee_c,

        -- Metadonnees
        u.source,
        current_timestamp                       as inserted_at

    from unified u
    inner join stations s on u.station_id = s.station_id
)

select * from final