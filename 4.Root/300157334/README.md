


# 🔐 racine
# Création d’un compte administrateur personnel sur Proxmox VE pour la VM

**👨‍🎓 Nom :** Hamdaoui Laala  
**🆔 Numéro étudiant :** 300157334  
**📅 Date :** 14 octobre 2026  
**💻 Sujet :** Administration des utilisateurs Proxmox VE

---

## 📌 1. Introduction

Dans ce laboratoire, l'objectif est de créer un compte administrateur personnel sur le serveur Proxmox VE.

Avant, on utilisait le compte partagé `root@pam` pour administrer le serveur. Mais cette méthode ne permet pas de savoir exactement quel étudiant a fait une modification.

Le but est donc d'avoir mon propre compte administrateur avec mon numéro étudiant, pour gérer les machines virtuelles et rendre les connexions plus sécurisées.

Pour ce travail, j'ai utilisé **Git Bash, SSH et l'interface Web de Proxmox**.

---

## 🖥️ 2. Informations du serveur

| ⚙️ Caractéristique | 📋 Configuration |
|---|---|
| Nom du serveur | server1 |
| Adresse IP | 10.7.236.240 |
| Interface Web | https://10.7.236.240:8006 |
| Hyperviseur | Proxmox VE |
| Compte personnel | B300157334@pam |
| Authentification | Linux PAM |
| Rôle à attribuer | Administrator |
| Machine virtuelle | laala |
| Identifiant VM | 100 |

📸 **Capture 1 – Interface principale de Proxmox**


