# Création et vérification d’une VM Linux

1. Sur le nœud Proxmox assigné au groupe, sélectionner **Create VM** et prendre un identifiant libre réservé au laboratoire.
2. Sélectionner l’ISO Linux du cours. Configurer le disque, les vCPU, la RAM et le bridge réseau selon les ressources attribuées.
3. Démarrer la VM, installer Linux depuis la console, retirer l’ISO et redémarrer sur le disque virtuel.
4. Vérifier l’OS, le disque, la mémoire et le réseau.

```bash
hostnamectl
lsblk -f
free -h
ip -br address
ip route
```

| Élément | Valeur réelle |
|---|---|
| Nom et identifiant de la VM | À relever |
| Distribution et version | À relever |
| vCPU, RAM et disque | À relever |
| Adresse de la VM | À relever |

Preuves à ajouter dans `images/` et à lier ici. Capturer le matériel de la VM et la vérification dans sa console.
