#### Rapport de Laboratoire : Virtualisation Proxmox, Réseau Debian 13 et Stockage NVMe & LVM-Thin
#### Étudiante : Rougaiyatou Diallo

#### Numéro d'étudiante : 300156627

#### Programme : Computer Systems and Technology (Collège Boréal - Campus de Toronto)

#### Machine Virtuelle : vm-300156627 (Debian 13)

#### Hyperviseur Proxmox : server239

#### 1. Introduction et Objectifs
Ce laboratoire a pour objectif de concevoir, configurer et administrer une infrastructure virtualisée robuste sous Proxmox VE.
Les principales compétences validées incluent :

La configuration avancée du réseau sous Linux (Debian 13).

L'administration du stockage haute performance via des partitions NVMe et l'architecture LVM-Thin.

La migration et l'optimisation des disques virtuels de machines virtuelles.

La sécurisation des accès distants par clés SSH.

#### 2. Configuration Réseau Statique sous Debian 13
Pour garantir une adresse IP fixe indispensable à l'administration de la machine virtuelle, la configuration de l'interface réseau ens18 a été modifiée dans le fichier /etc/network/interfaces.

Configuration appliquée :
Plaintext

#### La configuration réseau sous Debian (ip a ou le contenu de /etc/network/interfaces).

<img width="1207" height="622" alt="1" src="https://github.com/user-attachments/assets/6ceac187-4e6b-46a2-a0e3-6e939713385f" />


# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto ens18
iface ens18 inet static
    address 10.7.236.227/23
    gateway 10.7.236.1
    dns-nameservers 8.8.8.8
Application des modifications :
Le service réseau a été redémarré pour appliquer les paramètres :

Bash
sudo systemctl restart networking
Vérification : La commande ip a confirme que l'adresse IP 10.7.236.227/23 est bien assignée à l'interface ens18 et que la résolution DNS est fonctionnelle.

#### 3. Sécurisation et Accès SSH Distant
L'accès à distance sécurisé a été mis en place pour permettre l'administration de la machine virtuelle depuis un poste hôte distant (via PowerShell par exemple) :

#### Connexion SSH depuis PowerShell :

PowerShell
ssh rougaiyatoudiallo@10.7.236.227
Intégration de la clé publique du professeur dans le fichier ~/.ssh/authorized_keys avec application des permissions strictes (chmod 700 ~/.ssh et chmod 600 ~/.ssh/authorized_keys).

#### 4. Administration du Stockage et Intégration du Disque NVMe sous Proxmox
Pour s'affranchir des limites des disques classiques et offrir des performances optimales aux machines virtuelles, un disque SSD NVMe (/dev/nvme0n1) a été intégré à l'hyperviseur Proxmox (server239).

Étapes de configuration LVM-Thin :
Création du volume physique (PV) :

Bash
pvcreate /dev/nvme0n1p1
Création du groupe de volumes (VG) :

Bash
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
    
#### Vérification du stockage :
La commande pvesm status atteste que le stockage nvme-storage est actif et offre près de 1 To de capacité haute performance.

L'accès SSH distant réussi depuis votre terminal PowerShell Windows.

La vérification des disques sur l'hyperviseur Proxmox (lsblk montrant le NVMe et pvesm status montrant le stockage nvme-storage).

<img width="686" height="162" alt="2" src="https://github.com/user-attachments/assets/f69a57a2-6862-4ef4-a73d-300e67f82b57" />

<img width="1312" height="402" alt="3" src="https://github.com/user-attachments/assets/ad33fd3a-0c6e-42ad-9130-778ad963d21b" />

#### 5. Migration du Disque de la Machine Virtuelle
Le disque de la machine virtuelle 300156627 a été migré du stockage par défaut vers le nouveau pool NVMe afin d'accélérer les vitesses de lecture/écriture.

<img width="1047" height="522" alt="4" src="https://github.com/user-attachments/assets/bc1aeb23-0c22-4671-859e-737264c1f5b8" />


Vérification initiale de la configuration de la VM :

Bash
qm config 300156627
Exécution de la migration du disque vers le NVMe :

Bash
qm move_disk 300156627 scsi0 nvme-storage
Validation de la configuration finale :

Bash
qm config 300156627
Résultat attendu et validé :

Plaintext
scsi0: nvme-storage:vm-300156627-disk-0,size=20G

<img width="562" height="336" alt="4-1" src="https://github.com/user-attachments/assets/6c27d598-33a7-405f-88bc-701acefd5f4f" />


#### 6. Conclusion et Bilan
Le laboratoire s'est soldé par un succès total. Toutes les étapes d'administration système, de paramétrage réseau, de sécurisation SSH et d'optimisation du stockage sur NVMe via LVM-Thin ont été rigoureusement appliquées, testées et validées sur l'infrastructure Proxmox.
