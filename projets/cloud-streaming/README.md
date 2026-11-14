# Infrastructure cloud — Architecture AWS et POC Redpanda/PySpark

## Besoin

Concevoir une architecture hybride pour centraliser des données
d’entreprise et traiter des événements, puis illustrer une partie
de cette architecture par un POC local.

Projet 9 OpenClassrooms :
« Modélisez une infrastructure dans le cloud ».

## Périmètre réalisé

Le projet comprend deux volets :

- une architecture cible AWS documentée ;
- un POC local de publication et d’analyse de tickets clients.

L’architecture AWS est une proposition de conception.
Son déploiement n’est pas démontré par le POC local.

## Architecture cloud proposée

| Composant | Rôle prévu |
|---|---|
| AWS DMS | Migration ou réplication des données relationnelles |
| Amazon Redshift | Entrepôt analytique |
| AWS DataSync | Transfert des fichiers vers le cloud |
| Amazon S3 | Stockage des données brutes et des fichiers |
| Amazon MSK | Transport des événements compatible Kafka |
| Amazon EMR avec PySpark | Traitement des données |
| AWS Directory Service | Services d’annuaire |
| VPN ou Direct Connect | Connectivité entre le site et AWS |

Les sources considérées comprennent SQL Server, une baie SAN,
des capteurs IoT et des flux de journaux.

## POC local

Le producteur Python publie des tickets JSON dans le topic
`client_tickets` de Redpanda.

Après la fin du producteur, le consommateur PySpark :

- lit les messages disponibles depuis les premiers offsets ;
- décode le JSON selon un schéma explicite ;
- exclut les lignes sans identifiant de ticket ;
- affecte une équipe selon le type de ticket ;
- calcule les répartitions et des indicateurs de suivi ;
- exporte quatre fichiers Parquet.

Le consommateur utilise `spark.read` : le traitement est batch,
sans écoute continue des nouveaux événements.

## Technologies

Python · kafka-python · Redpanda · PySpark · pandas
· PyArrow · Parquet · Docker Compose · AWS

## Affectation des équipes

| Type | Équipe |
|---|---|
| Incident | Support Technique |
| Bug | Equipe Développement |
| Demande | Service Client |
| Question | Assistance Générale |
| Autre | Non assigné |

## Résultats vérifiés

Le 14 novembre 2026, le script de vérification a permis de lire
les quatre exports conservés du POC, datés du 31 mai 2026.

| Indicateur | Résultat |
|---|---|
| Tickets enrichis | 20 |
| Demandes | 7 |
| Questions | 6 |
| Bugs | 4 |
| Incidents | 3 |
| Priorités basses | 8 |
| Priorités hautes | 5 |
| Priorités critiques | 5 |
| Priorités moyennes | 2 |
| Tickets critiques non résolus | 3 |

Les répartitions par type, équipe et priorité totalisent
chacune 20 tickets. L’affectation des équipes est cohérente
avec les types des tickets affichés.

Cette vérification porte sur les fichiers existants,
pas sur une nouvelle exécution du pipeline Docker.

## Fichiers produits

- `tickets_enrichis.parquet`
- `tickets_par_type.parquet`
- `tickets_par_equipe.parquet`
- `tickets_par_priorite.parquet`

Le script calcule également une moyenne des temps renseignés
par équipe et affiche les tickets critiques non résolus.

## Limites et améliorations

- Démonstration limitée à 20 tickets.
- Lecture batch, sans traitement continu.
- Relecture des messages historiques à chaque exécution.
- Absence de déduplication explicite dans le consommateur.
- Export via `toPandas()`, qui rassemble les données en mémoire.
- Images Redpanda et Console non figées dans Compose.
- Absence de validation de montée en charge.
- Architecture AWS non déployée dans le cadre du POC présenté.

Le chemin d’export a été adapté au volume Docker et la version
déclarée du connecteur Kafka a été alignée sur celle de PySpark.
Ces modifications restent à valider par une nouvelle exécution.

## Démonstration

[Voir la vidéo du POC](https://www.loom.com/share/6a18bf3588b543e0bf7908b844992126)

## Documents

[Consulter le schéma d’architecture AWS](documents/architecture-aws.pdf)

[Retour au portfolio](../../README.md)