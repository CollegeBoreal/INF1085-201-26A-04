# Introduction au stockage sous Linux et Proxmox VE

**Étudiant** — Mohammed Mati  
**Numéro étudiant** — 300158185  
**Cours** — INF1085 – Administration Linux  
**Vérifications individuelles** — 25 novembre 2026

## 1. Introduction et objectifs

Ce laboratoire porte sur la gestion du stockage sous Linux et Proxmox VE. La partie en groupe décrit la préparation d’un NVMe avec LVM-Thin. Pour la partie individuelle, j’ai déplacé le disque de la VM 102 (Mohammed) vers `nvme-storage` et vérifié le démarrage de Debian après le transfert.

## 2. Notions de base

| Élément | Rôle |
| --- | --- |
| Partition | Zone délimitée d’un disque qui peut accueillir un système de fichiers ou un PV LVM. |
| Système de fichiers | Organise les fichiers et les dossiers. Ext4 et XFS en sont des exemples. |
| PV — Physical Volume | Disque ou partition initialisé pour LVM. |
| VG — Volume Group | Groupe qui rassemble l’espace d’un ou plusieurs PV. |
| LV — Logical Volume | Volume logique créé à partir de l’espace d’un VG. |
| Pool LVM-Thin | Volume logique qui fournit de l’espace aux disques virtuels au fur et à mesure des écritures. |

Dans ce labo, l’ordre est **NVMe → partition → PV → VG → thin pool → disques virtuels**. Le pool fournit du stockage bloc à Proxmox. Debian peut avoir son propre système de fichiers, comme ext4, à l’intérieur de son disque virtuel.

| Stockage Proxmox | Type habituel dans ce labo | Contenu |
| --- | --- | --- |
| `local` | Directory | Images ISO, sauvegardes et modèles de conteneurs. |
| `local-lvm` | LVM-Thin | Disques virtuels et volumes racines de conteneurs. |
| `nvme-storage` | LVM-Thin | Disques virtuels et volumes racines de conteneurs sur le NVMe. |

## Partie A – Travail en groupe : préparation du stockage NVMe

Le stockage `nvme-storage` était déjà visible sur le nœud `server1` de Proxmox VE 9.2.2. Les sections 3 à 8 décrivent la procédure du labo. Les captures disponibles montrent le stockage dans Proxmox. Les sorties du groupe restent nécessaires pour confirmer le modèle et la taille du disque physique, le partitionnement et la configuration du pool LVM-Thin.

