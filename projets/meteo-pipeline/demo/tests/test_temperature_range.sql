-- Test : temperature entre -20 et 50 degres Celsius
SELECT *
FROM {{ ref('int_meteo_unified') }}
WHERE temperature_c < -20
   OR temperature_c > 50