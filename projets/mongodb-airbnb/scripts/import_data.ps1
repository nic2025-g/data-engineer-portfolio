
<#
Projet 7 - Portfolio Data Engineer
Importation des données Airbnb Paris et Lyon dans MongoDB.

Prérequis :
- MongoDB Database Tools (mongoimport)
- Fichiers CSV sources
- Instance MongoDB accessible
- Droits d'importation sur la base cible
#>

param(
    [string]$ParisFile = "C:\data\listings_Paris.csv",
    [string]$LyonFile = "C:\data\lyon_with_city.csv",
    [string]$Database = "nos_cites_demo",
    [string]$MongoUri = $env:MONGO_URI,
    [switch]$Execute
)

$ErrorActionPreference = "Stop"

# Vérification de mongoimport
if (-not (Get-Command mongoimport -ErrorAction SilentlyContinue)) {
    throw "mongoimport est introuvable."
}

# Vérification des fichiers sources
foreach ($file in @($ParisFile, $LyonFile)) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
        throw "Fichier introuvable : $file"
    }
}

Write-Host "======================================"
Write-Host " Importation Airbnb - Paris et Lyon"
Write-Host "======================================"

Write-Host "Base cible : $Database"
Write-Host "Fichier Paris : $ParisFile"
Write-Host "Fichier Lyon  : $LyonFile"

# Mode simulation par défaut
if (-not $Execute) {
    Write-Host ""
    Write-Host "Mode simulation : aucune donnée importée."
    Write-Host "Les fichiers sources sont disponibles."
    Write-Host "Les prérequis locaux sont satisfaits."
    return
}

# Vérification de la connexion configurée
if ([string]::IsNullOrWhiteSpace($MongoUri)) {
    throw "La variable MONGO_URI doit être configurée."
}

function Import-Csv {
    param(
        [string]$File,
        [string]$Collection
    )

    Write-Host ""
    Write-Host "Importation vers $Database.$Collection"

    mongoimport `
        --uri $MongoUri `
        --db $Database `
        --collection $Collection `
        --type csv `
        --headerline `
        --file $File `
        --mode insert `
        --stopOnError

    if ($LASTEXITCODE -ne 0) {
        throw "Echec de l'importation : $Collection"
    }

    Write-Host "Importation réussie : $Collection"
}

Import-Csv -File $ParisFile -Collection "locations_paris"
Import-Csv -File $LyonFile -Collection "locations_lyon"

Write-Host ""
Write-Host "Importations terminées avec succès."
