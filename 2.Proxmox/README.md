# Installation de Proxmox VE 9 sur un HP ProLiant DL360 G6

[:tada: Participation](.scripts/Participation.md)

---

🉑 Credentials: root/Boreal@2️⃣02️⃣6

| IP | S/N  | 🩹 | 🧻 NVMe | Comments |
|-|-|-|-|-|
| 10.7.236.237 | MXQ0390MBX | S21 | ✅ 
| 10.7.236.238 | USE025N785 | S13 | ✅ | ⚠️ P2 DIMM 9 Error
| 10.7.236.239 | MXQ00309PP | S19 | ✅ | ⚠️ 1 CPU
| 10.7.236.240 | MXQ02302FC | S25 | ✅ | 

- [ ] 10.7.236.0/23 Network
- [ ] 10.7.237.1 Gateway
- [ ] 8.8.8.8 DNS

## 🎯 Objectif

À la fin de ce laboratoire, vous serez capable de :

- Installer Proxmox VE 9 sur un HP ProLiant DL360 G6.
- Comprendre les problèmes de compatibilité entre un ancien serveur et un noyau Linux moderne.
- Utiliser des paramètres de démarrage avancés.
- Diagnostiquer les problèmes liés à ACPI et APIC.
- Vérifier que tous les processeurs sont correctement détectés.

---

# 📖 Contexte

Le HP ProLiant DL360 G6 est un serveur datant d'environ 2009-2010.

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

- HP ProLiant DL360 G6
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
nomodeset acpi=off
```

Exemple :

```text
linux ... nomodeset acpi=off
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

Sur le DL360 G6, le contrôleur graphique intégré est très ancien.

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

### Pourquoi ?

Le BIOS P64 (2010) du DL360 G6 fournit parfois des informations incompatibles avec les noyaux Linux récents.

Sans :

```text
acpi=off
```

on peut observer :

```text
Illegal Opcode
NMI PCI Error
Boot Failure
```

ou d'autres problèmes matériels.

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
BOOT_IMAGE=/boot/vmlinuz-7.x.x-pve root=/dev/mapper/pve-root ro nomodeset acpi=off quiet
```

---

# Étape 6 – Vérifier les processeurs

Afficher les informations CPU :

```bash
lscpu
```

Exemple :

```text
CPU(s):                8
Socket(s):             2
Core(s) per socket:    4
Thread(s) per core:    1
```

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