### 3. Identification des disques

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
fdisk -l
pvs
pvesm status
```

Sur l’hôte, `lsblk` permet de repérer le disque système à partir du point de montage `/` et d’identifier le NVMe grâce à son modèle et à sa capacité.

Les chemins `/dev/nvme0n1` et `/dev/nvme0n1p1` sont des exemples. Les remplacer si le NVMe porte un autre nom.


### 4. Vérification des signatures existantes

Sur le NVMe identifié, afficher les signatures détectées avec cette commande de lecture.

```bash
wipefs --no-act /dev/nvme0n1
```

Si le professeur demande un nettoyage préalable, confirmer avec le groupe que le NVMe est dédié au laboratoire, que ses données peuvent être effacées et qu’il ne sert ni au système ni à un stockage existant. Dans ce cas seulement, `wipefs -a /dev/nvme0n1` retire les signatures détectées sur le disque. Cette commande est facultative lorsque le disque est prêt à être partitionné.


### 5. Création de la partition GPT

**Attention.** Enregistrer une nouvelle table GPT avec `w` remplace la table existante. Faire cette étape uniquement sur le NVMe du labo dont l’effacement a été validé.

```bash
fdisk /dev/nvme0n1
```

1. Entrer `g` pour préparer une table GPT.
2. Entrer `n` pour créer une partition. Accepter les trois valeurs proposées avec Entrée.
3. Entrer `p` pour vérifier le disque et la partition préparée.
4. Entrer `w` pour enregistrer quand la vérification est bonne.
5. Exécuter `lsblk /dev/nvme0n1` et vérifier que `nvme0n1p1` apparaît.


### 6. Création du PV, du VG et du pool LVM-Thin

Exécuter les commandes dans l’ordre après avoir confirmé le chemin de la nouvelle partition. Si une commande échoue, vérifier la sortie avant de passer à la suivante.

```bash
pvcreate /dev/nvme0n1p1
vgcreate nvme-vg /dev/nvme0n1p1
lvcreate -l 100%FREE -T nvme-vg/data
```

Le PV utilise la partition NVMe. Le VG s’appelle `nvme-vg` et le thin pool s’appelle `data`. La commande de création du pool crée déjà le LV demandé pour ce labo.

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

| Commande | Élément à vérifier |
| --- | --- |
| `lsblk` | La partition NVMe apparaît dans l’arbre. |
| `pvs` | La partition est associée à `nvme-vg`. |
| `vgs` | Le VG `nvme-vg` existe. |
| `lvs` | `nvme-vg/data` est un `thin-pool`. |
| `pvesm status` | `nvme-storage` est de type `lvmthin` et son état est `active`. |

Dans le Shell de `server1`, mon compte a reçu le message `pvesm: command not found`.

![Figure 1 – Première tentative de vérification avec pvesm](images/01-shell-pvesm.png)

La tentative avec `sudo` a aussi échoué. J’ai repéré le stockage `nvme-storage` et la VM 102 dans le panneau de gauche de Proxmox, puis poursuivi dans l’interface Web.

![Figure 2 – Stockage nvme-storage et VM 102 dans Proxmox](images/02-stockage-nvme-et-vm-102.png)

## Partie B – Travail individuel : déplacement du disque de ma VM 102

### 9. Identification de la VM et du disque

Dans Proxmox, j’ai ouvert **102 (Mohammed) → Hardware** sur le nœud `server1`. Le disque `scsi0` avait une capacité de **32 Gio** et se trouvait sur `local-lvm:vm-102-disk-0`.

![Figure 3 – Disque scsi0 de la VM 102 sur local-lvm avant le transfert](images/03-disque-avant-transfert.png)

### 10. Déplacement du disque

J’ai ouvert la fenêtre d’édition du disque pour vérifier le volume source affiché.

![Figure 4 – Fenêtre d’édition du disque scsi0 sur local-lvm](images/04-fenetre-edition-scsi0.png)

J’ai arrêté la VM et sélectionné **Hard Disk (scsi0) → Disk Action → Move Storage**. J’ai choisi `nvme-storage` comme destination en laissant **Delete source** décoché.

Le journal affiche le transfert de **32,0 Gio sur 32,0 Gio (100 %)**, l’ajout du volume source à la configuration sous `unused0` et le résultat **`TASK OK`**.

![Figure 5 – Journal du déplacement du disque de la VM 102](images/05-transfert-task-ok.png)

### 11. Vérification du disque et démarrage de Debian

Dans **Hardware**, la ligne **Hard Disk (scsi0)** indique maintenant `nvme-storage:vm-102-disk-0,iothread=1,size=32G`. L’ancien volume `local-lvm:vm-102-disk-0` apparaît sous **Unused Disk 0**.

![Figure 6 – Disque scsi0 de la VM 102 sur nvme-storage après le transfert](images/06-disque-sur-nvme.png)

Après avoir redémarré la VM, j’ai ouvert un terminal dans Debian. La commande `hostname` a retourné `mohammed`. La première saisie de `lsblk` contenait une virgule en trop.

![Figure 7 – Terminal Debian et première vérification du nom d’hôte](images/07-debian-demarre.png)

J’ai corrigé la commande pour afficher le nom, la taille, le système de fichiers et le point de montage de chaque périphérique.

```bash
hostname
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
```

Debian voit le disque virtuel `sda` de **32 Gio**. La partition `sda1` de **30,3 Gio** utilise `ext4` et est montée sur `/`. La partition `sda5` de **1,7 Gio** sert d’espace d’échange. La configuration de la VM dans Proxmox indique le stockage du disque virtuel.

![Figure 8 – Debian démarré et partition système montée sur /](images/08-verification-debian-lsblk.png)

### 12. Bilan des résultats

| Résultat attendu | Preuve |
| --- | --- |
| Identifier le disque NVMe physique et le pool LVM-Thin | Sorties `lsblk`, `pvs`, `vgs` et `lvs` du groupe à joindre. |
| Stockage NVMe visible | `nvme-storage (server1)` apparaît dans Proxmox. |
| Identifier la VM et le disque | VM 102 (Mohammed), `scsi0`, 32 Gio. |
| Déplacer le disque | Journal à 100 % et `TASK OK`. |
| Vérifier le stockage du disque actif | `scsi0` pointe vers `nvme-storage:vm-102-disk-0` dans **Hardware**. |
| Vérifier que la VM fonctionne | Debian a démarré et `sda1` est montée sur `/`. |

## 13. Questions de réflexion

1. **Quelle est la différence entre un HDD, un SSD SATA et un SSD NVMe ?**  
   Un HDD utilise des plateaux mécaniques. Les SSD utilisent de la mémoire flash. Un SSD SATA communique par l’interface SATA, tandis qu’un SSD NVMe utilise le protocole NVMe sur PCI Express. Le NVMe offre généralement une latence plus faible et un débit plus élevé.

2. **Quel est le rôle d’une partition ?**  
   Elle délimite une partie du disque pour un usage précis. Dans le labo, la partition du NVMe sert de PV pour LVM.

3. **À quoi sert un système de fichiers ?**  
   Il organise les fichiers, les dossiers et leurs métadonnées afin que le système puisse les retrouver et les gérer.

4. **Que signifient PV, VG et LV ?**  
   PV signifie *Physical Volume*, VG signifie *Volume Group* et LV signifie *Logical Volume*.

5. **Pourquoi Proxmox utilise-t-il souvent LVM-Thin ?**  
   LVM-Thin alloue les blocs physiques au fil des écritures et facilite les instantanés et les clones. Les colonnes `Data%` et `Meta%` de `lvs` permettent de surveiller l’occupation du pool.

6. **Quelle commande affiche les stockages configurés dans Proxmox ?**  
   `pvesm status` affiche notamment le nom, le type, l’état et l’occupation de chaque stockage.

7. **Quel est l’avantage d’un NVMe pour les VM ?**  
   Un NVMe peut réduire la latence des lectures et des écritures et traiter davantage d’opérations simultanées lorsque plusieurs VM utilisent le stockage.

## 14. Conclusion

J’ai déplacé le disque de 32 Gio de la VM 102 (Mohammed) de `local-lvm` vers `nvme-storage`. Le journal confirme la réussite du transfert, la configuration de Proxmox indique le nouveau stockage et Debian démarre avec sa partition système montée sur `/`.

## Annexe – Dépôt du rapport sur GitHub

Lors d’une tentative de création de `.gitkeep` depuis l’interface GitHub, le commit a été refusé avec le message `File could not be edited`.

![Figure 9 – Message de GitHub lors du commit de .gitkeep](images/09-erreur-commit-github.png)

## Références

- [Guide d’administration de Proxmox VE](https://pve.proxmox.com/pve-docs/pve-admin-guide.pdf)
- [Référence de la commande qm](https://pve.proxmox.com/pve-docs/qm.1.html)
