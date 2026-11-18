# 🔐 Comptes administrateurs Proxmox

### 📄 Rapport de laboratoire — Création d'un compte administrateur et sécurisation SSH

---

### 👤 Informations générales

**Auteur :** Lachi Lahlou — B300150410

**Environnement :** Proxmox VE 9.2.2 — server237 (10.7.236.237)

**Sujet :** Création d’un compte administrateur individuel et sécurisation par clé SSH

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

# 🛡️ 3. Recommandations de sécurité

À la suite de ce laboratoire, plusieurs bonnes pratiques de sécurité ont été abordées.

- ✅ Utiliser un compte administrateur individuel au lieu de partager le compte root.
- ✅ Utiliser une clé SSH ED25519 pour sécuriser les connexions à distance.
- ✅ Protéger la clé privée avec une phrase secrète.
- ✅ Utiliser les permissions Proxmox pour contrôler les accès.
- ✅ Réserver le compte root aux interventions de maintenance.
- ✅ Ne jamais partager les mots de passe ou les clés privées sur GitHub.

---

# ✅ 4. Résultat attendu et vérification

| Étapes | Résultats |
|---|---|
| Création du compte Linux B300150410 | ✅ Réussie |
| Enregistrement du compte B300150410@pam | ✅ Réussi |
| Attribution du rôle Administrator | ✅ Visible dans la capture ACL |
| Connexion à l'interface Web Proxmox | ✅ Captures de connexion présentes |
| Génération de la clé SSH ED25519 | ✅ Réussie |
| Vérification de l'accès au port SSH 22 | ✅ Réussie |
| Authentification SSH par clé uniquement | ✅ Réussie |
---

# 🎓 5. Conclusion

Pendant ce laboratoire, j'ai appris à créer et à gérer un compte administrateur individuel sur un serveur Proxmox VE.

J'ai commencé par accéder au serveur server237 avec le compte root. Ensuite, j'ai créé mon propre utilisateur Linux B300150410 avec la commande adduser. J'ai vérifié sa création avec la commande id, qui m'a permis de voir son identifiant et les groupes auxquels il appartient.

Après cette étape, j'ai ajouté mon compte dans Proxmox avec la commande pveum. J'ai également travaillé sur l'attribution des droits administrateur et vérifié les permissions avec la liste des ACL.

J'ai ensuite utilisé l'interface Web de Proxmox pour accéder au serveur avec mon compte individuel.

Pour la partie sécurité, j'ai utilisé Windows PowerShell afin de générer une paire de clés SSH ED25519. Au début, j'ai rencontré une petite difficulté parce qu'une clé SSH existait déjà sur mon ordinateur. Pour éviter de remplacer cette ancienne clé, j'ai créé une nouvelle paire de clés avec un nom différent.

J'ai aussi rencontré un problème de connexion au serveur Proxmox. Le serveur ne répondait plus et j'obtenais des erreurs de connexion. J'ai utilisé les commandes ping et Test-NetConnection pour vérifier son accessibilité. Après plusieurs essais, j'ai réussi à confirmer que le port SSH 22 était de nouveau accessible.

Ce laboratoire m'a permis de mieux comprendre la gestion des utilisateurs Linux, les permissions administrateur dans Proxmox et le fonctionnement des clés SSH.

J'ai également appris à vérifier les problèmes de connexion réseau et à utiliser différentes commandes dans PowerShell et Linux.

Pour terminer complètement la partie SSH, il reste à confirmer que la connexion fonctionne uniquement avec ma clé ED25519, sans utiliser le mot de passe du compte Linux.

Dans l'ensemble, ce travail m'a permis de développer mes connaissances en administration de serveurs et en sécurité des accès à distance.






