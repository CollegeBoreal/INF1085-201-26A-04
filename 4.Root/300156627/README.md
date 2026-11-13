ss#### Rapport de Laboratoire : Administration Avancée Proxmox VE, Réseau Debian 13 et Stockage Haute Performance NVMe
#### Étudiante : Rougaiyatou Diallo

#### Numéro d'étudiante : 300156627

#### Programme : Computer Systems and Technology (Collège Boréal - Campus de Toronto)

#### Machine Virtuelle : vm-300156627 (Debian 13)

#### Hyperviseur Proxmox : server239 (10.7.236.227)

##### 1. Introduction et Objectifs
Ce laboratoire a pour objectif de concevoir, configurer et administrer une infrastructure virtualisée robuste sous Proxmox VE. Les compétences validées dans ce rapport couvrent :

La mise en place de bonnes pratiques de sécurité et la création de comptes administrateurs individuels.

La configuration avancée du réseau statique sous Linux (Debian 13).

L'administration du stockage haute performance via des partitions NVMe et l'architecture LVM-Thin.

La migration et l'optimisation des disques virtuels de machines virtuelles.

<img width="942" height="980" alt="1" src="https://github.com/user-attachments/assets/2d4df45d-af93-459f-a0fe-8d38382c5b23" />


##### 2. Gestion des Comptes Administrateurs et Sécurisation Proxmox VE
Dans un environnement de production, l'utilisation unique du compte root@pam présente des risques majeurs en terms de traçabilité et de sécurité. Des comptes individuels ont donc été configurés.

### Création de l'utilisateur système et Proxmox :

Bash
adduser 300156627
pveum user add 300156627@pam
Attribution des droits administrateurs via les ACL :

Bash
pveum aclmod / -user 300156627@pam -role Administrator
Vérification des accès :

<img width="927" height="550" alt="2" src="https://github.com/user-attachments/assets/9d80b63a-bb92-46e5-88d1-3a404a1e3f76" />


Bash
pveum user list
pveum acl list
Sécurisation de l'accès SSH distant par clé publique (ssh-copy-id) pour s'affranchir des mots de passe en clair.

<img width="825" height="470" alt="3" src="https://github.com/user-attachments/assets/cb1bf045-b32a-4aaf-8e2f-233e740b22f6" />


#### 3. Configuration Réseau Statique sous Debian 13
Pour garantir une adresse IP fixe indispensable à l'administration de la machine virtuelle, la configuration de l'interface réseau ens18 a été définie dans /etc/network/interfaces :

Plaintext
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ens18
iface ens18 inet static
    address 10.7.236.227/23
    gateway 10.7.236.1
    dns-nameservers 8.8.8.8
Vérification : La commande ip a confirme que l'adresse IP 10.7.236.227/23 est active sur l'interface ens18.

##### Connexion à l'interface Web avec mon compte

<img width="597" height="270" alt="4" src="https://github.com/user-attachments/assets/268c9c8c-c776-41e9-bf58-3dc5b8228e8d" />


#### 4. Administration du Stockage et Intégration du Disque NVMe
Pour offrir des performances optimales aux machines virtuelles, un disque SSD NVMe (/dev/nvme0n1) a été partitionné et intégré à Proxmox via l'architecture LVM-Thin.

Création du volume physique (PV) et du groupe de volumes (VG) :

Bash
pvcreate /dev/nvme0n1p1
vgcreate nvme-vg /dev/nvme0n1p1
Création du pool Thin Provisioning :

Bash
lvcreate -l 100%FREE -T nvme-vg/data
Enregistrement du stockage dans Proxmox sous le nom nvme-storage :

Bash
pvesm add lvmthin nvme-storage \
    --vgname nvme-vg \
    --thinpool data \
    --content images,rootdir

<img width="1917" height="906" alt="5" src="https://github.com/user-attachments/assets/4cbc177a-2b67-4c7d-b934-4128e47c97c2" />

#### 5. Migration et Optimisation de la Machine Virtuelle
Le disque de la machine virtuelle 300156627 a été migré du stockage par défaut vers le nouveau pool NVMe haute performance.

Exécution de la migration du disque :

Bash
qm move_disk 300156627 scsi0 nvme-storage
Validation de la configuration finale (qm config 300156627) :

Plaintext
scsi0: nvme-storage:vm-300156627-disk-0,size=20G

<img width="1302" height="657" alt="12345" src="https://github.com/user-attachments/assets/6898b27b-97df-4822-9b52-52c6b71edb5d" />


#### 6. Preuves Visuelles et Captures d'Écran

<img width="690" height="472" alt="Screenshot 2026-11-06 235700" src="https://github.com/user-attachments/assets/df011818-b46a-4ee8-8012-8f125e7a2e2b" />


#### 7. Conclusion
Le laboratoire s'est soldé par un succès total. L'ensemble des exigences de configuration, de sécurité et d'optimisation des performances sous Proxmox VE et Debian 13 a été rigoureusement respecté et validé.
