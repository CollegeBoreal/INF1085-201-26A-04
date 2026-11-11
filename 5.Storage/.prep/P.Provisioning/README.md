# 💾 Qu'est-ce que le `Provisioning` ?

## Définition

Le **Thin Provisioning** permet d'allouer virtuellement plus d'espace disque que celui réellement utilisé.

Au lieu de réserver immédiatement tout l'espace demandé, le stockage est consommé uniquement lorsque des données sont réellement écrites.

---

## Sans Thin Provisioning

Création d'une VM :

```text
VM 101 = 100 Go
```

Proxmox réserve immédiatement :

```text
100 Go
```

Même si seulement :

```text
5 Go
```

sont utilisés.

```text
100 Go alloués
└── 95 Go inutilisés
```

---

## Avec Thin Provisioning

Création d'une VM :

```text
VM 101 = 100 Go
```

Au départ :

```text
5 Go utilisés
```

Proxmox consomme seulement :

```text
5 Go
```

sur le stockage.

```text
100 Go virtuels
└── 5 Go réellement utilisés
```

---

# 📊 Exemple

Supposons un SSD NVMe de :

```text
1 To
```

Créer trois VM :

```text
VM 101 = 200 Go
VM 102 = 200 Go
VM 103 = 200 Go
```

Total déclaré :

```text
600 Go
```

Mais les VM utilisent réellement :

```text
50 Go
30 Go
20 Go
```

Consommation réelle :

```text
100 Go
```

et non :

```text
600 Go
```

---

# 🖼️ Schéma

```text
SSD NVMe 1 To
      │
      ▼
+------------------+
| Thin Pool        |
| 1000 Go          |
+------------------+
      │
      ├── VM 101 (200 Go)
      │        └── 50 Go utilisés
      │
      ├── VM 102 (200 Go)
      │        └── 30 Go utilisés
      │
      └── VM 103 (200 Go)
               └── 20 Go utilisés

Espace consommé : 100 Go
```

---

# 🚀 Pourquoi Proxmox utilise LVM-Thin ?

✅ Économie d'espace

✅ Création rapide des disques VM

✅ Snapshots

✅ Clonage rapide

✅ Utilisation optimale des SSD NVMe

---

# ⚠️ Attention

Le Thin Provisioning n'empêche pas le stockage de se remplir.

Exemple :

```text
SSD NVMe = 1 To
```

Vous créez :

```text
10 VM de 200 Go
```

Total virtuel :

```text
2000 Go
```

Lorsque les VM commencent toutes à utiliser leur espace :

```text
Le Thin Pool peut devenir plein.
```

Il faut surveiller :

```bash
pvesm status
```

---

# ✅ Résumé

```text
Disque classique :
100 Go créés = 100 Go réservés

Thin Provisioning :
100 Go créés = espace utilisé seulement lorsqu'on écrit des données
```

Le **Thin Provisioning** permet donc à Proxmox d'utiliser efficacement un SSD NVMe en ne consommant que l'espace réellement utilisé par les machines virtuelles.

---

# 💾 Thin Provisioning vs Thick (Fat) Provisioning

## 🎯 Définition

Les deux méthodes déterminent comment l'espace disque est attribué à une machine virtuelle.

---

# 🥩 Thick (Fat) Provisioning

Avec le **Thick Provisioning**, tout l'espace est réservé immédiatement.

Exemple :

Création d'une VM de :

```text
100 Go
```

Proxmox réserve instantanément :

```text
100 Go
```

même si la VM n'utilise que :

```text
5 Go
```

### Schéma

```text
SSD 1 To

┌─────────────────────┐
│ VM 101 = 100 Go     │
│ Réservé : 100 Go    │
│ Utilisé : 5 Go      │
└─────────────────────┘
```

### Avantages

✅ Prévisible

✅ Aucune surprise liée à l'espace disque

✅ Souvent légèrement plus performant

### Inconvénients

❌ Gaspillage d'espace

❌ Moins flexible

---

# 🚀 Thin Provisioning

Avec le **Thin Provisioning**, seul l'espace réellement utilisé est consommé.

Création d'une VM de :

```text
100 Go
```

Au départ :

```text
Utilisé : 5 Go
```

Proxmox consomme seulement :

```text
5 Go
```

sur le stockage.

### Schéma

```text
SSD 1 To

┌─────────────────────┐
│ VM 101 = 100 Go     │
│ Réservé : 5 Go      │
│ Utilisé : 5 Go      │
└─────────────────────┘
```

---

# 📊 Exemple concret

## Thick Provisioning

Créer 5 VM de :

```text
100 Go
```

Total réservé :

```text
500 Go
```

Même si elles utilisent chacune :

```text
10 Go
```

---

## Thin Provisioning

Créer les mêmes VM :

```text
VM1 = 100 Go
VM2 = 100 Go
VM3 = 100 Go
VM4 = 100 Go
VM5 = 100 Go
```

Espace virtuel :

```text
500 Go
```

Mais si chaque VM utilise :

```text
10 Go
```

Consommation réelle :

```text
50 Go
```

---

# 🖼️ Comparaison

## Thick

```text
SSD 1 To

┌───────────────┐
│ VM 100 Go     │
├───────────────┤
│ VM 100 Go     │
├───────────────┤
│ VM 100 Go     │
└───────────────┘

300 Go consommés
```

---

## Thin

```text
SSD 1 To

VM 100 Go → 10 Go utilisés
VM 100 Go → 15 Go utilisés
VM 100 Go → 20 Go utilisés

45 Go consommés
```

---

# 🖥️ Sous Proxmox

## local-lvm

```text
LVM-Thin
```

Utilise généralement :

```text
Thin Provisioning
```

---

## NVMe LVM-Thin

```bash
lvcreate -l 100%FREE -T nvme-vg/data
```

Produit :

```text
nvme-storage
```

qui utilise également :

```text
Thin Provisioning
```

---

# ⚠️ Risque du Thin Provisioning

Supposons :

```text
SSD = 1 To
```

Vous créez :

```text
10 VM de 200 Go
```

Proxmox accepte :

```text
2000 Go virtuels
```

mais le stockage réel reste :

```text
1000 Go
```

Si toutes les VM se remplissent :

```text
Le Thin Pool peut manquer d'espace.
```

Il faut surveiller :

```bash
pvesm status
```

---

# 🧠 Résumé

| Caractéristique | Thick (Fat) | Thin |
|---|---|---|
| Espace réservé immédiatement | ✅ Oui | ❌ Non |
| Économie d'espace | ❌ Faible | ✅ Excellente |
| Flexibilité | ❌ Faible | ✅ Élevée |
| Risque de manque d'espace | ✅ Non | ⚠️ Oui |
| Utilisé par LVM-Thin Proxmox | ❌ Non | ✅ Oui |

## À retenir

```text
Thick = 100 Go créés → 100 Go réservés

Thin = 100 Go créés → espace consommé seulement lorsque les données sont écrites
```

Pour les laboratoires INF1085 et la plupart des déploiements Proxmox modernes, **LVM-Thin (Thin Provisioning)** est généralement le meilleur choix pour exploiter efficacement un SSD NVMe.
