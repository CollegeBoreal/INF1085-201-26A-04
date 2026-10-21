# INF1085 – Créer une machine virtuelle Linux avec Proxmox VE 9 (CLI)

## Objectif

Créer une machine virtuelle Linux :

- 1 vCPU
- 2 Go RAM
- 20 Go disque
- Stockage NVMe
- Installation à partir d'une image ISO

---

## Vérifier les stockages disponibles

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

## Vérifier les ISO disponibles

```bash
pvesm list local | grep iso
```

Exemple :

```text
ubuntu-24.04-live-server-amd64.iso
```

---

## Créer la machine virtuelle

```bash
qm create 101 \
    --name ubuntu01 \
    --memory 2048 \
    --cores 1 \
    --cpu host \
    --net0 virtio,bridge=vmbr0
```

---

## Créer le disque virtuel de 20 Go sur le NVMe

```bash
qm set 101 --scsi0 nvme-storage:20
```

---

## Configurer le contrôleur de disque VirtIO

```bash
qm set 101 --scsihw virtio-scsi-pci
```

---

## Attacher l'image ISO

```bash
qm set 101 \
    --ide2 local:iso/ubuntu-24.04-live-server-amd64.iso,media=cdrom
```

---

## Configurer l'ordre de démarrage

```bash
qm set 101 --boot order=ide2\;scsi0
```

---

## Vérifier la configuration

```bash
qm config 101
```

---

## Démarrer la VM

```bash
qm start 101
```

---

## Ouvrir la console

Dans l'interface Web :

```text
VM 101
└── Console
```

---

## Installer Linux

Suivre l'assistant d'installation :

- Langue : Français
- Installation sur le disque complet
- Créer un utilisateur
- Définir un mot de passe

---

## Arrêter la VM après l'installation

```bash
qm shutdown 101
```

---

## Retirer l'ISO

```bash
qm set 101 --delete ide2
```

---

## Modifier l'ordre de démarrage

```bash
qm set 101 --boot order=scsi0
```

---

## Redémarrer la VM

```bash
qm start 101
```

---

## Vérifier les VM

```bash
qm list
```

Exemple :

```text
VMID NAME      STATUS
101  ubuntu01  running
```

---

## Accéder à la console de la VM

```bash
qm terminal 101
```

---

## Vérifier Linux

### Mémoire

```bash
free -h
```

Résultat attendu :

```text
2.0 GiB RAM
```

### CPU

```bash
lscpu
```

Résultat attendu :

```text
CPU(s): 1
```

### Disque

```bash
lsblk
```

Résultat attendu :

```text
20G disque virtuel
```


---

## Résultat attendu

✅ VM ID 101 créée

✅ 1 vCPU

✅ 2 Go RAM

✅ 20 Go disque

✅ Stockage sur le NVMe

✅ Linux installé à partir d'un fichier ISO

✅ Machine virtuelle opérationnelle

---

# 💿 Proxmox VE – `ide2` vs `scsi0`

Dans Proxmox, `ide2` et `scsi0` représentent deux périphériques virtuels différents attachés à une machine virtuelle.

---

## 💿 `ide2` – Lecteur CD/DVD virtuel

Dans notre laboratoire :

```bash
qm set 101 \
    --ide2 local:iso/ubuntu-24.04-live-server-amd64.iso,media=cdrom
```

`ide2` contient l'image ISO utilisée pour installer Linux.

```text
ide2
  │
  └── 💿 ubuntu-24.04.iso
```

Il joue le rôle d'un **lecteur CD/DVD virtuel**.

---

## 💾 `scsi0` – Disque dur virtuel

Dans notre laboratoire :

```bash
qm set 101 --scsi0 nvme-storage:20
```

`scsi0` représente le disque virtuel sur lequel Linux sera installé.

```text
scsi0
  │
  └── 💾 Disque virtuel 20 Go
           │
           └── nvme-storage
```

---

## ⚙️ Contrôleur SCSI

Le contrôleur utilisé pour le disque est :

```bash
qm set 101 --scsihw virtio-scsi-pci
```

La VM utilise donc un contrôleur **VirtIO SCSI** pour accéder au disque `scsi0`.

---

# 🚀 Pendant l'installation

La VM possède deux périphériques principaux :

```text
VM 101
│
├── 💿 ide2
│      └── ubuntu.iso
│
└── 💾 scsi0
       └── 20 Go sur nvme-storage
```

L'ISO sert à **installer** Linux.

Le disque SCSI sert à **recevoir** l'installation Linux.

---

# 🔢 Ordre de démarrage

Pendant l'installation :

```bash
qm set 101 --boot order=ide2\;scsi0
```

Ordre :

```text
1️⃣ ide2  → ISO d'installation
2️⃣ scsi0 → Disque Linux
```

---

# ✅ Après l'installation

Retirer l'ISO :

```bash
qm set 101 --delete ide2
```

Puis démarrer directement sur le disque :

```bash
qm set 101 --boot order=scsi0
```

La VM démarre maintenant depuis :

```text
💾 scsi0
```

---

# 🧠 À retenir

| Périphérique | Fonction | Exemple |
|---|---|---|
| 💿 `ide2` | Lecteur CD/DVD virtuel | ISO Ubuntu |
| 💾 `scsi0` | Disque virtuel | Linux installé |
| ⚙️ `virtio-scsi-pci` | Contrôleur SCSI virtuel | Contrôle `scsi0` |

## Résumé

```text
        VM Proxmox
             │
      ┌──────┴──────┐
      │             │
   💿 ide2        💾 scsi0
      │             │
 Ubuntu ISO      Disque 20 Go
      │             │
      └── Installer Linux ──►
```

> 💡 **`ide2` contient l'installateur, tandis que `scsi0` contient le système Linux installé.**
