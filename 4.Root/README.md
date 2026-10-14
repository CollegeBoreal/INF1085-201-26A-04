# 🔐 root - Comptes administrateurs Proxmox : bonnes pratiques

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

:id:

```bash
adduser B
```

Vérifier :

```bash
id alice
```

---

# 🖥️ Ajouter l'utilisateur à Proxmox

```bash
pveum user add alice@pam
```

Afficher les utilisateurs :

```bash
pveum user list
```

---

# 🔑 Donner les droits administrateur

```bash
pveum aclmod / \
    -user alice@pam \
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
Utilisateur : alice@pam
Mot de passe : ********
```

---

# 💻 Connexion SSH

```bash
ssh alice@10.7.237.200
```

---

# 🔐 Utiliser une clé SSH

Créer une paire de clés :

```bash
ssh-keygen -t ed25519
```

Copier la clé sur le serveur :

```bash
ssh-copy-id alice@10.7.237.200
```

Tester :

```bash
ssh alice@10.7.237.200
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
ssh alice@10.7.237.200
```

---

# 🎓 Résultat attendu

✅ Chaque administrateur possède son propre compte

✅ Les actions sont traçables

✅ Les accès SSH sont sécurisés

✅ Le compte `root` est réservé aux urgences

✅ L'environnement Proxmox est plus sécuritaire
