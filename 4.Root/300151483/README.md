# 🔐 Root - Comptes administrateurs Proxmox

| Champ | Valeur |
|-------|--------|
| Nom | Arnauld Tchumno |
| Numéro étudiant | 300151483 |
| Serveur Proxmox | `server237` - [10.7.236.237](https://10.7.236.237:8006) |
| Compte créé | `B300151483@pam` |
| Date | 14 octobre 2026 |

## 🎯 Objectif

Ne plus utiliser le compte partagé `root@pam` pour administrer Proxmox, et créer un compte administrateur personnel. Ainsi, chaque action sur le serveur peut être attribuée à la bonne personne.

## Travail réalisé

- [x] Connexion SSH au serveur Proxmox
- [x] Création de l'utilisateur Linux `B300151483`
- [x] Ajout de l'utilisateur à Proxmox (`B300151483@pam`)
- [x] Attribution du rôle `Administrator`
- [x] Vérification des utilisateurs et des permissions
- [x] Vérification dans l'interface Web
- [x] Clé SSH personnelle et clé du professeur autorisées sur mon compte (connexion sans mot de passe)

---

## 1. Connexion SSH au serveur

### Problème rencontré

Ma première tentative de connexion a échoué à cause d'une erreur dans mon fichier `~/.ssh/config` :

```text
C:\Users\K TECH SOLUTION/.ssh/config: line 4: Bad configuration option: identity
```

![Erreur de configuration SSH](images/01-ssh-config-erreur.png)

*Figure 1 : `identity` n'est pas une option valide du client OpenSSH.*

### Correction

J'ai ouvert le fichier avec `nano ~/.ssh/config` et j'ai corrigé la ligne 4. La bonne option est `IdentityFile`. Exemple de bloc valide :

```text
Host server237
    HostName 10.7.236.237
    User root
    IdentityFile ~/.ssh/id_ed25519
```

La connexion a ensuite fonctionné. À la première connexion, SSH demande de confirmer l'empreinte ED25519 du serveur :

```bash
ssh root@10.7.236.237
```

![Connexion SSH réussie](images/02-ssh-root.png)

*Figure 2 : Connexion réussie à `server237` (noyau `7.0.2-6-pve`).*

---

## 2. Créer l'utilisateur Linux

```bash
adduser B300151483
```

La commande demande un mot de passe puis les informations de l'utilisateur (nom complet, salle 208, etc.).

> ⚠️ **Remarque** : `adduser 300151483` est refusé :
> `err: To avoid ambiguity with numerical UIDs, usernames which resemble numbers or negative numbers are not allowed.`
> Linux interdit les noms d'utilisateur purement numériques, car ils se confondent avec des UID. C'est pour cela qu'on ajoute la lettre **B** devant le numéro étudiant.

Pour la même raison, `id 300151483` répond `no such user`. Il faut vérifier avec le bon nom :

```bash
id B300151483
```

---

## 3. Ajouter l'utilisateur à Proxmox

```bash
pveum user add B300151483@pam
pveum user list
```

Le domaine `@pam` indique que Proxmox utilise l'authentification Linux (PAM). C'est donc le mot de passe défini avec `adduser` qui sert.

![adduser et pveum user list](images/03-adduser-pveum.png)

*Figure 3 : Création de l'utilisateur. `B300151483@pam` apparaît dans `pveum user list`, avec `enable = 1`.*

---

## 4. Donner les droits administrateur

```bash
pveum aclmod / \
    -user B300151483@pam \
    -role Administrator
```

Vérification :

```bash
pveum acl list
```

| path | roleid | type | ugid | propagate |
|------|--------|------|------|-----------|
| `/` | Administrator | user | **B300151483@pam** | 1 |
| `/` | Administrator | user | B300145955@pam | 1 |
| `/` | Administrator | user | B300150468@pam | 1 |
| `/` | Administrator | user | B300142542@pam | 1 |

![pveum acl list](images/04-acl-administrator.png)

*Figure 4 : Avant `aclmod`, mon compte n'avait aucun droit. Après, il a le rôle `Administrator` sur `/`, et `propagate = 1` étend ce droit à tous les objets en dessous (nœuds, VM, stockage).*

> 💡 Dans la figure 4, `https://IP_DU_SERVEUR:8006` a été tapé dans le terminal, ce qui provoque `No such file or directory`. Cette adresse doit être ouverte dans un **navigateur Web**, pas dans le shell.

---

## 5. Interface Web

Adresse : [https://10.7.236.237:8006](https://10.7.236.237:8006). On se connecte avec `B300151483` et le realm **Linux PAM standard authentication**.

![Interface Proxmox](images/05-interface-web.png)

*Figure 5 : Datacenter → Permissions → Users. On voit le nœud `server237` et le stockage `local` / `local-lvm`. Le journal des tâches montre que chaque étudiant apparaît avec son propre compte (`B300142542@pam`, `B300145955@pam`) au lieu de `root@pam` : les actions sont traçables.*

---

## 6. Vérification du système

```bash
cat /etc/os-release
uname -m
```

![os-release](images/06-os-release.png)

*Figure 6 : Proxmox VE 9.2 repose sur **Debian GNU/Linux 13 (trixie)**, version 13.5, architecture `x86_64`.*

---

## 7. Clé SSH : connexion sans mot de passe

### Ma paire de clés

J'avais déjà une paire de clés ED25519 sur mon PC (`~/.ssh/id_ed25519` et `~/.ssh/id_ed25519.pub`), créée avec :

```bash
ssh-keygen -t ed25519 -C "300151483@monboreal.com"
```

Comme le recommande le guide [🔐 X.Linux/3.keys](../../X.Linux/3.keys), je n'en ai pas recréé une nouvelle.

### Autoriser les clés sur mon compte du serveur

Dans le **Shell** de `server237` (interface Web), connecté avec mon propre compte `B300151483` et non `root`, j'ai ajouté deux clés publiques dans `~/.ssh/authorized_keys` :

- **ma clé** (`ssh-ed25519 ... 300151483@monboreal.com`) ;
- **la clé du professeur** (`ssh-rsa ... b300098957@ramena`), fournie dans le guide `X.Linux/3.keys`.

```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
echo 'ssh-rsa AAAAB3NzaC1yc2E...RP5N b300098957@ramena' >> ~/.ssh/authorized_keys
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1...31HqC 300151483@monboreal.com' >> ~/.ssh/authorized_keys
```

C'est l'équivalent de `ssh-copy-id -i ~/.ssh/id_ed25519.pub B300151483@10.7.236.237` lancé depuis mon PC.

![Clés autorisées sur server237](images/07-cle-ssh-authorized-keys.png)

*Figure 7 : Sur `server237`, avec le compte `B300151483` (uid 1003) : le dossier `~/.ssh` est en `drwx------` (700), `authorized_keys` en `-rw-------` (600), et le fichier contient les deux clés, `b300098957@ramena` (professeur) et `300151483@monboreal.com` (moi).*

> **Pourquoi ces droits ?** OpenSSH refuse d'utiliser `authorized_keys` si d'autres utilisateurs peuvent le modifier (option `StrictModes`). Avec 700 sur le dossier et 600 sur le fichier, moi seul peux le lire et le modifier.

### Test depuis mon PC

```text
$ ssh -o BatchMode=yes B300151483@10.7.236.237 'echo "Connexion par cle OK : $(whoami)@$(hostname)"; uname -r'
Connexion par cle OK : B300151483@server237
7.0.2-6-pve
```

L'option `BatchMode=yes` interdit toute demande de mot de passe. Si la clé n'était pas acceptée, la commande échouerait avec `Permission denied`. ✅ Aucun mot de passe n'a été demandé.

---

## ✅ Bilan

| Méthode | Recommandation |
|---------|----------------|
| Utiliser seulement `root@pam` | ❌ |
| Un compte par administrateur (`B300151483@pam`) | ✅ |
| SSH avec mot de passe | ⚠️ |
| SSH avec clé publique | ✅ |
| Rôles via les ACL Proxmox | ✅ |

Le compte `root@pam` doit être réservé au dépannage, aux réinitialisations de mot de passe et à la maintenance d'urgence.
