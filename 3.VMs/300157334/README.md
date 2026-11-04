# 🖥️ Rapport d'installation et de configuration d'une machine virtuelle Debian 13 sur Proxmox VE

## 👨‍🎓 Informations de l'étudiant et de la machine

| 📋 Information | ✅ Détails |
|---|---|
| 👤 Nom complet | Hamdaoui Laala |
| 🆔 Numéro d'étudiant | 300157334 |
| 💻 Nom de la machine virtuelle | laala |
| 🔢 Identifiant VM | 100 |
| 🐧 Système d'exploitation | Debian GNU/Linux 13 |
| 👨‍💻 Nom d'utilisateur | **laala2000** |
| 🌐 Adresse IP configurée | **10.7.236.229** |
| 📡 Masque réseau | 255.255.254.0 (/23) |
| 🚪 Passerelle | 10.7.237.1 |
| 🖥️ Adresse IP Proxmox | 10.7.236.240 |
| 🔐 Service SSH | Actif — Port 22 |

### 🔑 Commande de connexion SSH

Pour accéder à ma machine virtuelle depuis Git Bash :

```bash
ssh laala2000@10.7.236.229
```

Cette commande utilise la nouvelle adresse IP configurée. Son accessibilité doit être confirmée par un test de connexion.

---

## 📌 1. Introduction

Dans le cadre de ce laboratoire, j'ai réalisé l'installation et la configuration d'une machine virtuelle Debian sur un serveur utilisant **Proxmox VE**.

L'objectif principal de ce travail est de comprendre le fonctionnement de la virtualisation, d'apprendre à créer une machine virtuelle et de configurer les ressources matérielles nécessaires à son fonctionnement.

Ce laboratoire comprend également l'installation du système Debian, la configuration réseau, l'installation d'un serveur SSH et la préparation d'un accès à distance pour le professeur.

Durant la réalisation, plusieurs problèmes techniques ont été rencontrés et corrigés.

---

## ⚙️ 2. Configuration de la machine virtuelle

La machine virtuelle a été créée avec les caractéristiques suivantes :

| Caractéristique | Configuration |
|---|---|
| 🖥️ Nom de la VM | laala |
| 🆔 VM ID | 100 |
| 🛠️ Hyperviseur | Proxmox VE 7.0.2 |
| 🐧 Système d'exploitation | Debian GNU/Linux 13, 64 bits |
| 💾 Mémoire vive | 2048 Mo (2 Go) |
| ⚡ Processeur initial | 1 cœur |
| ⚡ Processeur demandé après modification | 2 cœurs |
| 🔧 Type de processeur | x86-64-v2 |
| 💽 Disque virtuel | 32 Go |
| 📂 Contrôleur de disque | VirtIO SCSI |
| 🌐 Interface réseau | VirtIO |
| 🔗 Pont réseau | vmbr0 |
| 📀 Fichier ISO | debian-13.7.0-amd64-netinst.iso |

### 📸 Captures de la configuration

