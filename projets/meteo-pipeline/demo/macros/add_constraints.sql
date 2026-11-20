{% macro add_constraints() %}

-- Contraintes sur mart_meteo_horaire
ALTER TABLE public.mart_meteo_horaire
    ALTER COLUMN station_id SET NOT NULL,
    ALTER COLUMN station_nom SET NOT NULL,
    ALTER COLUMN source SET NOT NULL,
    ALTER COLUMN heure SET NOT NULL;

DROP INDEX IF EXISTS uq_mart_horaire_station_heure;
CREATE UNIQUE INDEX uq_mart_horaire_station_heure
    ON public.mart_meteo_horaire (station_id, heure);

-- Contraintes sur mart_meteo_journalier
ALTER TABLE public.mart_meteo_journalier
    ALTER COLUMN station_id SET NOT NULL,
    ALTER COLUMN station_nom SET NOT NULL,
    ALTER COLUMN source SET NOT NULL,
    ALTER COLUMN date SET NOT NULL;

DROP INDEX IF EXISTS uq_mart_journalier_station_date;
CREATE UNIQUE INDEX uq_mart_journalier_station_date
    ON public.mart_meteo_journalier (station_id, date);

{% endmacro %}

-- Index sur int_meteo_unified pour les filtres fréquents
DROP INDEX IF EXISTS idx_unified_station;
CREATE INDEX idx_unified_station
    ON public.int_meteo_unified (station_id);

DROP INDEX IF EXISTS idx_unified_horodatage;
CREATE INDEX idx_unified_horodatage
    ON public.int_meteo_unified (horodatage);

DROP INDEX IF EXISTS idx_unified_source;
CREATE INDEX idx_unified_source
    ON public.int_meteo_unified (source);

-- Index sur mart_meteo_horaire
DROP INDEX IF EXISTS idx_horaire_heure;
CREATE INDEX idx_horaire_heure
    ON public.mart_meteo_horaire (heure);

-- Index sur mart_meteo_journalier
DROP INDEX IF EXISTS idx_journalier_date;
CREATE INDEX idx_journalier_date
    ON public.mart_meteo_journalier (date);