![Paramètres de la VM](https://github.com/user-attachments/assets/d04a0ac0-7cc2-477e-80cc-05eca9616eb3)



## 🔌 3. Connexion SSH au serveur

### 🎯 Objectif

La première étape consiste à accéder au serveur Proxmox à distance à partir de mon ordinateur Windows.

J'ai ouvert Git Bash et utilisé la commande suivante :

```bash
ssh root@10.7.236.240
```

Lors de la première connexion, SSH demande de confirmer l'empreinte du serveur. J'ai accepté en tapant `yes`.

Une fois la connexion établie, je peux exécuter les commandes Linux directement sur le serveur.


## 👤 4. Création de mon utilisateur Linux

### 🎯 Objectif

Créer un compte Linux personnel avec mon numéro étudiant pour ne plus utiliser le compte partagé.

### 🛠️ Commande utilisée

```bash
adduser B300157334
```

Cette commande permet de créer un nouvel utilisateur Linux.

Le système demande ensuite de choisir un mot de passe et de compléter les informations de l'utilisateur.

J'ai utilisé la lettre **B** devant mon numéro étudiant, car un nom d'utilisateur composé uniquement de chiffres peut être refusé par Linux.

### ✅ Vérification

```bash
id B300157334
```

Cette commande permet de vérifier si mon utilisateur existe.



<img width="342" height="181" alt="image" src="https://github.com/user-attachments/assets/c8e5e7f3-b33e-4a58-94ba-c30e2c2bd578" />






## 🧩 5. Ajout de mon compte dans Proxmox

Après avoir créé le compte Linux, je dois aussi l'ajouter dans Proxmox.

### 🛠️ Commande

```bash
pveum user add B300157334@pam
```

Le domaine `@pam` signifie que Proxmox utilise l'authentification Linux.

Cela permet d'utiliser le compte Linux pour se connecter à l'interface Web de Proxmox.

### 🔎 Vérification

```bash
pveum user list
```

Cette commande affiche la liste des utilisateurs Proxmox.

Je dois retrouver mon compte :

`B300157334@pam`




<img width="383" height="71" alt="image" src="https://github.com/user-attachments/assets/48cf8f6f-0357-4dbf-bfd1-83896d032a24" />





## 🛡️ 6. Attribution des droits administrateur

### 🎯 Objectif

Après la création du compte, il faut lui donner les permissions nécessaires pour gérer le serveur.

### 🛠️ Commande

```bash
pveum aclmod / -user B300157334@pam -role Administrator
```

Cette commande attribue le rôle **Administrator** à mon compte sur le chemin `/` de Proxmox.

Ce rôle permet de gérer les machines virtuelles, le stockage et plusieurs paramètres d'administration.

### 🔎 Vérification des permissions

```bash
pveum acl list
```

Cette commande affiche les rôles et les permissions des utilisateurs.

Le résultat attendu pour mon compte est :

| Chemin | Rôle | Utilisateur |
|---|---|---|
| / | Administrator | B300157334@pam |


<img width="347" height="32" alt="image" src="https://github.com/user-attachments/assets/a6f910a5-7086-4f97-9447-c12efe41fb11" />


## 🌐 7. Connexion à l'interface Web

Après la configuration, je peux tester mon compte directement dans le navigateur.

### 🔗 Adresse du serveur

https://10.7.236.240:8006

### 🔑 Informations de connexion

- **Nom d'utilisateur :** B300157334
- **Domaine :** Linux PAM standard authentication
- **Mot de passe :** celui créé pendant la configuration

Après la connexion, je dois pouvoir accéder à l'interface Proxmox et gérer les ressources autorisées.



<img width="333" height="172" alt="image" src="https://github.com/user-attachments/assets/1a0642a6-f4ff-4f83-98ff-f503dfa381d2" />



## 🔑 8. Configuration de la clé SSH

### 🎯 Objectif

Le professeur a demandé l'utilisation d'une clé SSH pour sécuriser l'accès au serveur.

Une clé SSH permet de se connecter sans utiliser directement le mot de passe du compte à chaque connexion.

### 🛠️ Étape 1 – Générer une clé SSH

Dans Git Bash :

```bash
ssh-keygen -t ed25519
```

Cette commande crée deux clés :

- 🔓 Une clé publique, qui peut être partagée.
- 🔒 Une clé privée, qui doit rester secrète.

### 🛠️ Étape 2 – Afficher la clé publique

```bash
cat ~/.ssh/id_ed25519.pub
```

La clé publique peut être ajoutée au fichier `authorized_keys` du compte Linux concerné sur le serveur.

### 🛠️ Étape 3 – Tester la connexion

```bash
ssh B300157334@10.7.236.240
```

Si la clé publique a été correctement installée, l'authentification SSH peut se faire sans demander le mot de passe du compte.


 
 
 <img width="390" height="161" alt="image" src="https://github.com/user-attachments/assets/86135cd5-66d7-42e7-980a-f5a2492d3b10" />



## 💻 9. Vérification du système Proxmox

Pour vérifier les informations du système d'exploitation, j'ai utilisé :

```bash
cat /etc/os-release
```

Cette commande permet de connaître la distribution Linux installée.

Pour vérifier l'architecture du processeur :

```bash
uname -m
```

Pour afficher les machines virtuelles :

```bash
qm list
```

Cette dernière commande affiche les identifiants, les noms et les états des machines virtuelles.

Sur mon serveur, ma machine virtuelle est identifiée par le numéro **100**, avec le nom **laala**.


## ⚠️ 10. Difficultés rencontrées et solutions

### ❌ Problème 1 – Nom d'utilisateur

Un nom d'utilisateur uniquement numérique peut être refusé par Linux.

**✅ Solution :** utiliser la lettre B devant mon numéro étudiant : `B300157334`.

### ❌ Problème 2 – Permissions insuffisantes

Un utilisateur nouvellement créé ne possède pas automatiquement les droits administrateur dans Proxmox.

**✅ Solution :** attribuer le rôle Administrator avec la commande `pveum aclmod`.

### ❌ Problème 3 – Connexion SSH

La connexion SSH peut échouer si le nom d'utilisateur, l'adresse IP ou la clé SSH ne sont pas corrects.

**✅ Solution :** vérifier les informations de connexion et les permissions du fichier `authorized_keys`.

---

## 📊 11. Bilan du laboratoire

| Travail | Vérification |
|---|---|
| Connexion SSH au serveur | À confirmer par capture |
| Création du compte Linux | À confirmer par capture |
| Ajout de l'utilisateur Proxmox | À confirmer par capture |
| Attribution du rôle Administrator | À confirmer par capture |
| Connexion à l'interface Web | À confirmer par capture |
| Création de la clé SSH | À confirmer par capture |
| Connexion avec la clé SSH | À confirmer par capture |

---

## ✅ 12. Conclusion

Ce laboratoire m'a permis de mieux comprendre comment gérer les comptes utilisateurs sur un serveur Proxmox VE.

J'ai appris les commandes nécessaires pour créer un utilisateur Linux, l'ajouter dans Proxmox et lui donner les permissions administrateur.

J'ai aussi appris à utiliser Git Bash et SSH pour accéder à un serveur à distance.

La partie sur les clés SSH m'a permis de comprendre la différence entre une clé publique et une clé privée et l'importance de sécuriser les connexions.

Finalement, ce travail m'a aidé à mieux comprendre l'administration Linux et la gestion des permissions sur un serveur de virtualisation.

---

**👨‍🎓 Rapport préparé par : Hamdaoui Laala**  
**🆔 Numéro étudiant : 300157334**
