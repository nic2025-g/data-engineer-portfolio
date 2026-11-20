-- Test : pression entre 900 et 1100 hPa
SELECT *
FROM {{ ref('int_meteo_unified') }}
WHERE pression_hpa < 900
   OR pression_hpa > 1100