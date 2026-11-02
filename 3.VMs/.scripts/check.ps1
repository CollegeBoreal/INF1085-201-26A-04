# --------------------------------------
# Script pour accéder aux AD DS des étudiants et générer README.md
# --------------------------------------

# Forcer UTF-8 dans tout le script
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Set-Content:Encoding'] = 'utf8'

# Autorise toutes les IP pour les connexions WinRM
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.7.236.*" -Force

# Charger la liste des VMs depuis students.ps1
. ../.scripts/students.ps1 # le point suivi d'espace permet d'importer les variables

# Vérifier que $SERVERS existe
if (-not $SERVERS) {
    Write-Host "La variable `$SERVERS n'a pas été trouvée dans students.ps1" -ForegroundColor Red
    exit
}

# Identifiants administrateur (local ou domaine)
$User = "Administrator"
# $Password = Read-Host -AsSecureString "Mot de passe de $User"
$plain = 'Boreal@2026'
$Password = ConvertTo-SecureString $plain -AsPlainText -Force

# Préparer le contenu Markdown
$timestamp = Get-Date -Format "dd-MM-yyyy HH:mm"
$md = @()
$md += "# Precision au $timestamp"
$md += ""
$md += "| Table des matieres            | Description                                             |"
$md += "|-------------------------------|---------------------------------------------------------|"
$md += "| :a: [Presence](#a-presence)   | L'etudiant.e a fait son travail    :heavy_check_mark:   |"
$md += "| :b: [Precision](#b-precision) | L'etudiant.e a reussi son travail  :tada:               |"
$md += ""
$md += ":bulb: Le mot de passe Administrateur (en Anglais) de la VM est **Infra@2024**"
$md += ""
$md += "## Legende"
$md += ""
$md += "| Signe              | Signification                 |"
$md += "|--------------------|-------------------------------|"
$md += "| :heavy_check_mark: | AD DS a ete installe          |"
$md += "| :x:                | AD DS est inexistant          |"
$md += "| :no_entry:         | Acces refuse                  |"
$md += ""
$md += "## :b: Precision"
$md += ""
$md += "| :hash: | Boreal :id: | :slot_machine: VM   | :tada:   |"
$md += "|--------|-------------|---------------------|----------|"

# Boucle sur chaque VM
$i = 0
$s = 0
$counter = 1

foreach ($VM in $SERVERS) {
    $URL = "[<image src='https://avatars0.githubusercontent.com/u/$($AVATARS[$i])?s=460&v=4' width=20 height=20></image>](https://github.com/$($IDS[$i]))"    
    $id = $ETUDIANTS[$i]
    $FILE = "$id/README.md"
    $server = $SERVERS[$i]

    Write-Host "Connexion à $VM ..." -ForegroundColor Cyan
    try {
        $Session = New-PSSession -ComputerName $VM -Credential (New-Object PSCredential ($User, $Password))
        
        # Vérifier le service AD DS (NTDS)
        $ADStatus = Invoke-Command -Session $Session -ScriptBlock {
            $svc = Get-Service -Name NTDS -ErrorAction SilentlyContinue
            if ($svc) { $svc.Status } else { -1 }
        }

        $statusIcon = if ($ADStatus -eq 4) { ":heavy_check_mark:"; $s++ } else { ":x:" }

        # Ajouter la ligne Markdown
        $md += "| $counter | [$id](../$FILE) $URL | $VM | $statusIcon |"

        # Fermer la session
        Remove-PSSession $Session
    }
    catch {
        Write-Host "Échec de connexion à $VM : $($_.Exception.Message)" -ForegroundColor Red
        $md += "| $counter | [$id](../$FILE) $URL | $VM | :no_entry: |"
    }
    $i++
    $counter++
    $COUNT = "\$\\frac{$s}{$i}$"
    $STATS = [math]::Round(($s * 100) / $i, 2)
    $SUM = "\$\displaystyle\sum_{i=1}^{$i} s_i$"
}

$md += "| :abacus: | $COUNT = $STATS% | | $SUM = $s |"

# Exporter le README.md
$md | Set-Content -Path ".scripts/Check.md" -Encoding UTF8
Write-Host "README.md généré avec succès !" -ForegroundColor Green
