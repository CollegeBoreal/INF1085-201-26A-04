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
