# Introduction au stockage sous Linux et Proxmox VE

**Étudiant** — Mohammed Mati  
**Numéro étudiant** — [Ton matricule]  
**Cours** — INF1085 – Administration Linux  
**Date du laboratoire** — [À compléter]

## 1. Introduction et objectifs

Ce laboratoire porte sur la gestion du stockage sous Linux et Proxmox VE. En groupe, je dois identifier le disque NVMe, le préparer avec LVM-Thin et l’ajouter à Proxmox. Dans la partie individuelle, je dois déplacer le disque de ma machine virtuelle vers `nvme-storage` et vérifier que la VM démarre après le transfert.

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

Exécuter les commandes dans **Proxmox → ton nœud → Shell**, avec les droits d’administration. Si le groupe a déjà préparé le NVMe, passer à la section 8 pour relever les résultats.

### 3. Identification des disques

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
fdisk -l
pvs
pvesm status
```

| Périphérique | Taille | Observation |
| --- | --- | --- |
| Disque système | [À relever] | [Périphérique et partition ou volume portant `/`] |
| Disque NVMe du labo | [À relever] | [Périphérique, modèle et partitions existantes] |

Les chemins `/dev/nvme0n1` et `/dev/nvme0n1p1` sont des exemples. Les remplacer si le NVMe porte un autre nom.

<!-- Après avoir ajouté la capture, retirer les marques de commentaire autour de la ligne suivante.
![Figure 1 – Identification des disques](images/01-disques-avant.png)
-->

### 4. Vérification des signatures existantes

Sur le NVMe identifié, afficher les signatures détectées avec cette commande de lecture.

```bash
wipefs --no-act /dev/nvme0n1
```

**Observation** — [Indiquer les signatures détectées et si le groupe a dû les retirer.]

Si le professeur demande un nettoyage préalable, confirmer avec le groupe que le NVMe est dédié au laboratoire, que ses données peuvent être effacées et qu’il ne sert ni au système ni à un stockage existant. Dans ce cas seulement, `wipefs -a /dev/nvme0n1` retire les signatures détectées sur le disque. Cette commande est facultative lorsque le disque est prêt à être partitionné.

<!--
![Figure 2 – Vérification des signatures ou état du disque après nettoyage](images/02-signatures-nvme.png)
-->

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

**Résultat relevé** — [Nom de la partition, taille et type de table.]

<!--
![Figure 3 – Création de la table GPT et de la partition](images/03-partition-gpt.png)
-->

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

<!--
![Figure 4 – Création du pool et ajout de nvme-storage](images/04-creation-lvm.png)
-->

### 8. Vérification du stockage

```bash
lsblk
pvs
vgs
lvs -o vg_name,lv_name,segtype,lv_size,data_percent,metadata_percent
pvesm status
```

| Commande | Élément à vérifier | Résultat relevé |
| --- | --- | --- |
| `lsblk` | La partition NVMe apparaît dans l’arbre. | [À compléter] |
| `pvs` | La partition est associée à `nvme-vg`. | [À compléter] |
| `vgs` | Le VG `nvme-vg` existe. | [À compléter] |
| `lvs` | `nvme-vg/data` est un `thin-pool`. | [À compléter] |
| `pvesm status` | `nvme-storage` est de type `lvmthin` avec l’état `active`. | [À compléter] |

<!--
![Figure 5 – Organisation du stockage NVMe dans lsblk](images/05-arbre-lvm.png)
![Figure 6 – Vérification du pool et de nvme-storage](images/06-validation-stockage.png)
-->

## Partie B – Travail individuel : déplacement du disque de ma VM

### 9. Identification de la VM et de son disque

```bash
qm list
qm config 101
```

Dans les commandes de cette partie, **101 et `scsi0` sont des exemples**. Remplacer 101 par l’ID de ma VM et `scsi0` par le nom de son disque système. Relever le champ `boot` et la ligne du disque. La configuration de la VM peut aussi contenir un lecteur ISO.

| Élément | Valeur relevée |
| --- | --- |
| ID et nom de la VM | [À compléter] |
| Disque système, stockage source et taille | [À compléter] |
| Ordre de démarrage | [À compléter] |

<!--
![Figure 7 – Configuration de ma VM avant le transfert](images/07-vm-avant.png)
-->

### 10. Déplacement du disque

Dans ce déroulement, arrêter proprement la VM avant de déplacer son disque. Vérifier que le stockage cible est actif et attendre que la tâche de copie soit terminée.

```bash
qm shutdown 101
qm status 101
```

Lorsque `qm status` affiche `status: stopped`, lancer le transfert.

```bash
qm move_disk 101 scsi0 nvme-storage
```

Par défaut, le volume source est conservé comme disque inutilisé. Il peut apparaître sous un nom comme `unused0`.

**Résultat de la tâche** — [Relever le statut final affiché.]

<!--
![Figure 8 – Résultat du déplacement vers nvme-storage](images/08-transfert.png)
-->

### 11. Vérification du disque et démarrage de la VM

Sur l’hôte Proxmox, vérifier que le disque actif pointe vers `nvme-storage` et que le volume apparaît dans le stockage.

```bash
qm config 101
pvesm list nvme-storage
qm start 101
qm status 101
```

Dans la **console de la VM Debian**, ouvrir une session et exécuter les commandes suivantes.

```bash
hostname
lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINTS
```

Le disque peut s’appeler `sda` dans Debian. C’est la sortie de `qm config` sur l’hôte qui indique où Proxmox stocke ce disque virtuel.

<!--
![Figure 9 – Disque de la VM dans nvme-storage](images/09-stockage-nvme.png)
![Figure 10 – Configuration finale de la VM](images/10-vm-apres.png)
![Figure 11 – Debian après redémarrage](images/11-debian.png)
-->

### 12. Bilan des résultats

| Résultat attendu | Preuve à relever |
| --- | --- |
| NVMe identifié et partition créée | [Périphérique, taille et partition visibles dans `lsblk`.] |
| Stockage NVMe actif | [Ligne `nvme-storage` dans `pvesm status`.] |
| Disque transféré | [Résultat de la tâche et volume dans `pvesm list nvme-storage`.] |
| Configuration mise à jour | [Ligne du disque actif dans `qm config`.] |
| VM opérationnelle | [État de la VM, nom d’hôte et partition montée sur `/` dans Debian.] |

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

[Indiquer le résultat de la partie groupe, le nom et l’ID de ma VM, ainsi que ce que les commandes de contrôle et la console Debian ont confirmé.]

## Références

- [Guide d’administration de Proxmox VE](https://pve.proxmox.com/pve-docs/pve-admin-guide.pdf)
- [Référence de la commande qm](https://pve.proxmox.com/pve-docs/qm.1.html)
