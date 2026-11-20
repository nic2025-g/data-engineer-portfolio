{{ config(materialized='view') }}

with raw as (
    select _airbyte_data::jsonb as data
    from {{ source('publicraw', '_airbyte_raw_ichtegem_raw') }}
    where _airbyte_data::jsonb ->> 'Time' is not null
),

final as (
    select
        'IICHTE19'                                              as station_id,
        'Ichtegem'                                             as station_nom,
        'weather_underground'                                   as source,
        null::timestamp                                        as horodatage,
        regexp_replace(data->>'Temperature', '[^0-9.]', '', 'g')::float
            * 5.0/9.0 - 32.0*5.0/9.0                         as temperature_c,
        regexp_replace(data->>'Humidity', '[^0-9.]', '', 'g')::float
                                                               as humidite_pct,
        regexp_replace(data->>'Pressure', '[^0-9.]', '', 'g')::float
            * 33.8639                                          as pression_hpa,
        regexp_replace(data->>'Speed', '[^0-9.]', '', 'g')::float
            * 1.60934                                          as vent_moyen_kmh,
        regexp_replace(data->>'Gust', '[^0-9.]', '', 'g')::float
            * 1.60934                                          as vent_rafales_kmh,
        null::float                                            as vent_direction_deg,
        regexp_replace(data->>'Precip. Rate.', '[^0-9.]', '', 'g')::float
            * 25.4                                             as pluie_1h_mm,
        regexp_replace(data->>'Dew Point', '[^0-9.]', '', 'g')::float
            * 5.0/9.0 - 32.0*5.0/9.0                         as point_rosee_c
    from raw
)

select * from final