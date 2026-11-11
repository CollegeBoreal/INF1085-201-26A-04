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

