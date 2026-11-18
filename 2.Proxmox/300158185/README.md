# INF1085 — Administration Linux
## Installation et configuration de Proxmox VE

| Information | Détail |
|---|---|
| Étudiant | Mohammed Mati |
| Numéro d’étudiant | 300158185 |
| Serveur physique du relevé | HP ProLiant DL360 G7 — modèle à confirmer |
| Nœud Proxmox utilisé pour ma VM | server1 |
| Adresse Web observée pour ma VM | https://10.7.236.240:8006/ |
| Version du relevé d’installation | Proxmox VE 9.2 |
| Version visible dans mes captures de VM | Proxmox VE 9.2.2 |

---

> **Identification des environnements :** les captures de ma VM montrent le nœud `server1` à l’adresse `10.7.236.240`. Le relevé d’installation ci-dessous mentionne `server237` et `10.7.236.237`. La correspondance entre ces deux environnements n’est pas établie ; les paramètres du relevé ne sont pas présentés comme ceux de mon serveur actuel.

## 1. Présentation du laboratoire

L’objectif de ce laboratoire était de préparer un serveur physique et d’y installer Proxmox Virtual Environment pour disposer d’une plateforme de virtualisation.

Le travail comprenait la préparation d’une clé USB d’installation, le démarrage du serveur sur cette clé, la sélection du stockage, la configuration du compte administrateur et les paramètres réseau.

Nous avons également adapté les options de démarrage pour permettre le lancement de l’installateur graphique sur le matériel utilisé.

## 2. Matériel et informations relevées

Le relevé d’installation fourni contient les caractéristiques suivantes. Elles restent à vérifier sur les captures matérielles originales :

| Élément | Information relevée |
|---|---|
| Modèle indiqué | HP ProLiant DL360 G7 |
| BIOS | ProLiant System BIOS P68 — 05/05/2011 |
| Processeurs indiqués | 2 × Intel Xeon E5540 à 2,53 GHz |
| Cœurs physiques indiqués | 8 au total |
| Hyperthreading | Activé |
| Mémoire installée | 64 Go |
| Protection mémoire | Advanced ECC Support |
| Gestion à distance indiquée | iLO 3 |

Ces informations sont reprises du relevé du laboratoire. La correspondance entre le modèle, le BIOS et les processeurs reste à confirmer directement sur le serveur.

<p align="center">
  <img src="https://github.com/user-attachments/assets/4815ab83-73bd-4b81-9edf-fcfb78822b49" alt="Serveur avec la clé USB branchée à l’avant" width="800">
</p>

*Figure 1 — Serveur utilisé et clé USB d’installation.*

<p align="center">
  <img src="https://github.com/user-attachments/assets/4460cfc8-a233-4641-ba7b-acaf47e96766" alt="Écran de démarrage HP ProLiant" width="800">
</p>

*Figure 2 — Calibration de l’alimentation et du système thermique au démarrage.*

<p align="center">
  <img src="https://github.com/user-attachments/assets/87ae1915-e328-4354-9521-2aa92ea31d99" alt="Informations matérielles affichées au démarrage" width="800">
</p>

*Figure 3 — Informations sur les processeurs et la mémoire.*

## 3. Démarrage sur la clé USB

La clé USB contenant l’image d’installation a été branchée sur un port USB situé à l’avant du serveur.

Dans les options du BIOS, nous avons sélectionné :

**One Time Boot to USB DriveKey**

Cette option permet de démarrer une seule fois sur la clé USB, sans modifier durablement l’ordre habituel de démarrage.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d2b5cc8c-a65d-4562-b9bf-d64c23c03230" alt="Options de démarrage ponctuel du BIOS" width="800">
</p>

*Figure 4 — Sélection du démarrage ponctuel sur la clé USB.*

## 4. Lancement de l’installateur graphique

Après le démarrage sur la clé USB, le menu d’installation de Proxmox est apparu.

Nous avons sélectionné :

**Install Proxmox VE (Graphical)**

