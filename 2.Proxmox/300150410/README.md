# Rapport d'installation et de configuration de Proxmox VE

**Cours :** INF1085 — Linux
**Laboratoire :** Exercice 2 — Proxmox
**Serveur :** HP ProLiant DL360 G7 (server237)
**Version :** Proxmox VE 9.2
**Travail :** Réalisé en groupe

## 1. Présentation du laboratoire

Dans le cadre du cours INF1085, notre groupe a participé à la mise en place d'un serveur physique destiné à accueillir la plateforme de virtualisation Proxmox VE.

L'objectif principal était de préparer le matériel, d'installer Proxmox VE et de configurer les paramètres nécessaires à son fonctionnement.

Un membre de notre groupe s'est chargé de l'installation sur le serveur physique. Les différentes étapes ont été documentées afin de permettre à l'ensemble du groupe de comprendre la procédure.

Nous avons notamment étudié la préparation d'une clé USB d'installation, le démarrage du serveur, la configuration du stockage, les paramètres réseau et l'accès à l'interface d'administration.

## 2. Matériel utilisé

Le matériel utilisé pour ce laboratoire est un serveur HP ProLiant DL360 G7.

Les caractéristiques techniques relevées au démarrage sont les suivantes :

| Élément            | Configuration                         |
| ------------------ | ------------------------------------- |
| Modèle             | HP ProLiant DL360 G7                  |
| BIOS               | ProLiant System BIOS P68 (05/05/2011) |
| Processeurs        | 2 × Intel Xeon E5540 @ 2,53 GHz       |
| Nombre de cœurs    | 8 cœurs au total                      |
| Hyperthreading     | Activé                                |
| Mémoire RAM        | 64 Go (Advanced ECC Support)          |
| Gestion à distance | iLO 3                                 |

### Photos du matériel

