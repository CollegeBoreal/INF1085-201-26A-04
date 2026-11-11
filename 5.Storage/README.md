# 💾 INF1085 – Introduction au stockage sous Linux et Proxmox VE

## 🎯 Objectif

À la fin de cette leçon, vous serez capable de :

- Comprendre les différents types de stockage.
- Identifier les disques présents dans un système Linux.
- Comprendre les concepts de partition, système de fichiers et LVM.
- Comprendre les stockages utilisés par Proxmox VE.
- Ajouter un disque NVMe comme stockage pour les machines virtuelles.

---

## 📖 Pourquoi le stockage est-il important ?

Le stockage permet de conserver de façon permanente :

- Le système d'exploitation
- Les données
- Les machines virtuelles
- Les sauvegardes
- Les images ISO

Sans stockage :

```text
Pas de système
Pas de fichiers
Pas de machines virtuelles
```

---

## 🧱 Architecture générale

```text
Disque physique
      │
      ▼
 Partition
      │
      ▼
 Système de fichiers
      │
      ▼
 Données
```

Sous Proxmox :

```text
Disque
   │
   ▼
LVM / ZFS
   │
   ▼
Stockage Proxmox
   │
   ▼
Disques des VM
```

---

## 💽 Types de stockage

## Disque dur (HDD)

Exemple :

```text
SAS
SATA
```

Caractéristiques :

- Grande capacité
- Faible coût
- Plus lent

---

### SSD SATA

Exemple :

```text
Samsung 870 EVO
```

Caractéristiques :

- Plus rapide qu'un HDD
- Pas de pièces mécaniques

---

### SSD NVMe

Exemple :

```text
SK hynix PC811
Samsung 980 Pro
WD SN850X
```

Caractéristiques :

- Très rapide
- Utilise PCI Express
- Idéal pour les VM Proxmox

---

## 🔍 Voir les disques

Afficher les périphériques de stockage :

```bash
lsblk
```

Exemple :

```text
sda      273G
nvme0n1  954G
```

---

## 📊 Informations détaillées

```bash
fdisk -l
```

Permet de voir :

- Les disques
- Les partitions
- Les tailles

---

# 🧩 Les partitions

Un disque peut être divisé en plusieurs partitions.

Exemple :

```text
nvme0n1
├── nvme0n1p1
└── nvme0n1p2
```

Une partition permet d'organiser l'espace disque.

---

# 🗂️ Les systèmes de fichiers

Un système de fichiers organise les données.

Exemples :

```text
ext4
xfs
ntfs
fat32
```

Identifier un système de fichiers :

```bash
blkid
```

Exemple :

```text
TYPE="ext4"
```

---

# 📦 Introduction à LVM

LVM signifie :

```text
Logical Volume Manager
```

Il permet de gérer dynamiquement l'espace disque.

Architecture :

```text
PV
 │
 ▼
VG
 │
 ▼
LV
```

---

# 🧱 Physical Volume (PV)

Le PV représente un disque ou une partition.

Exemple :

```text
/dev/nvme0n1p1
```

Création :

```bash
pvcreate /dev/nvme0n1p1
```

Vérification :

```bash
pvs
```

---

# 📦 Volume Group (VG)

Le VG regroupe un ou plusieurs PV.

Exemple :

```text
nvme-vg
```

Création :

```bash
vgcreate nvme-vg /dev/nvme0n1p1
```

Vérification :

```bash
vgs
```

---

# 📁 Logical Volume (LV)

Le LV est un volume logique utilisé comme espace de stockage.

Exemple :

```text
data
```

Création :

```bash
lvcreate -L 100G -n data nvme-vg
```

Vérification :

```bash
lvs
```

---

# 🚀 Thin Provisioning

Proxmox utilise souvent :

```text
LVM-Thin
```

Architecture :

```text
NVMe
 │
 ▼
PV
 │
 ▼
VG
 │
 ▼
Thin Pool
 │
 ▼
VM
```

Création d'un Thin Pool :

```bash
lvcreate -l 100%FREE -T nvme-vg/data
```

---

# 🧻 Les stockages Proxmox: 

