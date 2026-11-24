// Projet 7 - Portfolio Data Engineer
// Fusion des collections Airbnb Paris et Lyon.
// Execution avec mongosh.

const DATABASE_NAME = "nos_cites_demo";

// Mode simulation par defaut
const EXECUTE = false;

const EXPECTED_PARIS = 95885;
const EXPECTED_LYON = 9973;
const EXPECTED_TOTAL = EXPECTED_PARIS + EXPECTED_LYON;

function mergeCollections() {

    print("======================================");
    print(" Fusion des collections Paris et Lyon");
    print("======================================");

    print("Base cible : " + DATABASE_NAME);
    print("Documents Paris : " + EXPECTED_PARIS);
    print("Documents Lyon : " + EXPECTED_LYON);
    print("Documents attendus : " + EXPECTED_TOTAL);

    if (!EXECUTE) {
        print("Mode simulation : aucune modification.");
        print("Aucune connexion MongoDB necessaire.");
        return;
    }

    const database = db.getSiblingDB(DATABASE_NAME);

    // Controle des collections sources
    const parisCount =
        database.locations_paris.countDocuments({});

    const lyonCount =
        database.locations_lyon.countDocuments({});

    print("Paris : " + parisCount);
    print("Lyon : " + lyonCount);

    if (
        parisCount !== EXPECTED_PARIS ||
        lyonCount !== EXPECTED_LYON
    ) {
        throw new Error(
            "Volumes sources non conformes."
        );
    }

    // Protection de la collection cible
    if (database.getCollectionNames().includes("locations")) {
        throw new Error(
            "La collection locations existe deja. Fusion annulee."
        );
    }

    // Fusion des deux collections
    database.locations_paris.aggregate([
        {
            $addFields: {
                city: "Paris"
            }
        },
        {
            $unionWith: {
                coll: "locations_lyon",
                pipeline: [
                    {
                        $addFields: {
                            city: "Lyon"
                        }
                    }
                ]
            }
        },
        {
            $out: "locations"
        }
    ]).toArray();

    // Controle des resultats
    const total =
        database.locations.countDocuments({});

    const paris =
        database.locations.countDocuments({ city: "Paris" });

    const lyon =
        database.locations.countDocuments({ city: "Lyon" });

    print("Total : " + total);
    print("Paris : " + paris);
    print("Lyon : " + lyon);

    if (
        total !== EXPECTED_TOTAL ||
        paris !== EXPECTED_PARIS ||
        lyon !== EXPECTED_LYON
    ) {
        throw new Error(
            "Controle final non conforme."
        );
    }

    // Index pour les recherches par ville
    database.locations.createIndex({ city: 1 });

    print("Fusion terminee avec succes.");
}

mergeCollections();
