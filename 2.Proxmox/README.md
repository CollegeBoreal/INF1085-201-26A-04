# Installation de Proxmox VE 9 sur un HP ProLiant DL360 G7️⃣

[:tada: Participation](.scripts/Participation.md)

---

🉑 Credentials: root/Boreal@2️⃣02️⃣6

| POS | IP | S/N  | 🩹 | 🧻 NVMe | ARCH | Commentaires
|-|-|-|-|-|-|-|
| 2️⃣-3️⃣4️⃣ | 10.7.236.237 | MXQ1370MCG | S28 | ✅ | G7️⃣  | `nomodeset`
| 2️⃣-3️⃣3️⃣ | 10.7.236.238 | CZJ2030LYF | S35 | ✅ | G7️⃣  | 
| 2️⃣-3️⃣2️⃣ | 10.7.236.239 | MXQ1170T6R | S26 | ✅ | G7️⃣  | `nomodeset`
| 2️⃣-3️⃣1️⃣ | 10.7.236.240 | USE044N2AL | S20 | ✅ | G7️⃣  | `nomodeset`

- [ ] 10.7.236.0/23 Network
- [ ] 10.7.237.1 Gateway
- [ ] 8.8.8.8 DNS

## 🎯 Objectif

À la fin de ce laboratoire, vous serez capable de :

- Installer Proxmox VE 9 sur un HP ProLiant DL360 G7️⃣.
- Comprendre les problèmes de compatibilité entre un ancien serveur et un noyau Linux moderne.
- Utiliser des paramètres de démarrage avancés.
- Diagnostiquer si problèmes liés à ACPI et APIC.
- Vérifier que tous les processeurs sont correctement détectés.

---

# 📖 Contexte

Le HP ProLiant DL360 G7️⃣ est un serveur datant d'environ 2009-2010.

Bien que ce matériel soit toujours capable d'exécuter Proxmox VE 9, sa plateforme matérielle est beaucoup plus ancienne que le noyau Linux utilisé par Proxmox.

Lors de l'installation, il est fréquent d'observer :

- Écran noir.
- Blocage du démarrage.
- Erreurs liées aux tables ACPI.
- Mauvaise détection des processeurs.
- Erreurs PCI.

Dans notre environnement de laboratoire, les paramètres suivants ont permis d'assurer un démarrage stable :

```text
nomodeset acpi=off
```

---

# 🛠 Prérequis

## Matériel

- HP ProLiant DL360 G7️⃣
- 2 × Xeon E5540 (optionnel mais recommandé)
- 64 Go RAM
- SSD ou disque système
- Clé USB de 8 Go ou plus

## Logiciel

- Proxmox VE 9 ISO
- Rufus (Windows) ou balenaEtcher

---

# Étape 1 – Préparer la clé USB

Télécharger l'image ISO de Proxmox VE 9.

Créer une clé USB bootable.

## Sous Windows

Utiliser :

```text
Rufus
```

## Sous Linux

```bash
sudo dd if=proxmox-ve_9.iso of=/dev/sdX bs=4M status=progress
```

Remplacer :

```text
/dev/sdX
```

par votre clé USB.

---

# Étape 2 – Démarrer le serveur

Au démarrage :

```text
F11
```

Choisir :

```text
USB Drive
```

Le menu de démarrage de Proxmox apparaît.

---

# Étape 3 – Modifier les paramètres de démarrage

Sélectionner :

```text
Install Proxmox VE
```

Ne pas appuyer immédiatement sur Entrée.

Appuyer sur :

```text
e
```

pour modifier la ligne de démarrage.

---

## Ajouter les paramètres

Repérer la ligne contenant :

```text
linux
```

Ajouter à la fin :

```text
nomodeset
```

Exemple :

```text
linux ... nomodeset
```

Puis démarrer avec :

```text
Ctrl + X
```

ou

```text
F10
```

---

# 📘 Explication des paramètres

## nomodeset

### Fonction

Empêche Linux d'initialiser les pilotes graphiques avancés.

Normalement, Linux utilise :

```text
Kernel Mode Setting (KMS)
```

pour la vidéo.

Avec :

```text
nomodeset
```

Linux utilise un mode vidéo minimal.

### Pourquoi ?

Sur le DL360 G7️⃣, le contrôleur graphique intégré est très ancien.

Sans ce paramètre, l'installation peut :

- afficher un écran noir;
- rester figée;
- échouer à démarrer.

---

## acpi=off

### Fonction

Désactive complètement ACPI.

ACPI signifie :

```text
Advanced Configuration and Power Interface
```

ACPI est responsable de :

- la gestion d'énergie;
- la détection du matériel;
- les tables processeurs;
- les interruptions;
- les ressources PCI.

---

# Étape 4 – Installer Proxmox

Poursuivre l'installation normalement.

Configurer :

- Le disque système.
- Le mot de passe root.
- Le réseau.
- Le nom d'hôte.

Compléter l'installation.

---

# Étape 5 – Premier démarrage

Après le redémarrage :

```bash
login: root
```

Vérifier :

```bash
cat /proc/cmdline
```

Résultat attendu :

```text
BOOT_IMAGE=/boot/vmlinuz-7.x.x-pve root=/dev/mapper/pve-root ro nomodeset quiet
```

---

# Étape 6 – Vérifier les processeurs

Afficher les informations CPU :

```bash
lscpu
```

Exemple :

```text
CPU(s):                16
Socket(s):             2
Core(s) per socket:    4
Thread(s) per core:    2
```

