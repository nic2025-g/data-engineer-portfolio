-- Test : pas de doublons station+heure dans mart_meteo_horaire
SELECT station_id, heure, COUNT(*) as nb
FROM {{ ref('mart_meteo_horaire') }}
GROUP BY station_id, heure
HAVING COUNT(*) > 1