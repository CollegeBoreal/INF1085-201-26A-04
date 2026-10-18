# Rapport de mise en place et d'installation de Proxmox VE

**Cours :** INF1085
**Serveur :** HP ProLiant DL360 G7 (server237)
**Version :** Proxmox VE 9.2

## 1. Présentation

L'objectif de ce laboratoire était de préparer un serveur physique et d'y installer Proxmox VE afin de l'utiliser comme plateforme de virtualisation. Nous avons créé une clé USB contenant l'image ISO de Proxmox VE, démarré le serveur à partir de cette clé, puis suivi les étapes de l'installateur graphique : choix du disque, mot de passe administrateur, configuration du réseau et installation.

## 2. Matériel utilisé

Le serveur est un HP ProLiant DL360 G7. Les informations affichées au démarrage (BIOS) sont les suivantes :

| Élément | Valeur |
|---|---|
| Modèle | HP ProLiant DL360 G7 |
| BIOS | ProLiant System BIOS P68 (05/05/2011) |
| Processeurs | 2 × Intel Xeon E5540 @ 2,53 GHz |
| Cœurs | 8 cœurs au total, Hyperthreading activé |
| Mémoire | 64 Go installés (Advanced ECC Support) |
| Gestion à distance | iLO 3 |

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 50" src="https://github.com/user-attachments/assets/4815ab83-73bd-4b81-9edf-fcfb78822b49" />

 le serveur HP ProLiant DL360 G7 avec la clé USB branchée à l'avant.*

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 51" src="https://github.com/user-attachments/assets/4460cfc8-a233-4641-ba7b-acaf47e96766" />

 écran de démarrage du BIOS HP ProLiant (calibration de l'alimentation et de la température).*

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 524" src="https://github.com/user-attachments/assets/87ae1915-e328-4354-9521-2aa92ea31d99" />

 informations du BIOS (processeurs, mémoire).*

## 3. Démarrage à partir de la clé USB

La clé USB contenant l'image ISO de Proxmox VE a été branchée sur le port USB à l'avant du serveur. Au démarrage, nous avons ouvert le menu de démarrage du BIOS (Boot Override) et choisi l'option **One Time Boot to USB DriveKey**. Ce choix s'applique seulement pour ce démarrage et ne modifie pas l'ordre normal de démarrage du serveur.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 53" src="https://github.com/user-attachments/assets/d2b5cc8c-a65d-4562-b9bf-d64c23c03230" />

menu « Default Boot Override Options » du BIOS.*

## 4. Menu de démarrage de Proxmox (GRUB)

Le serveur a démarré sur le menu de Proxmox VE 9.2. Nous avons sélectionné l'option **Install Proxmox VE (Graphical)** pour lancer l'installation graphique.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 54" src="https://github.com/user-attachments/assets/bf8c226c-ea1f-4852-bd28-4f53afc74e72" />

menu d'accueil de Proxmox VE 9.2.*

Avant de lancer l'installation, nous avons modifié l'entrée avec la touche **e** pour ajouter le paramètre `nomodeset` à la ligne de démarrage du noyau. Ce paramètre désactive la gestion avancée de l'affichage et évite les problèmes d'affichage sur ce matériel ancien. Le démarrage s'est ensuite fait avec **Ctrl+X**.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 55" src="https://github.com/user-attachments/assets/0d45f4e6-7d6d-4464-93f5-7ef214d3b09f" />


modification de l'entrée GRUB (ajout de `nomodeset`).*

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 56" src="https://github.com/user-attachments/assets/3ad1168a-a5cc-436b-9c4a-6ee46422dcc0" />

 message « Loading Proxmox VE Installer … ».*

## 5. Chargement de l'installateur

Pendant le chargement, le système a recherché le support contenant l'ISO : il a d'abord testé le lecteur `/dev/sr0`, puis a trouvé l'image Proxmox VE sur `/dev/sdb` (la clé USB). Il a ensuite détecté les cartes réseau et obtenu des offres DHCP (« DHCPOFFERS received »), ce qui confirme que le réseau est accessible.



## 6. Contrat de licence (EULA)

L'installateur graphique affiche le contrat de licence de Proxmox VE. Nous avons cliqué sur **I agree** pour l'accepter.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 57" src="https://github.com/user-attachments/assets/440ecb65-0870-4dd5-9782-7d84d26d58b2" />

contrat de licence (EULA).*

## 7. Choix du disque d'installation

Par défaut, l'installateur propose le disque `/dev/nvme0n1` (953,87 GiB, SK hynix PC811 1024 Go). Nous avons ouvert la liste déroulante **Target Harddisk** et sélectionné `/dev/sda` (273,40 GiB, volume logique). L'installateur avertit que toutes les partitions et données du disque choisi seront perdues.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 59" src="https://github.com/user-attachments/assets/7858d57f-d3b0-48b9-a69c-532da9ccfed1" />




<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 46 00" src="https://github.com/user-attachments/assets/19f61c65-725e-483d-a4b9-5d0bfacb537b" />

 sélection de `noom\deset` dans la liste.*

## 8. Mot de passe administrateur et courriel

L'installateur demande de définir le mot de passe du compte administrateur **root** et une adresse courriel qui servira à recevoir les notifications importantes du serveur (par exemple les échecs de sauvegarde). Le mot de passe doit contenir au moins 8 caractères avec des lettres, des chiffres et des symboles.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 46 03" src="https://github.com/user-attachments/assets/df5dd717-10a5-4f1d-a20c-f0f95a11444c" />

*Figure 13 : saisie du mot de passe root et de l'adresse courriel (champs floutés).*

## 9. Configuration du réseau

Nous avons ensuite configuré l'interface de gestion du serveur :

| Paramètre | Valeur |
|---|---|
| Interface de gestion | nic0 (3c:d9:2b:ec:fb:a4, pilote bnx2) |
| Nom d'hôte (FQDN) | server237.labinfo.local |
| Adresse IP (CIDR) | 10.7.236.237/23 |
| Passerelle (Gateway) | 10.7.237.1 |
| Serveur DNS | 8.8.8.8 |

L'option **Pin network interface names** est cochée : elle fixe les noms des interfaces réseau pour qu'ils ne changent pas après un redémarrage.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 46 06" src="https://github.com/user-attachments/assets/d54a3a5c-8375-4ff3-a8ca-fa457a38cd15" />

 configuration du réseau de gestion.*

## 10. Résumé avant l'installation

Avant de lancer l'installation, l'installateur affiche un résumé des choix :

| Option | Valeur |
|---|---|
| Système de fichiers | ext4 |
| Disque | /dev/sda |
| Pays | Canada |
| Fuseau horaire | America/Toronto |
| Disposition du clavier | en-us |
| Interface de gestion | nic0 |
| Nom d'hôte | server237 |
| Adresse IP | 10.7.236.237/23 |
| Passerelle | 10.7.237.1 |
| DNS | 8.8.8.8 |

L'option **Automatically reboot after successful installation** est cochée. Nous avons cliqué sur **Install**.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-1478547 at 21 46 07" src="https://github.com/user-attachments/assets/d369b635-e012-4be5-9b7d-6b92416abe9d" />

 résumé de l'installation (courriel flouté).*

## 11. Installation de Proxmox

Les principales étapes exécutées par l'installateur sont :

- création des partitions (2 %) ;
- création des volumes logiques LVM (3 %) ;
- extraction des paquets du système (par exemple `debian-faq_12.2_all.deb`, 51 %) ;
- configuration du système et installation du chargeur de démarrage ;
- redémarrage automatique du serveur.

Pendant la création des volumes logiques, l'installateur a détecté un groupe de volumes `pve` existant (sur `/dev/nvme0n1p3`), provenant d'une installation précédente. Il a proposé de le renommer en `pve-OLD-810787F6` ou d'annuler l'installation. Nous avons choisi **OK** pour renommer l'ancien groupe de volumes et poursuivre.

<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 46 0578" src="https://github.com/user-attachments/assets/225829a0-37ee-4c0b-9704-c07eab2befae" />

 création des partitions.*


<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 46 09" src="https://github.com/user-attachments/assets/fd6586bb-2220-42e3-a139-6179607cbfc1" />
extraction des paquets (51 %).*

## 12. Connexion réseau

Une fois l'installation terminée, le serveur a redémarré. Il utilise l'adresse IP **10.7.236.237**. L'interface Web de Proxmox est accessible depuis un navigateur à l'adresse :

`https://10.7.236.237:8006`
<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 46 10" src="https://github.com/user-attachments/assets/62dc6876-3732-40b9-82f1-2072af7a4dc3" />

Cette interface permet d'administrer le serveur à distance. La connexion se fait avec l'utilisateur `root` et le mot de passe défini pendant l'installation (realm Linux PAM).

## 13. Messages d'erreur observés au démarrage

Pendant le chargement, deux messages d'erreur sont apparus (voir la figure 8) : le module `shpchp` est introuvable et le module `radeonfb` ne peut pas être inséré (« No such device »). Ils concernent du matériel absent ou des pilotes graphiques inutilisés et n'ont pas empêché l'installation de se poursuivre.

## 14. Résultat

L'installation de Proxmox VE s'est terminée correctement. Le serveur possède maintenant une configuration réseau fonctionnelle et peut être administré à partir de l'interface Web. Le compte administrateur root permet de gérer le serveur et de créer des machines virtuelles.

## 15. Conclusion

Ce laboratoire nous a permis d'apprendre les principales étapes pour installer Proxmox VE sur un serveur physique : démarrer à partir d'une clé USB, lancer l'installateur graphique, choisir le disque, définir le mot de passe administrateur et configurer le réseau. Après l'installation, le serveur est accessible sur le réseau grâce à son adresse IP et prêt à être utilisé pour créer et administrer des machines virtuelles.
