# INF1085 – Administration Linux

## Rapport de dépannage, validation matérielle et installation de Proxmox VE

**Étudiant :** Lachi Lahlou
**Numéro étudiant :** 300150410
**Cours :** INF1085 – Administration Linux
**Établissement :** Collège Boréal
**Serveur :** HP ProLiant DL360 G6


## 1. Introduction

Dans le cadre du cours INF1085, notre groupe a effectué le diagnostic et la remise en fonctionnement d'un serveur HP ProLiant DL360 G6.

Au départ, le serveur présentait des difficultés de démarrage. Pour identifier l'origine du problème, nous avons procédé progressivement en vérifiant les principaux composants matériels, notamment les processeurs, la mémoire RAM et les disques durs.

Après les différentes vérifications et la validation du POST, nous avons réussi à démarrer le serveur et à accéder à Proxmox Virtual Environment.

L'objectif de ce laboratoire était de comprendre les étapes de dépannage d'un serveur physique et de préparer un environnement de virtualisation fonctionnel.

## 2. Inspection du matériel

Nous avons commencé par ouvrir le serveur afin d'accéder à ses composants internes.

Cette inspection nous a permis d'identifier les processeurs, les emplacements de mémoire RAM, les ventilateurs et les différents composants de la carte mère.

<img width="2048" height="2048" alt="Vue interne du serveur" src="https://github.com/user-attachments/assets/5554cc80-df92-4897-a395-72c773bf9dec" />

*Figure 1 : Vue interne du serveur et des emplacements des processeurs.*

Cette étape nous a permis de vérifier visuellement l'état des composants et de rechercher d'éventuelles anomalies au niveau des sockets et de la carte mère.

## 3. Vérification des processeurs

Le serveur possède deux emplacements pour processeurs, identifiés comme **Processor 1** et **Processor 2**.

Pendant le diagnostic, les processeurs ont été retirés puis réinstallés afin de vérifier leur positionnement et leur état.

<img width="2048" height="2048" alt="Processeur installé" src="https://github.com/user-attachments/assets/2821acaf-60b5-45a7-8027-53584006310f" />

*Figure 2 : Processeur installé dans son socket.*

Nous avons également inspecté les processeurs après leur retrait.

<img width="2048" height="2048" alt="Processeur retiré" src="https://github.com/user-attachments/assets/4159be66-2469-4538-8f32-2884a83064b6" />

*Figure 3 : Processeur retiré du serveur pour inspection.*

Cette vérification permet de détecter d'éventuels dommages physiques et de s'assurer que les processeurs sont correctement installés.

## 4. Installation des dissipateurs thermiques

Après avoir terminé la vérification des processeurs, nous avons remis en place les dissipateurs thermiques.

Ces composants permettent d'évacuer la chaleur produite par les processeurs pendant leur fonctionnement.

<img width="2048" height="2048" alt="Dissipateurs thermiques" src="https://github.com/user-attachments/assets/d6dd21c5-7bb3-481e-b28f-a5180b72191a" />

*Figure 4 : Dissipateurs thermiques installés sur les processeurs.*

Une installation incorrecte des dissipateurs peut entraîner une surchauffe et provoquer des problèmes de fonctionnement du serveur.

## 5. Vérification de la mémoire RAM

La mémoire RAM faisait également partie des composants à vérifier pendant notre diagnostic.

Nous avons examiné les barrettes de mémoire et leur emplacement sur la carte mère.

<img width="2048" height="2048" alt="Mémoire RAM" src="https://github.com/user-attachments/assets/ed2457af-e6a4-42ee-aff0-db00e5a06951" />

*Figure 5 : Barrettes de mémoire RAM installées dans les emplacements DIMM.*

Pour identifier un éventuel problème de mémoire, une méthode consiste à démarrer le serveur avec une configuration minimale compatible, puis à ajouter progressivement les barrettes.

Cette procédure permet de déterminer si une barrette ou un emplacement DIMM présente un problème.

## 6. Composants retirés pendant le diagnostic

Pendant les différentes vérifications, plusieurs composants ont été temporairement retirés du serveur.

Il s'agissait principalement des disques durs et de certaines barrettes de mémoire RAM.

<img width="2048" height="2048" alt="Disques et RAM" src="https://github.com/user-attachments/assets/bb12bc21-a606-4ff2-85e3-c0c4c76d279e" />

*Figure 6 : Disques durs HP et barrettes de mémoire retirés pendant le diagnostic.*

Le retrait des disques permet notamment de vérifier si le serveur peut effectuer son POST indépendamment du système de stockage.

Cette méthode facilite l'identification de l'origine des problèmes matériels.

## 7. Démarrage du serveur et test POST

Après avoir réinstallé les composants nécessaires, nous avons remis le serveur sous tension.

L'écran de démarrage HP ProLiant s'est affiché avec le message suivant :

`Power and Thermal Calibration in Progress`

<img width="2048" height="2048" alt="Démarrage serveur" src="https://github.com/user-attachments/assets/c7bfeec7-673e-4861-9473-f646a1668090" />

*Figure 7 : Démarrage du serveur HP ProLiant et calibration thermique.*

Le POST (*Power-On Self-Test*) est une procédure exécutée au démarrage permettant de vérifier les principaux composants matériels.

L'affichage de cet écran indique que le serveur a commencé sa séquence de démarrage.

## 8. Diagnostic de la mémoire avec le BIOS

Nous avons ensuite utilisé l'outil **BIOS Memory Diagnostic** afin de vérifier la mémoire installée.

<img width="2048" height="2048" alt="Diagnostic mémoire BIOS" src="https://github.com/user-attachments/assets/dcc7ecf2-1d36-4a39-a506-28deb7b4d997" />

