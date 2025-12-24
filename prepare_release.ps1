# Chemin du dossier Release généré par Flutter
$releaseDir = "C:\Jcode\projets\kshieldauth\build\windows\x64\runner\Release"

# Chemin du dossier où tu veux préparer le package à transférer
$packageDir = "C:\Jcode\projets\kshieldauth\ReleasePackage"

# Crée le dossier package s'il n'existe pas
if (!(Test-Path $packageDir)) {
    New-Item -ItemType Directory -Path $packageDir
}

# Copie tous les fichiers .exe, .dll, .dat et dossiers nécessaires
Copy-Item "$releaseDir\*" $packageDir -Recurse -Force

Write-Host "Package prêt ! Tous les fichiers nécessaires sont copiés dans : $packageDir"
