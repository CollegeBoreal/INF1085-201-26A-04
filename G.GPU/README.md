# 🎮 Ajouter une NVIDIA RTX A400 à Proxmox VE pour le GPU Passthrough

## 🎯 Objectif

Permettre à une machine virtuelle Windows ou Linux d'utiliser directement une carte graphique :

```text
NVIDIA RTX A400
```

grâce au GPU Passthrough sous Proxmox VE.

---

# 📋 Prérequis

## Matériel

- Proxmox VE 8 ou 9
- NVIDIA RTX A400
- CPU Intel avec VT-d ou AMD avec AMD-Vi
- BIOS supportant l'IOMMU

---

# 🔍 Vérifier que la carte est détectée

```bash
lspci | grep -i nvidia
```

Exemple :

```text
01:00.0 VGA compatible controller: NVIDIA Corporation RTX A400
01:00.1 Audio device: NVIDIA Corporation Device
```

Afficher plus de détails :

```bash
lspci -nn
```

Exemple :

```text
01:00.0 VGA compatible controller [0300]: NVIDIA Corporation [10de:24b0]
01:00.1 Audio device [0403]: NVIDIA Corporation [10de:228b]
```

---

# 🧠 Activer l'IOMMU

Modifier :

```bash
nano /etc/default/grub
```

## Intel

```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
```

## AMD

```text
GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
```

Mettre à jour GRUB :

```bash
update-grub
```

---

# 🔧 Activer les modules VFIO

Créer :

```bash
nano /etc/modules
```

Ajouter :

```text
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
```

---

# 📦 Configurer VFIO

Créer :

```bash
nano /etc/modprobe.d/vfio.conf
```

Exemple :

```text
options vfio-pci ids=10de:24b0,10de:228b
```

Les identifiants proviennent de :

```bash
lspci -nn
```

---

# 🔄 Régénérer l'initramfs

```bash
update-initramfs -u -k all
```

Redémarrer :

```bash
reboot
```

---

# ✅ Vérifier VFIO

Après le redémarrage :

```bash
lspci -nnk
```

Résultat attendu :

```text
Kernel driver in use: vfio-pci
```

pour :

```text
01:00.0
01:00.1
```

---

# 🔍 Vérifier les groupes IOMMU

```bash
find /sys/kernel/iommu_groups/ -type l
```

La carte graphique doit être dans son propre groupe IOMMU ou dans un groupe acceptable.

---

# 🖥️ Ajouter le GPU à une VM

Exemple VM :

```text
101
```

Arrêter la VM :

```bash
qm stop 101
```

Ajouter le GPU :

```bash
qm set 101 --hostpci0 01:00,pcie=1
```

ou :

```bash
qm set 101 --hostpci0 01:00,pcie=1,x-vga=1
```

---

# ⚙️ Vérifier la configuration

```bash
qm config 101
```

Exemple :

```text
hostpci0: 0000:01:00,pcie=1
```

---

# 🚀 Démarrer la VM

```bash
qm start 101
```

---

# 🪟 Sous Windows

Installer les pilotes NVIDIA :

```text
NVIDIA RTX A400 Driver
```

Vérifier :

```text
Gestionnaire de périphériques
```

La RTX A400 doit apparaître sans erreur.

---

# 🐧 Sous Linux

Vérifier :

```bash
lspci | grep -i nvidia
```

Installer les pilotes :

```bash
ubuntu-drivers autoinstall
```

ou :

```bash
apt install nvidia-driver
```

---

# 🔍 Vérifications utiles

IOMMU activé :

```bash
dmesg | grep -e DMAR -e IOMMU
```

VFIO :

```bash
lspci -nnk | grep -A3 NVIDIA
```

Configuration VM :

```bash
qm config 101
```

---

# ✅ Résultat attendu

- ✅ RTX A400 détectée par Proxmox
- ✅ IOMMU activé
- ✅ Pilote VFIO attaché au GPU
- ✅ GPU ajouté à la VM
- ✅ Windows ou Linux détecte la RTX A400
- ✅ Accélération GPU disponible dans la machine 


# 📚 References

- [ ] [CNBC: The Truth About How Data Centers Use Water And Power To Keep Cool](https://youtu.be/qxB2eeHud6Q?si=tBF4FHNxMWpCXSQ1)
