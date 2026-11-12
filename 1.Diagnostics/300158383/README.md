# Diagnostic matériel et configuration — HP ProLiant DL360 G6

**Cours :** INF1085-201-26A-04 — 1.Diagnostics  
**Étudiante :** Salma Baali  
**Serveur :** HP ProLiant DL360 G6

---

## 1. Objectif du laboratoire

L'objectif de ce laboratoire est d'examiner un serveur HP ProLiant DL360 G6, de vérifier son démarrage matériel (POST), d'observer la détection des processeurs et de la mémoire système, puis d'analyser les problèmes rencontrés.

Les vérifications abordées sont :

- l'inspection des composants matériels ;
- la manipulation du dissipateur thermique ;
- la vérification des processeurs et de leur installation ;
- le démarrage et les messages POST ;
- l'accès au BIOS et au ROM-Based Setup Utility (RBSU) ;
- la détection et le diagnostic de la mémoire ;
- les options de démarrage et le message d'erreur PXE ;
- l'analyse des causes possibles d'un problème de détection du deuxième processeur.

### Contexte et problématique

Le serveur présentait un problème de démarrage : le deuxième processeur n'était pas détecté. Conformément à la procédure d'isolation de panne du laboratoire, l'objectif était de tester CPU2 seul dans le socket 1 (PROC 1), afin de déterminer si le problème venait du processeur lui-même ou du socket 2.

![Contexte du test](images/13-contexte-test.jpg)

*Figure 1 — Serveur utilisé pour le test d'isolation de panne.*

*Ce laboratoire a été réalisé en équipe.*

## 2. Inspection du serveur

Le serveur est ouvert afin d'observer ses composants internes avant les vérifications matérielles.

![Serveur ouvert](images/03-serveur-ouvert.jpg)

*Figure 2 — Vue du serveur ouvert.*

## 3. Manipulation du dissipateur thermique

L'accès aux processeurs nécessite de manipuler le système de refroidissement. Cette opération permet d'observer les composants et leur installation. Les manipulations doivent être réalisées en respectant les consignes de sécurité et de maintenance du laboratoire.

![Manipulation du dissipateur](images/04-manipulation-dissipateur.jpg)

*Figure 3 — Manipulation du dissipateur thermique.*

## 4. Vérification des processeurs

Le serveur possède deux emplacements pour processeurs. L'inspection visuelle permet d'observer les deux processeurs et leur emplacement sur la carte système.

![Deux processeurs](images/06-deux-processeurs.jpg)

*Figure 4 — Vue des deux processeurs.*

Une inspection visuelle seule ne permet pas de confirmer la cause du problème de détection. Un test croisé est nécessaire (voir section 9).

## 5. Configuration minimale utilisée pour le POST

Les consignes du laboratoire indiquent une configuration minimale pour isoler le problème :

| Élément | Configuration utilisée |
|---|---|
| Processeur | Un processeur Intel Xeon installé dans le socket 1 (PROC 1) |
| Mémoire | Une barrette de 8 Go |
| Emplacement mémoire | PROC 1 DIMM 3 (emplacement blanc A1) |
| Cartes PCIe | Aucune carte PCIe supplémentaire |
| Alimentation | Bloc d'alimentation dans la baie 1 uniquement |

Les modèles de processeurs mentionnés sont Intel Xeon E5620 à 2,40 GHz et Intel Xeon E5540 à 2,53 GHz.

Avec un seul bloc d'alimentation, le serveur affiche l'avertissement standard « 1615 - Power Supply Failure or Power Supply Unplugged in Bay 2 ». Ce message est normal, car seule la baie 1 est alimentée.

![Configuration minimale](images/14-config-minimale.jpg)

*Figure 5 — Configuration minimale utilisée pour le POST.*

## 6. Démarrage et calibration thermique

Au démarrage, le serveur affiche le message « Power and Thermal Calibration in Progress ». Ce message apparaît pendant la phase d'initialisation du serveur.

![Calibration thermique](images/07-calibration-thermique.jpg)

*Figure 6 — Écran de calibration thermique.*

### Détection du processeur au POST

Le serveur passe l'étape POST (Power-On Self-Test) et affiche :

- **1 Processor(s) detected**, 4 total cores enabled, Hyperthreading is enabled ;
- modèle : Intel Xeon E5620 à 2,40 GHz (ou E5540 à 2,53 GHz selon la capture) ;
- chargement du BIOS sans erreur critique de socket.

![Détection du processeur au POST](images/15-post-detection-cpu.jpg)

*Figure 7 — Écran POST : détection du processeur.*

## 7. BIOS et RBSU — configuration générale

Le ROM-Based Setup Utility (RBSU) est l'utilitaire de configuration intégré au serveur HP ProLiant. Il permet d'accéder aux paramètres de configuration du système, notamment aux réglages matériels, à la mémoire et aux options de démarrage.

L'accès au RBSU se fait avec la touche **F9** pendant le démarrage.

![Menu BIOS](images/08-menu-bios.jpg)

*Figure 8 — Menu de démarrage et accès aux utilitaires.*

Les options affichées dans le menu comprennent :

| Touche | Fonction affichée |
|---|---|
| F1 | Continuer |
| F9 | ROM-Based Setup Utility (RBSU) |
| F10 | System Maintenance Menu |
| F11 | Options de démarrage |
| F12 | Démarrage réseau |

### Configuration système dans le RBSU (version 3.00)

| Élément | Valeur observée |
|---|---|
| Proc 1 | Intel 2,53 GHz, 8 MB L3 Cache |
| Proc 2 | Not Installed |

![RBSU](images/17-rbsu-proc.jpg)

*Figure 9 — Configuration du processeur dans le RBSU.*

### Utilitaire de diagnostic système

Le menu principal de l'utilitaire de diagnostic HP (version 2.15) permet d'exécuter des tests ciblés :

- Memory Test ;
- CPU Test ;
- Boot Disk Test.

## 8. Mémoire système

La mémoire est vérifiée à partir des informations affichées au POST et de l'utilitaire de diagnostic mémoire.

| Vérification | Résultat observé |
|---|---|
| Configuration minimale (1 barrette) | PROC 1 DIMM 3 : 8192 MB détectés |
| Autres emplacements (PROC 1 et PROC 2) | Not Installed |
| Premier affichage POST (autre essai) | 16 GB Installed |
| Autre affichage POST (configuration finale) | 64 GB Installed |
| Diagnostic mémoire (configuration finale) | 65 536 MB configurés et disponibles |

### 8.1 Configuration minimale — 8 Go

![Diagnostic mémoire 8 Go](images/16-diagnostic-memoire-8go.jpg)

*Figure 10 — BIOS Memory Diagnostic : barrette de 8192 MB sur PROC 1 DIMM 3.*

### 8.2 POST — affichage de 16 Go

![POST 16 Go](images/09-post-16go.jpg)

*Figure 11 — Affichage de 16 GB Installed.*

### 8.3 Diagnostic mémoire

![Diagnostic mémoire](images/10-diagnostic-memoire.jpg)

*Figure 12 — Diagnostic de la mémoire système.*

### 8.4 POST — affichage de 64 Go

![POST 64 Go](images/11-post-64go.jpg)

*Figure 13 — Affichage de 64 GB Installed.*

Les capacités affichées changent selon les
