{{ config(materialized='table') }}

with infoclimat as (
    select * from {{ ref('stg_infoclimat') }}
),

ichtegem as (
    select * from {{ ref('stg_ichtegem') }}
),

la_madeleine as (
    select * from {{ ref('stg_la_madeleine') }}
),

unified as (
    select * from infoclimat
    union all
    select * from ichtegem
    union all
    select * from la_madeleine
),

final as (
    select
        station_id,
        station_nom,
        source,
        horodatage,
        round(temperature_c::numeric, 2)     as temperature_c,
        round(humidite_pct::numeric, 1)      as humidite_pct,
        round(pression_hpa::numeric, 2)      as pression_hpa,
        round(vent_moyen_kmh::numeric, 2)    as vent_moyen_kmh,
        round(vent_rafales_kmh::numeric, 2)  as vent_rafales_kmh,
        vent_direction_deg,
        round(pluie_1h_mm::numeric, 2)       as pluie_1h_mm,
        round(point_rosee_c::numeric, 2)     as point_rosee_c
    from unified
)

select * from final