<p align="center">
  <img src="https://github.com/user-attachments/assets/bf8c226c-ea1f-4852-bd28-4f53afc74e72" alt="Menu d’installation de Proxmox VE" width="800">
</p>

*Figure 5 — Menu de démarrage du support d’installation.*

### Adaptation de l’affichage

Avant de lancer l’installation, nous avons appuyé sur **e** pour modifier l’entrée de démarrage et ajouter le paramètre suivant à la ligne du noyau :

    nomodeset

Ce paramètre désactive le changement de mode graphique par le noyau. Il a été utilisé pour contourner les difficultés d’affichage rencontrées pendant le lancement de l’installateur.

Nous avons ensuite poursuivi le démarrage avec **Ctrl+X**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/0d45f4e6-7d6d-4464-93f5-7ef214d3b09f" alt="Modification des paramètres de démarrage" width="800">
</p>

*Figure 6 — Ajout du paramètre nomodeset dans l’entrée de démarrage.*

<p align="center">
  <img src="https://github.com/user-attachments/assets/3ad1168a-a5cc-436b-9c4a-6ee46422dcc0" alt="Chargement de l’installateur Proxmox" width="800">
</p>

*Figure 7 — Chargement de l’installateur Proxmox VE.*

## 5. Détection du support et du réseau

Pendant le chargement, l’installateur a recherché les fichiers d’installation.

D’après les messages relevés :

- le lecteur `/dev/sr0` a d’abord été examiné ;
- le support Proxmox a ensuite été trouvé sur `/dev/sdb` ;
- les interfaces réseau ont été détectées ;
- des offres DHCP ont été reçues.

La réception d’offres DHCP montre qu’une communication avec un serveur DHCP était possible à cette étape. Elle ne confirme pas à elle seule l’accès à Internet ou à l’interface Web finale.

## 6. Acceptation du contrat de licence

L’installateur graphique a affiché le contrat de licence.

Nous avons sélectionné **I agree** pour accepter les conditions et poursuivre.

<p align="center">
  <img src="https://github.com/user-attachments/assets/440ecb65-0870-4dd5-9782-7d84d26d58b2" alt="Contrat de licence de Proxmox VE" width="800">
</p>

*Figure 8 — Acceptation du contrat de licence.*

## 7. Sélection du disque d’installation

L’installateur présentait plusieurs périphériques de stockage.

| Périphérique | Description relevée | Choix |
|---|---|---|
| `/dev/nvme0n1` | SK hynix PC811, environ 953,87 GiB | Non retenu |
| `/dev/sda` | Volume logique, environ 273,40 GiB | Sélectionné pour l’installation |

Nous avons choisi **/dev/sda** dans la liste **Target Harddisk**.

L’installateur indiquait que les partitions et les données présentes sur le disque sélectionné seraient effacées.

<p align="center">
  <img src="https://github.com/user-attachments/assets/7858d57f-d3b0-48b9-a69c-532da9ccfed1" alt="Écran de choix du stockage" width="800">
</p>

*Figure 9 — Présentation des options de stockage.*

<p align="center">
  <img src="https://github.com/user-attachments/assets/19f61c65-725e-483d-a4b9-5d0bfacb537b" alt="Sélection du disque cible" width="800">
</p>

*Figure 10 — Choix du volume logique /dev/sda comme disque d’installation.*

## 8. Configuration du compte administrateur

Nous avons défini le mot de passe du compte **root**, puis renseigné une adresse courriel de contact.

Le compte root permet d’effectuer les opérations d’administration du serveur. L’adresse courriel peut être utilisée pour les notifications, selon la configuration du système de notification.

Le mot de passe n’est pas reproduit dans ce rapport.

<p align="center">
  <img src="https://github.com/user-attachments/assets/df5dd717-10a5-4f1d-a20c-f0f95a11444c" alt="Configuration du compte root et du courriel" width="800">
</p>

*Figure 11 — Définition du mot de passe administrateur et de l’adresse courriel.*

## 9. Paramètres réseau du relevé d’installation à confirmer

Le relevé fourni mentionne les paramètres suivants pour `server237`. Ils ne sont pas confirmés par les captures de ma VM sur `server1` :

