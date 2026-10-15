        
                **Nom :** Rougaiyatou Diallo  
                **Cours :** INF1085  
                **Date :** 14/10/2026


## # Rapport de Laboratoire : Installation de Proxmox VE 9 sur HP ProLiant DL360 G6

#### Étape 1 : Inspection du Matériel et Démarrage du Serveur
 
### Avant toute installation, nous avons préparé le serveur HP ProLiant DL360 G6 et accédé aux baies de disques et à la gestion iLO3.

# Rapport de laboratoire : Installation de Proxmox VE 9 sur HP ProLiant DL360 G7


## 1. Objectif

L’objectif de ce laboratoire est d’installer Proxmox VE 9 sur un serveur HP ProLiant DL360 G7, de résoudre les problèmes de compatibilité liés à l’ancien matériel et de vérifier la détection des processeurs et des autres ressources matérielles.

## 2. Matériel et logiciels

- Serveur HP ProLiant DL360 G7.
- Deux processeurs Intel Xeon E5540 et 64 Go de RAM, selon la configuration disponible.
- Clé USB d’au moins 8 Go.
- Image ISO de Proxmox VE 9 et logiciel Rufus.

## 3. Étapes de l’installation

**Étape 1 : Préparation de la clé USB**

Télécharger l’image ISO de Proxmox VE 9 et créer une clé USB amorçable avec Rufus.

**Étape 2 : Démarrage du serveur**

Brancher la clé USB, démarrer le serveur et appuyer sur F11 pour sélectionner le périphérique de démarrage.

**Étape 3 : Paramètres de démarrage**

Si nécessaire, modifier la ligne de démarrage du noyau et ajouter `nomodeset` pour contourner certains problèmes d’affichage. Le paramètre `acpi=off` peut également être testé si le démarrage présente des problèmes liés à l’ACPI.

**Étape 4 : Installation**

Choisir le disque système, définir le mot de passe `root`, configurer le réseau et terminer l’installation.

**Étape 5 : Vérification**

Après le redémarrage, exécuter les commandes suivantes :

```bash
cat /proc/cmdline
lscpu
nproc
lsblk
ip a
```

Ces commandes permettent de vérifier les paramètres de démarrage, les processeurs, les disques et les interfaces réseau.

## 4. Concepts importants

- **ACPI :** permet notamment la configuration du matériel et la gestion de l’énergie.
- **APIC :** gère la distribution des interruptions matérielles.
- **LAPIC :** gère les interruptions locales des processeurs.
- **SMP :** permet l’utilisation simultanée de plusieurs processeurs ou cœurs.
- **nomodeset :** évite l’initialisation du mode graphique avancé par le noyau Linux.

## 5. Résultats attendus

Avec deux Xeon E5540, le serveur devrait pouvoir présenter :

- 2 sockets ;
- 8 cœurs physiques ;
- jusqu’à 16 processeurs logiques si l’Hyper-Threading est activé ;
- la mémoire, les disques et les interfaces réseau correctement détectés.

Les résultats réels doivent être vérifiés sur le serveur.

## 6. Questions de réflexion

**1. À quoi sert `nomodeset` ?**

Il empêche l’activation du mode graphique avancé et peut résoudre certains problèmes d’écran noir.

**2. Pourquoi un ancien BIOS peut-il nécessiter `acpi=off` ?**

Des incompatibilités entre les tables ACPI du BIOS et le noyau Linux peuvent provoquer des erreurs de démarrage. Désactiver l’ACPI peut parfois contourner ces erreurs, mais aussi limiter certaines fonctions matérielles.

**3. Quelle est la différence entre ACPI et APIC ?**

ACPI concerne la configuration matérielle et la gestion de l’énergie, tandis qu’APIC gère les interruptions matérielles.

**4. Pourquoi `nolapic` peut-il réduire le nombre de processeurs visibles ?**

Parce que la désactivation du contrôleur d’interruptions local peut perturber le fonctionnement multiprocesseur.

**5. Quelle commande vérifie les paramètres de démarrage utilisés ?**

La commande `cat /proc/cmdline`.

## 7. Conclusion

Ce laboratoire permet de comprendre comment installer Proxmox VE 9 sur un serveur ancien et comment résoudre certains problèmes de compatibilité avec Linux. Les commandes de vérification permettent de contrôler les processeurs, la mémoire, les disques et le réseau. Une fois ces éléments validés, le serveur peut être préparé pour héberger des machines virtuelles destinées aux laboratoires INF1085.

