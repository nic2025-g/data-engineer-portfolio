-- =============================================================================
-- MODELE : dim_time
-- COUCHE : Marts — Dimension
-- ROLE   : Table de dimension temporelle par heure.
--          Permet d'analyser les patterns horaires de consommation electrique.
--          Cle de jointure : heure = extract(hour from fact_weather.horodatage)
--          Particulierement utile pour GreenCoop : les pics de consommation
--          surviennent typiquement le matin (7h-9h) et le soir (18h-21h).
-- =============================================================================

{{ config(materialized='table') }}

-- Generation d'une ligne par heure de la journee (0 a 23)
with hours as (
    select generate_series(0, 23) as heure
),

final as (
    select
        -- Cle primaire
        heure,

        -- Format lisible
        lpad(heure::text, 2, '0') || ':00'      as heure_label,

        -- Tranche horaire metier
        case
            when heure between 0  and 5  then 'Nuit'
            when heure between 6  and 11 then 'Matin'
            when heure between 12 and 17 then 'Apres-midi'
            when heure between 18 and 23 then 'Soir'
        end                                     as tranche_horaire,

        -- Periodes de pointe electrique (pertinent pour GreenCoop)
        case
            when heure between 7 and 9   then 'Pointe matin'
            when heure between 18 and 21 then 'Pointe soir'
            when heure >= 22 or heure <= 5 then 'Creuse nuit'
            else 'Normale'
        end                                     as periode_tarif,

        -- Indicateurs
        case
            when heure between 8 and 19
            then true else false
        end                                     as est_heure_diurne,

        case
            when heure in (7, 8, 9, 18, 19, 20, 21)
            then true else false
        end                                     as est_heure_pointe

    from hours
)

select * from final