![Serveur HP ProLiant DL360 G7](https://github.com/user-attachments/assets/4815ab83-73bd-4b81-9edf-fcfb78822b49)

*Figure 1 : Serveur HP ProLiant DL360 G7 avec la clé USB connectée à l'avant.*

![Démarrage BIOS](https://github.com/user-attachments/assets/4460cfc8-a233-4641-ba7b-acaf47e96766)

*Figure 2 : Démarrage du BIOS du serveur HP ProLiant.*

![Informations BIOS](https://github.com/user-attachments/assets/87ae1915-e328-4354-9521-2aa92ea31d99)

*Figure 3 : Informations matérielles affichées dans le BIOS.*

## 3. Démarrage depuis la clé USB

Pour commencer l'installation, une clé USB contenant l'image ISO de Proxmox VE a été préparée.

La clé a ensuite été branchée sur le port USB situé à l'avant du serveur.

Au démarrage, nous avons accédé au menu du BIOS afin de sélectionner l'option **One Time Boot to USB DriveKey**.

Cette option permet de démarrer temporairement sur la clé USB sans modifier l'ordre de démarrage permanent.

![Menu Boot Override](https://github.com/user-attachments/assets/d2b5cc8c-a65d-4562-b9bf-d64c23c03230)

*Figure 4 : Sélection du démarrage sur la clé USB.*

## 4. Menu de démarrage de Proxmox

Après le démarrage sur la clé USB, le menu d'installation de Proxmox VE 9.2 s'est affiché.

Nous avons choisi l'option **Install Proxmox VE (Graphical)** afin d'utiliser l'installateur graphique.

![Menu Proxmox](https://github.com/user-attachments/assets/bf8c226c-ea1f-4852-bd28-4f53afc74e72)

*Figure 5 : Menu principal d'installation de Proxmox VE.*

Afin d'éviter certains problèmes d'affichage liés à l'ancien matériel, nous avons modifié les paramètres de démarrage.

La touche **e** permet de modifier temporairement l'entrée GRUB.

Nous avons ajouté le paramètre suivant :

`nomodeset`

Ce paramètre désactive le réglage automatique du mode graphique par le noyau Linux.

Le démarrage a ensuite été poursuivi avec **Ctrl+X**.

![Modification GRUB](https://github.com/user-attachments/assets/0d45f4e6-7d6d-4464-93f5-7ef214d3b09f)

*Figure 6 : Modification des paramètres GRUB avec nomodeset.*

![Chargement Proxmox](https://github.com/user-attachments/assets/3ad1168a-a5cc-436b-9c4a-6ee46422dcc0)

*Figure 7 : Chargement de l'installateur Proxmox VE.*

## 5. Chargement de l'installateur

Pendant cette étape, le système a recherché le support contenant les fichiers d'installation.

Le lecteur `/dev/sr0` a d'abord été vérifié.

L'image ISO de Proxmox a ensuite été détectée sur le périphérique `/dev/sdb`, correspondant à la clé USB.

Le système a également procédé à la détection des interfaces réseau.

La présence du message **DHCPOFFERS received** indique que des réponses DHCP ont été reçues pendant le démarrage.

Ces vérifications ont permis de poursuivre le chargement de l'installateur.

## 6. Acceptation du contrat de licence

Une fois l'installateur graphique chargé, le contrat de licence de Proxmox VE s'est affiché.

Nous avons pris connaissance des conditions et sélectionné **I agree** afin de continuer.

![Licence Proxmox](https://github.com/user-attachments/assets/440ecb65-0870-4dd5-9782-7d84d26d58b2)

*Figure 8 : Acceptation du contrat de licence Proxmox VE.*

## 7. Sélection du disque d'installation

L'installateur a proposé par défaut le disque suivant :

`/dev/nvme0n1`

Ce disque possède une capacité de 953,87 GiB et correspond au modèle SK hynix PC811 de 1024 Go.

Pour notre installation, le disque sélectionné était :

`/dev/sda`

Sa capacité est de 273,40 GiB.

Il s'agit d'un volume logique détecté par l'installateur.

Nous avons sélectionné ce disque dans le menu **Target Harddisk**.

Il est important de vérifier le disque choisi, car l'installation efface les partitions et les données présentes sur le disque cible.

![Choix disque Proxmox](https://github.com/user-attachments/assets/7858d57f-d3b0-48b9-a69c-532da9ccfed1)

*Figure 9 : Sélection du disque d'installation.*

![Configuration installation](https://github.com/user-attachments/assets/19f61c65-725e-483d-a4b9-5d0bfacb537b)

*Figure 10 : Écran supplémentaire de configuration de l'installation.*

## 8. Configuration du compte administrateur

L'installateur demande ensuite de configurer le compte administrateur principal.

Ce compte porte le nom :

`root`

Nous avons défini un mot de passe administrateur ainsi qu'une adresse courriel destinée aux notifications du serveur.

Le compte root possède les privilèges nécessaires pour administrer Proxmox VE.

Pour des raisons de sécurité, les informations confidentielles ne sont pas affichées dans notre rapport.

![Configuration root](https://github.com/user-attachments/assets/df5dd717-10a5-4f1d-a20c-f0f95a11444c)

*Figure 11 : Configuration du compte root et de l'adresse courriel.*

## 9. Configuration du réseau

La configuration réseau constitue une étape importante de l'installation.

Elle permet d'accéder au serveur depuis un autre ordinateur connecté au réseau du laboratoire.

Les paramètres configurés sont les suivants :

| Paramètre            | Valeur                  |
| -------------------- | ----------------------- |
| Interface de gestion | nic0                    |
| Adresse MAC          | 3c:d9:2b:ec:fb:a4       |
| Pilote réseau        | bnx2                    |
| Nom d'hôte (FQDN)    | server237.labinfo.local |
| Adresse IP           | 10.7.236.237/23         |
| Passerelle           | 10.7.237.1              |
| Serveur DNS          | 8.8.8.8                 |

Nous avons également conservé l'option **Pin network interface names**.

Cette option permet de stabiliser les noms des interfaces réseau après les redémarrages.

![Configuration réseau](https://github.com/user-attachments/assets/d54a3a5c-8375-4ff3-a8ca-fa457a38cd15)

*Figure 12 : Configuration de l'interface réseau du serveur.*

## 10. Vérification des paramètres avant l'installation

Avant de lancer l'installation, un résumé des paramètres sélectionnés a été affiché.

Nous avons vérifié les informations suivantes :

| Paramètre             | Valeur          |
| --------------------- | --------------- |
| Système de fichiers   | ext4            |
| Disque d'installation | /dev/sda        |
| Pays                  | Canada          |
| Fuseau horaire        | America/Toronto |
| Clavier               | en-us           |
| Interface réseau      | nic0            |
| Nom du serveur        | server237       |
| Adresse IP            | 10.7.236.237/23 |
| Passerelle            | 10.7.237.1      |
| DNS                   | 8.8.8.8         |

L'option **Automatically reboot after successful installation** était activée.

Après vérification, nous avons sélectionné **Install** pour commencer l'installation.

![Résumé installation](https://github.com/user-attachments/assets/d369b635-e012-4be5-9b7d-6b92416abe9d)

*Figure 13 : Résumé des paramètres avant l'installation.*

## 11. Installation du système

L'installation de Proxmox VE s'est déroulée en plusieurs étapes.

Les principales opérations effectuées sont :

1. Création des partitions sur le disque.
2. Création et configuration des volumes logiques LVM.
3. Extraction des paquets nécessaires au système.
4. Configuration des composants du système.
5. Installation du chargeur de démarrage.
6. Préparation du redémarrage.

Pendant cette opération, l'installateur a détecté un ancien groupe de volumes nommé `pve`.

Ce groupe était présent sur le disque `/dev/nvme0n1p3`.

Pour éviter un conflit avec la nouvelle installation, l'installateur a proposé de le renommer :

`pve-OLD-810787F6`

Nous avons accepté cette modification afin de poursuivre l'installation.

![Création partitions](https://github.com/user-attachments/assets/225829a0-37ee-4c0b-9704-c07eab2befae)

*Figure 14 : Création des partitions et préparation du stockage.*

![Extraction paquets](https://github.com/user-attachments/assets/fd6586bb-2220-42e3-a139-6179607cbfc1)

*Figure 15 : Extraction des paquets pendant l'installation.*

## 12. Accès à l'interface Web

Une fois l'installation terminée, le serveur a redémarré.

L'adresse IP configurée pour le serveur est :

`10.7.236.237`

L'interface d'administration Web de Proxmox VE est accessible à l'adresse suivante :

`https://10.7.236.237:8006`

Pour accéder à cette interface, nous utilisons les informations suivantes :

* **Utilisateur :** root
* **Mot de passe :** défini pendant l'installation
* **Realm :** Linux PAM

L'interface Web permet notamment de gérer les machines virtuelles, le stockage, les ressources matérielles et les paramètres réseau.

![Accès Proxmox](https://github.com/user-attachments/assets/62dc6876-3732-40b9-82f1-2072af7a4dc3)

*Figure 16 : Écran du serveur après l'installation de Proxmox VE.*

## 13. Problèmes rencontrés

Pendant le démarrage de l'installateur, certains messages d'erreur sont apparus.

Les principaux messages concernaient les modules suivants :

`shpchp`

`radeonfb`

Le module `shpchp` n'a pas été trouvé et le module `radeonfb` n'a pas pu être chargé.

Ces messages peuvent être liés à la compatibilité entre les pilotes Linux et le matériel du serveur.

Cependant, ils n'ont pas empêché la poursuite de l'installation.

L'utilisation du paramètre `nomodeset` a également permis de contourner les difficultés d'affichage pendant le démarrage.

## 14. Résultat du laboratoire

À la fin de ce laboratoire, notre groupe a réussi à mettre en place Proxmox VE sur le serveur HP ProLiant DL360 G7.

Les principales opérations réalisées sont :

* Préparation du support d'installation.
* Démarrage du serveur à partir de la clé USB.
* Configuration des paramètres d'installation.
* Sélection et préparation du disque.
* Configuration du compte administrateur.
* Configuration de l'adresse IP et du réseau.
* Installation de Proxmox VE.
* Redémarrage du serveur.

Le serveur dispose maintenant de la plateforme Proxmox VE et peut être utilisé pour les prochains exercices de virtualisation.

## 15. Conclusion

Ce laboratoire nous a permis de découvrir les principales étapes de l'installation de Proxmox VE sur un serveur physique.

Nous avons appris comment préparer un support d'installation, configurer le démarrage du serveur, sélectionner un disque, définir les paramètres réseau et installer un environnement de virtualisation.

Le travail réalisé en groupe nous a également permis de mieux comprendre le fonctionnement d'un serveur physique et l'importance de la virtualisation dans l'administration des systèmes informatiques.

Cette installation constitue une première étape pour la création et la gestion des machines virtuelles dans les prochains laboratoires du cours INF1085.

