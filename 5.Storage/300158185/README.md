# Introduction au stockage sous Linux et Proxmox VE

**Étudiant** — Mohammed Mati  
**Numéro étudiant** — 300158185  
**Cours** — INF1085 – Administration Linux  
**Vérifications individuelles** — 25 novembre 2026

## 1. Introduction et objectifs

Ce laboratoire porte sur la gestion du stockage sous Linux et Proxmox VE. La partie en groupe décrit la préparation d’un NVMe avec LVM-Thin. Pour la partie individuelle, j’ai déplacé le disque de la VM 102 (Mohammed) vers `nvme-storage` et vérifié le démarrage de Debian après le transfert.

## 2. Notions de base

| **Élément**          | **Rôle**                                                                                      |
|----------------------|-----------------------------------------------------------------------------------------------|
| Partition            | Zone délimitée d’un disque qui peut accueillir un système de fichiers ou un PV LVM.           |
| Système de fichiers  | Organise les fichiers et les dossiers. Ext4 et XFS en sont des exemples.                      |
| PV — Physical Volume | Disque ou partition initialisé pour LVM.                                                      |
| VG — Volume Group    | Groupe qui rassemble l’espace d’un ou plusieurs PV.                                           |
| LV — Logical Volume  | Volume logique créé à partir de l’espace d’un VG.                                             |
| Pool LVM-Thin        | Volume logique qui fournit de l’espace aux disques virtuels au fur et à mesure des écritures. |

Dans ce labo, l’ordre est **NVMe → partition → PV → VG → thin pool → disques virtuels**. Le pool fournit du stockage bloc à Proxmox. Debian peut avoir son propre système de fichiers, comme ext4, à l’intérieur de son disque virtuel.

| **Stockage Proxmox** | **Type habituel dans ce labo** | **Contenu**                                                    |
|----------------------|--------------------------------|----------------------------------------------------------------|
| `local`              | Directory                      | Images ISO, sauvegardes et modèles de conteneurs.              |
| `local-lvm`          | LVM-Thin                       | Disques virtuels et volumes racines de conteneurs.             |
| `nvme-storage`       | LVM-Thin                       | Disques virtuels et volumes racines de conteneurs sur le NVMe. |

## Partie A – Travail en groupe : préparation du stockage NVMe

Le stockage `nvme-storage` était déjà visible sur le nœud `server1` de Proxmox VE 9.2.2. Pour les étapes de groupe, exécuter les commandes dans **Proxmox → ton nœud → Shell**, avec les droits d’administration.

