
## 1. À quoi sert le paramètre `nomodeset` ?

Le paramètre `nomodeset` empêche le noyau Linux d'activer le système avancé de gestion graphique appelé *Kernel Mode Setting (KMS)*. Il force ainsi l'utilisation d'un affichage graphique de base. Cette option peut être utile pour éviter les problèmes d'affichage, notamment un écran noir ou un blocage causé par une ancienne carte graphique.

## 2. Pourquoi un ancien BIOS peut-il nécessiter l'option `acpi=off` ?

Un BIOS ancien peut présenter des incompatibilités avec les versions récentes du noyau Linux au niveau de la gestion ACPI. Cela peut entraîner des erreurs matérielles ou empêcher le démarrage normal du système.

L'option `acpi=off` permet de désactiver cette fonctionnalité pour contourner certains problèmes. Cependant, cette désactivation limite également les capacités du système en matière de gestion de l'énergie et de détection du matériel.

## 3. Quelle est la distinction entre ACPI et APIC ?

- **ACPI (Advanced Configuration and Power Interface)** : technologie qui permet au système d'exploitation de communiquer avec le BIOS pour obtenir des informations sur les composants matériels et gérer l'alimentation de l'ordinateur.
- **APIC (Advanced Programmable Interrupt Controller)** : composant matériel chargé de gérer et de distribuer les interruptions entre les processeurs afin de faciliter leur coordination.

## 4. Pourquoi l'option `nolapic` peut-elle limiter le nombre de processeurs détectés ?

Chaque processeur dispose d'un contrôleur d'interruptions local appelé LAPIC (*Local Advanced Programmable Interrupt Controller*). Celui-ci permet notamment de gérer les interruptions et la communication entre les processeurs.

Lorsque le LAPIC est désactivé, Linux peut rencontrer des difficultés pour gérer plusieurs processeurs. Il peut alors désactiver le fonctionnement multiprocesseur et démarrer avec un seul processeur logique.

## 5. Quelle commande permet de consulter les paramètres utilisés lors du démarrage ?

La commande suivante permet d'afficher les paramètres transmis au noyau Linux au moment du démarrage :

```bash
cat /proc/cmdline
```

## Résultat final

- Installation de **Proxmox VE 9.2** sur le serveur `server239` à l'aide d'un SSD NVMe.
- Configuration de la connexion réseau du laboratoire avec l'adresse IP `10.7.236.239/23`.
- Identification et résolution des difficultés rencontrées pendant l'installation.
- Accès au compte `root` depuis la console et vérification de la connectivité avec la passerelle.
- Démarrage réussi de l'interface Web de Proxmox, accessible à l'adresse suivante : `https://10.7.236.239:8006`.