![Configuration de la machine virtuelle](https://github.com/user-attachments/assets/c14aa222-0991-49dd-8dc6-69ef3b73257f)

![Paramètres de la VM](https://github.com/user-attachments/assets/d04a0ac0-7cc2-477e-80cc-05eca9616eb3)

---

## 🚀 3. Étapes de réalisation

### ✅ Étape 1 : Accès au serveur Proxmox

J'ai commencé par accéder à l'interface Web du serveur Proxmox VE depuis un navigateur.

**Adresse utilisée :**

`https://10.7.236.240:8006`

Après l'authentification avec un compte autorisé, j'ai accédé à l'interface d'administration permettant de créer et de gérer les machines virtuelles.

### ✅ Étape 2 : Importation du fichier ISO Debian

J'ai téléchargé l'image ISO de Debian 13, puis je l'ai importée dans le stockage local du serveur Proxmox.

Le fichier utilisé est :

`debian-13.7.0-amd64-netinst.iso`

Cette image a permis de procéder à l'installation du système d'exploitation dans la machine virtuelle.

### ✅ Étape 3 : Création de la machine virtuelle

Depuis l'interface Proxmox, j'ai créé une nouvelle machine virtuelle avec les paramètres suivants :

- Nom : **laala**
- Identifiant : **100**
- Mémoire RAM : **2048 Mo**
- Processeur initial : **1 cœur**
- Disque dur virtuel : **32 Go**
- Interface réseau : **VirtIO**
- Pont réseau : **vmbr0**

![Création de la machine virtuelle](https://github.com/user-attachments/assets/0d5512ab-8b17-4a16-886b-77c6e945a44b)

### ✅ Étape 4 : Résolution du problème de processeur

Lors du premier démarrage, une erreur liée aux fonctionnalités du processeur a empêché le lancement de la machine virtuelle.

Le processeur physique du serveur ne prenait pas en charge certaines fonctionnalités demandées par le processeur virtuel, notamment AES.

Pour corriger cette erreur, j'ai modifié le modèle du processeur virtuel avec la commande suivante :

```bash
qm set 100 --cpu x86-64-v2
```

Après cette modification, la machine virtuelle a pu démarrer correctement.

### ✅ Étape 5 : Démarrage de la machine virtuelle

Pour démarrer la machine virtuelle, j'ai exécuté la commande :

```bash
qm start 100
```

Pour vérifier son état :

```bash
qm list
```

La machine virtuelle **100 (laala)** apparaissait avec l'état :

`running`

![Démarrage de la VM](https://github.com/user-attachments/assets/6365b66a-0a31-4b77-9b69-6ab6a169cc22)

![Vérification de la VM](https://github.com/user-attachments/assets/a52b0ed9-a4e4-43cf-a13f-590c6c1115bc)

### ✅ Étape 6 : Installation de Debian 13

Après le démarrage de la machine virtuelle, j'ai lancé l'installation de Debian à partir du fichier ISO.

Pendant l'installation, j'ai configuré les paramètres du système, notamment la langue, le compte utilisateur, le mot de passe et le disque de destination.

**Compte utilisateur créé :** `laala2000`

Après l'installation, j'ai pu accéder à l'interface graphique de Debian.

![Installation Debian](https://github.com/user-attachments/assets/f5a1aae8-3615-4841-bde2-ac41cee0be3b)

![Connexion à Debian](https://github.com/user-attachments/assets/e1f1a619-f2e9-458a-83f5-fd9fe6ffef34)

---

## ⚡ 4. Modification des ressources du processeur

La machine virtuelle avait initialement un seul cœur CPU.

Afin d'améliorer ses ressources, j'ai entrepris de modifier sa configuration pour utiliser **2 cœurs virtuels**.

### Commandes de modification

Arrêt de la machine virtuelle :

```bash
qm shutdown 100
```

Modification du nombre de cœurs :

```bash
qm set 100 --cores 2
```

Redémarrage :

```bash
qm start 100
```

Vérification :

```bash
qm config 100 | grep cores
```

Résultat attendu :

```text
cores: 2
```

Cette modification permet à Debian d'utiliser deux cœurs virtuels au lieu d'un, sous réserve que la configuration soit bien appliquée.

---

## 🌐 5. Configuration de l'adresse IP

### 5.1 Vérification de l'adresse IP initiale

Après l'installation de Debian, j'ai vérifié la configuration réseau à l'aide des commandes :

```bash
ip a
ip route
```

Les informations obtenues étaient :

| Paramètre | Configuration |
|---|---|
| Interface réseau | ens18 |
| Adresse IP initiale | 10.7.237.151 |
| Masque | /23 |
| Passerelle | 10.7.237.1 |
| Attribution | DHCP |

L'adresse IP initiale était attribuée automatiquement par le serveur DHCP.

### 5.2 Modification de l'adresse IP

Pour répondre aux exigences du laboratoire, j'ai configuré une nouvelle adresse IP statique :

**Nouvelle adresse : `10.7.236.229/23`**

J'ai utilisé NetworkManager pour modifier la configuration.

Commande exécutée :

```bash
sudo nmcli connection modify 5482bf84-d815-4ad0-ae18-de45c3c7960b ipv4.addresses 10.7.236.229/23 ipv4.gateway 10.7.237.1 ipv4.method manual
```

Pour activer la nouvelle configuration :

```bash
sudo nmcli connection up "Wired connection 1"
```

La commande d'activation a retourné un message de réussite.

Pour vérifier l'adresse IP :

```bash
hostname -I
```

Le résultat attendu est :

```text
10.7.236.229
```

**Remarque :** l'activation de la connexion a réussi, mais la nouvelle adresse doit encore être confirmée avec `hostname -I`.

---

## 🔐 6. Installation et configuration du serveur SSH

Afin de pouvoir accéder à ma machine virtuelle à distance depuis Git Bash, j'ai installé le service OpenSSH.

### 6.1 Installation d'OpenSSH

J'ai exécuté les commandes suivantes dans Debian :

```bash
sudo apt update
sudo apt install openssh-server -y
```

### 6.2 Vérification du service SSH

Pour vérifier que le service fonctionne :

```bash
sudo systemctl status ssh
```

Résultat obtenu :

```text
ssh.service - OpenBSD Secure Shell server
Active: active (running)
```

Le service SSH est donc correctement installé et démarré.

### 6.3 Connexion à distance avec Git Bash

Depuis mon ordinateur Windows, je peux utiliser la commande suivante pour me connecter à ma machine Debian :

```bash
ssh laala2000@10.7.236.229
```

Cette connexion permet d'administrer Debian à distance sans passer par l'interface graphique de Proxmox.

La connexion avec la nouvelle adresse IP reste à vérifier.

---

## 🔑 7. Préparation de l'accès SSH pour le professeur

Afin de permettre au professeur d'accéder à ma machine virtuelle de manière sécurisée, j'ai préparé la configuration de l'authentification SSH par clé publique.

### Étape 1 : Création du dossier SSH

```bash
mkdir -p ~/.ssh
```

### Étape 2 : Configuration des permissions

```bash
chmod 700 ~/.ssh
```

### Étape 3 : Création du fichier des clés autorisées

```bash
nano ~/.ssh/authorized_keys
```

Ce fichier permet d'enregistrer la clé publique SSH du professeur.

### Étape 4 : Sécurisation du fichier

```bash
chmod 600 ~/.ssh/authorized_keys
```

### Étape 5 : Vérification de l'accès

Après l'ajout de la clé publique, le professeur pourra tester la connexion avec :

```bash
ssh laala2000@10.7.236.229
```

L'authentification devra être réalisée avec la clé privée correspondant à sa clé publique.

**État :** préparation réalisée, vérification de l'accès du professeur encore nécessaire.

---

## 🛠️ 8. Problèmes rencontrés et solutions

Pendant ce laboratoire, plusieurs problèmes ont été rencontrés.

| ❌ Problème | ✅ Solution |
|---|---|
| Incompatibilité AES du processeur | Modification du CPU virtuel en x86-64-v2 |
| Machine virtuelle ne démarrant pas | Correction de la configuration du processeur |
| Mot de passe Debian oublié | Réinitialisation du mot de passe utilisateur |
| Connexion SSH refusée | Installation du serveur OpenSSH |
| Erreurs de saisie des commandes Linux | Correction des commandes |
| Adresse IP initiale attribuée par DHCP | Configuration d'une adresse IP statique |
| Difficulté à utiliser la console noVNC | Utilisation du terminal et de Git Bash |
| Accès SSH du professeur non confirmé | Configuration des clés et test final à réaliser |

Ces problèmes m'ont permis de développer mes compétences en dépannage et en administration Linux.

---

## 🧪 9. Vérifications finales

Pour vérifier le fonctionnement de ma machine virtuelle, les commandes suivantes peuvent être utilisées.

### Vérifier l'état de la machine virtuelle

Dans Proxmox :

```bash
qm list
```

### Vérifier le nombre de processeurs

Dans Debian :

```bash
nproc
```

### Vérifier la mémoire RAM

```bash
free -h
```

### Vérifier les disques

```bash
lsblk
```

### Vérifier l'adresse IP

```bash
hostname -I
```

### Vérifier la passerelle

```bash
ip route
```

### Vérifier le service SSH

```bash
sudo systemctl status ssh
```

### Tester la connexion réseau

```bash
ping -c 4 10.7.237.1
```

Ces commandes permettent de vérifier la configuration matérielle, réseau et les services de la machine virtuelle.

---

## 🎯 10. Conclusion

Ce laboratoire m'a permis d'acquérir une expérience pratique dans l'installation et l'administration d'une machine virtuelle Debian sur Proxmox VE.

J'ai réussi à créer la machine virtuelle **laala (VM 100)**, installer Debian 13, résoudre une incompatibilité du processeur et démarrer le système d'exploitation.

J'ai également installé et activé le serveur SSH, configuré une nouvelle adresse IP statique et préparé l'authentification par clé publique pour permettre au professeur d'accéder à ma machine.

J'ai entrepris la modification des ressources du processeur afin de passer de 1 à 2 cœurs virtuels.

Les dernières vérifications concernent la confirmation des deux cœurs CPU, de la nouvelle adresse IP et de l'accès SSH du professeur.

Ce travail m'a permis d'améliorer mes connaissances en virtualisation, en administration Linux et en configuration des réseaux informatiques.

---

**👨‍🎓 Réalisé par : Hamdaoui Laala**  
**🆔 Numéro d'étudiant : 300157334**  
**🖥️ Machine virtuelle : laala — VM 100**  
**🌐 Adresse IP configurée : 10.7.236.229**  
**👤 Utilisateur Debian : laala2000**  
**🐧 Environnement : Debian 13 / Proxmox VE 7.0.2**