### 3. Identification des disques

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
fdisk -l
pvs
pvesm status
```

Dans notre labo, `lsblk` affiche le disque système `/dev/sda` de 273,4 Gio et le NVMe `/dev/nvme0n1` de 953,9 Gio. Le NVMe comporte deux partitions avant la préparation.

![Capture 1 · NVMe de 953,9 Gio et ses deux partitions avant la préparation]<img width="728" height="645" alt="image" src="https://github.com/user-attachments/assets/40846937-0c2b-47b4-9658-d62c36aee39b" />


Capture 1 · NVMe de 953,9 Gio et ses deux partitions avant la préparation

### 4. Vérification des signatures existantes

Sur le NVMe identifié, afficher les signatures détectées avec cette commande de lecture.

```bash
wipefs --no-act /dev/nvme0n1
```

Si le professeur demande un nettoyage préalable, confirmer avec le groupe que le NVMe est dédié au laboratoire, que ses données peuvent être effacées et qu’il ne sert ni au système ni à un stockage existant. Dans ce cas seulement, `wipefs -a /dev/nvme0n1` retire les signatures détectées sur le disque. Cette commande est facultative lorsque le disque est prêt à être partitionné.

![Capture 2 · NVMe sans partitions après le retrait des signatures GPT et PMBR]<img width="728" height="645" alt="image" src="https://github.com/user-attachments/assets/89c76dd5-f6e6-4ac7-99e1-23db8d0c441c" />


Capture 2 · NVMe sans partitions après le retrait des signatures GPT et PMBR

### 5. Création de la partition GPT

**Attention.** Enregistrer une nouvelle table GPT avec `w` remplace la table existante. Faire cette étape uniquement sur le NVMe du labo dont l’effacement a été validé.

```bash
fdisk /dev/nvme0n1
```

1.  Entrer `g` pour préparer une table GPT.
2.  Entrer `n` pour créer une partition. Accepter les trois valeurs proposées avec Entrée.
3.  Entrer `p` pour vérifier le disque et la partition préparée.
4.  Entrer `w` pour enregistrer quand la vérification est bonne.
5.  Exécuter `lsblk /dev/nvme0n1` et vérifier que `nvme0n1p1` apparaît.

![Capture 3 · Création de la table GPT et de la partition de 953,9 Gio]<img width="1043" height="645" alt="image" src="https://github.com/user-attachments/assets/fd0cb861-aa4c-4b75-a450-451cd3912762" />


Capture 3 · Création de la table GPT et de la partition de 953,9 Gio

### 6. Création du PV, du VG et du pool LVM-Thin

Exécuter les commandes dans l’ordre après avoir confirmé le chemin de la nouvelle partition.

```bash
pvcreate /dev/nvme0n1p1
vgcreate nvme-vg /dev/nvme0n1p1
lvcreate -l 100%FREE -T nvme-vg/data
```

Le PV utilise la partition NVMe. Le VG s’appelle `nvme-vg` et le thin pool s’appelle `data`. La commande de création du pool crée déjà le LV demandé pour ce labo.

![Capture 4 · Création du volume physique, de nvme-vg et du pool data]<img width="1059" height="588" alt="image" src="https://github.com/user-attachments/assets/a6018988-031c-46f4-8eaa-1632ed851ee6" />


Capture 4 · Création du volume physique, de nvme-vg et du pool data

### 7. Ajout du stockage dans Proxmox

```bash
pvesm add lvmthin nvme-storage --vgname nvme-vg --thinpool data --content images,rootdir
```

Le contenu `images` autorise les disques des VM. Le contenu `rootdir` autorise les volumes racines des conteneurs. Sur un cluster, ajouter `--nodes NOM_DU_NŒUD` avec le vrai nom du nœud pour limiter cette configuration au serveur qui porte le NVMe.

### 8. Vérification du stockage

```bash
lsblk
pvs
vgs
lvs -o vg_name,lv_name,segtype,lv_size,data_percent,metadata_percent
pvesm status
```

| **Commande**   | **Élément à vérifier**                                     |
|----------------|------------------------------------------------------------|
| `lsblk`        | La partition NVMe apparaît dans l’arbre.                   |
| `pvs`          | La partition est associée à `nvme-vg`.                     |
| `vgs`          | Le VG `nvme-vg` existe.                                    |
| `lvs`          | `nvme-vg/data` est un `thin-pool`.                         |
| `pvesm status` | `nvme-storage` est de type `lvmthin` avec l’état `active`. |

![Capture 5 · Partition NVMe et volumes du pool LVM-Thin dans lsblk]<img width="754" height="645" alt="image" src="https://github.com/user-attachments/assets/a9033742-fd59-4df5-b63a-9964b20c5330" />


Capture 5 · Partition NVMe et volumes du pool LVM-Thin dans lsblk

![Capture 6 · Vérification de LVM et de nvme-storage actif dans Proxmox]<img width="904" height="645" alt="image" src="https://github.com/user-attachments/assets/d9a13726-5603-4ca2-83c1-85a5c9594c44" />


Capture 6 · Vérification de LVM et de nvme-storage actif dans Proxmox

## Partie B – Travail individuel : déplacement du disque de ma VM 102

### 9. Identification de la VM et du disque

Dans Proxmox, j’ai ouvert **102 (Mohammed) → Hardware** sur le nœud `server1`. Le disque `scsi0` avait une capacité de **32 Gio** et se trouvait sur `local-lvm:vm-102-disk-0`.

![Capture 7 · Disque scsi0 de la VM 102 sur local-lvm avant le transfert]<img width="1059" height="437" alt="image" src="https://github.com/user-attachments/assets/53423949-3577-44fa-b394-1f47d13deae8" />


Capture 7 · Disque scsi0 de la VM 102 sur local-lvm avant le transfert

### 10. Déplacement du disque

J’ai arrêté la VM et sélectionné **Hard Disk (scsi0) → Disk Action → Move Storage**. J’ai choisi `nvme-storage` comme destination en laissant **Delete source** décoché.

Le journal affiche le transfert de **32,0 Gio sur 32,0 Gio (100 %)**, l’ajout du volume source à la configuration sous `unused0` et le résultat `TASK OK`.

![Capture 8 · Journal du déplacement du disque de la VM 102]<img width="1035" height="645" alt="image" src="https://github.com/user-attachments/assets/332591df-7bd3-4642-ba88-f38ccead9085" />


Capture 8 · Journal du déplacement du disque de la VM 102

### 11. Vérification du disque et démarrage de Debian

Dans **Hardware**, la ligne **Hard Disk (scsi0)** indique maintenant `nvme-storage:vm-102-disk-0,iothread=1,size=32G`. L’ancien volume `local-lvm:vm-102-disk-0` apparaît sous **Unused Disk 0**.

![Capture 9 · Disque scsi0 de la VM 102 sur nvme-storage après le transfert]<img width="1059" height="500" alt="image" src="https://github.com/user-attachments/assets/93fb5cc8-f31e-4e50-961b-ed17291cf224" />


Capture 9 · Disque scsi0 de la VM 102 sur nvme-storage après le transfert

Après avoir redémarré la VM, j’ai ouvert un terminal dans Debian et lancé les commandes suivantes.

```bash
hostname
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
```

Le nom d’hôte retourné est `mohammed`. Debian voit le disque virtuel `sda` de **32 Gio**. La partition `sda1` de **30,3 Gio** utilise `ext4` et est montée sur `/`. La partition `sda5` de **1,7 Gio** sert d’espace d’échange. La configuration de la VM dans Proxmox indique le stockage du disque virtuel.

![Capture 10 · Debian démarré et partition système montée sur /]<img width="995" height="645" alt="image" src="https://github.com/user-attachments/assets/64bc1808-8342-40d0-b21b-275abd5c7220" />


Capture 10 · Debian démarré et partition système montée sur /

### 12. Bilan des résultats

| **Résultat attendu**                                   | **Preuve**                                                                                             |
|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| Identifier le disque NVMe physique et le pool LVM-Thin | Les captures du groupe montrent le NVMe de 953,9 Gio, le VG `nvme-vg` et le pool `data` de 953,63 Gio. |
| Stockage NVMe actif                                    | `pvesm status` affiche `nvme-storage` avec le type `lvmthin` et l’état `active`.                       |
| Identifier la VM et le disque                          | VM 102 (Mohammed), `scsi0`, 32 Gio.                                                                    |
| Déplacer le disque                                     | Journal à 100 % et `TASK OK`.                                                                          |
| Vérifier le stockage du disque actif                   | `scsi0` pointe vers `nvme-storage:vm-102-disk-0` dans **Hardware**.                                    |
| Vérifier que la VM fonctionne                          | Debian a démarré et `sda1` est montée sur `/`.                                                         |

## 13. Questions de réflexion

1.  **Quelle est la différence entre un HDD, un SSD SATA et un SSD NVMe ?**  
```bash
Un HDD utilise des plateaux mécaniques. Les SSD utilisent de la mémoire flash. Un SSD SATA communique par l’interface SATA, tandis qu’un SSD NVMe utilise le protocole NVMe sur PCI Express. Le NVMe offre généralement une latence plus faible et un débit plus élevé.
```

2.  **Quel est le rôle d’une partition ?**  
```bash
Elle délimite une partie du disque pour un usage précis. Dans le labo, la partition du NVMe sert de PV pour LVM.
```

3.  **À quoi sert un système de fichiers ?**  
```bash
Il organise les fichiers, les dossiers et leurs métadonnées afin que le système puisse les retrouver et les gérer.
```

4.  **Que signifient PV, VG et LV ?**  
```bash
PV signifie *Physical Volume*, VG signifie *Volume Group* et LV signifie *Logical Volume*.
```

5.  **Pourquoi Proxmox utilise-t-il souvent LVM-Thin ?**  
```bash
LVM-Thin alloue les blocs physiques au fil des écritures et facilite les instantanés et les clones. Les colonnes `Data%` et `Meta%` de `lvs` permettent de surveiller l’occupation du pool.
```

6.  **Quelle commande affiche les stockages configurés dans Proxmox ?**  
```bash
`pvesm status` affiche notamment le nom, le type, l’état et l’occupation de chaque stockage.
```

7.  **Quel est l’avantage d’un NVMe pour les VM ?**  
```bash
Un NVMe peut réduire la latence des lectures et des écritures et traiter davantage d’opérations simultanées lorsque plusieurs VM utilisent le stockage.
```

## 14. Conclusion

En groupe, nous avons préparé le NVMe de 953,9 Gio et activé `nvme-storage` dans Proxmox.

J’ai déplacé le disque de 32 Gio de la VM 102 (Mohammed) de `local-lvm` vers `nvme-storage`. Le journal confirme la réussite du transfert, la configuration de Proxmox indique le nouveau stockage et Debian démarre avec sa partition système montée sur `/`.

## Références

- [Guide d’administration de Proxmox VE](https://pve.proxmox.com/pve-docs/pve-admin-guide.pdf)
- [Référence de la commande qm](https://pve.proxmox.com/pve-docs/qm.1.html)
