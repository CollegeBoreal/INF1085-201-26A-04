
### 300156627

# Rapport de dépannage et validation POST – HP ProLiant DL360 G6

# 1. Contexte et Problématique
Le serveur présentait un problème de démarrage (absence de POST / serveur ne démarre pas). Dans la démarche d'isolation de la panne conseillée,
l'objectif était de tester individuellement le second processeur (CPU2) dans le premier emplacement (Socket 1 / Proc 1)
afin d'exclure un dysfonctionnement de Socket 2 ou un composant défectueux.

# 2. Configuration matérielle de test (Configuration minimale POST)
Conformément aux prérequis de configuration minimale (Minimum POST Configuration) :
# Processeur (Proc 1) : 1 processeur Intel Xeon E5620 (2.40 GHz) / E5540 (2.53 GHz) installé dans le Socket 1.   
# Mémoire (DIMM) : 1 barrette de mémoire installée dans le premier slot blanc de CPU1 (PROC 1 DIMM 3 / Slot A1).
# Stockage & Cartes : Tests d'amorçage réalisés sans cartes d'extension PCIe supplémentaires.
# Alimentation : Unités d'alimentation connectées en configuration simple (message d'avertissement standard 1615-Power Supply Failure or Power Supply Unplugged in Bay 2 causé par la seule présence de la baie 1). 