*Figure 8 : Diagnostic de la mémoire RAM dans le BIOS.*

Le BIOS a détecté plusieurs barrettes de mémoire de **16 384 MB**, soit environ 16 Go chacune.

La mémoire totale configurée était de :

**65 536 MB, soit 64 Go de RAM.**

Au moment de la capture d'écran, le test mémoire était encore en cours.

Cette vérification nous a permis de confirmer que les barrettes étaient reconnues par le BIOS et que le système pouvait accéder à la mémoire installée.

## 9. Vérification finale du matériel

Après les tests, nous avons réinstallé les composants nécessaires au fonctionnement du serveur.

Les dissipateurs thermiques, les ventilateurs et les disques ont été remis en place.

Voici le résumé des vérifications réalisées :

| Composant           | Résultat                |
| ------------------- | ----------------------- |
| Processeur 1        | Détecté et fonctionnel  |
| Processeur 2        | Installé et vérifié     |
| Sockets processeurs | Vérifiés                |
| Mémoire RAM         | Détectée                |
| Mémoire configurée  | 65 536 MB / 64 Go       |
| Disques durs        | Vérifiés et réinstallés |
| Ventilateurs        | Fonctionnels            |
| POST                | Réussi                  |
| BIOS                | Accessible              |

Ces vérifications ont permis de poursuivre la préparation du serveur pour l'installation de Proxmox VE.

## 10. Préparation et configuration des disques

Avant l'installation de Proxmox VE, nous avons préparé les disques du serveur à l'aide du contrôleur **HP Smart Array P410i**.

Nous avons sélectionné trois disques SAS de 146,8 Go afin de créer un volume logique en **RAID 5**.

Cette configuration permet de répartir les données et les informations de parité sur plusieurs disques.

Le volume RAID 5 obtenu possède une capacité d'environ **293,56 Go**.

<img width="2048" height="2048" alt="Configuration RAID 5" src="https://github.com/user-attachments/assets/241f6118-a928-4373-8596-d35a9b722c0a" />

*Figure 9 : Sélection des trois disques SAS et configuration du RAID 5.*

Cette étape nous a permis de préparer l'espace de stockage destiné à accueillir Proxmox VE.

## 11. Installation et démarrage de Proxmox VE

Après avoir terminé les vérifications matérielles et préparé le stockage, nous avons procédé à l'installation de Proxmox Virtual Environment.

Une fois l'installation terminée, le serveur a démarré correctement.

<img width="2048" height="2048" alt="Proxmox démarré" src="https://github.com/user-attachments/assets/d9d05c3e-1e72-47cd-9c99-fff5d9b313a6" />

*Figure 10 : Proxmox Virtual Environment démarré sur le serveur.*

L'écran affiche le message :

`Welcome to the Proxmox Virtual Environment`

L'adresse de l'interface Web indiquée par le serveur est :

`https://192.168.100.2:8006/`

Le système affiche également l'invite de commande :

`root@server1:~#`

Ces informations confirment que le système Proxmox a démarré et que la console administrateur est disponible.

## 12. Validation du fonctionnement du serveur

Le démarrage de Proxmox VE représente une étape importante dans la validation du serveur.

Il indique que les composants nécessaires au chargement du système fonctionnent suffisamment pour permettre son démarrage.

Les principaux éléments vérifiés pendant le laboratoire sont :

* Les processeurs.
* La mémoire RAM.
* Les sockets des processeurs.
* Les ventilateurs.
* Les disques durs.
* Le contrôleur de stockage.
* Le BIOS.
* Le démarrage de Proxmox VE.

Le serveur dispose maintenant d'un environnement de virtualisation installé.

L'interface Web pourra être utilisée depuis un ordinateur ayant accès au réseau du serveur.

## 13. Résultats obtenus

À la fin de ce travail pratique, notre groupe a réalisé les opérations suivantes :

1. Ouverture et inspection du serveur.
2. Vérification des processeurs.
3. Inspection des sockets.
4. Réinstallation des processeurs.
5. Vérification des barrettes de mémoire RAM.
6. Diagnostic de la mémoire à partir du BIOS.
7. Inspection des disques durs.
8. Réinstallation des dissipateurs thermiques.
9. Vérification des ventilateurs.
10. Validation du démarrage et du POST.
11. Configuration du stockage en RAID 5.
12. Installation de Proxmox Virtual Environment.
13. Démarrage du système Proxmox.
14. Accès à la console administrateur root.

Ces résultats montrent que le serveur a pu être remis en fonctionnement après les différentes étapes de diagnostic.

## 14. Conclusion

Ce travail pratique réalisé dans le cadre du cours INF1085 nous a permis de mieux comprendre le dépannage et la préparation d'un serveur physique HP ProLiant DL360 G6.

Nous avons commencé par inspecter les composants matériels afin de rechercher l'origine des problèmes de démarrage.

Les processeurs ont été retirés, vérifiés et réinstallés. Nous avons également contrôlé la mémoire RAM à l'aide de l'utilitaire de diagnostic du BIOS.

Après ces vérifications, le serveur a réussi à démarrer et le BIOS a reconnu une configuration mémoire de 64 Go.

Nous avons ensuite préparé les disques avec une configuration RAID 5 avant de procéder à l'installation de Proxmox Virtual Environment.

Le système a finalement démarré et affiché son adresse d'administration réseau :

`https://192.168.100.2:8006/`

Cette activité nous a permis de comprendre l'importance d'une méthode de dépannage progressive et organisée.

Nous avons également découvert comment préparer un serveur physique pour l'utiliser comme plateforme de virtualisation dans un environnement informatique professionnel.

---

**Rapport préparé par : Lachi Lahlou**
**Numéro étudiant : 300150410**
**Cours : INF1085 – Administration Linux**
**Collège Boréal**

