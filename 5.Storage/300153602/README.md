# Stockage Linux et migration d’un disque de VM

## Questions de réflexion

1. Un HDD utilise des plateaux mécaniques. Un SSD SATA utilise de la mémoire flash via SATA. Un SSD NVMe utilise la mémoire flash avec un protocole adapté à PCIe.
2. Une partition définit une zone du disque qu’on peut gérer séparément.
3. Un système de fichiers organise les dossiers, les fichiers et leurs métadonnées.
4. PV signifie volume physique, VG groupe de volumes et LV volume logique. Un VG rassemble un ou plusieurs PV pour allouer de l’espace aux LV.
5. LVM-Thin alloue l’espace physique au fur et à mesure des écritures et permet les instantanés.
6. `pvesm status` affiche les stockages déclarés dans Proxmox.
7. Un NVMe réduit généralement la latence et augmente le débit lorsque plusieurs VM accèdent au stockage.

## Laboratoire de migration

```bash
lsblk -f
pvs
vgs
lvs
pvesm status
qm list
```

Vérifier que le stockage NVMe est actif et a l’espace requis, puis identifier le disque de sa propre VM avec `qm config VMID`. Remplacer `VMID` et `scsi0` par les valeurs relevées.

```bash
qm move_disk VMID scsi0 nvme-storage
qm config VMID
pvesm list nvme-storage
```

La ligne du disque actif doit pointer vers le stockage NVMe après l’opération. Démarrer la VM ou vérifier qu’elle reste opérationnelle selon les conditions du labo. Ajouter les captures de la configuration avant et après dans `images/`.
