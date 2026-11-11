# 💾 Qu'est-ce que LVM ?

**LVM (Logical Volume Manager)** est un système de gestion du stockage sous Linux qui ajoute une couche d'abstraction entre les disques physiques et les systèmes de fichiers.

Au lieu d'utiliser directement un disque ou une partition, Linux utilise :

```text
PV → VG → LV
```

---

## 🧱 Les trois composantes

### Physical Volume (PV)

Le disque ou la partition physique.

Exemple :

```text
/dev/nvme0n1p1
```

---

### Volume Group (VG)

Un regroupement d'un ou plusieurs PV.

Exemple :

```text
nvme-vg
```

---

### Logical Volume (LV)

Un volume logique créé dans le VG.

Exemple :

```text
data
```

---

## 🖼️ Schéma

```text
SSD NVMe
    │
    ▼
+-----------+
|    PV     |
+-----------+
      │
      ▼
+-----------+
|    VG     |
| nvme-vg   |
+-----------+
      │
      ▼
+-----------+
|    LV     |
|   data    |
+-----------+
      │
      ▼
 Machines virtuelles
```

---

## 🚀 Pourquoi utiliser LVM ?

✅ Agrandir facilement un volume

✅ Ajouter plusieurs disques dans un même groupe

✅ Utiliser le Thin Provisioning (LVM-Thin)

✅ Simplifier la gestion du stockage des VM Proxmox

---

## 🎯 Résumé

```text
PV = Disque ou partition
VG = Réservoir de stockage
LV = Volume de stockage utilisable
```

Sous Proxmox :

```text
NVMe
 → PV
 → VG
 → Thin Pool (LV)
 → Disques des VM
```

LVM permet donc à Proxmox de transformer un simple disque NVMe en un espace de stockage flexible pour héberger les machines virtuelles.

# 💾 Architecture du stockage sous Linux et Proxmox VE

## 🎯 Objectif

Comprendre comment un disque physique devient un espace de stockage utilisable pour les machines virtuelles Proxmox.

---

# 🧱 Vue d'ensemble

Imaginez que vous venez d'installer un nouveau SSD NVMe de 1 To :

```text
SK hynix PC811 1 To
```

Linux ne peut pas immédiatement l'utiliser pour héberger des VM.

Plusieurs étapes sont nécessaires.

---

# 📦 Étape 1 – Disque physique

Le système détecte le disque :

```bash
lsblk
```

Exemple :

```text
nvme0n1 953.9G
```

```text
+----------------------+
| NVMe 1 To            |
| /dev/nvme0n1         |
+----------------------+
```

---

# 🗂️ Étape 2 – Partition

Le disque est découpé en partitions.

Exemple :

```text
+----------------------+
| NVMe 1 To            |
+----------------------+
           │
           ▼
+----------------------+
| nvme0n1p1            |
| 953.9 Go             |
+----------------------+
```

Vérification :

```bash
lsblk
```

Résultat :

```text
nvme0n1
└── nvme0n1p1
```

---

# 🧱 Étape 3 – Physical Volume (PV)

LVM transforme la partition en volume physique.

Commande :

```bash
pvcreate /dev/nvme0n1p1
```

Architecture :

```text
NVMe
 │
 ▼
Partition
 │
 ▼
PV
```

Schéma :

```text
+----------------------+
| /dev/nvme0n1p1       |
|      Physical        |
|        Volume        |
+----------------------+
```

Vérification :

```bash
pvs
```

---

# 📦 Étape 4 – Volume Group (VG)

Le PV est ajouté dans un groupe de volumes.

Commande :

```bash
vgcreate nvme-vg /dev/nvme0n1p1
```

Schéma :

```text
+----------------------+
|        PV            |
+----------------------+
           │
           ▼
+----------------------+
|      VG              |
|     nvme-vg          |
+----------------------+
```

Le VG représente une réserve d'espace disponible.

---

# 📁 Étape 5 – Thin Pool

Proxmox utilise généralement un Thin Pool.

Commande :

```bash
lvcreate -l 100%FREE -T nvme-vg/data
```

Schéma :

```text
+----------------------+
|      nvme-vg         |
+----------------------+
           │
           ▼
+----------------------+
|      Thin Pool       |
|        data          |
+----------------------+
```

---

# 🖥️ Étape 6 – Stockage Proxmox

Le Thin Pool est ajouté à Proxmox :

```bash
pvesm add lvmthin nvme-storage \
    --vgname nvme-vg \
    --thinpool data \
    --content images,rootdir
```

Schéma :

```text
+----------------------+
|      Thin Pool       |
|         data         |
+----------------------+
           │
           ▼
+----------------------+
|    nvme-storage      |
+----------------------+
```

Vérification :

```bash
pvesm status
```

---

# 🖥️ Étape 7 – Création des disques de VM

Lorsqu'une VM est créée :

```bash
qm set 101 --scsi0 nvme-storage:20
```

Proxmox crée automatiquement un disque virtuel.

Schéma :

```text
+----------------------+
|     nvme-storage     |
+----------------------+
           │
           ├─────────────► VM 101 (20 Go)
           │
           ├─────────────► VM 102 (40 Go)
           │
           └─────────────► VM 103 (100 Go)
```

---

# 🚀 Architecture complète

```text
+--------------------------------+
|       SSD NVMe 1 To            |
|      /dev/nvme0n1             |
+--------------------------------+
                │
                ▼
+--------------------------------+
|      Partition GPT             |
|     /dev/nvme0n1p1            |
+--------------------------------+
                │
                ▼
+--------------------------------+
|      Physical Volume (PV)      |
+--------------------------------+
                │
                ▼
+--------------------------------+
|      Volume Group (VG)         |
|           nvme-vg              |
+--------------------------------+
                │
                ▼
+--------------------------------+
|        Thin Pool               |
|            data                |
+--------------------------------+
                │
                ▼
+--------------------------------+
|      Stockage Proxmox          |
|        nvme-storage            |
+--------------------------------+
                │
      ┌─────────┼─────────┐
      ▼         ▼         ▼
+---------+ +---------+ +---------+
| VM 101  | | VM 102  | | VM 103  |
| 20 Go   | | 40 Go   | |100 Go   |
+---------+ +---------+ +---------+
```

---

# 🔍 Vérification des différentes couches

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

Afficher les VM :

```bash
qm list
```

---

# ✅ Résumé

```text
Disque NVMe
      │
      ▼
Partition
      │
      ▼
PV (Physical Volume)
      │
      ▼
VG (Volume Group)
      │
      ▼
Thin Pool
      │
      ▼
Stockage Proxmox
      │
      ▼
Disques des VM
```

C'est cette chaîne complète qui permet à Proxmox de transformer un simple SSD NVMe en espace de stockage pour héberger des machines virtuelles.
