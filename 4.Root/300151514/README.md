# Compte administrateur individuel sur Proxmox

Un compte individuel permet d’associer les modifications à leur auteur. Le compte root partagé est réservé à la récupération et à la maintenance d’urgence.

## Création et vérification

Sur le serveur de groupe, un administrateur autorisé crée le compte Linux, l’ajoute au domaine PAM de Proxmox et applique le rôle demandé par le labo.

```bash
adduser B300151514
id B300151514
pveum user add B300151514@pam
pveum aclmod / -user B300151514@pam -role Administrator
pveum user list
pveum acl list
```

Tester la connexion à l’interface HTTPS de Proxmox sur le port 8006. Depuis le poste de travail, utiliser une clé SSH Ed25519 personnelle. Ajouter uniquement la clé publique avec `ssh-copy-id B300151514@HOTE`, puis tester `ssh B300151514@HOTE` et `whoami` en remplaçant HOTE par le serveur attribué.

Le compte, le rôle et la connexion restent à confirmer sur le serveur.

[Consignes du groupe du mercredi](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/4.Root)
