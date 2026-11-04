# Diagnostic matériel et configuration du serveur HP ProLiant DL360 G6

**Cours :** INF1085-201-26A-04 — 1.Diagnostics  
**Étudiante :** Salma Baali  
**Équipement :** HP ProLiant DL360 G6

---

## 1. Objectif du laboratoire

L'objectif de ce laboratoire est de diagnostiquer un problème de démarrage (POST) sur un serveur HP ProLiant DL360 G6 et de vérifier le fonctionnement de ses composants matériels.

Les vérifications portent principalement sur :

- L'installation et la détection des processeurs.
- La configuration minimale nécessaire au POST.
- La détection et la capacité de la mémoire système.
- L'accès au BIOS et au RBSU (ROM-Based Setup Utility).
- Les options de diagnostic disponibles.
- L'identification de la cause possible du problème.

## 2. Présentation du serveur et inspection visuelle

Le serveur est ouvert afin d'observer les composants internes et de préparer les manipulations nécessaires au diagnostic.

![Serveur ouvert](images/03-serveur-ouvert.jpg)

*Figure 1 — Vue du serveur HP ProLiant DL360 G6 ouvert.*

## 3. Manipulation du dissipateur thermique

Cette étape permet d'accéder aux processeurs et d'observer leur installation ainsi que les éléments de refroidissement.

La manipulation doit être effectuée avec précaution afin de préserver les composants matériels.

![Manipulation du dissipateur thermique](images/04-manipulation-dissipateur.jpg)

*Figure 2 — Manipulation du dissipateur thermique.*

## 4. Vérification des processeurs

Le serveur possède deux emplacements pour processeurs. L'inspection permet de vérifier leur présence et leur installation sur la carte mère.

![Deux processeurs](images/06-deux-processeurs.jpg)

*Figure 3 — Vue des deux processeurs.*

Le diagnostic vise à déterminer si le problème provient d'un processeur, de son emplacement ou d'un autre composant associé.

## 5. Configuration minimale pour le POST

Afin de simplifier le diagnostic, une configuration matérielle minimale est utilisée.

Les éléments de configuration indiqués dans les observations du laboratoire sont :

| Élément | Configuration |
|---|---|
| Processeur | Un seul processeur installé dans le socket 1 (PROC 1) |
| Modèles de processeurs mentionnés | Intel Xeon E5620 2,40 GHz ou E5540 2,53 GHz |
| Mémoire | Une barrette de 8 Go |
| Emplacement mémoire | PROC 1 DIMM 3 (emplacement blanc A1) |
| Cartes PCIe | Aucune carte PCIe supplémentaire |
| Alimentation | Bloc d'alimentation dans la baie 1 uniquement |

Cette configuration permet de réduire le nombre de composants utilisés pendant le diagnostic et de faciliter l'identification d'une anomalie.

## 6. Démarrage et calibration thermique

Lors du démarrage, le serveur affiche le message :

`Power and Thermal Calibration in Progress`

Cette étape fait partie de l'initialisation du serveur.

![Calibration thermique](images/07-calibration-thermique.jpg)

*Figure 4 — Écran de calibration thermique.*

## 7. Configuration générale du BIOS et du RBSU

Le ROM-Based Setup Utility (RBSU) est un utilitaire intégré au serveur HP ProLiant. Il permet de consulter et de configurer les paramètres matériels du système.

L'accès au menu de configuration se fait à partir de l'écran de démarrage, avec la touche F9.

Les fonctions du RBSU concernent notamment :

- La configuration générale du serveur.
- Les paramètres du processeur.
- La mémoire système.
- Les options de démarrage.
- Les paramètres matériels disponibles.

![Menu BIOS](images/08-menu-bios.jpg)

*Figure 5 — Menu de démarrage et accès aux utilitaires du serveur.*

**Version du RBSU observée :** 3.00.

Le menu de démarrage présente notamment les options suivantes :

| Touche | Fonction |
|---|---|
| F1 | Continuer |
| F9 | Accéder au RBSU |
| F10 | System Maintenance Menu |
| F11 | Options de démarrage |
| F12 | Démarrage réseau |

La capture montre le menu d'accès. Elle ne constitue pas une preuve visuelle de chaque sous-menu du RBSU.

## 8. Configuration et vérification de la mémoire système

La mémoire système est vérifiée à partir des informations affichées par le BIOS et de l'utilitaire de diagnostic mémoire.

La configuration minimale utilisée pendant le diagnostic comprend une barrette de 8 Go installée dans l'emplacement indiqué précédemment.

La capacité mémoire maximale mentionnée pour le serveur est de **65 536 MB, soit 64 Go**.

Les observations du laboratoire présentent différents résultats :

| Vérification | Résultat observé |
|---|---|
| Premier affichage POST | 16 GB Installed |
| Deuxième affichage POST | 64 GB Installed |
| Diagnostic mémoire | 65 536 MB configurés |
| Mémoire disponible affichée | 65 536 MB |

