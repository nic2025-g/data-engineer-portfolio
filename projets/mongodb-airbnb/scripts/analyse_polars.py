
"""
Projet 7 - Portfolio Data Engineer
Analyse statistique des annonces Airbnb avec Polars.

Objectifs :
- Explorer les annonces parisiennes.
- Calculer les indicateurs statistiques.
- Comparer les super-hôtes et les autres hôtes.
- Analyser la répartition géographique des annonces.
"""

import argparse
from pathlib import Path

import polars as pl


def analyse_airbnb(input_path: Path) -> None:

    if not input_path.is_file():
        raise FileNotFoundError(
            f"Fichier introuvable : {input_path}"
        )

    print("=" * 50)
    print("ANALYSE AIRBNB PARIS AVEC POLARS")
    print("=" * 50)

    # 1. Chargement des données
    df = pl.read_csv(
        input_path,
        infer_schema_length=10000,
        schema_overrides={
            "host_id": pl.String,
            "host_is_superhost": pl.String,
            "instant_bookable": pl.String,
            "number_of_reviews": pl.Int64,
            "availability_365": pl.Int64,
            "reviews_per_month": pl.Float64,
        }
    )

    print(f"\nDimensions : {df.shape}")
    print(f"Nombre total d'annonces : {df.height}")

    # 2. Répartition par type de logement
    print("\n2. Répartition par type de logement")

    print(
        df.group_by("room_type")
        .agg(pl.len().alias("nombre_annonces"))
        .sort("nombre_annonces", descending=True)
    )

    # 3. Nombre d'hôtes distincts
    print("\n3. Nombre d'hôtes distincts")

    print(
        df.select(
            pl.col("host_id")
            .drop_nulls()
            .n_unique()
            .alias("nombre_hotes")
        )
    )

    # 4. Nombre de super-hôtes distincts
    print("\n4. Nombre de super-hôtes distincts")

    print(
        df.filter(pl.col("host_is_superhost") == "t")
        .select(
            pl.col("host_id")
            .drop_nulls()
            .n_unique()
            .alias("nombre_super_hotes")
        )
    )

    # 5. Réservation instantanée
    print("\n5. Annonces avec réservation instantanée")

    instant = df.filter(
        pl.col("instant_bookable") == "t"
    ).height

    print(f"Nombre : {instant}")

    if df.height > 0:
        print(f"Pourcentage : {instant / df.height:.2%}")

    # 6. Médiane globale des avis
    print("\n6. Médiane globale des avis")

    print(
        df.select(
            pl.col("number_of_reviews")
            .median()
            .alias("mediane_avis")
        )
    )

    # 7. Comparaison super-hôtes / autres hôtes
    print("\n7. Médiane des avis selon le statut")

    print(
        df.filter(
            pl.col("host_is_superhost").is_in(["t", "f"])
        )
        .group_by("host_is_superhost")
        .agg(
            pl.col("number_of_reviews")
            .median()
            .alias("mediane_avis"),
            pl.len().alias("nombre_annonces")
        )
    )

    # 8. Hôtes ayant plus de 100 annonces
    print("\n8. Hôtes ayant plus de 100 annonces")

    grands_hotes = (
        df.filter(pl.col("host_id").is_not_null())
        .group_by("host_id")
        .agg(pl.len().alias("nombre_annonces"))
        .filter(pl.col("nombre_annonces") > 100)
        .sort("nombre_annonces", descending=True)
    )

    print(f"Nombre d'hôtes concernés : {grands_hotes.height}")

    # 9. Estimation des jours indisponibles par mois
    print("\n9. Jours indisponibles par mois")

    print(
        df.filter(
            pl.col("availability_365").is_between(0, 365)
        )
        .with_columns(
            (
                (365 - pl.col("availability_365")) / 12
            ).alias("jours_indisponibles_mois")
        )
        .group_by("room_type")
        .agg(
            pl.col("jours_indisponibles_mois")
            .mean()
            .round(2)
            .alias("moyenne_jours_indisponibles")
        )
        .sort(
            "moyenne_jours_indisponibles",
            descending=True
        )
    )

    # 10. Répartition géographique des annonces
    print("\n10. Top 10 des quartiers par nombre d'annonces")

    print(
        df.group_by("neighbourhood_cleansed")
        .agg(pl.len().alias("nombre_annonces"))
        .sort("nombre_annonces", descending=True)
        .head(10)
    )

    # 11. Nombre moyen d'avis mensuels par quartier
    print("\n11. Nombre moyen d'avis mensuels par quartier")

    print(
        df.group_by("neighbourhood_cleansed")
        .agg(
            pl.col("reviews_per_month")
            .mean()
            .round(2)
            .alias("moyenne_avis_mensuels")
        )
        .filter(
            pl.col("moyenne_avis_mensuels").is_not_null()
        )
        .sort("moyenne_avis_mensuels", descending=True)
        .head(10)
    )

    print("\nAnalyse terminée avec succès.")


if __name__ == "__main__":

    parser = argparse.ArgumentParser(
        description="Analyse Airbnb Paris avec Polars"
    )

    parser.add_argument(
        "--input",
        type=Path,
        required=True,
        help="Chemin du fichier CSV source"
    )

    args = parser.parse_args()

    analyse_airbnb(args.input)
