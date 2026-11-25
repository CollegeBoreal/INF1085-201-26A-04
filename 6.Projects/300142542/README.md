# 💳 Portefeuille Personnel & Tableau de Bord Financier
* Auteur
* Développé et déployé par Anouar Airn.
##

**LEDGER // 3D** est une application web interactive de gestion de finances personnelles et de portefeuille de cartes en 3D. Propulsée par un backend Node.js et une base de données PostgreSQL, l'application est hébergée sur une instance Debian (via Proxmox VE) et servie par Nginx.

## 🚀 Aperçu du projet

L'objectif de ce projet est de proposer une interface moderne, fluide et réactive permettant de visualiser ses cartes bancaires dans un étui 3D interactif, tout en suivant ses dépenses, ses budgets mensuels et son historique de transactions stockés de manière persistante.

## ✨ Fonctionnalités principales

### 🪄 Portefeuille 3D interactif
- Ouverture en éventail (fan-out) par clic ou glissement vers le haut (swipe-up).
- Retournement des cartes (flip 3D) pour consulter les détails au verso (numéro, CVV/CID, plafond).
- Rangement des cartes dans le portefeuille (Tuck All).
- Effets de reflets spéculaires dynamiques et inclinaison au survol de la souris.

### 💳 Cartes intégrées
- American Express (Édition Centurion avec gravure vectorielle détaillée).
- Scotiabank (ScotiaCard Visa Débit).
- TD Bank (Compte chèques Visa Débit).

### 📊 Gestion budgétaire & suivi des dépenses (Full-Stack)
- ** 💾 Persistance des données** : Toutes les transactions et les soldes sont sauvegardés dans une base de données PostgreSQL.
- ** 🛡️ Calcul côté serveur** : Le solde des cartes est calculé par l'API (transactions SQL `BEGIN / COMMIT`) pour éviter les incohérences si plusieurs onglets sont ouverts.
-  🎛️ Curseur et préréglages rapides pour ajuster le plafond mensuel par carte.
-  📁 Répartition par catégories réalistes (Voyages & Vols, Mode & Vente au détail, Épicerie & Maison, Logiciels & Cloud, Restauration, Abonnements).
- 🏷️ Badges visuels des commerçants (Metro Market, Walmart, Zara, Air Canada, AWS, etc.).
- ⚡ Ajout et suppression de transactions en temps réel, recherche instantanée, filtrage par catégorie et exportation au format CSV.

## 🏗️ Architecture & Infrastructure

Le projet repose sur une architecture full-stack moderne, autonome et facile à déployer :

| Composant | Détail |
| :--- | :--- |
| ** 🖥️ Hyperviseur** | Proxmox VE |
| ** 🐧 Système d'exploitation** | Debian (`b300142542-vm`) |
| ** 🌐 Serveur Web (Frontend)** | Nginx (HTTP sur le port 80, proxy inverse pour `/api/`) |
| ** 🎨 Frontend** | Fichier unique `index.html` (HTML5, CSS3 glassmorphism, animations 3D, Tailwind CSS, Vanilla JS) + `api.js` (Client REST) |
| ** ⚙️ Backend (API)** | Node.js / Express (Port 3000, géré par `systemd`) |
| ** 🐘 Base de données** | PostgreSQL (Tables: `cards`, `categories`, `transactions`) |

## 🛠️ Installation & Déploiement sur Debian

### 1. Prérequis
- Une machine virtuelle ou un conteneur Debian opérationnel sur Proxmox.
- Un accès root (via la console Proxmox ou SSH).

### 2. Installation des dépendances (Nginx, Node.js, PostgreSQL)
```bash
apt update && apt upgrade -y
apt install -y nginx curl ca-certificates

# Installation de Node.js 20.x
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt install -y nodejs

# Installation de PostgreSQL
apt install -y postgresql postgresql-contrib
```

### 3. Configuration de PostgreSQL
Créez l'utilisateur et la base de données :
```bash
sudo -u postgres psql -c "CREATE USER ledger WITH PASSWORD 'votre_mot_de_passe';"
sudo -u postgres psql -c "CREATE DATABASE ledger OWNER ledger;"
```
```bash
PGPASSWORD='votre_mot_de_passe' psql -h 127.0.0.1 -U ledger -d ledger -f /opt/ledger-api/schema.sql
```

### 4. Déploiement du Backend (API)
Créez le dossier du projet et installez les dépendances :
```bash
mkdir -p /opt/ledger-api
cd /opt/ledger-api
# Placez server.js et package.json ici
npm install
```

Créez le service systemd pour maintenir l'API en arrière-plan (/etc/systemd/system/ledger-api.service) :
```bash
[Unit]
Description=LEDGER // 3D API
After=network.target postgresql.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/ledger-api
Environment=NODE_ENV=production PORT=3000 HOST=127.0.0.1 PGHOST=127.0.0.1 PGPORT=5432 PGUSER=ledger PGPASSWORD=votre_mot_de_passe PGDATABASE=ledger
ExecStart=/usr/bin/node /opt/ledger-api/server.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Démarrez le service :
``bash
systemctl daemon-reload
systemctl enable --now ledger-api
``

### 5. Déploiement du Frontend
Placez index.html et api.js dans le répertoire web :
```bash
mkdir -p /var/www/ledger-wallet
# Copiez index.html et api.js ici
```

### 6. Configuration de Nginx
Créez le fichier de configuration /etc/nginx/sites-available/ledger-wallet :
```bash
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;
    root /var/www/ledger-wallet;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy inverse pour l'API Node.js
    location /api/ {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "no-referrer" always;
}
```

Activez le site, vérifiez la syntaxe et rechargez Nginx :

```bash
rm -f /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/ledger-wallet /etc/nginx/sites-enabled/ledger-wallet
nginx -t && systemctl enable --now nginx && systemctl reload nginx
```

### 🖥️ 7. Accès à l'application

Ouvrez votre navigateur sur le réseau local et accédez à l'adresse IP de votre machine Debian (par exemple http://10.7.236.202).
💡 Note : Une pastille verte en bas à gauche de l'écran indique "DB: PostgreSQL connected" lorsque le frontend communique correctement avec l'API.

* 🔒 Sécurité & Bonnes Pratiques
* 🛡️ Isolation du réseau : L'API Node.js écoute uniquement sur 127.0.0.1 (localhost). Seul Nginx est exposé sur le port 80.

* 🌐 Usage local / VPN : Il est recommandé d'héberger cette application sur un réseau local privé ou d'y accéder via un tunnel sécurisé (Tailscale ou WireGuard) plutôt que d'exposer le port 80 directement sur Internet.

* ⚠️ Données affichées : Les numéros de cartes, soldes et transactions présents dans le code initial sont des données de démonstration. Ne stockez jamais d'informations bancaires réelles et sensibles en clair dans un dépôt public.


