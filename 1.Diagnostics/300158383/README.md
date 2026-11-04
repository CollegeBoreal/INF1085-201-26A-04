# Rapport de dépannage et validation POST — HP ProLiant DL360 G6

**Cours :** INF1085-201-26A-04 — 1.Diagnostics  
**Étudiant :** Salma Baali  
**Date :** 4 novembre 2026  
**Équipement :** Serveur HP ProLiant DL360 G6

---

## 1. Contexte et objectif

Ce travail consiste à examiner un serveur HP ProLiant qui présente un problème de détection des processeurs. L'objectif est de vérifier le démarrage matériel (POST), d'observer la détection du processeur et de la mémoire, puis d'identifier les vérifications nécessaires pour trouver la cause du problème.

## 2. Identification et inspection visuelle

La première photographie montre le serveur HP ProLiant ouvert, avec les baies de disques en façade et les composants internes visibles.

<image src=images/01-vue-generale-serveur.jpg width=50% height=50% alt="Vue du serveur HP ProLiant"> </image>

*Photo 1 : Vue du dessus et de la façade du serveur.*

## 3. Configuration observée

| Élément | Observation |
|---|---|
| Processeur détecté | 1 Intel Xeon E5620 à 2,40 GHz |
| Nombre de cœurs | 4 cœurs activés |
| Hyper-Threading | Activé |
| Mémoire — premier affichage | 16 GB Installed |
| Mémoire — deuxième affichage | 64 GB Installed |
| Diagnostic mémoire | 65 536 MB configurés et disponibles |
| BIOS | ProLiant System BIOS P64 |
| Démarrage réseau | Broadcom UNDI PXE-2.1 |

## 4. Procédure et résultats

### 4.1 Démarrage et étalonnage thermique

Au démarrage, le serveur affiche le message « Power and Thermal Calibration in Progress ». Cette étape indique que le serveur poursuit son initialisation matérielle.

![Étalonnage thermique](images/02-calibration-thermique.jpg)

*Photo 2 : Écran d'étalonnage de l'alimentation et de la température.*

### 4.2 Premier démarrage — 16 Go de mémoire

L'écran POST affiche 16 GB Installed et indique qu'un seul processeur est détecté par le BIOS.

![POST avec 16 Go](images/03-post-16go.jpg)

*Photo 3 : Écran POST indiquant 16 GB Installed.*

### 4.3 Diagnostic de la mémoire

L'utilitaire BIOS Memory Diagnostic affiche 65 536 MB configurés et 65 536 MB disponibles. Cela confirme que le BIOS reconnaît une capacité mémoire de 64 Go au moment de la capture. Cependant, la photographie ne permet pas de confirmer que chaque barrette a terminé un test complet.

![Diagnostic mémoire](images/04-diagnostic-memoire.jpg)

*Photo 4 : Utilitaire BIOS Memory Diagnostic.*

### 4.4 Deuxième démarrage — 64 Go de mémoire

Après l'ajout ou la reconfiguration de la mémoire, l'écran POST affiche 64 GB Installed. Le BIOS indique toujours qu'un seul processeur est détecté, avec quatre cœurs activés et l'Hyper-Threading.

![POST avec 64 Go](images/05-post-64go.jpg)

*Photo 5 : Écran POST indiquant 64 GB Installed.*

### 4.5 Menu des options BIOS et RBSU

Le menu propose plusieurs options :
- **F1 :** Continuer.
- **F9 :** Ouvrir le ROM-Based Setup Utility (RBSU).
- **F10 :** System Maintenance Menu.
- **F11 :** Options de démarrage.
- **F12 :** Démarrage réseau.

La photographie confirme la présence de ces options, mais ne montre pas les écrans internes du RBSU.

![Menu BIOS](images/06-menu-bios.jpg)

*Photo 6 : Menu des options BIOS.*

### 4.6 Tentative de démarrage réseau

Après le POST, le serveur tente un démarrage depuis le CD-ROM, puis depuis la carte réseau. Le message suivant apparaît :

`PXE-E61: Media test failure, check cable`

Il est suivi de :

`PXE-M0F: Exiting Broadcom PXE ROM`

Cela indique que la tentative de démarrage réseau a échoué. Il faut vérifier l'ordre de démarrage, le support de démarrage et la connexion réseau.

![Erreur PXE](images/07-erreur-pxe.jpg)

*Photo 7 : Échec de l'amorçage PXE.*

## 5. Tableau récapitulatif

| Vérification | Résultat observé | Interprétation |
|---|---|---|
| Démarrage / POST | Écrans BIOS atteints | Le serveur effectue son initialisation matérielle. |
| Processeur | 1 Intel Xeon E5620 détecté | Un seul processeur est reconnu par le BIOS. |
| Mémoire | 16 Go puis 64 Go affichés | Le BIOS reconnaît 64 Go sur une capture. |
| Diagnostic mémoire | 65 536 MB disponibles | La capacité mémoire est détectée. |
| BIOS | ROM redondante détectée | Un message concernant la ROM apparaît. |
| Démarrage PXE | PXE-E61 / PXE-M0F | La tentative de démarrage réseau échoue. |

## 6. Analyse du problème

Le principal problème observé est la détection d'un seul processeur par le BIOS.

Plusieurs causes sont possibles :
- Un problème lié au deuxième processeur.
- Un mauvais contact ou des broches endommagées dans le socket.
- Un problème d'alimentation ou de connexion.
- Une configuration mémoire incorrecte liée à l'installation du deuxième processeur.

Pour identifier précisément la cause, il faudrait effectuer des vérifications complémentaires en suivant la procédure de maintenance HP et les consignes du laboratoire.

Les photographies disponibles ne permettent pas de confirmer que le deuxième processeur a été testé individuellement dans le premier socket. Il n'est donc pas possible d'affirmer que le deuxième socket est défectueux sans un test croisé documenté.

## 7. Conclusion

Les captures démontrent que le serveur HP ProLiant atteint les écrans BIOS et effectue son POST. Le BIOS reconnaît un processeur Intel Xeon E5620 à 2,40 GHz, avec quatre cœurs activés et l'Hyper-Threading.

La mémoire est affichée à 16 Go lors d'un premier essai, puis à 64 Go lors d'un autre essai. Le diagnostic mémoire indique 65 536 MB configurés et disponibles.

Le serveur rencontre ensuite un problème lors de la tentative de démarrage réseau, avec le message PXE-E61.

Le problème principal restant à vérifier est la détection d'un seul processeur. Les captures confirment ce symptôme, mais ne permettent pas de déterminer avec certitude si la cause vient du processeur secondaire, du socket ou d'un autre élément.

## 8. Référence

Dépôt GitHub du laboratoire :

[INF1085 — 1.Diagnostics](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/1.Diagnostics)

---