<details><summary>🪵 Print </summary>

```lua
Architecture:                x86_64
  CPU op-mode(s):            32-bit, 64-bit
  Address sizes:             40 bits physical, 48 bits virtual
  Byte Order:                Little Endian
CPU(s):                      16
  On-line CPU(s) list:       0-15
Vendor ID:                   GenuineIntel
  Model name:                Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    CPU family:              6
    Model:                   26
    Thread(s) per core:      2
    Core(s) per socket:      4
    Socket(s):               2
    Stepping:                5
    CPU(s) scaling MHz:      90%
    CPU max MHz:             2666.0000
    CPU min MHz:             1600.0000
    BogoMIPS:                5334.12
    Flags:                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall nx r
                             dtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni dtes64 monitor ds_cpl vmx es
                             t tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm pti ssbd ibrs ibpb stibp tpr_shadow flexpriority ept vpid dtherm ida 
                             vnmi flush_l1d
Virtualization features:     
  Virtualization:            VT-x
Caches (sum of all):         
  L1d:                       256 KiB (8 instances)
  L1i:                       256 KiB (8 instances)
  L2:                        2 MiB (8 instances)
  L3:                        16 MiB (2 instances)
NUMA:                        
  NUMA node(s):              2
  NUMA node0 CPU(s):         0,2,4,6,8,10,12,14
  NUMA node1 CPU(s):         1,3,5,7,9,11,13,15
Vulnerabilities:             
  Gather data sampling:      Not affected
  Ghostwrite:                Not affected
  Indirect target selection: Not affected
  Itlb multihit:             KVM: Mitigation: Split huge pages
  L1tf:                      Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                       Vulnerable: Clear CPU buffers attempted, no microcode; SMT vulnerable
  Meltdown:                  Mitigation; PTI
  Mmio stale data:           Not affected
  Old microcode:             Not affected
  Reg file data sampling:    Not affected
  Retbleed:                  Not affected
  Spec rstack overflow:      Not affected
  Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:                Mitigation; Retpolines; IBPB conditional; IBRS_FW; STIBP conditional; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
  Srbds:                     Not affected
  Tsa:                       Not affected
  Tsx async abort:           Not affected
  Vmscape:                   Not affected
```

</details>

---

Afficher le nombre de processeurs détectés :

```bash
nproc
```

Résultat attendu :

```text
8
```

---

# Étape 7 – Vérifier le matériel

## Processeurs

```bash
lscpu
```

---

## Mémoire

```bash
lsmem
```

---

## Disques

```bash
lsblk
```

---

## Cartes PCI

```bash
lspci
```

---

## Modules du noyau

```bash
lsmod
```

---

# Dépannage

## Le serveur démarre avec un seul CPU

Vérifier que les paramètres suivants ne sont PAS utilisés :

```text
nolapic
```

ou

```text
noapic
```

Ces paramètres peuvent empêcher Linux d'utiliser les processeurs multiples.

---

## Vérifier les paramètres actifs

```bash
cat /proc/cmdline
```

---

## Vérifier le nombre de CPU activés

```bash
cat /sys/devices/system/cpu/online
```

Exemple :

```text
0-7
```

---

## Vérifier les interruptions

```bash
cat /proc/interrupts
```

---

# Concepts importants

## ACPI

```text
Advanced Configuration and Power Interface
```

Permet au BIOS de transmettre des informations matérielles à Linux.

---

## APIC

```text
Advanced Programmable Interrupt Controller
```

Permet de distribuer les interruptions entre les différents processeurs.

---

## Local APIC (LAPIC)

Chaque processeur possède son propre APIC local.

Désactiver LAPIC avec :

```text
nolapic
```

peut provoquer :

```text
smpboot: SMP disabled
```

et limiter le système à un seul processeur logique.

---

## SMP

```text
Symmetric Multiprocessing
```

Permet l'utilisation simultanée de plusieurs processeurs ou cœurs.

---

# Vérification finale

Effectuer les commandes suivantes :

```bash
cat /proc/cmdline
```

```bash
lscpu
```

```bash
nproc
```

```bash
lsblk
```

```bash
ip a
```

---

# Résultat attendu

✅ Proxmox VE 9 installé

✅ Paramètres permanents :

```text
nomodeset acpi=off
```

✅ Système stable

✅ Les deux Xeon E5540 détectés

✅ 8 cœurs physiques disponibles

✅ Prêt à héberger plusieurs machines virtuelles Linux pour les laboratoires INF1085

---

# Questions de réflexion

1. À quoi sert le paramètre `nomodeset` ?

2. Pourquoi un ancien BIOS peut-il nécessiter `acpi=off` ?

3. Quelle est la différence entre ACPI et APIC ?

4. Pourquoi le paramètre `nolapic` peut-il réduire le nombre de processeurs visibles ?

5. Quelle commande permet de vérifier les paramètres réellement utilisés lors du démarrage du noyau Linux ?

---

# 📚 Reference

| IP | S/N  | 🩹 | 🧻 NVMe | Comments |
|-|-|-|-|-|
|              | MXQ0390MBX | S21 | ✅ 
|              | USE025N785 | S13 | ✅ | ⚠️ P2 DIMM 9 Error
|              | MXQ00309PP | S19 | ✅ | G6️⃣ ⚠️ 1 CPU
|              | MXQ02302FC | S25 | ✅ | G6️⃣ ⚠️ 1 CPU

