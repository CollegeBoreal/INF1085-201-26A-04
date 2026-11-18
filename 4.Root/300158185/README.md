# Sécurisation de l’accès à Proxmox VE

**Auteur** · Mohammed Mati  
**Numéro d’étudiant** · 300158185  
**Date du laboratoire** · 18 novembre 2026  
**Environnement** · Proxmox VE 9.2.2, nœud `server1`  
**Compte Proxmox** · `B300158185@pam`  
**Adresse du serveur de laboratoire** · `10.7.236.240`

## Objectif

Utiliser un compte administrateur individuel pour gérer Proxmox et se connecter par SSH avec une clé. Un compte personnel permet d’associer les actions d’administration à la personne qui les a effectuées. Le compte `root@pam` est réservé au dépannage et à la récupération.

## 1. Vérification du compte et des droits

J’ai réutilisé mon compte `B300158185@pam`, qui existait déjà. Je me suis connecté à l’interface Web avec le domaine **Linux PAM**, puis j’ai ouvert **server1 → Shell** et exécuté `whoami`. La commande a affiché `B300158185`.

![Résultat de whoami dans le Shell de server1]<img width="1032" height="530" alt="image" src="https://github.com/user-attachments/assets/4599d5ef-1df3-4db3-b1a1-d24c13c22fb4" />


Dans **Datacenter → Permissions**, j’ai vérifié les droits du compte.

| Chemin | Utilisateur | Rôle | Propagation |
| --- | --- | --- | --- |
| `/` | `B300158185@pam` | `Administrator` | `true` |

![Compte B300158185@pam et rôle Administrator dans Proxmox]<img width="1032" height="178" alt="image" src="https://github.com/user-attachments/assets/885a8b20-5a56-4fcd-99cf-8a686c53ae7a" />


## 2. Installation de la clé SSH

Dans **PowerShell sur mon PC Windows**, j’ai créé une paire de clés Ed25519 et copié la clé publique sur le serveur.

```powershell
ssh-keygen -t ed25519
scp "$env:USERPROFILE\.ssh\id_ed25519.pub" B300158185@10.7.236.240:~/cle-boreal.pub
ssh B300158185@10.7.236.240
```

Après la connexion à **server1**, j’ai ajouté la clé publique à mon fichier `authorized_keys` et réglé les permissions.

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
cat ~/cle-boreal.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exit
```

La clé privée est conservée sur mon PC et protégée par une phrase secrète.

## 3. Test final

De retour dans **PowerShell**, j’ai lancé ce test en demandant l’authentification par clé publique.

```powershell
ssh -o PreferredAuthentications=publickey B300158185@10.7.236.240 whoami
```

Le test a affiché `B300158185` après la saisie de la phrase secrète de la clé. SSH n’a pas demandé le mot de passe du compte Linux.

![Test SSH par clé publique depuis PowerShell et résultat B300158185]<img width="1032" height="488" alt="image" src="https://github.com/user-attachments/assets/6afda20b-7f54-4482-8c2b-a5685d92755f" />


