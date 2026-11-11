# 🔐 Comptes administrateurs Proxmox – server239

| Champ | Information |
| --- | --- |
| Étudiant | Karim Bamba |
| Matricule | 300153972 |
| Cours | INF1085 – Administration Linux, Collège Boréal |
| Serveur | `server239` – Proxmox VE (Debian), `10.7.236.239` |
| Compte administrateur | `B300153972@pam` |

---

## 🎯 Objectif

Ne plus utiliser le compte partagé `root@pam` pour l'administration courante. Chaque administrateur a son propre compte, ce qui rend les actions traçables et évite de partager le mot de passe `root`.

| Méthode | Recommandation |
| --- | --- |
| Utiliser seulement `root@pam` | ❌ |
| Un compte par administrateur | ✅ |
| SSH avec mot de passe | ⚠️ |
| SSH avec clé publique | ✅ |
| Utiliser les ACL Proxmox | ✅ |

Le compte `root@pam` est gardé uniquement pour le dépannage, la réinitialisation de mots de passe et la récupération du système.

---

## 1. Connexion SSH au serveur (compte root)

```powershell
ssh root@10.7.236.239
```

L'invite `root@server239:~#` confirme que les commandes s'exécutent sur le serveur.

**`Connection timed out`** : le serveur ne répond pas du tout, le problème vient du réseau et pas du mot de passe. Le serveur a une adresse privée du collège : il faut être sur le réseau **Boréal** (labo ou Wi-Fi étudiant), ou sur le VPN FortiClient depuis la maison.

Vérifications depuis le PC :

```powershell
ipconfig                                   # le PC doit avoir une adresse en 10.7.x.x
ping 10.7.236.239                          # le serveur répond-il ?
Test-NetConnection 10.7.236.239 -Port 22   # le port SSH est-il ouvert ?
```

---

## 2. Premier essai : utilisateur `@pve` (erreur)

Au premier essai, j'ai créé un utilisateur dans le domaine **`pve`** (Proxmox VE authentication server), sans le préfixe **B** :

```bash
pveum user add 300153972@pve
pveum passwd add 300153972@pve     # erreur : 400 too many arguments
pveum passwd 300153972@pve
pveum acl modify / -user 300153972@pve -role Administrator
```

![Premier essai avec 300153972@pve](images/Screenshot%202026-10-14%20113852.png)

| Erreur | Cause | Correction |
| --- | --- | --- |
| `400 too many arguments` | Le mot `add` est de trop dans `pveum passwd` | `pveum passwd <userid>` |
| Compte `300153972@pve` | Préfixe **B** oublié, et domaine `pve` au lieu de `pam` | Recréé en `B300153972@pve`, puis remplacé par `B300153972@pam` |

**Différence entre `@pve` et `@pam` :**

- `@pve` : compte qui existe **seulement dans Proxmox**. Il permet d'ouvrir l'interface web, mais pas de se connecter en SSH.
- `@pam` : compte relié à un **vrai utilisateur Linux** du serveur. Le même compte sert pour l'interface web **et** pour SSH. C'est ce que demande la consigne.

Nettoyage des anciens comptes (`300153972@pve`, puis `B300153972@pve`) :

```bash
pveum acl delete / -user B300153972@pve -role Administrator
pveum user delete B300153972@pve
```

---

## 3. Créer l'utilisateur Linux

```bash
adduser --allow-bad-names --disabled-password --comment "Karim Bamba" B300153972
passwd B300153972
id B300153972
```

```text
uid=1004(B300153972) gid=1004(B300153972) groups=1004(B300153972),100(users)
```

- `adduser` crée le compte et son dossier `/home/B300153972`.
- `--allow-bad-names` est nécessaire parce que Debian refuse par défaut les noms d'utilisateur avec une majuscule (le **B**).
- `passwd` définit le mot de passe du compte, utilisé pour l'interface web.

---

## 4. Ajouter l'utilisateur à Proxmox

```bash
pveum user add B300153972@pam --firstname Karim --lastname Bamba --email 300153972@monboreal.ca
pveum user list
```

Avec `@pam`, il n'y a pas de `pveum passwd` à faire : Proxmox utilise le mot de passe Linux défini par `adduser`.

---

## 5. Donner les droits administrateur

```bash
pveum aclmod / -user B300153972@pam -role Administrator
pveum acl list
```

- `/` : la permission s'applique à tout le serveur (nœuds, VMs, stockages).
- `propagate = 1` : la permission est héritée par tous les sous-chemins.

---

## 6. Connexion à l'interface web

```text
https://10.7.236.239:8006
Utilisateur : B300153972
Realm       : Linux PAM standard authentication
```

---

## 7. Clé SSH

Depuis PowerShell sur mon PC. La clé privée reste sur le PC, seule la clé publique est copiée sur le serveur.

La paire de clés `id_ed25519` existait déjà (`ssh-keygen -t ed25519`). La clé publique a été copiée dans le dossier du nouveau compte, avec les bonnes permissions :

```powershell
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh root@10.7.236.239 "install -d -m 700 -o B300153972 -g B300153972 /home/B300153972/.ssh && cat >> /home/B300153972/.ssh/authorized_keys && chown B300153972:B300153972 /home/B300153972/.ssh/authorized_keys && chmod 600 /home/B300153972/.ssh/authorized_keys"
```

```text
drwx------ 2 B300153972 B300153972 4096 Nov  3 15:09 .
-rw------- 1 B300153972 B300153972   97 Nov  3 15:09 authorized_keys
```

> `ssh-copy-id` n'existe pas dans PowerShell. La commande `type ... | ssh ...` fait la même chose. On passe par `root` parce que le nouveau compte n'a pas encore de mot de passe.

- Si la clé a une phrase de passe, SSH demande `Enter passphrase for key` au lieu du mot de passe du compte.
- Si SSH redemande `B300153972@10.7.236.239's password`, la clé n'a pas été copiée correctement.

---

## 8. Vérifications

```bash
pveum user list
```

```text
│ userid         │ email                  │ enable │ firstname │ lastname │ realm-type │
│ B300153972@pam │ 300153972@monboreal.ca │ 1      │ Karim     │ Bamba    │ pam        │
```

```bash
pveum acl list
```

```text
│ path │ roleid        │ type │ ugid           │ propagate │
│ /    │ Administrator │ user │ B300153972@pam │ 1         │
```

Connexion SSH par clé, sans mot de passe :

```powershell
ssh B300153972@10.7.236.239 "whoami; hostname"
```

```text
B300153972
server239
```

---

## ✅ État d'avancement

| Étape | État |
| --- | --- |
| Connexion SSH en `root` | ✅ Fait |
| Suppression des comptes `@pve` | ✅ Fait |
| Utilisateur Linux `B300153972` | ✅ Fait |
| `B300153972@pam` dans Proxmox (nom, courriel) | ✅ Fait |
| Rôle Administrator sur `/` | ✅ Fait |
| Clé SSH sur le compte `B300153972` | ✅ Fait |
| Mot de passe Linux (`passwd`) et connexion web | ✅ Fait |

## 🎓 Conclusion

Avec un compte personnel `B300153972@pam`, mes actions sur le serveur sont traçables, je n'ai plus besoin du mot de passe `root`, et la connexion SSH se fait par clé publique. Le compte `root@pam` reste réservé aux urgences.
