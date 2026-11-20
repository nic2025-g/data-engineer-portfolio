-- =============================================================================
-- MODELE : dim_source
-- COUCHE : Marts — Dimension
-- ROLE   : Table de dimension des sources de donnees meteorologiques.
--          Permet d'analyser la qualite et la couverture par source.
--          Utile pour evaluer la fiabilite de chaque reseau de mesure
--          et justifier les choix d'integration de GreenCoop.
--          Cle de jointure : source = fact_weather.source
-- =============================================================================

{{ config(materialized='table') }}

-- Definition statique des sources — mise a jour manuelle si nouvelle source
with sources as (
    select * from (values
        (
            'infoclimat',
            'InfoClimat',
            'Reseau collaboratif de stations meteorologiques amateurs en France',
            'France',
            'https://www.infoclimat.fr',
            10,
            'JSON',
            'Gratuit',
            'Haute'
        ),
        (
            'weather_underground',
            'Weather Underground',
            'Reseau mondial de stations meteorologiques personnelles (PWS)',
            'International',
            'https://www.wunderground.com',
            30,
            'Excel (XLSX)',
            'Gratuit (export manuel)',
            'Moyenne'
        )
    ) as t(
        source_id,
        source_nom,
        source_description,
        couverture_geo,
        url,
        frequence_releve_min,
        format_donnees,
        acces,
        fiabilite
    )
)

select * from sources