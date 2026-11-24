
# Projet 7 — Analyse et architecture NoSQL avec MongoDB

**Formation :** Expert en ingénierie des données — OpenClassrooms

**Statut :** Projet validé lors de la revue avec le mentor

**Technologies :** MongoDB · Python · PyMongo · Polars · Power BI · ODBC

## 1. Contexte et problématique

Dans le cadre d'une mission pour une association exploitant des données de locations courte durée, l'objectif était de restaurer, analyser et sécuriser une base MongoDB contenant des annonces Airbnb à Paris et à Lyon.

Le projet répond à trois enjeux :

- Restaurer et contrôler la cohérence des données.
- Produire des analyses exploitables par les équipes métier.
- Concevoir une architecture de réplication et de distribution adaptée à deux localités.

## 2. Données exploitées

| Ville | Nombre de documents |
|---|---:|
| Paris | 95 885 |
| Lyon | 9 973 |
| **Total** | **105 858** |

Les données ont été regroupées dans la collection `nos_cites.locations`, avec un champ `city` permettant d'identifier la ville de chaque annonce.

## 3. Réalisations techniques

### Restauration et exploration MongoDB

- Importation de données CSV et JSON.
- Vérification des collections et du nombre de documents.
- Exploration de la structure BSON.
- Requêtes MongoDB et pipelines d'agrégation.

### Analyse avec Python et Polars

- Répartition des annonces par type de logement.
- Analyse des hôtes et des super hôtes.
- Étude des réservations instantanées.
- Calcul des médianes du nombre d'avis.
- Analyse du volume d'annonces par quartier.
- Estimation d'indicateurs d'activité à partir des données disponibles.

### Réplication et disponibilité

Mise en place d'un Replica Set MongoDB comprenant :

- Un nœud Primary.
- Un nœud Secondary.
- Un arbitre participant aux élections.

L'objectif est de maintenir la disponibilité du service en permettant l'élection d'un nouveau Primary lorsque les conditions de majorité sont réunies.

### Architecture distribuée

Étude d'une stratégie de sharding géographique permettant de distinguer les données de Paris et de Lyon.

Le champ `city` constitue la clé logique envisagée pour cette distribution.

Cette stratégie nécessite de tenir compte du déséquilibre des volumes entre les deux villes et des contraintes de distribution de MongoDB.

### Business Intelligence

- Configuration d'une source de données ODBC.
- Vérification de la connexion.
- Exploitation des données dans Power BI.
- Création de tableaux de bord pour faciliter l'analyse des annonces.

#### État actuel de la connexion Power BI

La connexion ODBC et l'exploitation des données dans
Power BI ont été réalisées lors du projet initial.

Lors de la préparation du portfolio en novembre 2026,
la connexion Power BI n'est plus opérationnelle dans
l'environnement local actuel.

La cause exacte reste à identifier.

Le rétablissement de cette connexion constitue un axe
d'amélioration technique.

Les analyses statistiques réalisées avec Python et
Polars restent fonctionnelles et reproductibles,
indépendamment de Power BI.


## 4. Résultats obtenus

### Chiffres clés


## 4. Résultats obtenus

### Chiffres clés

| Indicateur | Résultat |
|---|---:|
| Documents intégrés lors du projet initial | 105 858 |
| Annonces à Paris | 95 885 |
| Annonces à Lyon | 9 973 |
| Nombre de variables du fichier Paris | 75 |
| Hôtes distincts à Paris | 71 979 |
| Super-hôtes distincts à Paris | 10 027 |
| Annonces parisiennes réservables instantanément | 22 094 |
| Part des annonces réservables instantanément | 23,04 % |
| Hôtes ayant plus de 100 annonces à Paris | 24 |
| Médiane du nombre d'avis à Paris | 3 |
| Médiane des avis pour les super-hôtes à Paris | 24 |
| Médiane des avis pour les autres hôtes à Paris | 2 |
| Annonces associées à des super-hôtes | 14 776 |
| Annonces associées à des non-super-hôtes | 81 035 |
| Annonces avec statut super-hôte non reconnu ou manquant | 74 |

### Résultats techniques

- **105 858 documents** regroupés dans une collection lors du projet initial.
- Analyses statistiques réalisées avec Python et Polars.
- Replica Set MongoDB configuré et vérifié lors du projet initial.
- Connexion ODBC testée avec succès.
- Données exploitées dans Power BI.
- Architecture distribuée avec sharding étudiée et proposée.
- Projet validé lors de la revue avec le mentor.

### Reproductibilité des résultats

