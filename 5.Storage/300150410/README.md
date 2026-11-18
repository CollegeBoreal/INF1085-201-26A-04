# 💾 Gestion du Stockage sous Proxmox VE (NVMe & LVM)
### Auteur : B300150410
### Environnement : Serveur Proxmox VE (server237)
### Sujet : Nettoyage d'un disque NVMe, création d'un stockage LVM-Thin et migration de machines virtuelles.

## 🎯 1. Objectifs du Travail
Ce laboratoire a pour but de comprendre la gestion du stockage sous Linux et Proxmox. Il s'agit de préparer un disque physique NVMe, de le configurer en LVM-Thin pour l'hyperviseur, puis de migrer des machines virtuelles du stockage lent (local-lvm) vers ce nouveau stockage hautes performances (nvme-storage).

## 🛠️ 2. Procédure et Preuves
#### 2.1. Nettoyage du disque NVMe
Le disque NVMe (nvme0n1) contenait une ancienne installation de Proxmox (volume pve-OLD-810787F6). Il a fallu désactiver et supprimer ce volume, puis effacer les signatures du disque pour le rendre utilisable.

##### Commandes exécutées :
```bash
umount /dev/nvme0n1p3
wipefs -a /dev/nvme0n1
vgchange -an pve-OLD-810787F6
vgremove -f pve-OLD-810787F6
wipefs -a /dev/nvme0n1
```

##### Preuve :
Le premier wipefs échoue car le disque est occupé. Après suppression du VG, le second wipefs réussit et efface les signatures GPT/PMBR.

<img width="851" height="525" alt="WhatsApp Image 2026-11-11 at 12 21 21" src="https://github.com/user-attachments/assets/3314a529-dfa4-42d1-91c4-ed305f3b0576" />



#### 2.2. Création du stockage nvme-storage (LVM-Thin)
Une fois le disque propre, l'espace a été préparé avec LVM (Logical Volume Manager) pour créer un pool de stockage "Thin". La commande finale ajoute ce stockage à Proxmox avec le type lvmthin.

##### Commandes exécutées :
```bash
pvesm add lvmthin nvme-storage --vgname nvme-vg --thinpool data --content images,rootdir
```

##### Preuve :
 La commande pvesm status affiche le nouveau stockage nvme-storage (Type lvmthin) avec un statut active et une capacité d'environ 953 Go.
 
<img width="1280" height="1229" alt="WhatsApp Image 2026-11-18 at 13 01 28" src="https://github.com/user-attachments/assets/e62b6c40-700a-4fc5-a15b-22f9d62e6e66" />



#### 2.3. Migration de la VM 104 vers le NVMe

##### Étape 1 : Vérification de l'emplacement du disque AVANT la migration
Avant de déplacer le disque, nous avons vérifié sur quel stockage il se trouvait.

```bash
qm config 104 | grep scsi0
```

###### Résultat attendu (Avant) :"scsi0: local-lvm:vm-100-disk-0,size=20G"


(Le disque est actuellement sur le stockage lent local-lvm).


#### Étape 2 : Déplacement du disque

```bash
qm move_disk 104 scsi0 nvme-storage
```

##### Preuve (Déplacement en cours) :

<img width="1600" height="835" alt="WhatsApp Image 2026-11-18 at 13 06 38" src="https://github.com/user-attachments/assets/166798ae-d850-45e5-a220-c3816149e2e0" />



##### Résultat attendu (Après) : scsi0: "nvme-storage:vm-100-disk-0,size=20G"

#### 2.4. Suppression des anciens disques (Nettoyage)

Lors d'un move_disk, Proxmox conserve l'ancien volume par sécurité sous le nom unused0. Pour libérer l'espace sur local-lvm, ces volumes ont été supprimés.

#### Commandes exécutées :
```bash
qm set 104 --delete unused0
```

 Les anciens volumes ont été supprimés avec succès. Le lsblk final montre que les VM sont maintenant hébergées sur nvme--vg.

<img width="765" height="857" alt="WhatsApp Image 2026-11-11 at 12 28 41" src="https://github.com/user-attachments/assets/f271f35f-8e36-4542-b2a3-6e72c4e4447a" />


## 3. Résultat attendu

#### ✅ Le disque NVMe a été nettoyé et configuré en LVM-Thin.
#### ✅ Le stockage nvme-storage est visible et actif dans Proxmox.
#### ✅ Les machines virtuelles utilisent désormais le stockage NVMe.
#### ✅ L'espace sur local-lvm a été libéré en supprimant les volumes unused0.






