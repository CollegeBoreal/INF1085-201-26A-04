# 🧩 Que signifie `pvesm` ?

`pvesm` signifie :

```text
Proxmox VE Storage Manager
```

C'est l'utilitaire en ligne de commande utilisé pour gérer les stockages de Proxmox VE.

---

# 🎯 À quoi sert `pvesm` ?

Avec `pvesm`, vous pouvez :

- Afficher les stockages disponibles
- Ajouter un nouveau stockage
- Supprimer un stockage
- Vérifier l'utilisation du stockage
- Lister les disques des VM
- Vérifier l'espace libre

---

# 📋 Commandes courantes

## Afficher les stockages

```bash
pvesm status
```

Exemple :

```text
Name          Type      Status
local         dir       active
local-lvm     lvmthin   active
nvme-storage  lvmthin   active
```

---

## Afficher le contenu d'un stockage

```bash
pvesm list nvme-storage
```

Exemple :

```text
vm-101-disk-0
vm-102-disk-0
```

---

## Ajouter un stockage LVM-Thin

```bash
pvesm add lvmthin nvme-storage \
    --vgname nvme-vg \
    --thinpool data \
    --content images,rootdir
```

---

## Supprimer un stockage

```bash
pvesm remove nvme-storage
```

---

# 🖥️ Relation avec les autres outils Proxmox

| Commande | Fonction |
|-----------|----------|
| `qm` | Gestion des machines virtuelles |
| `pct` | Gestion des conteneurs LXC |
| `pvesm` | Gestion du stockage |

Exemples :

```bash
qm list
```

Liste les VM.

```bash
pct list
```

Liste les conteneurs.

```bash
pvesm status
```

Liste les stockages.

---

# 🖼️ Exemple

```text
SSD NVMe
    │
    ▼
PV
    │
    ▼
VG (nvme-vg)
    │
    ▼
Thin Pool (data)
    │
    ▼
nvme-storage
    │
    ▼
Disques des VM
```

---

# ✅ Résumé

```text
pvesm = Proxmox VE Storage Manager
```

Il s'agit de l'outil principal permettant de gérer les stockages utilisés par Proxmox pour :

- les disques des VM ;
- les conteneurs LXC ;
- les images ISO ;
- les sauvegardes.

La commande la plus utilisée est généralement :

```bash
pvesm status
```

qui permet d'afficher tous les stockages configurés sur un serveur Proxmox.