Le 24 novembre 2026, les analyses statistiques ont été
réexécutées avec Python et Polars 1.39.2 sur le fichier
source de Paris contenant 95 885 lignes et 75 colonnes.

Les 11 analyses ont été exécutées avec succès et les
principaux résultats historiques ont été reproduits.

Le nombre d'hôtes possédant plus de 100 annonces a été
confirmé à 24.

La préparation des données de Lyon a également été
réexécutée avec succès :

- 9 973 lignes en entrée.
- 9 973 lignes en sortie.
- Aucune perte de lignes.
- Aucune valeur manquante dans le champ city.

Les scripts d'importation, de fusion et de requêtes
MongoDB ont été vérifiés en mode simulation, sans
modification des bases existantes.

[Consulter les résultats de l'exécution Polars](captures/resultats_polars.txt)

### Qualité des données et limites des indicateurs

L'analyse a identifié 74 annonces dont le statut
super-hôte ne correspond ni à la valeur t ni à la
valeur f, soit environ 0,077 % des annonces parisiennes.

L'indicateur calculé à partir de availability_365
représente une estimation du nombre moyen de jours
indisponibles par mois et non un taux réel de réservation.

Ces limites sont prises en compte dans l'interprétation
des résultats métier.


## 5. Compétences démontrées

- Administration d'une base de données NoSQL.
- Modélisation et manipulation de documents BSON.
- Développement de scripts d'analyse de données.
- Compréhension de la réplication et de la tolérance aux pannes.
- Conception d'une architecture de distribution des données.
- Intégration entre bases NoSQL et outils de Business Intelligence.
- Documentation et présentation de choix techniques.

### Compétences validées lors de la revue avec le mentor

| Compétence évaluée | Statut |
|---|---|
| Construire et manipuler une base de données | Validée |
| Élaborer un processus | Validée |
| Schématiser une architecture physique on-premise | Validée |
| Schématiser la collecte et le stockage des données | Validée |

### Axes d'amélioration identifiés

- Approfondir les compromis entre réplication et sharding.
- Améliorer la lisibilité des schémas d'architecture.
- Prendre en compte les contraintes de disponibilité,
  de performance et de coût.
- Étudier les limites d'une clé de sharding à faible
  cardinalité comme le champ `city`.

## 6. Valeur ajoutée métier

Ce projet illustre ma capacité à transformer des données brutes en informations exploitables tout en prenant en compte leur disponibilité, leur organisation et leur intégration dans un environnement décisionnel.

Les analyses permettent notamment d'identifier les caractéristiques des logements, la répartition géographique des annonces et les tendances d'activité.

## 7. Livrables

Le dépôt présente les scripts techniques disponibles, les schémas d'architecture, les captures de résultats et le support de présentation du projet.

Les données sources volumineuses et les informations sensibles ne sont pas publiées dans le dépôt.


### Documentation des architectures

Trois schémas d'architecture permettent de comprendre
le fonctionnement du système et ses perspectives d'évolution.

| Architecture | Description | Documentation |
|---|---|---|
| Pipeline de données | Collecte, préparation, stockage et exploitation | [Consulter le schéma](architecture/pipeline_donnees.md) |
| Réplication MongoDB | Architecture physique, disponibilité et basculement | [Consulter le schéma](architecture/architecture_replication.md) |
| Sharding MongoDB | Architecture distribuée proposée et stratégie de partitionnement | [Consulter le schéma](architecture/architecture_sharding.md) |

Les diagrammes sont réalisés avec Mermaid afin de
faciliter leur consultation et leur maintenance
directement dans GitHub.

### Scripts techniques

| Script | Fonction | Validation |
|---|---|---|
| [prepare_lyon.py](scripts/prepare_lyon.py) | Préparation des données de Lyon | Test réel réussi |
| [import_data.ps1](scripts/import_data.ps1) | Importation des données dans MongoDB | Simulation réussie |
| [merge_collections.js](scripts/merge_collections.js) | Fusion des collections Paris et Lyon | Simulation réussie |
| [mongodb_queries.js](scripts/mongodb_queries.js) | Requêtes et agrégations MongoDB | Simulation réussie |
| [analyse_polars.py](scripts/analyse_polars.py) | Analyse statistique des annonces parisiennes | Test réel réussi |

### Preuves d'exécution

- [Résultats des analyses Polars](captures/resultats_polars.txt)


### Support de présentation

[Consulter la présentation du Projet 7 (PowerPoint)](presentation/Projet7_MongoDB_Portfolio.pptx)