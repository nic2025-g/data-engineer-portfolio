{{ config(
    materialized='table',
    constraints=[
        {'type': 'not_null', 'columns': ['station_id', 'station_nom', 'source', 'date']},
        {'type': 'unique', 'columns': ['station_id', 'date']}
    ]
) }}

with horaire as (
    select * from {{ ref('mart_meteo_horaire') }}
),

final as (
    select
        station_id,
        station_nom,
        source,
        heure::date                                         as date,
        round(avg(temperature_moy_c)::numeric, 2)          as temperature_moy_c,
        round(min(temperature_min_c)::numeric, 2)          as temperature_min_c,
        round(max(temperature_max_c)::numeric, 2)          as temperature_max_c,
        round(avg(humidite_moy_pct)::numeric, 1)           as humidite_moy_pct,
        round(avg(pression_moy_hpa)::numeric, 2)           as pression_moy_hpa,
        round(avg(vent_moy_kmh)::numeric, 2)               as vent_moy_kmh,
        round(max(vent_rafales_max_kmh)::numeric, 2)       as vent_rafales_max_kmh,
        round(sum(pluie_totale_mm)::numeric, 2)            as pluie_totale_mm
    from horaire
    group by station_id, station_nom, source, heure::date
)

select * from final