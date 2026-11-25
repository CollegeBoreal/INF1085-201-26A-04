# SMARTWALLET // PRO

## Portefeuille numérique personnel interactif en 3D

SMARTWALLET // PRO est une application web interactive de gestion de documents personnels, hébergée sur une machine virtuelle Debian via Proxmox VE et propulsée par le serveur web Nginx.

L'application propose une interface moderne et futuriste avec un design noir carbone, des couleurs vert néon, des animations 3D et un portefeuille numérique inspiré des applications mobiles modernes.

## Aperçu du projet

L'objectif de ce projet est de centraliser différents documents personnels dans un portefeuille numérique interactif permettant de consulter, organiser, ajouter et supprimer des cartes, tout en assurant le suivi de leurs dates d'expiration.

## Fonctionnalités principales

### Portefeuille interactif en 3D

- Ouverture et fermeture animées du portefeuille.
- Superposition des cartes numériques.
- Ouverture des cartes en éventail.
- Retournement des cartes à 180 degrés.
- Effets de reflets métalliques.
- Design noir carbone et vert néon.
- Navigation tactile sur téléphone.
- Interface adaptée aux ordinateurs et aux appareils mobiles.

### Documents intégrés

- Desjardins : assurance automobile.
- RAMQ : carte d'assurance maladie.
- SAAQ : permis de conduire.
- Collège Boréal : carte étudiante.
- Certificat d'immatriculation du véhicule.

Toutes les cartes contiennent des données fictives et sont utilisées uniquement à des fins éducatives.

### Gestion des documents

- Ajout de nouvelles cartes.
- Suppression des cartes existantes.
- Recherche instantanée.
- Consultation des informations au verso.
- Suivi des dates d'expiration.
- Identification des documents à renouveler.
- Sauvegarde locale dans le navigateur avec LocalStorage.

### Tableau de bord

Le tableau de bord permet de consulter :

- Le nombre total de documents.
- Le nombre de documents actifs.
- Le nombre de documents à renouveler.
- Le nombre de documents expirés.

## Architecture et infrastructure

| Composant | Configuration |
| :--- | :--- |
| Hyperviseur | Proxmox VE |
| Système d'exploitation | Debian 13 |
| Serveur web | Nginx |
| Adresse IP | 10.7.236.205 |
| Protocole | HTTP |
| Port | 80 |
| Administration distante | SSH via PowerShell |
| Frontend | HTML5, CSS3 et JavaScript |
| Animations | CSS 3D |
| Stockage | LocalStorage |
| Répertoire web | /var/www/smartwallet |
| Fichier principal | index.html |

## Architecture du projet

```text
Ordinateur Windows / Téléphone
              |
              | HTTP - Port 80
              |
              v
      10.7.236.205
              |
        Proxmox VE
              |
        VM Debian 13
              |
            Nginx
              |
   /var/www/smartwallet/
              |
          index.html
```

## Installation et déploiement

### 1. Prérequis

- Une machine virtuelle Debian opérationnelle sur Proxmox VE.
- Une adresse IP accessible sur le réseau local.
- Un accès SSH.
- Un compte administrateur.
- Une connexion réseau fonctionnelle.

### 2. Connexion à Debian depuis PowerShell

```powershell
ssh lahloulachi@10.7.236.205
```

Passage en mode administrateur :

```bash
su -
```

### 3. Installation du serveur web Nginx

Mise à jour des paquets et installation des composants nécessaires :

```bash
apt update
apt install -y nginx curl ca-certificates
```

Activation du serveur web :

```bash
systemctl enable --now nginx
```

Vérification du fonctionnement :

```bash
systemctl is-active nginx
```

Résultat obtenu :

```text
active
```

### 4. Création du répertoire de l'application

```bash
mkdir -p /var/www/smartwallet
cd /var/www/smartwallet
```

Création du fichier principal :

```bash
nano index.html
```

Le fichier index.html contient l'ensemble du code HTML, CSS et JavaScript nécessaire au fonctionnement de l'application.

### 5. Configuration de Nginx

Création du fichier de configuration :

```bash
nano /etc/nginx/sites-available/smartwallet
```

Configuration du serveur web :

```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    server_name _;
    root /var/www/smartwallet;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header Referrer-Policy "no-referrer" always;
}
```

### 6. Activation du site web

Désactivation du site par défaut :

```bash
rm -f /etc/nginx/sites-enabled/default
```

Activation de SmartWallet :

```bash
ln -sf /etc/nginx/sites-available/smartwallet /etc/nginx/sites-enabled/smartwallet
```

Vérification de la configuration :

```bash
nginx -t
```

Résultat obtenu :

```text
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Rechargement du serveur web :

```bash
systemctl reload nginx
```

### 7. Test de fonctionnement

Vérification de la disponibilité de l'application :

```bash
curl -I http://10.7.236.205
```

Résultat obtenu :

```text
HTTP/1.1 200 OK
Server: nginx
Content-Type: text/html
Content-Length: 51097
Connection: keep-alive
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
Referrer-Policy: no-referrer
```

Le code HTTP 200 OK confirme que le serveur Nginx répond correctement aux requêtes HTTP.

## Accès à l'application

L'application est accessible depuis un navigateur web sur le réseau local à l'adresse suivante :

http://10.7.236.205

Elle peut être consultée depuis :

- Un ordinateur Windows.
- Un ordinateur Linux.
- Un téléphone Android.
- Un iPhone.
- Une tablette.

L'appareil doit être connecté à un réseau autorisant l'accès à la machine virtuelle Debian.

## Sécurité et bonnes pratiques

- Administration distante via SSH.
- Utilisation d'une adresse IP privée.
- Configuration d'en-têtes de sécurité HTTP.
- Utilisation exclusive de données fictives.
- Aucun stockage de véritables informations bancaires ou personnelles.
- Hébergement sur un réseau local.
- Possibilité d'utiliser un VPN pour un accès distant sécurisé.

Le stockage LocalStorage n'est pas chiffré et ne doit pas être utilisé pour conserver des informations sensibles.

## Technologies utilisées

- Proxmox VE
- Debian 13
- Nginx
- PowerShell
- OpenSSH
- HTML5
- CSS3
- JavaScript
- LocalStorage

## Améliorations futures

- Installation d'un certificat HTTPS.
- Authentification des utilisateurs.
- Intégration d'une base de données.
- Notifications automatiques de renouvellement.
- Exportation des documents.
- Transformation en Progressive Web App (PWA).
- Accès distant sécurisé via VPN.

## Documentation et références

- Proxmox VE : https://pve.proxmox.com/pve-docs/
- Debian : https://www.debian.org/doc/
- Nginx : https://nginx.org/en/docs/
- MDN Web Docs : https://developer.mozilla.org/fr/
- OpenSSH : https://www.openssh.com/

## Conclusion

Ce projet m'a permis de mettre en pratique mes connaissances en administration Linux, virtualisation, configuration de serveurs web et développement web.

J'ai installé et configuré un serveur Nginx sur une machine virtuelle Debian hébergée dans Proxmox VE, puis déployé une application web interactive de gestion de documents personnels.

Les tests de configuration Nginx et la réponse HTTP 200 OK confirment le bon fonctionnement du serveur web.

SMARTWALLET // PRO représente une solution moderne de démonstration combinant administration système, infrastructure réseau et développement web interactif.

## Auteur

**Développé et déployé par Lachi Lahlou**

- Établissement : Collège Boréal
- Campus : Toronto
- Programme : TSIQ
- Année : 2026

---

SMARTWALLET // PRO — YOUR LIFE. ONE WALLET.
