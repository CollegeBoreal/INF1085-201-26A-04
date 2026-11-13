# 💾 Documentation Technique : Gestion du Stockage Haute Performance sous Proxmox VE (NVMe & LVM-Thin)

## 📌 Informations Générales

| Métadonnée | Valeur / Description | 
| ----- | ----- | 
| **Auteur** | B300150468 | 
| **Environnement cible** | Serveur Proxmox VE (`server237` / IP `10.7.236.237`) | 
| **Sujet** | Nettoyage NVMe, provisioning LVM-Thin et migration à chaud de machines virtuelles | 
| **Périphérique cible** | `/dev/nvme0n1` (\~953.9 GiB NVMe SSD) | 
| **Stockage créé** | `nvme-storage` (Volume Group: `nvme-vg`, Thin Pool: `data`) | 
| **VMs Migrées** | VM 100, VM 102, VM 104 | 
| **Statut de validation** | Succès complet | 

## 📑 Table des Matières

1. [Contexte et Concepts Théoriques](#1-contexte-et-concepts-théoriques)

2. [Objectifs du Laboratoire](#2-objectifs-du-laboratoire)

3. [Schéma d'Architecture du Stockage](#3-schéma-darchitecture-du-stockage)

4. [Procédure Détaillée et Preuves d'Exécution](#4-procédure-détaillée-et-preuves-dexécution)

   * [4.1. Nettoyage et remise à neuf du disque NVMe](#41-nettoyage-et-remise-à-neuf-du-disque-nvme)

   * [4.2. Configuration du stockage LVM-Thin et enregistrement PVE](#42-configuration-du-stockage-lvm-thin-et-enregistrement-pve)

   * [4.3. Migration à chaud du disque des VMs (VM 100, 102, 104)](#43-migration-à-chaud-du-disque-des-vms-vm-100-102-104)

   * [4.4. Nettoyage des volumes obsolètes post-migration](#44-nettoyage-des-volumes-obsolètes-post-migration)

5. [Validation et Matrice de Synthèse](#5-validation-et-matrice-de-synthèse)

6. [Bonnes Pratiques et Recommandations d'Administration](#6-bonnes-pratiques-et-recommandations-dadministration)

7. [Guide de Dépannage (Troubleshooting)](#7-guide-de-dépannage-troubleshooting)

## 1. Contexte et Concepts Théoriques

Dans un environnement de virtualisation d'entreprise sous Proxmox VE (PVE), la gestion fine des sous-systèmes de stockage conditionne directement les débits I/O (IOPS) et la latence subie par les machines virtuelles (VM).

### 💡 Pourquoi LVM-Thin sur NVMe ?

* **LVM Traditionnel (Thick) :** Alloue l'intégralité de l'espace disque réservé dès la création de la VM. Si une VM se voit attribuer 100 Go, 100 Go sont immédiatement consommés physiquement, même si seulement 5 Go sont occupés par le système d'exploitation.

* **LVM-Thin (Thin Provisioning) :** Alloue l'espace disque physique au fur et à mesure de l'écriture effective des données (allocation à la demande). Cela permet d'effectuer du *surdimensionnement* (*overcommit*) tout en supportant les instantanés rapides (*snapshots*) et la réduction du temps de clonage d'images disque.

* **NVMe (Non-Volatile Memory Express) :** Protocole optimisé pour les SSD sur bus PCIe, offrant des milliers de files d'attente parallèles et réduisant drastiquement les temps de latence par rapport aux bus SATA/SAS traditionnels.

## 2. Objectifs du Laboratoire

1. **Assainissement matériel :** Identifier et détruire les anciennes tables de partition, signatures GPT/PMBR et groupes de volumes (`pve-OLD-810787F6`) résiduels sur le disque NVMe physiquement présent (`/dev/nvme0n1`).

2. **Implémentation LVM-Thin :** Initialiser le Physical Volume (PV), le Volume Group (`nvme-vg`) ainsi que le Thin Pool (`data`), puis déclarer la ressource dans l'hyperviseur Proxmox via l'outil CLI `pvesm`.

3. **Migration sans interruption de service :** Déplacer à chaud (*live storage migration*) les disques virtuels principaux (`scsi0`) des VMs (ex: **VM 100**, **VM 102**, **VM 104**) depuis le stockage par défaut (`local-lvm`) vers la nouvelle réserve haute performance (`nvme-storage`).

4. **Maintenance et récupération d'espace :** Purger les pointeurs de disques restants (`unused0`) pour libérer définitivement les blocs de stockage sur le pool d'origine.

## 3. Schéma d'Architecture du Stockage

```
+-------------------------------------------------------------------------+
|                         Serveur Proxmox VE (server237)                  |
+-------------------------------------------------------------------------+
                                     |
             +-----------------------+-----------------------+
             |                                               |
  [ Disque HDD/SATA Système ]                     [ Disque physique NVMe ]
      /dev/sda (273.4G)                               /dev/nvme0n1 (953.9G)
             |                                               |
      Storage: local-lvm                              ( wipefs -a )
    (Stockage lent / par défaut)                             |
             |                                      Physical Volume (PV)
             |                                               |
             |                                      Volume Group (nvme-vg)
             |                                               |
             |                                       Thin Pool (data)
             |                                               |
             |                                    Storage PVE: nvme-storage
             |                                  (Type: lvmthin | High IOPS)
             |                                               |
             +========> Live Storage Migration (qm move_disk) ======>|
                        (VM 100, 102, 104 -> nvme-storage)

```

## 4. Procédure Détaillée et Preuves d'Exécution

### 4.1. Nettoyage et remise à neuf du disque NVMe

Le disque NVMe cible (`/dev/nvme0n1`) contenait les vestiges d'une ancienne installation Proxmox VE (`pve-OLD-810787F6`). Une simple suppression des partitions ne suffit pas ; il convient de désactiver le groupe de volumes logique et de nettoyer les signatures de système de fichiers.

#### Séquence de commandes exécutées :

```
# 1. Démontage de la partition si elle est actuellement montée
umount /dev/nvme0n1p3

# 2. Premier effacement des signatures magiques de la table de partition (échec si LVM verrouillé)
wipefs -a /dev/nvme0n1

# 3. Désactivation explicite du groupe de volumes LVM résiduel
vgchange -an pve-OLD-810787F6

# 4. Suppression forcée du groupe de volumes LVM existant
vgremove -f pve-OLD-810787F6

# 5. Effacement complet et définitif des signatures GPT / PMBR du disque brut
wipefs -a /dev/nvme0n1

```

> 📌 **Explication technique :** La première tentative avec `wipefs` renvoie l'erreur `device or resource busy` car le sous-système LVM maintient des verrous d'E/S. La séquence `vgchange -an` (désactivation) suivie de `vgremove -f` libère les volumes logiques (`data`, `swap`, `root`) et déverrouille le disque.

#### Preuves visuelles d'exécution :

*Figure 1 : Désactivation du Volume Group résiduel et effacement des signatures GPT/PMBR avec `wipefs`.*

*Figure 2 : Exécution de `lsblk` montrant le disque `/dev/nvme0n1` totalement libre (953.9G).*

### 4.2. Configuration du stockage LVM-Thin et enregistrement PVE

Une fois le périphérique NVMe vierge, nous enregistrons la structure LVM-Thin auprès du gestionnaire de stockage de Proxmox VE (`pvesm`).

#### Commande d'ajout du stockage sous Proxmox VE :

```
pvesm add lvmthin nvme-storage --vgname nvme-vg --thinpool data --content images,rootdir

```

#### Détail des paramètres :

* `lvmthin` : pilote de stockage Proxmox pour LVM en allocation dynamique.

* `nvme-storage` : identifiant du stockage dans Proxmox VE.

* `--vgname nvme-vg` : nom du groupe de volumes LVM.

* `--thinpool data` : nom du pool LVM-Thin.

* `--content images,rootdir` : types de contenus autorisés (images disque VM et conteneurs LXC).

#### Preuve d'enregistrement du stockage :

*Figure 3 : Création du stockage `nvme-storage`, vérification par `pvesm status` (statut `active`, 953.87 GB) et initialisation du `qm move_disk 100`.*

### 4.3. Migration à chaud du disque des VMs (VM 100, 102, 104)

Les machines virtuelles utilisaient initialement le stockage standard `local-lvm`. L'objectif est de transférer leurs disques virtuels (`scsi0`) vers `nvme-storage` sans interruption de service.

#### Étape 1 : Inspection pré-migration

```
qm config 100 | grep scsi0

```

* **Résultat initial :** `scsi0: local-lvm:vm-100-disk-0,size=20G`

#### Étape 2 : Exécution du déplacement de disque (Live Migration)

```
qm move_disk 100 scsi0 nvme-storage

```

#### Preuves visuelles du transfert et de la fin de la migration :

*Figure 4 : Progression du transfert (100.00% atteint), finalisation du job miroir et bascule vers `scsi0: nvme-storage:vm-100-disk-0,size=20G`.*

*Figure 5 : Contrôle des fichiers de configuration pour les VMs 100, 102 et 104 hébergées sur `nvme-storage`.*

### 4.4. Nettoyage des volumes obsolètes post-migration

Après le déplacement de disque, Proxmox conserve l'ancien volume sous l'identifiant `unused0`. Pour récupérer l'espace physique sur `local-lvm`, nous exécutons la suppression administrative de ces disques résiduels.

#### Séquence de nettoyage des disques inutilisés :

```
qm set 100 --delete unused0
qm set 102 --delete unused0
qm set 104 --delete unused0

```

#### Preuve visuelle du nettoyage complet :

*Figure 6 : Confirmation de la suppression des volumes `unused0` et sortie de `lsblk` montrant les volumes des VMs 100, 102 et 104 instanciés physiquement sur `nvme--vg-data`.*

## 5. Validation et Matrice de Synthèse

### 📋 Checklist des Objectifs

| Étape de Validation | État | Preuve / Commande de validation | 
| ----- | ----- | ----- | 
| Nettoyage NVMe & purge de `pve-OLD-810787F6` | ✅ Validé | `wipefs -a /dev/nvme0n1` (Figure 1 & 2) | 
| Configuration LVM-Thin `nvme-storage` | ✅ Validé | `pvesm status` -> active (Figure 3) | 
| Live Migration VM 100 (`scsi0`) | ✅ Validé | `qm move_disk 100 scsi0 nvme-storage` (Figure 4) | 
| Migration des VM 102 & 104 | ✅ Validé | `qm config 102 / 104` (Figure 5) | 
| Suppression des disques orphelins `unused0` | ✅ Validé | `qm set <VMID> --delete unused0` & `lsblk` (Figure 6) | 

## 6. Bonnes Pratiques et Recommandations d'Administration

1. **Surveillance de la saturation du Thin Pool :**

   * Dans un pool LVM-Thin, si l'espace physique atteint 100%, toutes les écritures sont bloquées et les VMs s'interrompent pour éviter les corruptions. Configurer une alerte dès **80% d'utilisation**.

2. **Activation de TRIM / Discard :**

   * Pour permettre aux VMs d'informer le disque NVMe physique des blocs libérés lors de suppressions de fichiers, activer le drapeau `discard` sur l'interface SCSI :

     ```
     qm set 100 --scsihw virtio-scsi-pci --scsi0 nvme-storage:vm-100-disk-0,discard=on
     
     ```

3. **Politique de Sauvegarde :**

   * Exécuter une sauvegarde Proxmox Backup Server (PBS) ou `vzdump` avant toute modification majeure de la topologie de stockage.

## 7. Guide de Dépannage (Troubleshooting)

### Problème 1 : `wipefs: error: /dev/nvme0n1: device or resource busy`

* **Cause :** Un volume LVM ou une partition reste verrouillé par le noyau Linux.

* **Résolution :**

  ```
  umount /dev/nvme0n1* 2>/dev/null
  vgchange -an <nom-du-vg-existant>
  vgremove -f <nom-du-vg-existant>
  wipefs -a /dev/nvme0n1
  
  ```

### Problème 2 : `storage 'nvme-storage' does not support content type 'images'`

* **Cause :** Type de contenu non sélectionné lors du `pvesm add`.

* **Résolution :**

  ```
  pvesm set nvme-storage --content images,rootdir
  
  ```

*Document de laboratoire Proxmox VE - System Administration & Storage Management.*