### 8.1 Premier affichage POST — 16 Go

![Premier affichage POST](images/09-post-16go.jpg)

*Figure 6 — Affichage de 16 Go de mémoire pendant le POST.*

### 8.2 Diagnostic mémoire

![Diagnostic mémoire](images/10-diagnostic-memoire.jpg)

*Figure 7 — Résultat du diagnostic de la mémoire système.*

### 8.3 Deuxième affichage POST — 64 Go

![Deuxième affichage POST](images/11-post-64go.jpg)

*Figure 8 — Affichage de 64 Go de mémoire pendant le POST.*

Ces résultats montrent que la capacité de mémoire reconnue varie entre les captures. Le diagnostic mémoire indique 65 536 MB configurés et disponibles au moment de la capture.

## 9. Vérification du démarrage et des options de diagnostic

Le serveur propose plusieurs outils de diagnostic accessibles depuis ses menus de maintenance.

Les catégories mentionnées dans les observations comprennent :

- **Memory :** vérification de la mémoire système.
- **CPU :** vérification des processeurs.
- **Boot Disk :** vérification du disque de démarrage.

Ces outils permettent d'examiner différents composants et de recueillir des informations utiles au diagnostic.

## 10. Analyse de la détection des processeurs

Pendant le test avec la configuration minimale, le serveur effectue le POST avec un seul processeur installé dans le socket 1.

Les informations observées indiquent :

- Un processeur Intel Xeon détecté.
- Une fréquence de 2,40 GHz pour le modèle E5620.
- Quatre cœurs activés.
- L'Hyper-Threading activé.
- Le deuxième processeur affiché comme « Not Installed ».

Le test avec le processeur placé dans le socket 1 permet de vérifier le fonctionnement de cette configuration minimale.

Le fait que le deuxième processeur ne soit pas détecté peut être lié au processeur secondaire, au socket 2, au canal associé ou à un autre problème matériel.

Il faut toutefois distinguer le symptôme observé de la cause définitive : un test croisé documenté et les vérifications recommandées par HP sont nécessaires pour confirmer précisément l'origine de la panne.

## 11. Problème de démarrage réseau

Une tentative de démarrage réseau affiche le message suivant :

`PXE-E61: Media test failure, check cable`

Puis :

`PXE-M0F: Exiting Broadcom PXE ROM`

![Erreur PXE](images/12-erreur-pxe.jpg)

*Figure 9 — Message d'échec du démarrage réseau.*

Ces messages indiquent que la tentative de démarrage par le réseau n'a pas abouti. Il faut vérifier la connexion réseau, la disponibilité du serveur de démarrage et l'ordre de démarrage configuré.

Cette erreur ne prouve pas à elle seule que le serveur est incapable de démarrer à partir d'un autre support.

## 12. Tableau récapitulatif des résultats

| Élément vérifié | Résultat |
|---|---|
| Inspection matérielle | Serveur ouvert et composants observés |
| Processeur principal | Détecté dans la configuration minimale |
| Deuxième processeur | Affiché « Not Installed » pendant le test minimal |
| POST | Réalisé avec la configuration minimale |
| Mémoire minimale | Une barrette de 8 Go dans PROC 1 DIMM 3 |
| Mémoire affichée | 16 Go puis 64 Go selon les captures |
| Diagnostic mémoire | 65 536 MB configurés et disponibles |
| RBSU | Version 3.00 mentionnée dans les observations |
| Diagnostic matériel | Menus Memory, CPU et Boot Disk |
| Démarrage réseau | Échec PXE-E61 |

## 13. Conclusion

Ce laboratoire a permis d'examiner le fonctionnement matériel du serveur HP ProLiant DL360 G6 et d'effectuer plusieurs vérifications liées au POST, aux processeurs et à la mémoire système.

La configuration minimale permet de réduire les composants utilisés pendant le diagnostic et d'observer le comportement du serveur avec un seul processeur installé dans le socket 1.

Les observations montrent que le processeur principal est détecté, tandis que le deuxième processeur apparaît comme « Not Installed » pendant le test minimal.

Les captures de mémoire montrent différentes capacités reconnues, soit 16 Go et 64 Go. Le diagnostic mémoire indique 65 536 MB configurés et disponibles.

Le RBSU permet d'accéder aux paramètres généraux du serveur et à la configuration matérielle. Les outils de diagnostic permettent également d'examiner la mémoire, les processeurs et le disque de démarrage.

Enfin, le message PXE-E61 indique un échec de la tentative de démarrage réseau.

Le diagnostic met donc en évidence un problème de détection du deuxième processeur qui nécessite des vérifications supplémentaires pour confirmer si l'origine se trouve au niveau du processeur, du socket ou du canal associé.

## 14. Référence

[Répertoire du laboratoire INF1085 — 1.Diagnostics](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/1.Diagnostics)

---

*Rapport réalisé à partir des observations et des photographies du laboratoire.*
