{{ config(materialized='view') }}

with stations as (
    select
        '00052' as station_id, 'Bergues'       as station_nom
    union all select '000R5',  'Hazebrouck'
    union all select '07015',  'Lille-Lesquin'
    union all select 'STATIC0010', 'Armentieres'
),

raw as (
    select _airbyte_data::jsonb as data
    from {{ source('publicraw', '_airbyte_raw_infoclimat_raw') }}
),

expanded as (
    select
        s.station_id,
        s.station_nom,
        releve.value as releve
    from raw r
    cross join stations s
    cross join lateral jsonb_array_elements(r.data -> 'hourly' -> s.station_id) as releve
),

final as (
    select
        station_id,
        station_nom,
        'infoclimat'                                            as source,
        (releve->>'dh_utc')::timestamp                         as horodatage,
        (releve->>'temperature')::float                        as temperature_c,
        (releve->>'humidite')::float                           as humidite_pct,
        (releve->>'pression')::float                           as pression_hpa,
        (releve->>'vent_moyen')::float                         as vent_moyen_kmh,
        (releve->>'vent_rafales')::float                       as vent_rafales_kmh,
        (releve->>'vent_direction')::float                     as vent_direction_deg,
        (releve->>'pluie_1h')::float                           as pluie_1h_mm,
        (releve->>'point_de_rosee')::float                     as point_rosee_c
    from expanded
)

select * from final