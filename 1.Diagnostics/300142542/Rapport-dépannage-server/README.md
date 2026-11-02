# Rapport de dépannage et validation POST – HP ProLiant DL360 G6

## 1. Contexte et problématique

Le serveur rencontrait un problème de démarrage (absence de POST / le serveur ne démarrait pas). Conformément à la procédure d'isolation de panne recommandée, l'objectif était de tester individuellement le second processeur (CPU2) dans le premier emplacement (Socket 1 / Proc 1), afin d'écarter un dysfonctionnement du Socket 2 ou d'un composant défectueux.
<img width="900" height="1600" alt="WhatsApp Image 2026-09-24 at 09 26 23" src="https://github.com/user-attachments/assets/4fdef68f-2e88-48ac-8616-7e7ec427878d" />

## 2. Configuration matérielle de test (configuration minimale POST)

Conformément aux prérequis de la configuration minimale POST :

Processeur (Proc 1) : un processeur Intel Xeon E5620 (2,40 GHz) / E5540 (2,53 GHz) installé dans le Socket 1.

Mémoire (DIMM) : une barrette de mémoire installée dans le premier slot blanc du CPU1 (PROC 1 DIMM 3 / Slot A1).

Stockage et cartes : tests d'amorçage réalisés sans cartes d'extension PCIe supplémentaires.

Alimentation : unités d'alimentation connectées en configuration simple (message d'avertissement standard 1615-Power Supply Failure or Power Supply Unplugged in Bay 2, causé par la seule présence de la baie 1).
<img width="900" height="1600" alt="WhatsApp Image 2026-09-24 at 09 26 23 (1)" src="https://github.com/user-attachments/assets/516caa38-8c75-4a76-9540-6602f0d029c1" />
<img width="900" height="1600" alt="WhatsApp Image 2026-09-24 at 09 26 23 (1)" src="https://github.com/user-attachments/assets/516caa38-8c75-4a76-9540-6602f0d029c1" />



## 3. Résultats des tests et captures d'écran

A. Écran de démarrage BIOS et détection du processeur
<img width="900" height="1600" alt="WhatsApp Image 2026-09-24 at 09 26 23 (3)" src="https://github.com/user-attachments/assets/9cbc1479-1e81-42bb-b930-334e551cc353" />

Lors du démarrage, le serveur passe l'étape POST (Power-On Self-Test) :

Processeur détecté : 1 Processor(s) detected, 4 total cores enabled, Hyperthreading is enabled

Modèle : Intel(R) Xeon(R) CPU E5620 @ 2.40GHz (ou E5540 @ 2.53GHz)

Statut de démarrage : progression de l'étalonnage thermique (Power and Thermal Calibration in Progress...) et chargement du BIOS sans erreur critique de socket.

B. Diagnostic de la mémoire BIOS (BIOS Memory Diagnostic)

Accès à l'utilitaire de diagnostic mémoire pour valider la configuration des bancs RAM :

PROC 1 DIMM 3 : 8192 MB détectés.
<img width="1600" height="900" alt="WhatsApp Image 2026-09-24 at 09 26 23 (4)" src="https://github.com/user-attachments/assets/d8fd18d8-3f85-4668-99e2-58ae8b4cf028" />


Tous les autres emplacements (PROC 1 et PROC 2) indiquent « Not Installed ».

Mémoire totale configurée / disponible : 8192 MB OK.

## C. Configuration système BIOS (utilitaire RBSU)

Dans le ROM-Based Setup Utility (version 3.00) :

Proc 1 : Intel 2.53GHz, 8MB L3 Cache.

Proc 2 : Not Installed.
<img width="1600" height="900" alt="WhatsApp Image 2026-09-24 at 09 26 23 (6)" src="https://github.com/user-attachments/assets/a25c88d0-0757-4036-a925-cca1c95c61b2" />


Mémoire totale : détection confirmée jusqu'à 65 536 MB (64 GB) selon la configuration finale des barrettes réinstallées.




D. Utilitaire de diagnostic système (Diagnostic Utility v2.15)

Le menu principal du diagnostic HP est accessible pour exécuter les tests ciblés :

Memory Test

CPU Test

Boot Disk Test

## 4. Conclusion du diagnostic

Validation du processeur et du Socket 1 : le processeur testé dans le Socket 1 démarre correctement et valide le POST.
Cause identifiée : le test confirme que le processeur utilisé est fonctionnel. Si le serveur ne démarrait pas lorsque le second socket était occupé, le problème est localisé au niveau du Socket 2 (broches pliées/endommagées) ou de son canal mémoire dédié.

HP ProLiant DL360 G6 – Diagnostic et résolution de panne

Description

Ce projet documente le dépannage d'un serveur HP ProLiant DL360 G6 qui ne démarrait pas. L'objectif était de procéder par élimination en testant la configuration minimale POST et en vérifiant l'état du processeur et du socket.

Étape de test : isolation CPU et configuration minimale POST

Processeur : 1x Intel Xeon (Socket 1)

Mémoire : 1x 8 GB DIMM (Proc 1 Slot 3 / White Slot A1)

Alimentation : Bay 1 alimentée

Résultats obtenus

Power-On Self-Test (POST) : réussi (1 Processor(s) detected).

Diagnostic mémoire BIOS : barrette de 8192 MB détectée sur PROC 1 DIMM 3.

Statut RBSU : Proc 1 reconnu, Proc 2 indiqué comme non installé.

Conclusion : le CPU et le Socket 1 sont pleinement fonctionnels. Le défaut de démarrage initial est attribué au Socket 2 ou à ses broches.

Captures d'écran du diagnostic

Écran POST : détection du CPU Xeon et vitesse QPI.

Memory Diagnostic : validation du slot DIMM 3.

RBSU Utility : configuration générale et mémoire système.

