# Création d’une machine virtuelle Ubuntu

## Configuration proposée

| Paramètre | Valeur |
| --- | --- |
| Nom | ubuntu-300151514 |
| Mémoire | 2 Gio |
| Processeur | 1 vCPU |
| Disque | 20 Gio, SCSI |
| Réseau | VirtIO, pont vmbr0 |
| Système | Ubuntu Server |

Sur le serveur Proxmox attribué, choisir un VMID libre et utiliser un stockage disponible. Monter l’ISO Ubuntu Server, créer la VM, installer Ubuntu, puis éjecter l’ISO et démarrer sur le disque. Vérifier la configuration dans Proxmox et relever l’adresse IP depuis la console de la VM. Si le professeur demande un accès de validation, installer sa clé publique officielle sur le compte désigné et tester l’accès.

```bash
# Hôte Proxmox
qm list
qm config <VMID>
qm status <VMID>
# Console Ubuntu
cat /etc/os-release
ip -br addr
ip route
```

## Résultats attendus

La VM démarre sur son disque, Ubuntu répond à la console et l’interface réseau a une adresse dans le réseau du labo. Le VMID, l’adresse et les captures restent à confirmer.

[Consignes du groupe du mercredi](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/3.VMs)
