# Stockage NVMe et déplacement du disque d’une VM

## Inventaire

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL
pvs
vgs
lvs -o lv_name,vg_name,lv_size,data_percent,metadata_percent
pvesm status
```

Si le stockage est déjà présent, passer à la migration. Sur un NVMe vide attribué au labo, créer une partition GPT, l’initialiser comme PV, l’ajouter à un VG et créer un thin pool `data`. Enregistrer ce pool comme stockage Proxmox `nvme-storage` de type LVM-Thin. La création d’une table GPT remplace la table de partitions existante.

## Déplacement

```bash
qm list
qm config <VMID>
qm move_disk <VMID> scsi0 nvme-storage
qm config <VMID>
pvesm list nvme-storage
qm status <VMID>
```

Confirmer le VMID et l’identifiant du disque dans la configuration avant la migration. Vérifier ensuite que le disque actif pointe vers `nvme-storage` et que la VM redémarre. Conserver le volume source jusqu’à validation.

## Questions de réflexion

1. Le HDD stocke les données sur des plateaux mécaniques. Le SSD SATA utilise de la mémoire flash et une interface SATA. Le NVMe communique via PCIe.
2. Une partition délimite une zone du disque.
3. Un système de fichiers organise les fichiers, répertoires et métadonnées.
4. PV signifie volume physique, VG groupe de volumes et LV volume logique.
5. LVM-Thin alloue l’espace physique selon les blocs réellement écrits.
6. `pvesm status` affiche les stockages Proxmox.
7. Le NVMe réduit la latence des entrées-sorties des VM.

Configuration avant et après, démarrage et captures à confirmer.

[Consignes du groupe du mercredi](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/5.Storage)
