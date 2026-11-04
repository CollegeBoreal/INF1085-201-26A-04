# INF1085 – Administration Linux

## Rapport de dépannage, de validation matérielle et d’installation de Proxmox VE

**Nom :** Mohammed Mati  
**Numéro d’étudiant :** 300158185  
**Serveur :** HP ProLiant DL360 G6  

---

## 1. Introduction

Dans le cadre de ce travail pratique, nous avons effectué le diagnostic et la remise en fonctionnement d’un serveur HP ProLiant DL360 G6 présentant des problèmes de démarrage.

Nous avons procédé progressivement en inspectant les principaux composants : les processeurs, la mémoire RAM, les disques et le système de refroidissement.

Après les vérifications matérielles, nous avons préparé le stockage avec le contrôleur HP Smart Array P410i, puis installé et démarré Proxmox Virtual Environment.

## 2. Objectifs du travail

- Inspecter les composants internes du serveur.
- Vérifier l’installation des processeurs et de la mémoire RAM.
- Observer la séquence de démarrage et les informations du BIOS.
- Préparer un volume de stockage en RAID 5.
- Installer et démarrer Proxmox VE.
- Relever les informations nécessaires à son administration.

## 3. Inspection du matériel

Nous avons commencé par ouvrir le serveur pour accéder aux composants internes.

Nous avons repéré les deux emplacements des processeurs, les emplacements DIMM de la mémoire RAM, les ventilateurs et les connexions de la carte mère.

<p align="center">
  <img src="https://github.com/user-attachments/assets/5554cc80-df92-4897-a395-72c773bf9dec" alt="Vue interne du serveur HP ProLiant DL360 G6" width="700">
</p>

*Figure 1 : Vue interne du serveur et des deux emplacements des processeurs.*

Cette inspection visuelle permet de rechercher un composant mal installé, une connexion débranchée ou un dommage apparent.

## 4. Vérification des processeurs

Le serveur possède deux emplacements de processeurs, identifiés **Processor 1** et **Processor 2**.

Pendant le diagnostic, nous avons retiré puis réinstallé les processeurs afin de vérifier leur positionnement et leur fixation.

<p align="center">
  <img src="https://github.com/user-attachments/assets/2821acaf-60b5-45a7-8027-53584006310f" alt="Processeur installé dans son socket" width="700">
</p>

*Figure 2 : Processeur installé dans son socket.*

Nous avons également inspecté visuellement un processeur après son retrait.

<p align="center">
  <img src="https://github.com/user-attachments/assets/4159be66-2469-4538-8f32-2884a83064b6" alt="Processeur retiré pour inspection" width="700">
</p>

*Figure 3 : Processeur retiré pour inspection.*

Cette vérification permet de rechercher des dommages apparents sur les contacts du processeur et dans le socket. L’inspection visuelle seule ne permet toutefois pas de confirmer le fonctionnement complet de chaque processeur.

## 5. Remontage des dissipateurs thermiques

Après la réinstallation des processeurs, nous avons remis en place les dissipateurs thermiques.

Ces composants évacuent la chaleur produite par les processeurs. Leur fixation correcte est nécessaire pour assurer un refroidissement adéquat.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d6dd21c5-7bb3-481e-b28f-a5180b72191a" alt="Dissipateurs thermiques remontés" width="700">
</p>

*Figure 4 : Dissipateurs thermiques remontés sur les processeurs.*

Une mauvaise installation peut entraîner une surchauffe, une instabilité ou un arrêt de protection du serveur.

## 6. Vérification de la mémoire RAM

Nous avons vérifié l’installation des barrettes de mémoire dans les emplacements DIMM.

Le placement des barrettes doit respecter les indications du serveur et tenir compte des processeurs installés.

<p align="center">
  <img src="https://github.com/user-attachments/assets/ed2457af-e6a4-42ee-aff0-db00e5a06951" alt="Barrettes de mémoire dans les emplacements DIMM" width="700">
</p>

*Figure 5 : Barrettes de mémoire installées dans les emplacements DIMM.*

Pour isoler une panne de mémoire, la méthode consiste à commencer avec une configuration minimale conforme aux recommandations du constructeur, puis à ajouter progressivement les autres barrettes.

Cette démarche aide à repérer une barrette ou un emplacement pouvant être à l’origine du problème.

## 7. Retrait temporaire des composants

Pendant les tests, nous avons retiré les disques durs ainsi que plusieurs barrettes de mémoire.

<p align="center">
  <img src="https://github.com/user-attachments/assets/bb12bc21-a606-4ff2-85e3-c0c4c76d279e" alt="Disques HP et barrettes de mémoire retirés" width="700">
</p>

*Figure 6 : Disques HP et barrettes de mémoire retirés pendant le diagnostic.*

Le retrait temporaire des disques permet d’observer le démarrage matériel sans tenter de charger le système d’exploitation installé sur ceux-ci.

Cette méthode facilite la distinction entre un problème matériel au démarrage et un problème lié au stockage ou au système d’exploitation.

## 8. Démarrage et séquence POST

Après avoir réinstallé les composants nécessaires, nous avons mis le serveur sous tension.

L’écran HP ProLiant est apparu avec le message suivant :

> Power and Thermal Calibration in Progress

<p align="center">
  <img src="https://github.com/user-attachments/assets/c7bfeec7-673e-4861-9473-f646a1668090" alt="Démarrage et calibration du serveur" width="700">
</p>

*Figure 7 : Démarrage du serveur et calibration de l’alimentation et du système thermique.*

Cet écran montre que le serveur a commencé sa séquence de démarrage.

Le **POST**, ou *Power-On Self-Test*, correspond aux vérifications réalisées à la mise sous tension.

