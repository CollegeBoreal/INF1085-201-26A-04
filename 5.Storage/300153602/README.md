# Travail 5 — Stockage sous Linux et Proxmox

**Meriem Abdedou — INF1085, groupe 04**

## Objectif

Identifier les disques et les volumes du serveur, puis vérifier où Proxmox
stocke les images ISO et les disques des machines virtuelles.

## Vérifications

| Commande | Ce que je vérifie |
|---|---|
| `lsblk -f` | Les disques, les partitions et leurs systèmes de fichiers |
| `pvs` et `vgs` | Les volumes physiques et les groupes de volumes LVM |
| `lvs -a` | Les volumes logiques et les pools LVM-thin |
| `pvesm status` | L’état et l’espace disponible des stockages Proxmox |

Un volume physique (PV) fournit de l’espace à un groupe de volumes (VG).
On utilise cet espace pour créer des volumes logiques (LV). Avec LVM-thin,
les blocs sont alloués à mesure que les machines virtuelles écrivent des données.

## Résultats du laboratoire

- Disques détectés :
- Groupe de volumes et pool LVM-thin :
- Stockage des ISO :
- Stockage des disques des VM :
