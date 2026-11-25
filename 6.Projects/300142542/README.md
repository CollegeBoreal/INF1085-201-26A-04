## Portefeuille Personnel & Tableau de Bord Financier

### LEDGER // 3D est une application web interactive de gestion de finances personnelles et de portefeuille de cartes en 3D, hébergée sur une instance Debian (via Proxmox VE) et propulsée par Nginx.
<img width="1919" height="911" alt="image" src="https://github.com/user-attachments/assets/cd8140b4-2760-4b7c-abfd-59cbd7327b59" />

## Aperçu du projet

L'objectif de ce projet est de proposer une interface moderne, fluide et réactive permettant de visualiser ses cartes bancaires dans un étui 3D interactif, tout en suivant ses dépenses, ses budgets mensuels et son historique de transactions.


## Fonctionnalités principales
 * Portefeuille 3D interactif
 * Ouverture en éventail (fan-out) par clic ou glissement vers le haut (swipe-up).
 * Retournement des cartes (flip 3D) pour consulter les détails au verso (numéro, CVV/CID, plafond).
 * Rangement des cartes dans le portefeuille (Tuck All).
 * Effets de reflets spéculaires dynamiques et inclinaison au survol de la souris.
## Cartes intégrées
 * American Express (Édition Centurion avec gravure vectorielle détaillée).
 * Scotiabank (ScotiaCard Visa Débit).
 * TD Bank (Compte chèques Visa Débit).
## Gestion budgétaire & suivi des dépenses
 * Curseur et préréglages rapides pour ajuster le plafond mensuel par carte.
 * Répartition par catégories réalistes (Voyages & Vols, Mode & Vente au détail, Épicerie & Maison, Logiciels & Cloud, Restauration, Abonnements).
 * Badges visuels des commerçants (Metro Market, Walmart, Zara, Air Canada, AWS, etc.).
 * Ajout et suppression de transactions en temps réel, recherche instantanée, filtrage par catégorie et exportation au format CSV.

## Architecture & Infrastructure

Le projet repose sur une architecture légère, autonome et facile à déployer :

| Composant | Détail |
| :--- | :--- |
| **Hypervisor** | Proxmox VE |
| **Operating System** | Debian (`b300142542-vm`) |
| **Web Server** | Nginx (HTTP on port 80) |
| **Frontend** | Single file `index.html` (HTML5, CSS3 with glassmorphism effects and 3D animations, Tailwind CSS via CDN, Vanilla JavaScript) |

## Installation & Déploiement sur Debian

### 1. Prérequis

 * Une machine virtuelle ou un conteneur Debian opérationnel sur Proxmox.

 * Un accès root (via la console Proxmox ou SSH).

### 2. Installation de Nginx et création du répertoire web
``bash
apt update && apt upgrade -y
apt install -y nginx curl ca-certificates
mkdir -p /var/www/ledger-wallet
``

### 3. Déploiement de l'application (index.html)

Placez le fichier index.html du dépôt dans /var/www/ledger-wallet/index.html :
``bash
cp index.html /var/www/ledger-wallet/index.html
``

### 4. Configuration de Nginx
Créez le fichier de configuration /etc/nginx/sites-available/ledger-wallet :
 
    cat <<'EOF' > /etc/nginx/sites-available/ledger-wallet
    server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;
    root /var/www/ledger-wallet;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "no-referrer" always;
    }
    EOF
``

Activez le site, vérifiez la syntaxe et rechargez Nginx :
``bash
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/ledger-wallet /etc/nginx/sites-enabled/ledger-wallet
nginx -t && systemctl enable --now nginx && systemctl reload nginx
``

### 5. Accès à l'application

Ouvrez votre navigateur sur le réseau local et accédez à l'adresse IP de votre machine Debian (par exemple http://10.7.236.202).


# Sécurité & Bonnes Pratiques

 * Usage local / VPN : Il est recommandé d'héberger cette application sur un réseau local privé ou d'y accéder via un tunnel sécurisé (Tailscale ou WireGuard) plutôt que d'exposer le port 80 directement sur Internet.

 * Données affichées : Les numéros de cartes, soldes et transactions présents dans le code sont des données de démonstration. Ne stockez jamais d'informations bancaires réelles et sensibles en clair dans un dépôt public.

 # Auteur

#### Développé et déployé par Anouar Airn.


