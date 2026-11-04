# 🖥️ Rapport d'installation et de configuration d'une machine virtuelle Debian sur Proxmox VE

**👨‍🎓 Étudiant :** Hamdaoui Laala  
**🆔 Numéro d'étudiant :** 300157334  
**📚 Projet :** Installation et administration d'une machine virtuelle  
**🛠️ Technologies :** Proxmox VE, Debian GNU/Linux, SSH et Linux

---

## 📌 1. Introduction

Dans le cadre de ce laboratoire, j'ai réalisé l'installation et la configuration d'une machine virtuelle Debian sur un serveur utilisant l'hyperviseur Proxmox VE.

L'objectif principal de ce travail était d'apprendre à créer une machine virtuelle, installer un système d'exploitation Linux, configurer les ressources matérielles et mettre en place une connexion réseau permettant l'administration à distance.

Durant ce laboratoire, j'ai également rencontré plusieurs difficultés techniques que j'ai pu résoudre progressivement.

## ⚙️ 2. Configuration de la machine virtuelle

| Caractéristique | Configuration |
|---|---|
| 🖥️ Nom de la VM | laala |
| 🆔 Identifiant VM | 100 |
| 🛠️ Hyperviseur | Proxmox VE 7.0.2 |
| 🐧 Système d'exploitation | Debian GNU/Linux 13 |
| 💾 Mémoire vive | 2048 Mo (2 Go) |
| ⚡ Processeur | 2 cœurs virtuels (configuration demandée) |
| 🔧 Type de processeur | x86-64-v2 |
| 💽 Disque virtuel | 32 Go |
| 📂 Contrôleur de disque | VirtIO SCSI |
| 🌐 Interface réseau | VirtIO |
| 🔗 Pont réseau | vmbr0 |
| 📀 Fichier ISO | debian-13.7.0-amd64-netinst.iso |
| 👤 Utilisateur Debian | laala2000 |
| 🔐 Accès distant | OpenSSH |
| 🌍 Adresse IP initiale | 10.7.237.151 |
| 🌍 Nouvelle adresse IP configurée | 10.7.236.229 |
| 🚪 Passerelle | 10.7.237.1 |
| 📡 Interface Debian | ens18 |

### 📸 Captures de la configuration

![Configuration de la VM](https://github.com/user-attachments/assets/c14aa222-0991-49dd-8dc6-69ef3b73257f)

![Paramètres de la machine virtuelle](https://github.com/user-attachments/assets/d04a0ac0-7cc2-477e-80cc-05eca9616eb3)

---

## 🚀 3. Étapes de réalisation

### ✅ Étape 1 : Connexion au serveur Proxmox

J'ai commencé par accéder à l'interface Web de Proxmox VE à l'aide d'un navigateur.

**Adresse du serveur :**

`https://10.7.236.240:8006`

Après l'authentification, j'ai pu accéder aux différentes fonctionnalités permettant la gestion des machines virtuelles.

### ✅ Étape 2 : Importation de l'image ISO Debian

J'ai téléchargé l'image ISO de Debian 13, puis je l'ai importée dans le stockage local de Proxmox.

Le fichier utilisé était :

`debian-13.7.0-amd64-netinst.iso`

Cette image a servi à installer le système d'exploitation dans la machine virtuelle.

### ✅ Étape 3 : Création de la machine virtuelle

Depuis l'interface Proxmox, j'ai créé une nouvelle machine virtuelle avec les paramètres suivants :

- Nom : **laala**
- VM ID : **100**
- Système : Debian GNU/Linux
- Mémoire : 2048 Mo
- Disque : 32 Go
- Réseau : VirtIO connecté à vmbr0

![Création de la VM](https://github.com/user-attachments/assets/0d5512ab-8b17-4a16-886b-77c6e945a44b)

### ✅ Étape 4 : Résolution du problème de processeur

Lors du premier démarrage, la machine virtuelle ne pouvait pas démarrer correctement.

Le serveur physique ne prenait pas en charge certaines fonctionnalités demandées par le processeur virtuel, notamment AES.

Pour résoudre ce problème, j'ai utilisé la commande suivante dans le terminal Proxmox :

```bash
qm set 100 --cpu x86-64-v2
```

Après cette modification, le démarrage de la VM a pu être effectué.

### ✅ Étape 5 : Démarrage de la machine virtuelle

J'ai démarré ma machine virtuelle avec la commande :

```bash
qm start 100
```

Pour vérifier son état :

```bash
qm list
```

La machine virtuelle **100 (laala)** apparaissait avec l'état :

`running`

![Démarrage de Debian](https://github.com/user-attachments/assets/6365b66a-0a31-4b77-9b69-6ab6a169cc22)

![Vérification de la VM](https://github.com/user-attachments/assets/a52b0ed9-a4e4-43cf-a13f-590c6c1115bc)

### ✅ Étape 6 : Installation et connexion à Debian

Après le démarrage, j'ai poursuivi l'installation de Debian et configuré mon compte utilisateur.

**Nom d'utilisateur :** `laala2000`

J'ai ensuite pu accéder à l'interface graphique de Debian 13.

![Installation Debian](https://github.com/user-attachments/assets/f5a1aae8-3615-4841-bde2-ac41cee0be3b)

![Connexion à Debian](https://github.com/user-attachments/assets/e1f1a619-f2e9-458a-83f5-fd9fe6ffef34)

---

## ⚡ 4. Modification des ressources CPU

Afin d'améliorer les ressources disponibles pour la machine virtuelle, j'ai entrepris de passer de **1 à 2 cœurs CPU virtuels**.

Les commandes utilisées pour cette opération sont :

```bash
qm shutdown 100
qm set 100 --cores 2
qm start 100
```

Pour vérifier la configuration :

```bash
qm config 100 | grep cores
```

Le résultat attendu est :

```text
cores: 2
```

Cette modification permet à Debian de disposer de deux cœurs virtuels pour exécuter ses processus.

---

## 🌐 5. Configuration du réseau Debian

### 5.1 Vérification de
