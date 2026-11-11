### ### 📖 Rapport de Déploiement & Configuration — VM Debian 13 (Proxmox VE)
##### Projet académique : Infrastructure & Virtualisation

##### Établissement : Collège Boréal (Campus de Toronto)

##### Auteur : Rougaiyatou Diallo (N° étudiant : 300156627)

##### 1. Fiche Technique de l'Étudiante & de la Machine

#### Paramètre	Valeur / Description
#### Nom & Prénom	Rougaiyatou Diallo
#### Identifiant Étudiant	300156627
#### Identifiant de la VM	300156627
#### Nom d'hôte (Hostname)	debian
#### Nœud Hyperviseur	server239 (Proxmox VE 9)
#### Système d'Exploitation	Debian 13 (GNU/Linux) avec environnement graphique Xfce
#### Compte Utilisateur	rougaiyatoudiallo
#### Adresse IP Statique	10.7.236.227/23
#### Passerelle (Gateway)	10.7.236.1
#### Port SSH	22 (Service actif)
#### Commande d'accès distant (SSH)
Pour prendre la main à distance sur la machine virtuelle :

#### Bash
ssh rougaiyatoudiallo@10.7.236.227
#### 2. Objectifs du Laboratoire
Dans le cadre de ma formation en Techniques des Systèmes Informatiques, ce laboratoire vise à valider les compétences pratiques suivantes :

#### Virtualisation : 
Création et dimensionnement d'une VM Linux sous l'hyperviseur Proxmox VE 9.

#### Déploiement Système : 
Installation complète de Debian 13 avec configuration d'un environnement de bureau léger (Xfce).

#### Administration Réseau & Sécurité : 
Transition d'une adresse DHCP vers une IP fixe statique, gestion des privilèges administratifs (sudoers), et activation du serveur OpenSSH pour le management distant.

#### 3. Spécifications Matérielles Allouées
Ressource	Dimensionnement	Détails techniques
Processeur	1 vCPU	Extensible selon les besoins
Mémoire RAM	2 Go (2048 Mo)	Allocation dédiée
Espace Disque	20 Go	Type VirtIO SCSI (/dev/sda)
Carte Réseau	VirtIO (ens18)	Connectée au bridge principal vmbr0
Support ISO	Netinst	debian-13.7.0-amd64-netinst.iso
#### 4. Journal d'Exécution & Étapes Clés (Captures à l'appui)
#### 4.1 Lancement de l'installateur et détection du matériel
Le démarrage s'est effectué sur l'image ISO Debian 13 connectée à la machine virtuelle. Le journal système indique l'initialisation du support et la détection des composants.

   
<img width="1535" height="731" alt="2" src="https://github.com/user-attachments/assets/7acada32-a82e-456d-bb36-bd986cec8f69" />


#### 4.2 Configuration des paramètres régionaux et de la langue
L'assistant textuel de l'installateur a permis de configurer les éléments linguistiques et géographiques du système :

Langue : Français (fr).

Pays : Canada (Option 2).

Clavier : Disposition Canadien français (Option 16).

   <img width="1502" height="736" alt="3" src="https://github.com/user-attachments/assets/4c27be9d-a429-4578-b3df-78a87613a719" />

<img width="1530" height="726" alt="4" src="https://github.com/user-attachments/assets/0216479d-0485-4f3f-8bab-59f2449851f5" />

  <img width="1542" height="727" alt="5" src="https://github.com/user-attachments/assets/0018405a-973f-4b8e-be42-2a045419343d" />


#### 4.3 Paramétrage réseau et identifiants administrateur
L'interface réseau ens18 a initialement récupéré une configuration DHCP, puis le nom de machine (Hostname) debian a été attribué avant la configuration des mots de passe.

   
<img width="1527" height="722" alt="6" src="https://github.com/user-attachments/assets/32710ace-743c-44e2-af83-efdc6c5d78c4" />

<img width="1532" height="727" alt="7" src="https://github.com/user-attachments/assets/e64d20fd-645d-46dc-848f-17a73016cd32" />

<img width="1532" height="727" alt="8" src="https://github.com/user-attachments/assets/3d692f94-4fa8-4818-bed3-7a9ee8765db2" />


#### 4.4 Partitionnement du disque virtuel
Le partitionnement assisté a été exécuté sur le disque dur virtuel sda de 21.5 Go, générant une partition principale ext4 pour la racine / (~20.3 Go) et une partition logique swap (~1.2 Go), suivies de l'écriture effective sur le disque.

   <img width="1532" height="730" alt="9" src="https://github.com/user-attachments/assets/bce16e20-d93d-49e0-ba63-361a6f8c3349" />

   <img width="1516" height="735" alt="10" src="https://github.com/user-attachments/assets/c0722e64-7c38-4fe3-a19b-b2fd68050dd4" />


#### 4.5 Post-installation et Tests de Connexion
Après l'installation de l'environnement graphique Xfce et des paquets de base, les tests de connexion et l'administration à distance ont été validés via le terminal PowerShell hôte.

   
1.png

 ##### 5. Configuration Réseau & Services Avancés
 
#### 5.1 Fixation de l'Adresse IP Statique
L'adresse IP dynamique initiale (10.7.236.155) a été remplacée par l'adresse IP fixe requise en modifiant le fichier /etc/network/interfaces :

Plaintext
auto ens18
iface ens18 inet static
    address 10.7.236.227/23
    gateway 10.7.236.1
    dns-nameservers 8.8.8.8
#### Application : 
Redémarrage de la pile réseau via sudo systemctl restart networking.

#### 5.2 Activation du Service OpenSSH
Installation et mise en service du serveur SSH pour autoriser les connexions distantes sécurisées :

Bash
sudo apt update && sudo apt install -y openssh-server
sudo systemctl enable --now ssh
#### 6. Matrice de Dépannage & Incidents Résolus
Incident rencontré	Cause racine	Action corrective appliquée
Boucle de redémarrage sur l'ISO	Priorité de boot conservée sur le lecteur optique	Arrêt de la VM et désassociation du média CD/DVD dans Proxmox.
Échec d'authentification graphique	Inversion de caractères / disposition clavier	Passage en Recovery mode via GRUB et réinitialisation avec passwd.
Erreur de privilèges sudo	Compte non rattaché au groupe sudoers	Élévation temporaire en su - et exécution de usermod -aG sudo rougaiyatoudiallo.
#### 7. Validation & Vérifications Finales
Les commandes de contrôle exécutées dans le terminal confirment la bonne santé du système :

Vérification de l'IP : ip a (Validation de la présence de 10.7.236.227/23 sur ens18).

Statut du démon SSH : sudo systemctl status ssh (Retour : active (running)).

Test de la passerelle : ping -c 4 10.7.236.1 (Aucune perte de paquets).

#### 8. Conclusion
Ce projet pratique m'a permis d'appréhender l'ensemble du cycle de vie d'une machine virtuelle sous Proxmox VE 9, de sa création matérielle initiale à sa configuration logicielle et réseau sous Debian 13. La gestion des incidents de démarrage et des droits d'accès m'a permis de consolider mes compétences fondamentales en administration système Linux.
