# Pipeline météo — PostgreSQL, dbt et architecture AWS

## Besoin

Centraliser et harmoniser des relevés météorologiques provenant
d’InfoClimat et de deux stations Weather Underground, pour préparer
des données destinées aux analyses et prévisions de GreenCoop.

Projet 8 OpenClassrooms :
« Construisez et testez une infrastructure de données ».

## Deux environnements

### Projet AWS historique

Le projet s’appuie sur une architecture Airbyte, PostgreSQL RDS
et dbt, avec une configuration de déploiement ECS Fargate.

Les ressources AWS ont ensuite été supprimées pour limiter les coûts.

Les fichiers examinés comprennent :

- un Dockerfile pour dbt ;
- un script de connexion PostgreSQL et de préparation des vues sources ;
- une définition de tâche ECS Fargate ;
- une cible EventBridge ;
- une configuration de journalisation awslogs ;
- des références de secrets pour les paramètres sensibles.

Ces configurations ne constituent pas, à elles seules,
une preuve d’exécution réussie sur ECS.

### Démonstration locale reproductible

Une démonstration PostgreSQL sous Docker a été reconstruite
avec des données entièrement fictives.

Elle permet d’exécuter les transformations et les tests dbt.
Elle ne reproduit pas la collecte Airbyte ni les services AWS.

## Technologies

SQL · PostgreSQL 15 · dbt Core 1.11.8 · dbt-postgres 1.10.0
· Docker Compose · Airbyte · AWS RDS · ECS Fargate · EventBridge

## Organisation des transformations

| Couche | Contenu |
|---|---|
| Sources | Trois tables JSONB dans publicraw |
| Staging | Trois vues de normalisation |
| Intermediate | Une table d’unification des relevés |
| Marts | Quatre dimensions, une table de faits et deux agrégats |

Le projet contient 11 modèles SQL : 3 vues et 8 tables.

Les transformations comprennent la conversion des unités,
l’arrondi des mesures et les agrégations horaires et journalières.

## Qualité des données

Les 61 tests couvrent notamment :

- la non-nullité ;
- l’unicité des identifiants ;
- les valeurs autorisées des sources ;
- les plages de température, d’humidité et de pression ;
- l’absence de doublons par station et par heure.

## Résultats vérifiés

### Exécution historique

L’artefact du 24 mai 2026 indique 61 tests réussis
avec dbt Core 1.11.8.

### Démonstration locale du 20 novembre 2026

| Vérification | Résultat |
|---|---|
| Modèles construits | 11 |
| Tests réussis | 61 |
| Total des éléments exécutés | 72 |
| Avertissements et erreurs | 0 |
| Code de sortie | 0 |
| Relevés unifiés | 196 |
| Relevés dans la table de faits | 192 |
| Agrégats horaires | 192 |
| Agrégats journaliers | 8 |

Le jeu fictif comprend 192 relevés InfoClimat et 4 relevés
Weather Underground.

Les modèles Weather Underground produisent un horodatage nul.
Ces quatre relevés restent dans la couche unifiée, mais sont
exclus de la table de faits et des agrégats temporels.

[Consulter le résumé de validation](demo/validation-demo.txt)

## Choix techniques

| Choix | Justification |
|---|---|
| PostgreSQL et JSONB | Stocker les structures sources puis les transformer en SQL |
| Couches dbt | Séparer normalisation, unification et restitution |
| Tests dbt | Contrôler les propriétés attendues des données |
| Docker Compose | Isoler et reproduire la base locale |
| Données fictives déterministes | Permettre la démonstration sans ressources AWS |

## Limites

- La démonstration locale ne valide pas le pipeline cloud complet.
- Le jeu fictif ne représente pas toutes les anomalies des sources réelles.
- Les relevés Weather Underground ne disposent pas d’horodatage complet.
- UNION ALL conserve les doublons éventuels des sources.
- Le nettoyage numérique Weather Underground ne préserve pas les signes négatifs.
- La dimension calendrier est limitée à octobre 2024.
- Les métadonnées des stations sont définies dans le code.
- La capacité à monter en charge n’a pas été mesurée.

Dans le script AWS historique, l’attente de PostgreSQL n’est pas
bornée et la gestion des erreurs SQL doit être renforcée.

## Reproduire la démonstration

### Prérequis

- Docker Desktop démarré ;
- Python et dbt-postgres installés.

Versions utilisées pour la validation :
Python 3.13.9, dbt Core 1.11.8 et dbt-postgres 1.10.0.

Les commandes suivantes sont à exécuter dans PowerShell,
depuis le dossier demo de cette fiche.

### Configuration et démarrage

```powershell
Copy-Item .\profiles.example.yml .\profiles.yml
docker compose -f compose.demo.yml up -d postgres
docker compose -f compose.demo.yml ps
```

Attendre le statut healthy.

Le port local utilisé est 55433. Il doit être disponible.
Les identifiants inclus sont réservés à cette démonstration locale.

### Chargement des données fictives

```powershell
docker compose -f compose.demo.yml cp .\demo_sources.sql postgres:/tmp/demo_sources.sql

docker compose -f compose.demo.yml exec -T postgres psql -U meteo_demo -d meteo_demo -v ON_ERROR_STOP=1 -f /tmp/demo_sources.sql
```

Le script remplace le contenu des trois tables sources
de cette base de démonstration.

### Construction et tests

```powershell
dbt debug --profiles-dir . --target demo
dbt build --profiles-dir . --target demo
```

Résultat de référence : PASS=72 WARN=0 ERROR=0.

### Arrêt

```powershell
docker compose -f compose.demo.yml stop
```

Le volume conserve les données.

## Améliorations envisagées

- Reconstituer des horodatages fiables pour Weather Underground.
- Corriger le traitement des valeurs négatives.
- Ajouter des tests de relations entre faits et dimensions.
- Adapter automatiquement le calendrier à la période des données.
- Définir une stratégie de déduplication.
- Documenter et tester le redéploiement cloud.

[Retour au portfolio](../../README.md)