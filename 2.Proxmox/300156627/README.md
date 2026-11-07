        
##### Nom  :  ROUGAIYATOU DIALLO  
                
##### COURS : INF1085  
                
##### DATE : 14/10/2026


## # Rapport de Laboratoire : Installation de Proxmox VE 9 sur HP ProLiant DL360 G6

#### Étape 1 : Inspection du Matériel et Démarrage du Serveur
 
### Avant toute installation, nous avons préparé le serveur HP ProLiant DL360 G6 et accédé aux baies de disques et à la gestion iLO3.

# Rapport de laboratoire : Installation de Proxmox VE 9 sur HP ProLiant DL360 G7


## 1. Objectif

L’objectif de ce laboratoire est d’installer Proxmox VE 9 sur un serveur HP ProLiant DL360 G7, de résoudre les problèmes de compatibilité liés à l’ancien matériel et de vérifier la détection des processeurs et des autres ressources matérielles.

<img width="1600" height="900" alt="WhatsApp Image 2026-09-24 at 9 26 28 AM (7)" src="https://github.com/user-attachments/assets/e2afbc87-1ad8-48e5-9dd4-e968c5213e71" />


## 2. Matériel et logiciels

- Serveur HP ProLiant DL360 G7.
- Deux processeurs Intel Xeon E5540 et 64 Go de RAM, selon la configuration disponible.
- Clé USB d’au moins 8 Go.
- Image ISO de Proxmox VE 9 et logiciel Rufus.

  <img width="2048" height="1536" alt="WhatsApp Image 2026-10-07 at 12 17 09 PM (1)" src="https://github.com/user-attachments/assets/978f2eb5-f1dd-4c34-8465-959364120b2c" />


## 3. Étapes de l’installation

**Étape 1 : Préparation de la clé USB**

Télécharger l’image ISO de Proxmox VE 9 et créer une clé USB amorçable avec Rufus.

<img width="1536" height="1146" alt="WhatsApp Image 2026-10-07 at 12 17 11 PM (7)" src="https://github.com/user-attachments/assets/790b2b95-6282-4a64-84de-337b1b4dc7b1" />


**Étape 2 : Démarrage du serveur**

Brancher la clé USB, démarrer le serveur et appuyer sur F11 pour sélectionner le périphérique de démarrage.

<img width="1536" height="1059" alt="WhatsApp Image 2026-10-07 at 1 16 39 PM" src="https://github.com/user-attachments/assets/7b831330-aaa6-4884-9d46-5ca57aa20326" />


**Étape 3 : Paramètres de démarrage**

Si nécessaire, modifier la ligne de démarrage du noyau et ajouter `nomodeset` pour contourner certains problèmes d’affichage. Le paramètre `acpi=off` peut également être testé si le démarrage présente des problèmes liés à l’ACPI.

<img width="1872" height="1066" alt="WhatsApp Image 2026-10-07 at 1 16 37 PM (3)" src="https://github.com/user-attachments/assets/3085f9ba-5c1c-4ba5-8a71-44bbc64bb0c4" />


**Étape 4 : Installation**

Choisir le disque système, définir le mot de passe `root`, configurer le réseau et terminer l’installation.

<img width="2048" height="1237" alt="WhatsApp Image 2026-10-07 at 1 16 36 PM" src="https://github.com/user-attachments/assets/4397e2c0-0b7b-472e-b3c6-aa99fc350e9a" />



**Étape 5 : Vérification**

Après le redémarrage, exécuter les commandes suivantes :

```bash<img width="2048" height="1536" alt="WhatsApp Image 2026-10-07 at 12 17 10 PM (4)" src="https://github.com/user-attachments/assets/5320c3a1-4568-4b75-b30c-c90c5ebbb9c4" />
nproc
lsblk
ip a
```

<img width="1566" height="893" alt="WhatsApp Image 2026-10-07 at 1 16 30 PM (1)" src="https://github.com/user-attachments/assets/83fa8683-54e6-4995-811f-a1962e63345b" />


Ces commandes permettent de vérifier les paramètres de démarrage, les processeurs, les disques et les interfaces réseau.

## 4. Concepts importants

- **ACPI :** permet notamment la configuration du matériel et la gestion de l’énergie.
- **APIC :** gère la distribution des interruptions matérielles.
- **LAPIC :** gère les interruptions locales des processeurs.
- **SMP :** permet l’utilisation simultanée de plusieurs processeurs ou cœurs.
- **nomodeset :** évite l’initialisation du mode graphique avancé par le noyau Linux.

### Connexion réseau
Une fois l'installation terminée, le serveur a redémarré. Il utilise l'adresse IP 10.7.236.239.
L'interface Web de Proxmox est accessible depuis un navigateur à l'adresse :

<img width="2048" height="1536" alt="WhatsApp Image 2026-10-07 at 12 17 10 PM (4)" src="https://github.com/user-attachments/assets/5301d04a-47cc-4d64-acad-c1c68b139d8b" />



## 5. Résultats attendus

Avec deux Xeon E5540, le serveur devrait pouvoir présenter :

- 2 sockets ;
- 8 cœurs physiques ;
- jusqu’à 16 processeurs logiques si l’Hyper-Threading est activé ;
- la mémoire, les disques et les interfaces réseau correctement détectés.

Les résultats réels doivent être vérifiés sur le serveur.

## Vérification et Résultats des Tests Matériels 
Après l'installation et le redémarrage du serveur HP ProLiant DL360 G7, nous avons procédé à la validation matérielle directement dans la console locale de Proxmox VE. La séquence de commandes suivante a été exécutée pour valider la détection et la configuration des ressources :

Vérification du noyau (cat /proc/cmdline) : Pour confirmer les paramètres de démarrage appliqués.

Configuration des processeurs (lscpu et nproc) : Pour valider la détection des sockets, des cœurs physiques, de l'Hyper-Threading (16 CPUs totaux) et du support VT-x.

Stockage (lsblk) : Pour confirmer l'arborescence des disques et la configuration LVM par défaut.

Réseau (ip a) : Pour vérifier l'état des interfaces physiques et du pont virtuel vmbr0.

Validation de la séquence de tests matériels :

<img width="1302" height="657" alt="12345" src="https://github.com/user-attachments/assets/f5021bad-8ba2-409c-ab57-5d3f8f1690a6" />


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

