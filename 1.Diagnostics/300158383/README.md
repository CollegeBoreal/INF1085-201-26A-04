# Rapport de dépannage et validation POST — Serveur HP ProLiant DL360 G6

**Cours :** INF1085-201-26A-04 — 1.Diagnostics  
**Étudiante :** Salma Baali  
**Date :** 4 novembre 2026  
**Équipement :** Serveur HP ProLiant DL360 G6

---

## 1. Contexte et objectif

Ce travail consiste à examiner un serveur HP ProLiant qui présente un problème de détection des processeurs. L'objectif est de vérifier le démarrage matériel (POST), d'observer la détection du processeur et de la mémoire, puis d'identifier les vérifications nécessaires pour comprendre l'origine du problème.

## 2. Inspection visuelle du serveur

La première étape consiste à ouvrir le serveur afin d'observer ses composants internes et de repérer les éléments nécessaires au diagnostic.

![Serveur ouvert](images/03-serveur-ouvert.jpg)

*Photo 1 : Vue du serveur HP ProLiant ouvert.*

## 3. Manipulation du dissipateur thermique

L'accès aux processeurs nécessite la manipulation des éléments de refroidissement. Cette étape permet d'observer l'installation des composants et leur emplacement.

![Manipulation du dissipateur thermique](images/04-manipulation-dissipateur.jpg)

*Photo 2 : Manipulation du dissipateur thermique.*

## 4. Vérification des processeurs

La configuration matérielle est examinée afin de vérifier la présence des deux processeurs et leur installation sur la carte mère.

![Deux processeurs](images/06-deux-processeurs.jpg)

*Photo 3 : Vue des deux processeurs.*

## 5. Démarrage et calibration thermique

Au démarrage, le serveur affiche le message « Power and Thermal Calibration in Progress ». Cette étape fait partie de l'initialisation matérielle du serveur.

![Calibration thermique](images/07-calibration-thermique.jpg)

*Photo 4 : Écran de calibration thermique.*

## 6. Menu BIOS et utilitaire RBSU

Le menu de démarrage propose plusieurs options :

- **F1 :** Continuer.
- **F9 :** Accéder au ROM-Based Setup Utility (RBSU).
- **F10 :** Accéder au System Maintenance Menu.
- **F11 :** Accéder aux options de démarrage.
- **F12 :** Démarrage réseau.

Le RBSU permet de consulter et de configurer plusieurs paramètres matériels du serveur.

![Menu BIOS](images/08-menu-bios.jpg)

*Photo 5 : Menu des options BIOS.*

## 7. Résultats des vérifications

Les captures du POST et du diagnostic mémoire montrent les observations suivantes :

| Élément | Résultat observé |
|---|---|
| Processeur | 1 Intel Xeon E5620 détecté à 2,40 GHz |
| Nombre de cœurs | 4 cœurs activés |
| Hyper-Threading | Activé |
| Mémoire — premier affichage | 16 GB Installed |
| Mémoire — deuxième affichage | 64 GB Installed |
| Diagnostic mémoire | 65 536 MB configurés et disponibles |
| BIOS | ProLiant System BIOS P64 |
| Démarrage réseau | Message PXE-E61 |

## 8. Analyse du problème

Le principal problème observé est la détection d'un seul processeur par le BIOS.

Plusieurs causes sont possibles :

- Un problème lié au deuxième processeur.
- Un mauvais contact au niveau du socket.
- Un problème de connexion ou d'alimentation.
- Une configuration matérielle ou mémoire incorrecte.

Les observations disponibles ne permettent pas de confirmer avec certitude que le deuxième processeur ou le deuxième
