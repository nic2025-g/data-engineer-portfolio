
// Projet 7 - Portfolio Data Engineer
// Requetes et agregations MongoDB sur les annonces Airbnb.
// Analyse des donnees parisiennes avec mongosh.

const DATABASE_NAME = "nos_cites_demo";
const COLLECTION_NAME = "locations_paris";

// Mode simulation par defaut
const EXECUTE = false;

function runQueries() {

    print("======================================");
    print(" Analyse MongoDB - Airbnb Paris");
    print("======================================");

    print("Base cible : " + DATABASE_NAME);
    print("Collection : " + COLLECTION_NAME);

    if (!EXECUTE) {
        print("Mode simulation : aucune connexion.");
        print("8 analyses disponibles :");
        print("1. Nombre total d'annonces");
        print("2. Annonces avec disponibilite");
        print("3. Repartition par type de logement");
        print("4. Top 5 des logements les plus evalues");
        print("5. Nombre d'hotes distincts");
        print("6. Reservations instantanees");
        print("7. Nombre de super hotes distincts");
        print("8. Hotes ayant plus de 100 annonces");
        return;
    }

    const database = db.getSiblingDB(DATABASE_NAME);
    const collection = database.getCollection(COLLECTION_NAME);

    if (!database.getCollectionNames().includes(COLLECTION_NAME)) {
        throw new Error("Collection source introuvable.");
    }

    // 1. Nombre total d'annonces
    print("\n1. Nombre total d'annonces");

    const total = collection.countDocuments({});
    print(total);

    // 2. Annonces avec disponibilite
    print("\n2. Annonces avec disponibilite");

    print(collection.countDocuments({
        has_availability: { $in: ["t", true] }
    }));

    // 3. Repartition par type de logement
    print("\n3. Repartition par type de logement");

    printjson(collection.aggregate([
        {
            $group: {
                _id: "$room_type",
                count: { $sum: 1 }
            }
        },
        {
            $sort: { count: -1 }
        }
    ]).toArray());

    // 4. Top 5 des logements les plus evalues
    print("\n4. Top 5 des logements les plus evalues");

    printjson(collection.aggregate([
        {
            $project: {
                _id: 0,
                name: 1,
                number_of_reviews: {
                    $convert: {
                        input: "$number_of_reviews",
                        to: "int",
                        onError: null,
                        onNull: null
                    }
                }
            }
        },
        {
            $match: {
                number_of_reviews: { $ne: null }
            }
        },
        {
            $sort: { number_of_reviews: -1 }
        },
        {
            $limit: 5
        }
    ]).toArray());

    // 5. Nombre d'hotes distincts
    print("\n5. Nombre d'hotes distincts");

    printjson(collection.aggregate([
        {
            $match: {
                host_id: { $exists: true, $nin: [null, ""] }
            }
        },
        {
            $group: { _id: "$host_id" }
        },
        {
            $count: "nombre_hotes"
        }
    ]).toArray());

    // 6. Reservations instantanees
    print("\n6. Reservations instantanees");

    const instantBooking = collection.countDocuments({
        instant_bookable: { $in: ["t", true] }
    });

    print("Nombre : " + instantBooking);

    if (total > 0) {
        print(
            "Pourcentage : " +
            ((instantBooking / total) * 100).toFixed(2) +
            "%"
        );
    }

    // 7. Nombre de super hotes distincts
    print("\n7. Nombre de super hotes distincts");

    printjson(collection.aggregate([
        {
            $match: {
                host_is_superhost: { $in: ["t", true] },
                host_id: { $exists: true, $nin: [null, ""] }
            }
        },
        {
            $group: { _id: "$host_id" }
        },
        {
            $count: "nombre_super_hotes"
        }
    ]).toArray());

    // 8. Hotes ayant plus de 100 annonces
    print("\n8. Hotes ayant plus de 100 annonces");

    printjson(collection.aggregate([
        {
            $match: {
                host_id: { $exists: true, $nin: [null, ""] }
            }
        },
        {
            $group: {
                _id: "$host_id",
                nombre_annonces: { $sum: 1 }
            }
        },
        {
            $match: {
                nombre_annonces: { $gt: 100 }
            }
        },
        {
            $count: "nombre_hotes"
        }
    ]).toArray());

    print("\nAnalyses terminees avec succes.");
}

runQueries();
