-- Test : humidite entre 0 et 100%
SELECT *
FROM {{ ref('int_meteo_unified') }}
WHERE humidite_pct < 0
   OR humidite_pct > 100