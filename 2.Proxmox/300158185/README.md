# INF1085 — Administration Linux
## Installation et configuration de Proxmox VE

| Information | Détail |
|---|---|
| Étudiant | Mohammed Mati |
| Numéro d’étudiant | 300158185 |
| Serveur indiqué dans le laboratoire | HP ProLiant DL360 G7 |
| Nom du serveur | server237 |
| Version indiquée dans le relevé | Proxmox VE 9.2 |

---

## 1. Présentation du laboratoire

L’objectif de ce laboratoire était de préparer un serveur physique et d’y installer Proxmox Virtual Environment pour disposer d’une plateforme de virtualisation.

Le travail comprenait la préparation d’une clé USB d’installation, le démarrage du serveur sur cette clé, la sélection du stockage, la configuration du compte administrateur et les paramètres réseau.

Nous avons également adapté les options de démarrage pour permettre le lancement de l’installateur graphique sur le matériel utilisé.

## 2. Matériel et informations relevées

Les caractéristiques suivantes ont été consignées pendant le laboratoire :

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

## 9. Configuration du réseau de gestion

Les paramètres suivants ont été renseignés :

| Paramètre | Valeur |
|---|---|
| Interface de gestion | nic0 |
| Adresse MAC | 3c:d9:2b:ec:fb:a4 |
| Pilote indiqué | bnx2 |
| Nom d’hôte complet | server237.labinfo.local |
| Adresse IPv4 | 10.7.236.237/23 |
| Masque correspondant | 255.255.254.0 |
| Passerelle | 10.7.237.1 |
| Serveur DNS | 8.8.8.8 |

L’option **Pin network interface names** a été cochée pour stabiliser les noms des interfaces réseau.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d54a3a5c-8375-4ff3-a8ca-fa457a38cd15" alt="Paramètres réseau du serveur" width="800">
</p>

*Figure 12 — Configuration du réseau de gestion.*

## 10. Vérification du résumé

Avant de lancer l’installation, nous avons vérifié les paramètres affichés dans le résumé.

| Option | Valeur retenue |
|---|---|
| Système de fichiers | ext4 |
| Disque cible | `/dev/sda` |
| Pays | Canada |
| Fuseau horaire | America/Toronto |
| Clavier | en-us |
| Interface de gestion | nic0 |
| Nom court du serveur | server237 |
| Adresse IP | 10.7.236.237/23 |
| Passerelle | 10.7.237.1 |
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

## 12. Démarrage et administration à distance

Après l’installation, le serveur a redémarré avec l’adresse configurée :

**10.7.236.237**

L’adresse prévue pour l’administration Web est :

**https://10.7.236.237:8006/**

<p align="center">
  <img src="https://github.com/user-attachments/assets/62dc6876-3732-40b9-82f1-2072af7a4dc3" alt="Écran du serveur après l’installation" width="800">
</p>

*Figure 16 — Écran obtenu après l’installation et le redémarrage.*

Pour se connecter à l’interface Web, les paramètres sont :

| Champ | Valeur |
|---|---|
| Utilisateur | root |
| Mot de passe | Celui défini pendant l’installation |
| Domaine d’authentification | Linux PAM standard authentication |

L’affichage de l’adresse de gestion ne suffit pas à confirmer l’accès depuis un autre ordinateur. Une connexion réussie dans le navigateur permet de compléter cette vérification.

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
| Configuration réseau | Paramètres renseignés |
| Gestion de l’ancien groupe LVM | Renommage accepté |
| Installation du système | Terminée selon le déroulement rapporté |
| Redémarrage | Effectué |
| Accès Web depuis un poste client | À confirmer par une connexion réussie |

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

Ce laboratoire nous a permis de suivre les principales étapes d’installation de Proxmox VE sur un serveur physique.

Nous avons démarré sur une clé USB, adapté les paramètres d’affichage, sélectionné le volume de stockage et configuré les paramètres d’administration et de réseau.

L’installation et le redémarrage constituent les résultats principaux du travail. La connexion à l’interface Web depuis un poste client permettra de compléter la validation avant la création des premières machines virtuelles.

Cette activité nous a également appris à relever les messages du système et à distinguer une configuration renseignée d’un fonctionnement effectivement vérifié.
