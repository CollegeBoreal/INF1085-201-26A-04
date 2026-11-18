
<div align="center">

# 🔐 Sécurisation des accès administrateur à Proxmox VE

### Comptes individuels · Permissions ACL · Authentification SSH par clé publique

![Proxmox VE](https://img.shields.io/badge/Proxmox_VE-9.2.2-E57000?style=for-the-badge&logo=proxmox&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-PAM-263238?style=for-the-badge&logo=linux&logoColor=white)
![SSH](https://img.shields.io/badge/SSH-ED25519-198754?style=for-the-badge)
![Statut](https://img.shields.io/badge/Atelier-Valid%C3%A9-2ea44f?style=for-the-badge)

**Nassim Idir** · **300151504**  
**Serveur :** `server238` · **18 novembre 2026**

</div>

---

> [!IMPORTANT]
> **Objectif :** utiliser un compte administrateur personnel pour la gestion courante de Proxmox et réserver `root@pam` aux opérations exceptionnelles. Ce dépôt documente les **vérifications effectuées**, illustrées par des captures d'écran réelles.

## 📚 Sommaire

1. [Présentation de l'environnement](#-présentation-de-lenvironnement)
2. [Vérification du compte Linux](#-vérification-du-compte-linux)
3. [Enregistrement dans Proxmox](#-enregistrement-dans-proxmox)
4. [Contrôle des permissions ACL](#-contrôle-des-permissions-acl)
5. [Connexion à l'interface Web](#-connexion-à-linterface-web)
6. [Connexion Linux et SSH](#-connexion-linux-et-ssh)
7. [Configuration de la clé SSH](#-configuration-de-la-clé-ssh)
8. [Validation finale](#-validation-finale)
9. [Recommandations et limites](#-recommandations-et-limites)

## 🖥️ Présentation de l'environnement

| Élément | Configuration constatée |
|:--|:--|
| Hyperviseur | Proxmox Virtual Environment **9.2.2** |
| Nœud | `server238` |
| Adresse du serveur | `10.7.236.235` (réseau du laboratoire) |
| Compte personnel Linux | `B300151504` |
| Compte Proxmox | `B300151504@pam` |
| Rôle accordé | `Administrator` sur `/` |
| Ordinateur client | Windows / PowerShell |
| Authentification SSH | Clé publique **ED25519** |

**Pourquoi changer de méthode ?** Un compte `root@pam` partagé empêche d'attribuer clairement les opérations à chaque administrateur. Le compte individuel améliore la traçabilité et limite le partage d'identifiants.

## 🛡️ Vérification de l'accès au nœud

Une session a d'abord été ouverte dans le **Shell du nœud** (et non dans la console de la VM Debian).

```bash
whoami
# root
```

![Shell root du serveur Proxmox](images/01_connexion_shell_root.png)

*Figure 1 — Accès au Shell du nœud `server238` avec `root` pour les vérifications initiales.*

## 👤 Vérification du compte Linux

Le compte était **déjà présent** au moment de l'atelier : inutile de le recréer.

```bash
adduser B300151504   # Commande de création initiale, non relancée
id B300151504
```

Résultat observé : `uid=1000(B300151504)`, groupe principal `B300151504`.

![Vérification de l'utilisateur Linux](images/02_verification_compte_linux.png)

*Figure 2 — `adduser` indique que le compte existe déjà ; `id` confirme sa présence.*

## 🧩 Enregistrement dans Proxmox

```bash
# Ajout initial d'un compte existant (à n'exécuter que s'il manque)
pveum user add B300151504@pam

# Vérification effectivement réalisée
pveum user list
```

Dans la liste, `B300151504@pam` apparaît avec `enable = 1` et le domaine d'authentification `pam`.

![Liste des utilisateurs Proxmox](images/03_utilisateurs_proxmox.png)

*Figure 3 — Compte personnel Proxmox existant et activé.*

## 🔑 Contrôle des permissions ACL

La permission `Administrator` existait déjà sur la racine `/` et se propageait aux ressources enfants.

```bash
# Commande de configuration à utiliser seulement si nécessaire
pveum aclmod / -user B300151504@pam -role Administrator

# Vérification effectivement réalisée
pveum acl list
```

| Champ | Résultat |
|:--|:--|
| `path` | `/` |
| `roleid` | `Administrator` |
| `type` | `user` |
| `ugid` | `B300151504@pam` |
| `propagate` | `1` |

![ACL administrateur](images/04_permissions_administrateur.png)

*Figure 4 — Les ACL confirment les droits d'administrateur de `B300151504@pam`.*

> [!NOTE]
> Le rôle **Administrator** accorde de larges privilèges. Il est conforme à l'objectif de cet atelier mais, en production, il faut appliquer le **principe du moindre privilège** quand un rôle plus restreint suffit.

## 🌐 Connexion à l'interface Web

Adresse utilisée dans le laboratoire : `https://10.7.236.235:8006`

- **Identifiant :** `B300151504`
- **Realm :** `Linux PAM standard authentication`
- **Mot de passe :** celui du compte Linux, non publié

Une fois connecté, l'interface affiche **`B300151504@pam`** en haut à droite.

![Connexion Web au compte administrateur](images/05_connexion_interface_web.png)

*Figure 5 — Interface Web Proxmox ouverte avec le compte individuel, sans `root@pam`.*

## 💻 Connexion Linux et SSH

### Session Linux locale

La console du nœud accepte le compte `B300151504`.

![Connexion à la console Linux](images/06_connexion_console_linux.png)

*Figure 6 — Connexion locale au nœud : `B300151504@server238:~$`.*

### Première connexion SSH avec mot de passe

```bash
ssh B300151504@10.7.236.235
```

Le test initial a été réalisé depuis une session Linux du serveur vers son adresse IP et s'est terminé avec succès.

![Connexion SSH avec mot de passe](images/07_connexion_ssh_mot_de_passe.png)

*Figure 7 — Authentification SSH avec mot de passe réussie.*

## 🔐 Configuration de la clé SSH

### 1. Vérifier l'existence d'une clé publique sur Windows

Dans **PowerShell** :

```powershell
Get-ChildItem "$HOME\.ssh\*.pub"
```

Le fichier `id_ed25519.pub` existait déjà ; **aucune nouvelle paire de clés n'a été générée**.

![Clé publique ED25519 sur Windows](images/08_cle_publique_existante.png)

*Figure 8 — Clé publique existante dans le répertoire `.ssh` de Windows.*

### 2. Installer la clé publique sur le compte Linux

Dans **PowerShell** :

```powershell
Get-Content "$HOME\.ssh\id_ed25519.pub" | ssh B300151504@10.7.236.235 "umask 077; mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
```

Cette commande transfère **uniquement la clé publique** et l'ajoute au fichier `~/.ssh/authorized_keys` du compte distant sans effacer les clés déjà présentes.

![Copie de la clé publique sur le serveur](images/09_installation_cle_ssh.png)

*Figure 9 — Transfert de la clé publique ; la commande se termine sans erreur visible.*

### 3. Vérifier l'authentification par clé uniquement

Dans **PowerShell** :

```powershell
ssh -o PreferredAuthentications=publickey -o PasswordAuthentication=no B300151504@10.7.236.235
```

**Résultat obtenu :** ouverture de session et affichage de `B300151504@server238:~$`. Comme l'authentification par mot de passe était désactivée pour ce test, la session démontre que **la clé SSH fonctionne**.

![Connexion SSH avec clé publique validée](images/10_ssh_cle_publique_reussie.png)

*Figure 10 — Authentification SSH par clé publique réussie depuis Windows.*

## ✅ Validation finale

| Contrôle | État | Preuve |
|:--|:--:|:--|
| Accès au Shell du nœud | ✅ | Fig. 1 |
| Compte Linux existant | ✅ | Fig. 2 |
| Compte Proxmox activé | ✅ | Fig. 3 |
| Rôle `Administrator` sur `/` | ✅ | Fig. 4 |
| Connexion Web avec le compte personnel | ✅ | Fig. 5 |
| Connexion à la console Linux | ✅ | Fig. 6 |
| Connexion SSH avec mot de passe | ✅ | Fig. 7 |
| Clé publique ED25519 présente | ✅ | Fig. 8 |
| Installation de la clé publique | ✅ | Fig. 9 |
| Authentification SSH par clé publique | ✅ | Fig. 10 |

## 🧠 Recommandations et limites

- Utiliser **un compte différent par administrateur**, avec des permissions adaptées à son rôle.
- Conserver `root@pam` pour le dépannage et les urgences ; ne pas partager son mot de passe.
- Protéger la **clé privée** Windows : ne jamais l'ajouter au dépôt GitHub. Seules des captures et des commandes non secrètes figurent ici.
- Vérifier l'empreinte du serveur SSH avant de faire confiance à un nouveau serveur.
- **Non testé dans cet atelier :** désactivation globale de l'authentification SSH par mot de passe, configuration MFA et contrôle des journaux d'audit. La réussite du test par clé ne signifie pas que tous les accès par mot de passe ont été désactivés.
- Le serveur et l'IP sont ceux du **réseau de laboratoire** ; ils ne sont pas nécessairement accessibles hors du collège.

---

<div align="center">

### 🎯 Conclusion

**Objectif atteint :** le compte individuel `B300151504@pam` est actif, dispose des droits requis dans Proxmox et permet une connexion SSH par clé publique depuis Windows.

*Atelier Proxmox VE — Nassim Idir — 300151504*

</div>

