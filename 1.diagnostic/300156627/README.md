
### 300156627

# Rapport de dépannage et validation POST – HP ProLiant DL360 G6

# 1. Contexte et Problématique
Le serveur présentait un problème de démarrage (absence de POST / serveur ne démarre pas). Dans la démarche d'isolation de la panne conseillée,
l'objectif était de tester individuellement le second processeur (CPU2) dans le premier emplacement (Socket 1 / Proc 1)
afin d'exclure un dysfonctionnement de Socket 2 ou un composant défectueux.

# 2. Configuration matérielle de test (Configuration minimale POST)
Conformément aux prérequis de configuration minimale (Minimum POST Configuration) :
# Processeur (Proc 1) : 
1 processeur Intel Xeon E5620 (2.40 GHz) / E5540 (2.53 GHz) installé dans le Socket 1.   
# Mémoire (DIMM) : 
1 barrette de mémoire installée dans le premier slot blanc de CPU1 (PROC 1 DIMM 3 / Slot A1).
# Stockage & Cartes : 
Tests d'amorçage réalisés sans cartes d'extension PCIe supplémentaires.
# Alimentation : 
Unités d'alimentation connectées en configuration simple (message d'avertissement standard 1615-Power Supply Failure or Power Supply Unplugged in Bay 2 causé par la seule présence de la baie 1).
# 3. Résultats des tests et captures d'écran
# A. Écran de démarrage BIOS et détection du processeur
Lors du démarrage, le serveur passe l'étape POST (Power-On Self-Test) :
Processeur détecté : 1 Processor(s) detected, 4 total cores enabled, Hyperthreading is enabled
Modèle : Intel(R) Xeon(R) CPU E5620 @ 2.40GHz (ou E5540 @ 2.53GHz).
Statut de démarrage : Progression de l'étalonnage thermique (Power and Thermal Calibration in Progress...) et chargement du BIOS sans erreur critique de socket.
# B. Diagnostic de la mémoire BIOS (BIOS Memory Diagnostic)
Accès à l'utilitaire de diagnostic mémoire pour valider la configuration des bancs RAM :   PROC 1 DIMM 3 : 8192 MB détectés.   Tous les autres emplacements (PROC 1 et PROC 2) indiquent Not Installed.   Mémoire totale configurée / disponible : 8192 MB OK.   C. Configuration système BIOS (RBSU - Utility)Dans le ROM-Based Setup Utility (Version 3.00) :   Proc 1 : Intel 2.53GHz, 8MB L3 Cache.   Proc 2 : Not Installed.   Mémoire totale : Détection confirmée jusqu'à 65 536 MB (64 GB) selon la configuration finale de barrettes réinstallées. 


