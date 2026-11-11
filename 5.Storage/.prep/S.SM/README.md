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

## Afficher le contenu d