La présence de cet écran ne prouve pas, à elle seule, que toutes les vérifications sont terminées. Le démarrage ultérieur de Proxmox montre cependant que le serveur a pu poursuivre sa séquence jusqu’au chargement du système.

## 9. Diagnostic de la mémoire dans le BIOS

Nous avons utilisé l’utilitaire **BIOS Memory Diagnostic** pour vérifier la reconnaissance de la mémoire installée.

<p align="center">
  <img src="https://github.com/user-attachments/assets/dcc7ecf2-1d36-4a39-a506-28deb7b4d997" alt="Diagnostic de la mémoire dans le BIOS" width="700">
</p>

*Figure 8 : Diagnostic de la mémoire dans le BIOS.*

| Élément | Valeur affichée |
|---|---|
| Capacité des barrettes indiquées | 16 384 MB chacune |
| Mémoire totale configurée | 65 536 MB |
| Capacité correspondante | Environ 64 Go |
| État du diagnostic sur la capture | Test en cours |

Le BIOS reconnaît la mémoire dans la configuration testée.

Puisque le diagnostic est encore en cours sur la capture, celle-ci ne permet pas de conclure que l’ensemble de la mémoire a terminé le test sans erreur.

## 10. Préparation du stockage en RAID 5

Avant l’installation de Proxmox VE, nous avons utilisé le contrôleur **HP Smart Array P410i** pour préparer le stockage.

Trois disques SAS de **146,8 Go chacun** ont été sélectionnés pour constituer un volume logique en **RAID 5**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/241f6118-a928-4373-8596-d35a9b722c0a" alt="Sélection des disques SAS et configuration du RAID 5" width="700">
</p>

*Figure 9 : Sélection des trois disques SAS pour la configuration du RAID 5.*

| Élément | Configuration |
|---|---|
| Contrôleur | HP Smart Array P410i |
| Nombre de disques | 3 |
| Type de disques | SAS |
| Capacité par disque | 146,8 Go |
| Niveau RAID | RAID 5 |
| Capacité du volume indiquée | Environ 293,56 Go |

Le RAID 5 répartit les données et les informations de parité sur les disques. Une capacité équivalente à celle d’un disque est consacrée à la parité.

La création du volume logique prépare le stockage pour l’installation. Le partitionnement et le formatage nécessaires au système sont ensuite réalisés pendant l’installation de Proxmox.

## 11. Installation et démarrage de Proxmox VE

Après la préparation du stockage, nous avons installé et démarré **Proxmox Virtual Environment**.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d9d05c3e-1e72-47cd-9c99-fff5d9b313a6" alt="Console de Proxmox VE après le démarrage" width="700">
</p>

*Figure 10 : Console de Proxmox VE après le démarrage.*

L’écran affiche le message :

> Welcome to the Proxmox Virtual Environment

Il indique également l’adresse d’administration suivante :

**https://192.168.100.2:8006/**

L’invite de commande affichée est :

    root@server1:~#

Ces éléments confirment que Proxmox a chargé son système et qu’une session locale avec le compte **root** est ouverte.

L’adresse affichée correspond à l’interface d’administration Web prévue. Pour confirmer son accessibilité, il faut l’ouvrir depuis un ordinateur disposant d’une connexion réseau appropriée au serveur.

## 12. Bilan des vérifications

| Élément | Résultat ou observation |
|---|---|
| Processeurs | Retirés, inspectés et réinstallés |
| Sockets des processeurs | Inspection visuelle effectuée |
| Dissipateurs thermiques | Remontés |
| Mémoire RAM | Reconnue par le BIOS |
| Mémoire configurée | 65 536 MB, soit environ 64 Go |
| Diagnostic mémoire | En cours sur la capture fournie |
| Disques SAS | Trois disques sélectionnés pour le RAID 5 |
| Stockage logique | Volume d’environ 293,56 Go indiqué |
| BIOS | Accessible |
| Séquence de démarrage | Poursuivie jusqu’au chargement de Proxmox |
| Proxmox VE | Démarré en console |
| Compte root | Session locale ouverte |
| Accès Web | Adresse affichée ; connexion à vérifier depuis un navigateur |

Le démarrage de Proxmox constitue un résultat positif. Il montre que le matériel nécessaire au chargement du système fonctionne dans la configuration utilisée.

Il ne remplace toutefois pas un diagnostic complet de chaque composant.

## 13. Résultats obtenus

À la fin du travail, nous avons réussi à :

1. Ouvrir le serveur et identifier ses principaux composants.
2. Inspecter et réinstaller les processeurs.
3. Remonter les dissipateurs thermiques.
4. Vérifier l’installation des barrettes de mémoire.
5. Accéder au BIOS et lancer le diagnostic mémoire.
6. Observer une mémoire configurée d’environ 64 Go.
7. Préparer un volume RAID 5 avec trois disques SAS.
8. Poursuivre le démarrage jusqu’au système d’exploitation.
9. Installer et démarrer Proxmox VE.
10. Accéder à la console locale avec le compte root.

## 14. Conclusion

Ce travail pratique nous a permis de remettre en fonctionnement un serveur HP ProLiant DL360 G6 en suivant une démarche progressive de dépannage.

Nous avons inspecté les processeurs, la mémoire, le stockage et les composants de refroidissement. Le BIOS a reconnu environ 64 Go de mémoire dans la configuration testée. Nous avons ensuite préparé un volume RAID 5 et démarré Proxmox VE.

Le résultat principal est le chargement réussi de Proxmox et l’accès à sa console locale. Pour compléter la validation, il reste à relever le résultat final du diagnostic mémoire et à confirmer l’accès à l’interface Web depuis un autre ordinateur.

Cette activité nous a appris à isoler les problèmes étape par étape et à distinguer une observation, un test en cours et un résultat confirmé.
