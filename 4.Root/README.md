# 🔐 root - Comptes administrateurs Proxmox : bonnes pratiques

| #️⃣ | Participations |
|-|-|
| 1️⃣ | [:tada: Participation](.scripts/Participation-group1.md) |
| 2️⃣ | [:tada: Participation](.scripts/Participation-group2.md) |
| 3️⃣ | [:tada: Participation](.scripts/Participation-group3.md) |
| 4️⃣ | [:tada: Participation](.scripts/Participation-group4.md) |

## 🗄️ Rack 2️⃣ - 📇 42U

| Rack | U#️⃣| 🏙️ Serveurs | 🏷️  | S/N #️⃣        | Host IP                                  | RAM  | CPU | HD      | Comments                             |
| ---- | -:| ------------| --- | ------------ | ----------------------------------------- | ---: | ---:| ------- | ------------------------------------ |
| 2️⃣   | 34 | 🅰️ G7️⃣      | S28 | MXQ1370MCG✅ | [10.7.236.237](https://10.7.236.237:8006)  | 64GB | 16  | 273.4G  | $\color{green}\text{1TBNVMe}$  
| 2️⃣   | 33 | 🅰️ G7️⃣      | S35 | CZJ2030LYF✅ | [10.7.236.235](https://10.7.236.235:8006)  | 64GB | 16  | 273.4G  | $\color{green}\text{1TBNVMe}$  
| 2️⃣   | 32 | 🅰️ G7️⃣      | S26 | MXQ1170T6R✅ | [10.7.236.239](https://10.7.236.239:8006)  | 64GB | 16  | 273.4G  | $\color{green}\text{1TBNVMe}$  
| 2️⃣   | 31 | 🅰️ G7️⃣      | S20 | USE044N2AL✅ | [10.7.236.240](https://10.7.236.240:8006)  | 64GB | 16  | 273.4G  | $\color{green}\text{1TBNVMe}$  


## 🎯 Objectif

Apprendre à sécuriser l'accès à Proxmox VE en utilisant des comptes administrateurs individuels plutôt que le compte `root`.

---

# ❌ Mauvaise pratique

Tous les administrateurs utilisent :

```text
root@pam
```

Problèmes :

- ❌ Impossible de savoir qui a effectué une modification
- ❌ Partage du mot de passe
- ❌ Moins sécuritaire
- ❌ Plus difficile à dépanner

---

# ✅ Bonne pratique

Créer un compte par administrateur :

```text
djamel@pam
alice@pam
bob@pam
```

Chaque administrateur possède son propre compte.

---

# 👤 Créer un utilisateur Linux

* avec son compte boreal 🆔

```bash
adduser B🆔
```

Vérifier :

```bash
id 🆔
```

---

# 🖥️ Ajouter l'utilisateur à Proxmox

```bash
pveum user add B🆔@pam
```

Afficher les utilisateurs :

```bash
pveum user list
```

---

# 🔑 Donner les droits administrateur

```bash
pveum aclmod / \
    -user B🆔@pam \
    -role Administrator
```

Vérifier :

```bash
pveum acl list
```

---

# 🌐 Connexion à l'interface Web

Accéder à :

```text
https://IP_DU_SERVEUR:8006
```

Exemple :

```text
https://10.7.237.200:8006
```

Connexion :

```text
Utilisateur : B🆔@pam
Mot de passe : ********
```

---

# 💻 Connexion SSH

```bash
ssh B🆔@10.7.237.200
```

---

# 🔐 Utiliser une clé SSH

⚠️ Si tu as déjà une clé publique (i.e. ma_cle.pub) refère toi à [🔐](../X.Linux/3.keys)

Créer une paire de clés :

```bash
ssh-keygen -t ed25519
```

Copier la clé sur le serveur :

```bash
ssh-copy-id B🆔@10.7.237.200
```

Tester :

```bash
ssh B🆔@10.7.237.200
```

✅ Aucun mot de passe ne devrait être demandé.

---

# 🚨 Le compte root

Conserver :

```text
root@pam
```

uniquement pour :

- 🔧 Dépannage
- 🔄 Réinitialisation de mots de passe
- 🛠️ Maintenance d'urgence
- 🚑 Récupération du système

---

# ✅ Recommandations

| Méthode | Recommandation |
|----------|----------|
| Utiliser seulement `root@pam` | ❌ |
| Créer un compte par administrateur | ✅ |
| SSH avec mot de passe | ⚠️ |
| SSH avec clé publique | ✅ |
| Partager le compte root | ❌ |
| Utiliser les ACL Proxmox | ✅ |

---

# 🧪 Vérifications

Lister les utilisateurs :

```bash
pveum user list
```

Lister les rôles :

```bash
pveum role list
```

Lister les permissions :

```bash
pveum acl list
```

Tester SSH :

```bash
ssh BB🆔@10.7.237.200
```

---

# 🎓 Résultat attendu

✅ Chaque administrateur possède son propre compte

✅ Les actions sont traçables

✅ Les accès SSH sont sécurisés

✅ Le compte `root` est réservé aux urgences

✅ L'environnement Proxmox est plus sécuritaire
