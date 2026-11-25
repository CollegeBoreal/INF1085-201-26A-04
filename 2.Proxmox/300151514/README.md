# Installation de Proxmox VE 9

## Procédure

Préparer une clé avec l’ISO de Proxmox VE 9. Sur le DL360 G7, ouvrir le menu de démarrage avec F11 et sélectionner la clé. En cas d’écran noir, modifier temporairement la ligne du noyau avec `e`, ajouter `nomodeset` et démarrer avec Ctrl+X ou F10. Sélectionner le disque système prévu et configurer le nom d’hôte et les paramètres réseau attribués au serveur du groupe.

## Vérifications après démarrage

```bash
pveversion
cat /proc/cmdline
lscpu
nproc
cat /sys/devices/system/cpu/online
lsmem
lsblk
lspci
ip -br addr
ip route
```

Avec deux processeurs de quatre cœurs et deux fils par cœur, la configuration attendue compte huit cœurs physiques et seize processeurs logiques. Le résultat réel dépend du matériel détecté et des paramètres actifs.

## Questions de réflexion

1. `nomodeset` empêche l’activation du mode graphique avancé au démarrage.
2. Un ancien BIOS peut transmettre des tables ACPI incompatibles. `acpi=off` sert alors au diagnostic et peut perturber la détection du matériel et la gestion de l’énergie.
3. ACPI fournit des informations de configuration et d’énergie. APIC gère les interruptions.
4. `nolapic` désactive le contrôleur d’interruptions local et peut empêcher le noyau d’activer plusieurs processeurs logiques.
5. `cat /proc/cmdline` affiche les paramètres du noyau réellement chargé.

## Validation sur le serveur

Version, paramètres actifs, inventaire CPU et capture de Proxmox à confirmer.

[Consignes du groupe du mercredi](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/2.Proxmox)