| Paramètre | Valeur |
|---|---|
| Interface de gestion | nic0 |
| Adresse MAC | 3c:d9:2b:ec:fb:a4 |
| Pilote indiqué | bnx2 |
| Nom d’hôte complet | server240.labinfo.local |
| Adresse IPv4 | 10.7.236.240/23 |
| Masque correspondant | 255.255.254.0 |
| Passerelle | 10.7.236.1 |
| Serveur DNS | 8.8.8.8 |

Le relevé indique que l’option **Pin network interface names** a été cochée pour stabiliser les noms des interfaces réseau.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d54a3a5c-8375-4ff3-a8ca-fa457a38cd15" alt="Paramètres réseau du serveur" width="800">
</p>

*Figure 12 — Configuration du réseau de gestion.*

## 10. Vérification du résumé

Le résumé du relevé d’installation reprend les paramètres ci-dessous. L’identité du serveur physique reste à confirmer avant de les considérer comme ma configuration d’installation.

| Option | Valeur retenue |
|---|---|
| Système de fichiers | ext4 |
| Disque cible | `/dev/sda` |
| Pays | Canada |
| Fuseau horaire | America/Toronto |
| Clavier | en-us |
| Interface de gestion | nic0 |
| Nom court du serveur | server237 |
| Adresse IP | 10.7.236.240/23 |
| Passerelle | 10.7.240.1 |
| DNS | 8.8.8.8 |

L’option **Automatically reboot after successful installation** était activée.

Après vérification, nous avons cliqué sur **Install**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d369b635-e012-4be5-9b7d-6b92416abe9d" alt="Résumé des paramètres d’installation" width="800">
</p>

*Figure 13 — Vérification finale avant l’installation.*

## 11. Déroulement de l’installation

L’installateur a effectué les principales opérations suivantes :

1. Création des partitions.
2. Création des volumes logiques LVM.
3. Extraction des paquets du système.
4. Application des paramètres de configuration.
5. Installation du chargeur de démarrage.
6. Redémarrage du serveur après l’installation.

<p align="center">
  <img src="https://github.com/user-attachments/assets/225829a0-37ee-4c0b-9704-c07eab2befae" alt="Création des partitions pendant l’installation" width="800">
</p>

*Figure 14 — Préparation du stockage par l’installateur.*

### Gestion d’un ancien groupe de volumes

Pendant l’installation, un groupe de volumes nommé **pve** a été détecté sur `/dev/nvme0n1p3`.

L’installateur a proposé de renommer cet ancien groupe en :

    pve-OLD-810787F6

Nous avons accepté cette proposition avec **OK** pour poursuivre l’installation et éviter un conflit de noms avec le nouveau groupe de volumes.

Cette opération de renommage ne constitue pas une validation de l’état des données de l’ancienne installation.

<p align="center">
  <img src="https://github.com/user-attachments/assets/fd6586bb-2220-42e3-a139-6179607cbfc1" alt="Extraction des paquets du système" width="800">
</p>

*Figure 15 — Extraction des paquets pendant l’installation.*

## 12. Démarrage et environnement personnel vérifié

Le relevé d’installation prévoit l’accès à `https://10.7.236.237:8006/` pour `server237`. Cette adresse reste à confirmer pour cette installation physique.

<p align="center">
  <img src="https://github.com/user-attachments/assets/62dc6876-3732-40b9-82f1-2072af7a4dc3" alt="Écran de fin d’installation du relevé source à vérifier" width="800">
</p>

*Figure 16 — Écran de fin d’installation joint au relevé source.*

Mes captures de travail sur Debian confirment séparément l’environnement suivant :

| Élément | Valeur observée le 4 novembre 2026 |
|---|---|
| Étudiant | Mohammed Mati |
| Numéro étudiant | 300158185 |
| Nœud Proxmox | server1 |
| Interface Web | https://10.7.236.240:8006/ |
| Version Proxmox visible | 9.2.2 |
| Compte Proxmox visible | root@pam |
| VM | 102 — Mohammed |
| Ressources | 1 vCPU, 2 Gio RAM, disque 32 Gio |
| Système invité | Debian 13 avec GNOME |
| Nom de la machine Debian | mohammed |
| Compte Debian | mohammed18 |
| Interface Debian | ens18, UP |
| Adresse IPv4 Debian | 10.7.236.185/23 |

