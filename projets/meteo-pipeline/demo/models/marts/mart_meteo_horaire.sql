{{ config(
    materialized='table',
    constraints=[
        {'type': 'not_null', 'columns': ['station_id', 'station_nom', 'source', 'heure']},
        {'type': 'unique', 'columns': ['station_id', 'heure']}
    ]
) }}

with unified as (
    select * from {{ ref('int_meteo_unified') }}
    where horodatage is not null
),

final as (
    select
        station_id,
        station_nom,
        source,
        date_trunc('hour', horodatage)      as heure,
        round(avg(temperature_c)::numeric, 2)    as temperature_moy_c,
        round(min(temperature_c)::numeric, 2)    as temperature_min_c,
        round(max(temperature_c)::numeric, 2)    as temperature_max_c,
        round(avg(humidite_pct)::numeric, 1)     as humidite_moy_pct,
        round(avg(pression_hpa)::numeric, 2)     as pression_moy_hpa,
        round(avg(vent_moyen_kmh)::numeric, 2)   as vent_moy_kmh,
        round(max(vent_rafales_kmh)::numeric, 2) as vent_rafales_max_kmh,
        round(sum(pluie_1h_mm)::numeric, 2)      as pluie_totale_mm
    from unified
    group by station_id, station_nom, source, date_trunc('hour', horodatage)
)

select * from final