- [ ] [pvesm (Storage Manager)](.prep/S.SM)

Afficher les stockages :

```bash
pvesm status
```

Exemple :

```text
local
local-lvm
nvme-storage
```

---

## local

```text
Type : Directory
```

Contient :

- ISO
- Sauvegardes
- Templates

---

## local-lvm

```text
Type : LVM-Thin
```

Contient :

- Disques des VM
- Conteneurs LXC

---

## nvme-storage

```text
Type : LVM-Thin
```

Créé sur un SSD NVMe.

---

# 💾 Ajouter un NVMe à Proxmox

## Créer le PV

```bash
pvcreate /dev/nvme0n1p1
```

---

## Créer le VG

```bash
vgcreate nvme-vg /dev/nvme0n1p1
```

---

## Créer le Thin Pool

```bash
lvcreate -l 100%FREE -T nvme-vg/data
```

---

## Ajouter à Proxmox

```bash
pvesm add lvmthin nvme-storage \
    --vgname nvme-vg \
    --thinpool data \
    --content images,rootdir
```

---

# 🔍 Vérifications

Afficher les disques :

```bash
lsblk
```

Afficher les PV :

```bash
pvs
```

Afficher les VG :

```bash
vgs
```

Afficher les LV :

```bash
lvs
```

Afficher les stockages Proxmox :

```bash
pvesm status
```

---

# 🧪 Questions de réflexion

1. Quelle est la différence entre un HDD, un SSD SATA et un NVMe ?

2. Quel est le rôle d'une partition ?

3. À quoi sert un système de fichiers ?

4. Que signifient les acronymes PV, VG et LV ?

5. Pourquoi Proxmox utilise-t-il souvent LVM-Thin ?

6. Quelle commande permet d'afficher les stockages configurés dans Proxmox ?

7. Quel est l'avantage d'utiliser un NVMe pour les machines virtuelles ?

---

# ✅ Résultat attendu

À la fin du laboratoire, vous devez être capable de :

✅ Identifier les disques présents dans Linux

✅ Comprendre l'organisation du stockage

✅ Créer un PV, un VG et un LV

✅ Comprendre le fonctionnement de LVM-Thin

✅ Ajouter un disque NVMe à Proxmox

✅ Vérifier les stockages avec :

```bash
pvesm status
```
---

# 🧪 lab – Déplacer une machine virtuelle vers le stockage NVMe

:round_pushpin: Créer une page 

- [ ] créer un répertoire avec son :id: et ajouter le fichier `README.md`
- [ ] créer un répertoire dans son répertoire :id:, ajouter le répertoire `images` et ajouter le fichier `.gitkeep`
- [ ] Ajouter des images dans le répertoire `images`
- [ ] Ajouter les images au fichier `README.md`

## 🎯 Objectif

Déplacer le disque d'une machine virtuelle vers :

```text
nvme-storage
```

afin d'améliorer les performances.

---

# 🔍 Vérifier la VM

Afficher les VM :

```bash
qm list
```

Exemple :

```text
101  ubuntu01
```

---

# 🔍 Vérifier le disque actuel

```bash
qm config 101
```

Exemple :

```text
scsi0: local-lvm:vm-101-disk-0,size=20G
```

---

# 🚀 Déplacer le disque

```bash
qm move_disk 101 scsi0 nvme-storage
```

Attendre la fin de la copie.

---

# ✅ Vérifier le résultat

```bash
qm config 101
```

Résultat attendu :

```text
scsi0: nvme-storage:vm-101-disk-0,size=20G
```

---

# 📋 Vérifier le stockage NVMe

```bash
pvesm list nvme-storage
```

Le disque de la VM doit apparaître.

---

# 🧠 Résumé

Avant :

```text
local-lvm
   │
   └── VM 101
```

Après :

```text
nvme-storage
   │
   └── VM 101
```

---

# ✅ Résultat attendu

- ✅ VM identifiée
- ✅ Disque déplacé vers `nvme-storage`
- ✅ Configuration mise à jour
- ✅ VM opérationnelle
- ✅ Stockage NVMe utilisé
