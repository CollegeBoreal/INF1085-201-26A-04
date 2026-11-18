# 🔐 Comptes administrateurs Proxmox

### 📄 Rapport de laboratoire — modèle à compléter avec mes captures d’écran

---

### 👤 Informations générales

**Auteur :** Lachi Lahlou — B300150410

**Environnement :** Proxmox VE 9.2.2 — server237 (10.7.236.237)

**Sujet :** Création d’un compte administrateur individuel et sécurisation par clé SSH

**État :** Travail en cours — compléter uniquement après vérification des résultats

---

# 🎯 1. Objectifs du travail

Ce laboratoire vise à remplacer l’usage quotidien du compte partagé root@pam par un compte administrateur individuel, afin de mieux attribuer les actions et de sécuriser l’accès au serveur par clé SSH. Le compte root reste disponible pour les interventions autorisées.

### 📸 Capture d'écran — Environnement Proxmox

<img width="847" height="883" alt="image" src="https://github.com/user-attachments/assets/b82d0190-85c7-45e8-a5fb-b4b0019f6954" />

---

# 🛠️ 2. Procédure et preuves

## 🔹 2.1. Création de l’utilisateur Linux

Sur le serveur Proxmox (et non dans la VM Debian), créer le compte Linux. Utiliser le compte autorisé à administrer le nœud.

### 💻 Commandes exécutées

```bash
adduser B300150410
id B300150410
```

### 📸 Capture d'écran — Création de l'utilisateur Linux

<img width="828" height="639" alt="image" src="https://github.com/user-attachments/assets/c1dc9bd9-3414-422f-9753-db0134300464" />

---

## 🔹 2.2. Ajout du compte dans Proxmox et droits

Après autorisation du professeur, enregistrer l’utilisateur dans le realm PAM et lui attribuer le rôle Administrator à la racine. Cette attribution donne des droits très étendus sur le serveur partagé.

### 💻 Commandes exécutées

```bash
pveum user add B300150410@pam
pveum aclmod / -user B300150410@pam -role Administrator
pveum user list
pveum acl list
```

### 📸 Capture d'écran — Liste des utilisateurs et droits Proxmox

<img width="897" height="663" alt="image" src="https://github.com/user-attachments/assets/9d869895-d455-42eb-9766-34d9dd0dd890" />

---

## 🔹 2.3. Connexion à l’interface Web

Ouvrir l’interface Web Proxmox, se déconnecter de root et tester le nouveau compte avec le realm « Linux PAM standard authentication ». Vérifier que la connexion réussit.

### ⚙️ Paramètres de connexion

**Adresse du serveur :** https://10.7.236.237:8006

**Utilisateur :** B300150410

**Realm :** Linux PAM standard authentication

### 📸 Capture d'écran — Connexion à Proxmox

<img width="641" height="303" alt="image" src="https://github.com/user-attachments/assets/73c67d55-55ed-4a0e-95cf-9727bc7b414e" />

<img width="900" height="455" alt="image" src="https://github.com/user-attachments/assets/f1fb63d4-c2a6-4589-a0e2-bd73aaffa487" />

### 📸 CAPTURE 5 — Interface Proxmox après connexion, compte B300150410@pam visible

<img width="900" height="287" alt="image" src="https://github.com/user-attachments/assets/2b438856-eee9-4299-9b04-debd95fa7f79" />

---

## 🔹 2.4. Authentification SSH par clé ED25519

Dans Windows PowerShell, générer une paire de clés, puis copier uniquement la clé publique vers le compte Linux sur le serveur Proxmox. Si une clé ED25519 existe déjà, ne pas l’écraser : utiliser un nom de fichier distinct.

### 💻 Commande de génération de la clé SSH

```powershell
ssh-keygen -t ed25519 -f "$HOME\.ssh\proxmox_b300150410"
```

### 📸 Capture d'écran — Génération de la clé ED25519

<img width="900" height="766" alt="image" src="https://github.com/user-attachments/assets/f35bb9a3-807f-48ba-b9ea-43084cd9d5ba" />

<img width="900" height="103" alt="image" src="https://github.com/user-attachments/assets/cd4ae3e2-400e-4a74-8700-ad91af731249" />

---

### 🔑 Copie de la clé publique vers le serveur

Tester explicitement la clé privée sans autoriser l’authentification par mot de passe :

### 📸 Capture d'écran — Authentification SSH

<img width="900" height="111" alt="image" src="https://github.com/user-attachments/assets/12466801-938b-47f3-8dd8-fe0333abab1c" />

---

# ✅ 4. Résultat attendu et vérification

- Compte Linux B300150410 créé.
- Compte Proxmox B300150410@pam enregistré.
- Rôle Administrator attribué avec autorisation.
- Connexion Web avec compte individuel.
- Connexion SSH par clé ED25519.

---

# 🎓 5. Conclusion (à compléter après le laboratoire)

Après avoir réalisé et vérifié les étapes, décrire ici les résultats obtenus, les difficultés rencontrées et les solutions appliquées. Ne déclarer une étape réussie que lorsqu’elle a été testée.

---
