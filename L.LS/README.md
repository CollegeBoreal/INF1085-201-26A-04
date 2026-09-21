
La plupart de ces commandes servent à **afficher (list)** des informations sur le système Linux. Elles sont très utiles en administration système (INF1085).

***

# 📁 Gestion des fichiers et systèmes de fichiers

## `ls`

Affiche les fichiers et dossiers.

```bash
ls
ls -l
ls -lah
```

Exemple :

```bash
ls /etc
```

Affiche le contenu du dossier `/etc`.

***

## `lsattr`

Affiche les attributs spéciaux des fichiers.

```bash
lsattr fichier.txt
```

Exemple :

```text
----i-------- important.txt
```

Le `i` signifie **immutable** (impossible à modifier ou supprimer).

Modifier l'attribut :

```bash
chattr +i important.txt
```

***

## `lsblk`

Affiche les périphériques de stockage (disques, partitions, SSD, clés USB).

```bash
lsblk
```

Exemple :

```text
sda      100G
├─sda1     1G
└─sda2    99G
```

Très utile pour :

* Identifier les disques
* Vérifier les partitions
* Voir les points de montage

Version détaillée :

```bash
lsblk -f
```

***

# 🖥️ Informations CPU et mémoire

***

## `lscpu`

Affiche la topologie du processeur.

```bash
lscpu
```

Permet de connaître :

* l'architecture
* le nombre de sockets
* le nombre de cœurs
* le nombre de threads
* les capacités de virtualisation

Exemple sur ton DL360 G6 :

```text
Socket(s):            2
Core(s) per socket:   4
CPU(s):               8
```

***

## `lsmem`

Affiche la disposition de la mémoire vive.

```bash
lsmem
```

Exemple :

```text
RANGE                                  SIZE
0x0000000000000000-0x000000007fffffff   2G
```

Utile sur :

* serveurs
* systèmes NUMA
* machines avec beaucoup de RAM

***

# 🔌 Matériel

***

## `lspci`

Affiche les périphériques PCI/PCIe.

```bash
lspci
```

Exemples :

```text
Smart Array P410i
Broadcom NetXtreme II
```

Permet d'identifier :

* cartes réseau
* contrôleurs RAID
* GPU
* cartes HBA
* contrôleurs USB

Version détaillée :

```bash
lspci -nn
```

***

## `lsusb`

Affiche les périphériques USB.

```bash
lsusb
```

Exemple :

```text
Bus 001 Device 002: USB Keyboard
```

Permet de voir :

* claviers
* souris
* clés USB
* imprimantes
* onduleurs USB

***

# 🧩 Modules du noyau

***

## `lsmod`

Affiche les modules actuellement chargés dans le noyau Linux.

```bash
lsmod
```

Exemple :

```text
Module         Size
kvm
kvm_intel
```

Très utile pour vérifier :

* la virtualisation
* les pilotes de cartes réseau
* les contrôleurs RAID

Exemple :

```bash
lsmod | grep kvm
```

***

# 🚀 Démarrage Linux

***

## `lsinitramfs`

Affiche le contenu d'un initramfs.

```bash
lsinitramfs /boot/initrd.img-$(uname -r)
```

Très utile quand Linux refuse de démarrer.

Exemple :

```text
ALERT! /dev/mapper/pve-root does not exist
```

Permet de vérifier si les modules nécessaires sont présents dans l'initramfs.

***

# 🔒 Verrous de fichiers

***

## `lslocks`

Affiche les fichiers actuellement verrouillés.

```bash
lslocks
```

Utile lorsqu'un système indique :

```text
file is busy
```

ou

```text
cannot remove file
```

***

# ⚡ Interruptions matérielles

***

## `lsirq`

Affiche les IRQ (Interrupt Requests).

```bash
lsirq
```

Permet d'analyser :

* l'affinité CPU
* la répartition des interruptions
* les problèmes SMP

Très utile lors de diagnostics comme :

```text
acpi=off
nolapic
noapic
```

***

# 🔄 Communication interprocessus (IPC)

***

## `lsipc`

Affiche les mécanismes IPC.

```bash
lsipc
```

Montre :

* mémoire partagée
* sémaphores
* files de messages

Souvent utilisé pour :

* bases de données
* applications serveur

***

# 👤 Gestion des utilisateurs

***

## `lslogins`

Affiche les comptes d'utilisateurs du système.

```bash
lslogins
```

Exemple :

```text
UID USER
0   root
1000 brice
```

Plus lisible que :

```bash
cat /etc/passwd
```

***

# 🔎 Fichiers ouverts

***

## `lsof`

Affiche les fichiers actuellement ouverts.

```bash
lsof
```

Une des commandes les plus utiles pour les administrateurs.

Exemples :

### Quel programme utilise le port 8006 ?

```bash
lsof -i :8006
```

### Qui utilise un fichier ?

```bash
lsof /var/log/syslog
```

### Connexions réseau ouvertes

```bash
lsof -i
```

***

# 📦 Espaces de noms Linux

***

## `lsns`

Affiche les namespaces Linux.

```bash
lsns
```

Important pour :

* Docker
* LXC
* Kubernetes
* Proxmox CT

Exemple :

```text
NS TYPE
4026531836 pid
4026532000 net
```

***

# 🎓 Résumé INF1085 : inventaire complet d'un serveur

Pour analyser rapidement un serveur Linux :

```bash
lscpu      # Processeurs
lsmem      # Mémoire
lsblk      # Disques
lspci      # Cartes PCIe
lsusb      # Périphériques USB
lsmod      # Pilotes chargés
lsns       # Conteneurs et namespaces
lsof       # Fichiers et ports ouverts
```

Sur ton **HP ProLiant DL360 G6 avec Proxmox**, ces huit commandes permettent pratiquement de réaliser un **inventaire matériel et logiciel complet**. 🚀
