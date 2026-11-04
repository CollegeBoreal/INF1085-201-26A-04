## 📄 Rapport de Laboratoire : Déploiement d'une VM sur Proxmox VE
### Auteur : B300142542  
### Environnement : Serveur Proxmox VE (Nœud server237)>
### Sujet : Création, configuration et déploiement d'une machine virtuelle Debian 13.

## 🎯 1. Objectifs du Travail
L'objectif de ce laboratoire est de maîtriser le cycle de vie complet d'une machine virtuelle sur un hyperviseur Proxmox VE, en utilisant exclusivement la ligne de commande (CLI) et les outils d'administration Linux.

#### Ce travail permet de :

Sécuriser l'accès à l'hyperviseur via l'authentification par clé SSH.

Provisionner une VM en allouant manuellement les ressources (CPU, RAM, disque, réseau).

Installer un OS (Debian 13) et configurer son réseau sur un bridge (vmbr0).

Déployer un environnement graphique (XFCE) et diagnostiquer les services de démarrage (LightDM, D-Bus).

Assurer l'administration à distance via SSH et l'interface Web de Proxmox.

## 🛠️ 2. Procédure de Déploiement et Preuves
2.1. Authentification SSH sécurisée
La première étape a été de générer une paire de clés SSH sur le poste client (Windows PowerShell) et de transférer la clé publique sur le serveur Proxmox pour permettre une connexion sans mot de passe.
<img width="1382" height="506" alt="Screenshot 2026-10-14 123232" src="https://github.com/user-attachments/assets/2d1df858-9f70-4587-a1f1-fd94fabcd09a" />
Preuve : Génération de la paire de clés ed25519 et transfert de la clé publique vers ~/.ssh/authorized_keys sur le serveur.

<img width="1374" height="502" alt="Screenshot 2026-10-14 123256" src="https://github.com/user-attachments/assets/a7ee9b8b-f3ea-4431-9f80-f76df3c8d331" />
Preuve : Connexion réussie en tant que B300142542@server237 sans demande de mot de passe.

### 2.2. Accès à l'interface d'administration
Une fois connecté, l'accès à l'interface Web Proxmox a été validé pour vérifier l'état du nœud et les permissions.
<img width="1358" height="815" alt="Screenshot 2026-10-14 115642" src="https://github.com/user-attachments/assets/626b75e3-ae4e-4875-99a2-ef91a9cf9ea5" />
Preuve : Connexion réussie à l'interface Proxmox avec le compte utilisateur B300142542@pam.


<img width="1315" height="691" alt="Screenshot 2026-10-14 122228" src="https://github.com/user-attachments/assets/1df668f1-01e9-4e71-bf86-8b22a6dfaa6f" />
Preuve : Accès au Shell du serveur Proxmox via l'interface Web.

## 3. Création et configuration de la VM (VM 100)
La machine virtuelle a été créée en ligne de commande avec les spécifications suivantes : 2 Go de RAM, 2 cœurs CPU, connectée au réseau via vmbr0 et utilisant le contrôleur SCSI virtio-scsi-pci.

#### Commandes exécutées :
```bash
qm create 100 --name B300142542-vm --memory 2048 --cores 2 \
  --net0 virtio,bridge=vmbr0 --scsihw virtio-scsi-pci --ostype l26

qm set 100 --scsi0 local-lvm:20
qm set 100 --ide2 local:iso/debian-13.7.0-amd64-netinst.iso,media=cdrom
qm set 100 --boot "order=scsi0;ide2"
```
#### Preuve de l'état de la VM :
<img width="1919" height="852" alt="Screenshot 2026-11-03 212838" src="https://github.com/user-attachments/assets/e8605bbb-217b-46c5-a9ae-af212f5378ba" />
Preuve : La VM 100 est en état "running", utilise 2 Go de

## 4. Installation de Debian et Démarrage
L'installation de Debian 13 a été effectuée via la console Proxmox. Après l'installation, le système a démarré sur le chargeur d'amorçage GRUB.
<img width="763" height="560" alt="Screenshot 2026-10-15 120356" src="https://github.com/user-attachments/assets/1972facb-2124-46ef-b75a-103d863f9679" />
Preuve : Démarrage réussi sur le noyau Debian GNU/Linux 13.

<img width="821" height="206" alt="Screenshot 2026-10-15 120538" src="https://github.com/user-attachments/assets/3a28256c-f5d2-4df2-b3c7-ee0b5e798e3c" />
Preuve : Connexion réussie au système en mode texte (tty1) avec l'utilisateur b300142542.

## 5. Installation de l'Interface Graphique (XFCE) et Résolution des Erreurs
Le système initial étant en mode texte, nous avons installé XFCE. Cette étape a révélé plusieurs erreurs classiques d'administration Linux que nous avons corrigées

Commandes exécutées dans la VM :
```bash
apt update
apt install -y xorg xserver-xorg xinit task-xfce-desktop
apt install -y dbus-x11
```
#### 5.1. Diagnostic des erreurs
Nous avons rencontré des échecs de démarrage du gestionnaire de connexion lightdm et du service dbus.

<img width="857" height="337" alt="Screenshot 2026-10-15 121220" src="https://github.com/user-attachments/assets/306ccc59-98a6-4aad-8664-4f72d69caf9c" />
Preuve : Échec du service LightDM (Failed with result 'exit-code').

<img width="341" height="42" alt="Screenshot 2026-10-15 121343" src="https://github.com/user-attachments/assets/57822014-5e94-4721-823e-80bfd900d189" />
Preuve : Commande sudo introuvable (le compte root doit être utilisé).

<img width="855" height="511" alt="Screenshot 2026-10-15 121316" src="https://github.com/user-attachments/assets/fb93ef8f-ca09-457e-8e49-bb4cb59c9405" />
Preuve : Analyse des logs révélant l'absence du serveur X (Can't launch X server X).

<img width="753" height="167" alt="Screenshot 2026-10-15 120850" src="https://github.com/user-attachments/assets/83dc106e-9bf0-43a8-b620-29111d180007" />
Preuve : Erreur d'accès D-Bus lors du redémarrage des services.

#### 5.2. Résolution
L'installation des paquets xorg et dbus-x11 a permis de résoudre le problème. Le gestionnaire de connexion LightDM a finalement démarré avec succès
<img width="1245" height="779" alt="image" src="https://github.com/user-attachments/assets/be3055fb-27b4-4e99-9037-aa9e19cff3e1" />
Preuve : L'écran de connexion graphique de Debian 13 est désormais fonctionnel.

<img width="1242" height="772" alt="image" src="https://github.com/user-attachments/assets/8f6b2e39-927c-42f5-877d-1ab05da7b60c" />
Preuve : Bureau XFCE opérationnel avec un terminal ouvert.

## 6. Conclusion
Ce laboratoire a permis de déployer avec succès une machine virtuelle Debian 13 sur Proxmox VE. Malgré les défis liés à l'installation d'un environnement graphique sur une base minimale (résolution des dépendances Xorg et D-Bus), la VM est désormais pleinement fonctionnelle. Elle est connectée au réseau, sécurisée par authentification SSH, et prête à être utilisée pour d'autres travaux pratiques.



