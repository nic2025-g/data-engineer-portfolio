
"""
Projet 7 - Portfolio Data Engineer
Préparation des données Airbnb de Lyon.

Objectifs :
- Charger les données sources CSV.
- Ajouter le champ city.
- Exporter les données préparées pour MongoDB.
"""

import argparse
from pathlib import Path

import pandas as pd

def prepare_lyon(input_path: Path, output_path: Path) -> None:
    """Prépare les annonces Airbnb de Lyon."""

    if not input_path.is_file():
        raise FileNotFoundError(
            f"Fichier source introuvable : {input_path}"
        )

    print(f"Chargement du fichier : {input_path}")

    df = pd.read_csv(input_path, low_memory=False)

    print(f"Nombre de lignes : {len(df):,}")

    # Ajouter la ville
    df["city"] = "Lyon"

    # Créer le dossier de destination si nécessaire
    output_path.parent.mkdir(parents=True, exist_ok=True)

    # Exporter les données préparées
    df.to_csv(output_path, index=False, encoding="utf-8")

    print(f"Nombre de lignes exportées : {len(df):,}")
    print(f"Fichier généré : {output_path}")
    print("Préparation terminée avec succès.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Préparation des données Airbnb de Lyon"
    )

    parser.add_argument(
        "--input",
        type=Path,
        required=True,
        help="Chemin du fichier CSV source"
    )

    parser.add_argument(
        "--output",
        type=Path,
        required=True,
        help="Chemin du fichier CSV de destination"
    )

    args = parser.parse_args()

    prepare_lyon(args.input, args.output)