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

## 6 Installation du serveur SSH sur la VM
#### 6.1. Passage en root

Depuis la console Proxmox, j’ai essayé d’exécuter sudo apt update, mais le système m’a répondu que mon utilisateur b300142542 n’est pas dans le fichier sudoers. J’ai donc utilisé le compte root :
```bash
su -
```
<img width="1150" height="713" alt="Screenshot 2026-11-04 104553" src="https://github.com/user-attachments/assets/cfa947ba-23a2-465f-8441-4e7180a2d44c" />

#### 6.2. Problème réseau : pas de passerelle par défaut

Après apt update, j’ai obtenu l’erreur Temporary failure resolving 'deb.debian.org'. J’ai vérifié la configuration réseau :

```bash
ip a
ip route
ping -c 3 8.8.8.8
```
L’interface ens18 avait bien l’adresse 10.7.236.202/23, mais ip route ne montrait aucune ligne default via, et le ping retournait Network is unreachable. Ma VM n’avait donc pas de passerelle par défaut.
<img width="745" height="462" alt="image" src="https://github.com/user-attachments/assets/4ed936e9-06a8-4949-953e-936c7a55371a" />
<img width="743" height="459" alt="image" src="https://github.com/user-attachments/assets/e01608d2-6c48-47bf-b47c-5bbb19cda526" />

J’ai essayé de redémarrer le réseau avec systemctl restart networking, sans succès. La commande dhclient n’est pas installée par défaut sur Debian 13.

#### 6.3. Recherche de la bonne passerelle
J’ai testé plusieurs passerelles manuellement :
```bash
ip route add default via 10.7.236.1
ping -c 3 8.8.8.8
```
Cela a retourné Destination Host Unreachable, donc cette adresse n’est pas la bonne passerelle. J’ai ensuite essayé l’adresse du nœud Proxmox :
```bash
ip route del default
ip route add default via 10.7.236.237
ping -c 3 8.8.8.8
```

Cette fois, le ping a fonctionné (64 bytes from 8.8.8.8 ... time=3.73 ms). Le message Redirect Host (New nexthop: 10.7.237.1) m’a indiqué la vraie passerelle du réseau, que j’ai configurée :
```bash
ip route del default
ip route add default via 10.7.237.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf
apt update
```

#### 6.4. Installation et activation de SSH

Une fois Internet disponible, j’ai installé OpenSSH et je l’ai activé au démarrage :
```bash
apt install openssh-server -y
systemctl enable --now ssh
systemctl status ssh
```
<img width="657" height="411" alt="image" src="https://github.com/user-attachments/assets/7afadb87-925d-49e7-8187-6333e49d8491" />

#### 6.5. Connexion depuis Windows PowerShell
Depuis mon poste Windows, je me suis connecté à la VM par SSH avec son adresse IP :
```bash
ssh b300142542@10.7.236.202
```
La connexion a réussi et le prompt est devenu b300142542@b300142542-vm:~$. J’ai ensuite travaillé depuis PowerShell, car le copier-coller y est possible par simple clic droit, alors qu’il ne fonctionne pas dans la console noVNC de Proxmox.
<img width="932" height="413" alt="image" src="https://github.com/user-attachments/assets/5694b3e7-0031-45e6-8024-e899a2621618" />

## 7. Ajout de la clé SSH publique de l’enseignant
Pour que l’enseignant puisse accéder à ma VM sans mot de passe, j’ai ajouté sa clé publique dans le fichier authorized_keys de mon utilisateur :
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2E... b300098957@ramena' >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
cat ~/.ssh/authorized_keys
```
#### L’enseignant peut maintenant se connecter avec :
```bash
ssh b300142542@10.7.236.202
```

## 8. Conclusion

Dans ce laboratoire, j’ai déployé une VM Debian 13 sur Proxmox VE et installé l’interface XFCE. J’ai ensuite diagnostiqué un problème réseau (absence de passerelle par défaut et de DNS), installé le serveur SSH, et configuré l’accès par clé publique pour l’enseignant. La VM est accessible à distance et prête pour les prochains travaux pratiques.



