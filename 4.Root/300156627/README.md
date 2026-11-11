#### Rapport de Laboratoire : Administration Avancée Proxmox VE, Réseau Debian 13 et Stockage Haute Performance NVMe
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

Bash
pveum user list
pveum acl list
Sécurisation de l'accès SSH distant par clé publique (ssh-copy-id) pour s'affranchir des mots de passe en clair.

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
#### 5. Migration et Optimisation de la Machine Virtuelle
Le disque de la machine virtuelle 300156627 a été migré du stockage par défaut vers le nouveau pool NVMe haute performance.

Exécution de la migration du disque :

Bash
qm move_disk 300156627 scsi0 nvme-storage
Validation de la configuration finale (qm config 300156627) :

Plaintext
scsi0: nvme-storage:vm-300156627-disk-0,size=20G

#### 6. Preuves Visuelles et Captures d'Écran
Les captures d'écran suivantes ont été versées dans le dossier images/ du projet :

images/reseau-debian.png : Configuration réseau (ip a et /etc/network/interfaces).

images/disques-vm.png : Analyse des partitions (lsblk).

images/stockage-proxmox.png : État des stockages (pvesm status).

images/config-vm.png : Validation de la migration du disque sur le NVMe (qm config).

#### 7. Conclusion
Le laboratoire s'est soldé par un succès total. L'ensemble des exigences de configuration, de sécurité et d'optimisation des performances sous Proxmox VE et Debian 13 a été rigoureusement respecté et validé.
