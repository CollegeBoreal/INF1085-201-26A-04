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

![Figure 1](<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 50" src="https://github.com/user-attachments/assets/f2a87749-d87a-4dce-a8c8-6056deb788e7" />)

*Figure 1 : le serveur HP ProLiant DL360 G7 avec la clé USB branchée à l'avant.*

![Figure 2](<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 52" src="https://github.com/user-attachments/assets/42849ba3-9ef0-4f4f-8a61-6da5a10bce67" />)

*Figure 2 : écran de démarrage du BIOS HP ProLiant (calibration de l'alimentation et de la température).*

![Figure 3](<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 52 (1)" src="https://github.com/user-attachments/assets/6096b41a-b146-4d82-9603-66f1f5cbfdbc" />)

*Figure 3 : informations du BIOS (processeurs, mémoire).*

## 3. Démarrage à partir de la clé USB

La clé USB contenant l'image ISO de Proxmox VE a été branchée sur le port USB à l'avant du serveur. Au démarrage, nous avons ouvert le menu de démarrage du BIOS (Boot Override) et choisi l'option **One Time Boot to USB DriveKey**. Ce choix s'applique seulement pour ce démarrage et ne modifie pas l'ordre normal de démarrage du serveur.

![Figure 4](<img width="2048" height="1152" alt="WhatsApp Image 2026-10-17 at 21 45 53" src="https://github.com/user-attachments/assets/ebfcd41f-f291-4eaf-8920-c24ddf2532ed" />)

*Figure 4 : menu « Default Boot Override Options » du BIOS.*

## 4. Menu de démarrage de Proxmox (GRUB)

Le serveur a démarré sur le menu de Proxmox VE 9.2. Nous avons sélectionné l'option **Install Proxmox VE (Graphical)** pour lancer l'installation graphique.

![Figure 5](images/fig05.jpg)

*Figure 5 : menu d'accueil de Proxmox VE 9.2.*

Avant de lancer l'installation, nous avons modifié l'entrée avec la touche **e** pour ajouter le paramètre `nomodeset` à la ligne de démarrage du noyau. Ce paramètre désactive la gestion avancée de l'affichage et évite les problèmes d'affichage sur ce matériel ancien. Le démarrage s'est ensuite fait avec **Ctrl+X**.

![Figure 6](images/fig06.jpg)

*Figure 6 : modification de l'entrée GRUB (ajout de `nomodeset`).*

![Figure 7](images/fig07.jpg)

*Figure 7 : message « Loading Proxmox VE Installer … ».*

## 5. Chargement de l'installateur

Pendant le chargement, le système a recherché le support contenant l'ISO : il a d'abord testé le lecteur `/dev/sr0`, puis a trouvé l'image Proxmox VE sur `/dev/sdb` (la clé USB). Il a ensuite détecté les cartes réseau et obtenu des offres DHCP (« DHCPOFFERS received »), ce qui confirme que le réseau est accessible.

![Figure 8](images/fig08.jpg)

*Figure 8 : détection de l'ISO sur `/dev/sdb`.*

![Figure 9](images/fig09.jpg)

*Figure 9 : détection des cartes réseau et réception des offres DHCP.*

## 6. Contrat de licence (EULA)

L'installateur graphique affiche le contrat de licence de Proxmox VE. Nous avons cliqué sur **I agree** pour l'accepter.

![Figure 10](images/fig10.jpg)

*Figure 10 : contrat de licence (EULA).*

## 7. Choix du disque d'installation

Par défaut, l'installateur propose le disque `/dev/nvme0n1` (953,87 GiB, SK hynix PC811 1024 Go). Nous avons ouvert la liste déroulante **Target Harddisk** et sélectionné `/dev/sda` (273,40 GiB, volume logique). L'installateur avertit que toutes les partitions et données du disque choisi seront perdues.

![Figure 11](images/fig11.jpg)

*Figure 11 : disque proposé par défaut (`/dev/nvme0n1`).*

![Figure 12](images/fig12.jpg)

*Figure 12 : sélection de `/dev/sda` dans la liste.*

## 8. Mot de passe administrateur et courriel

L'installateur demande de définir le mot de passe du compte administrateur **root** et une adresse courriel qui servira à recevoir les notifications importantes du serveur (par exemple les échecs de sauvegarde). Le mot de passe doit contenir au moins 8 caractères avec des lettres, des chiffres et des symboles.

![Figure 13](images/fig13.jpg)

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

![Figure 14](images/fig14.jpg)

*Figure 14 : configuration du réseau de gestion.*

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

![Figure 15](images/fig15.jpg)

*Figure 15 : résumé de l'installation (courriel flouté).*

## 11. Installation de Proxmox

Les principales étapes exécutées par l'installateur sont :

- création des partitions (2 %) ;
- création des volumes logiques LVM (3 %) ;
- extraction des paquets du système (par exemple `debian-faq_12.2_all.deb`, 51 %) ;
- configuration du système et installation du chargeur de démarrage ;
- redémarrage automatique du serveur.

Pendant la création des volumes logiques, l'installateur a détecté un groupe de volumes `pve` existant (sur `/dev/nvme0n1p3`), provenant d'une installation précédente. Il a proposé de le renommer en `pve-OLD-810787F6` ou d'annuler l'installation. Nous avons choisi **OK** pour renommer l'ancien groupe de volumes et poursuivre.

![Figure 16](images/fig16.jpg)

*Figure 16 : création des partitions.*

![Figure 17](images/fig17.jpg)

*Figure 17 : détection d'un groupe de volumes `pve` existant.*

![Figure 18](images/fig18.jpg)

*Figure 18 : création des volumes logiques.*

![Figure 19](images/fig19.jpg)

*Figure 19 : extraction des paquets (51 %).*

## 12. Connexion réseau

Une fois l'installation terminée, le serveur a redémarré. Il utilise l'adresse IP **10.7.236.237**. L'interface Web de Proxmox est accessible depuis un navigateur à l'adresse :

`https://10.7.236.237:8006`

Cette interface permet d'administrer le serveur à distance. La connexion se fait avec l'utilisateur `root` et le mot de passe défini pendant l'installation (realm Linux PAM).

## 13. Messages d'erreur observés au démarrage

Pendant le chargement, deux messages d'erreur sont apparus (voir la figure 8) : le module `shpchp` est introuvable et le module `radeonfb` ne peut pas être inséré (« No such device »). Ils concernent du matériel absent ou des pilotes graphiques inutilisés et n'ont pas empêché l'installation de se poursuivre.

## 14. Résultat

L'installation de Proxmox VE s'est terminée correctement. Le serveur possède maintenant une configuration réseau fonctionnelle et peut être administré à partir de l'interface Web. Le compte administrateur root permet de gérer le serveur et de créer des machines virtuelles.

## 15. Conclusion

Ce laboratoire nous a permis d'apprendre les principales étapes pour installer Proxmox VE sur un serveur physique : démarrer à partir d'une clé USB, lancer l'installateur graphique, choisir le disque, définir le mot de passe administrateur et configurer le réseau. Après l'installation, le serveur est accessible sur le réseau grâce à son adresse IP et prêt à être utilisé pour créer et administrer des machines virtuelles.