L’adresse `10.7.236.240` est celle de l’hyperviseur utilisé dans ces captures. L’adresse `10.7.236.185` est celle de la VM Debian. Ces valeurs observées doivent être revérifiées avant une nouvelle connexion.

Le compte `root@pam` utilise l’authentification Linux PAM. Les captures ne démontrent pas la création ni les permissions d’un compte personnel `B300158185@pam`.

### Accès SSH à la VM

La commande à utiliser depuis Windows, après confirmation de l’adresse actuelle et du fonctionnement du service SSH, est :

```powershell
ssh mohammed18@10.7.236.185
```

Le test d’activation de SSH avec `sudo` a été refusé parce que `mohammed18` ne disposait pas des droits sudo. Les captures disponibles ne prouvent pas encore une connexion SSH réussie ou l’ajout de la clé du professeur.

## 13. Messages observés pendant le chargement

Des messages concernant les modules **shpchp** et **radeonfb** ont été relevés pendant le démarrage.

| Module | Message rapporté |
|---|---|
| shpchp | Module introuvable |
| radeonfb | Échec d’insertion : « No such device » |

Dans l’essai réalisé, ces messages n’ont pas empêché l’installateur graphique de poursuivre son exécution.

Leur cause exacte n’a pas été établie pendant le laboratoire. Ils ne permettent donc pas, à eux seuls, de conclure à une panne matérielle.

## 14. Bilan du laboratoire

| Étape | Résultat rapporté |
|---|---|
| Préparation de la clé USB | Réalisée |
| Démarrage sur la clé | Réussi |
| Modification des paramètres de démarrage | Paramètre nomodeset ajouté |
| Lancement de l’installateur graphique | Réussi |
| Choix du stockage | `/dev/sda` sélectionné |
| Configuration du compte root | Réalisée |
| Réseau du serveur physique | Valeurs du relevé à confirmer |
| Environnement utilisé pour la VM | server1, 10.7.236.240:8006 |
| Réseau Debian observé | ens18 UP, 10.7.236.240/23 |
| Gestion de l’ancien groupe LVM | Renommage accepté |
| Installation du système | Terminée selon le déroulement rapporté |
| Redémarrage | Effectué |
| Accès Web observé dans mes captures | Interface Proxmox de server1 accessible |
| Correspondance avec server240 | À confirmer |

## 15. Compétences développées

Ce laboratoire nous a permis de :

- Utiliser les options de démarrage d’un serveur.
- Démarrer sur un support USB d’installation.
- Modifier temporairement les paramètres du noyau.
- Identifier et sélectionner un disque cible.
- Configurer un compte administrateur.
- Définir une adresse IP, une passerelle et un serveur DNS.
- Comprendre le rôle des volumes logiques LVM.
- Documenter une installation avec des captures et des tableaux.

## 16. Conclusion

Le relevé décrit la préparation d’un serveur physique, le démarrage sur une clé USB et les principales étapes d’installation de Proxmox VE. L’identité du matériel et les paramètres associés à `server237` doivent encore être confirmés.

Mes captures de travail confirment l’accès à Proxmox sur `server1` à l’adresse `10.7.236.240:8006`, ainsi que l’utilisation de la VM Debian 102. Le compte Debian est `mohammed18`, le nom de machine est `mohammed` et l’adresse IPv4 observée est `10.7.236.185/23`.

La suite consiste à vérifier les droits d’administration du compte Debian, le service SSH et les accès par clé publique.

## Note sur les illustrations

Les 16 liens d’images du fichier fourni sont conservés. Leur contenu n’a pas pu être revérifié lors de cette correction ; ils doivent être contrôlés avant la remise, particulièrement pour le matériel, les disques et la configuration réseau de l’installation physique.
