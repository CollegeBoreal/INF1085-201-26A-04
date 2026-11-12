## 🔐 root - Comptes administrateurs Proxmox
### Auteur : B300142542
### Environnement : Serveur Proxmox VE (server237 - 10.7.236.237)
### Sujet : Création d'un compte administrateur individuel et sécurisation par clé SSH.

## 🎯 1. Objectifs du Travail
L'objectif de ce laboratoire est de remplacer l'utilisation du compte root@pam (qui est une mauvaise pratique) par un compte administrateur individuel. Cela permet d'assurer la traçabilité des actions, d'éviter le partage de mots de passe, et de sécuriser l'accès au serveur via une authentification par clé SSH.
<img width="1476" height="830" alt="image" src="https://github.com/user-attachments/assets/ab353d1f-473b-475f-905d-f177b0d96f13" />


## 🛠️ 2. Procédure et Preuves

### 2.1. Création de l'utilisateur Linux
La première étape consiste à créer un utilisateur au niveau du système d'exploitation Linux (Debian) du serveur Proxmox, puisque l'authentification utilisera le realm @pam (Pluggable Authentication Modules).

##### Commandes exécutées :
```bash
adduser B300142542
id B300142542
```
Lors de la création, les informations de l'utilisateur ont été renseignées, puis vérifiées avec id qui confirme son UID, GID et son appartenance au groupe users

##### Preuve : 
<img width="817" height="455" alt="Screenshot 2026-11-12 104733" src="https://github.com/user-attachments/assets/da975166-8656-434e-9ff4-0dc8e238ad16" />

### 2.2. Ajout de l'utilisateur dans Proxmox et attribution des droits
Une fois l'utilisateur Linux créé, il faut l'enregistrer dans la base de données de Proxmox et lui donner les droits d'administration.

##### Commandes exécutées :
```bash
# Ajout de l'utilisateur dans Proxmox
pveum user add B300142542@pam

# Attribution du rôle Administrator sur la racine (/)
pveum aclmod / -user B300142542@pam -role Administrator

# Vérification
pveum user list
pveum acl list
```
##### Preuve :
L'utilisateur apparaît dans la liste et possède bien le rôle Administrator avec la propagation (propagate: 1) sur le chemin /.

<img width="824" height="392" alt="image" src="https://github.com/user-attachments/assets/8d405fc8-425d-4395-a655-21f9cd936c3c" />

### 2.3. Connexion à l'interface Web

Le nouveau compte a été testé sur l'interface graphique de Proxmox.

###Paramètres de connexion :

#### User name : B300142542 (ou b300142542)

#### Realm : Linux PAM standard authentication

##### Preuve :

Connexion réussie à l'interface Web en utilisant le compte individuel plutôt que root.
<img width="1352" height="812" alt="Screenshot 2026-10-14 115634" src="https://github.com/user-attachments/assets/4040c602-d27a-4707-937e-6c353764df64" />
<img width="1358" height="815" alt="Screenshot 2026-10-14 115642" src="https://github.com/user-attachments/assets/85a060f0-cf93-41dd-88ea-3d1b2e059231" />
<img width="1315" height="691" alt="Screenshot 2026-10-14 122228" src="https://github.com/user-attachments/assets/5c124142-bc97-4756-b9dd-aea2fdc94ce5" />

### 2.4. Authentification par clé SSH

Pour sécuriser l'accès en ligne de commande, une paire de clés SSH (ed25519) a été générée sur le poste client (Windows). La clé publique a ensuite été copiée sur le serveur Proxmox.

#### Commandes exécutées (sur Windows PowerShell) :
```bash
# Génération de la clé
ssh-keygen -t ed25519

# Copie de la clé vers le serveur (via la commande Windows)
type $env:USERPROFILE\.ssh\id_ed25519.pub | ssh B300142542@10.7.236.237 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

##### Preuve (Génération) :
Génération de la paire de clés sur le poste client.

<img width="1382" height="506" alt="Screenshot 2026-10-14 123232" src="https://github.com/user-attachments/assets/775825ff-c438-4e7b-a4f5-5457904fb12e" />

##### Preuve (Test de connexion) :
La commande ssh B300142542@10.7.236.237 permet de se connecter sans qu'aucun mot de passe ne soit demandé.

<img width="1374" height="502" alt="Screenshot 2026-10-14 123256" src="https://github.com/user-attachments/assets/2016f1ad-e3f7-4e80-8b2b-a9f454f48a08" />


## 3. Recommandations de Sécurité (Bilan)
Suite à ce laboratoire, voici les bonnes pratiques appliquées :

#### ✅ Créer un compte par administrateur (fini le partage de root).

#### ✅ Utiliser des clés SSH pour l'accès à distance (plus sécurisé qu'un mot de passe).

#### ✅ Utiliser les ACL Proxmox pour attribuer précisément les droits.

#### ⚠️ Le compte root@pam est désormais réservé aux urgences (maintenance, dépannage système, réinitialisation de mot de passe).

## 🎓 Résultat attendu
#### ✅ Chaque administrateur possède son propre compte (B300142542@pam).
#### ✅ Les actions sont traçables dans l'interface (onglet Tasks).
#### ✅ Les accès SSH sont sécurisés par clé publique.
#### ✅ Le compte root est réservé aux urgences.



























