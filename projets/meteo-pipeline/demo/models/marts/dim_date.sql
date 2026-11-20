-- =============================================================================
-- MODELE : dim_date
-- COUCHE : Marts — Dimension
-- ROLE   : Table de dimension temporelle par jour.
--          Permet d'enrichir les analyses avec des attributs calendaires :
--          jour de la semaine, mois, trimestre, saison, weekend...
--          Cle de jointure : date = fact_weather.horodatage::date
-- =============================================================================

{{ config(materialized='table') }}

-- Generation d'une ligne par jour sur la periode couverte par les donnees
with date_spine as (
    select
        generate_series(
            '2024-10-01'::date,
            '2024-10-31'::date,
            interval '1 day'
        )::date as date
),

final as (
    select
        -- Cle primaire
        date,

        -- Attributs numeriques
        extract(day   from date)::int           as jour,
        extract(month from date)::int           as mois,
        extract(year  from date)::int           as annee,
        extract(week  from date)::int           as semaine_annee,
        extract(quarter from date)::int         as trimestre,
        extract(dow   from date)::int           as jour_semaine_num,
        -- 0=dimanche, 1=lundi ... 6=samedi

        -- Attributs textuels
        to_char(date, 'TMDay')                  as jour_semaine_nom,
        to_char(date, 'TMMonth')                as mois_nom,
        to_char(date, 'YYYY-MM')                as annee_mois,

        -- Indicateurs
        case
            when extract(dow from date) in (0, 6)
            then true else false
        end                                     as est_weekend,

        case
            when extract(month from date) in (12, 1, 2)  then 'Hiver'
            when extract(month from date) in (3, 4, 5)   then 'Printemps'
            when extract(month from date) in (6, 7, 8)   then 'Ete'
            when extract(month from date) in (9, 10, 11) then 'Automne'
        end                                     as saison,

        -- Pertinent pour GreenCoop : periodes de forte demande electrique
        case
            when extract(month from date) in (12, 1, 2, 3)
            then true else false
        end                                     as est_periode_chauffe

    from date_spine
)

select * from final