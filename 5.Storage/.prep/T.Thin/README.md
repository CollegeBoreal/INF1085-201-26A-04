# 💾 Qu'est-ce que le Thin Provisioning ?

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
