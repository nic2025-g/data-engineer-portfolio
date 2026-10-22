# Migration de données CSV vers MongoDB

## Besoin

Automatiser le transfert d’un fichier CSV de données médicales
vers MongoDB et rendre le lancement reproductible avec Docker Compose.

Projet réalisé dans le cadre de ma formation Data Engineer.

## Solution réalisée

- Lecture du CSV nettoyé avec Pandas.
- Transformation des lignes en documents MongoDB imbriqués.
- Insertion par lots de 1 000 documents.
- Vérification du nombre de documents après insertion.
- Refus du chargement si la collection est déjà remplie.
- Journalisation des opérations et signalement des échecs.

Chaque document représente un enregistrement d’hospitalisation.

## Technologies

Python · Pandas · PyMongo · MongoDB 7 · Docker Compose · Git

## Choix techniques

| Choix | Justification |
|---|---|
| Documents imbriqués | Regrouper les informations d’une hospitalisation |
| Insertion par lots | Fractionner les opérations d’écriture |
| Docker Compose | Définir la base et le service de migration |
| CSV monté en lecture seule | Préserver le fichier source |
| Contrôle de collection non vide | Éviter un rechargement involontaire |
| Logs persistants | Conserver une trace des opérations |

## Résultats vérifiés

Tests réalisés le 19 octobre 2026 dans un environnement de test dédié.

| Test | Résultat |
|---|---|
| Migration initiale | 54 897 documents insérés, code de sortie 0 |
| Contrôle final | Nombre de documents égal au nombre de lignes du CSV |
| Seconde exécution | Chargement refusé avant insertion, code de sortie 1 |

## Limites et améliorations envisagées

- Chargement intégral du CSV et des documents en mémoire.
- Dates du CSV conservées sous forme de chaînes.
- Insertion partielle possible en cas d’échec pendant le chargement.
- Compte administrateur à remplacer par un compte aux droits limités.
- Index métier et mesures de performance à ajouter.
- Absence de déduplication métier.

## Code et instructions d’exécution

[Consulter le dépôt MongoDB](https://github.com/nic2025-g/projet5-mongodb-migration)

[Retour au portfolio](../../README.md)