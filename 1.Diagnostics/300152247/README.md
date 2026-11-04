Les captures du diagnostiques : Rapport de dépannage, validation matérielle et installation Proxmox Serveur HP ProLiant DL360 G6

<img width="680" height="685" alt="image" src="https://github.com/user-attachments/assets/30f449b0-4e14-4d16-8e4e-7e154c7e3790" />
<img width="683" height="683" alt="image" src="https://github.com/user-attachments/assets/c6b993bb-def1-4a59-831f-e4d259eea4bf" />
<img width="676" height="675" alt="image" src="https://github.com/user-attachments/assets/bdea7d88-0e1d-4d52-934e-318bdde2774f" />

# 1. Introduction

Dans le cadre de ce travail pratique, nous avons réalisé une intervention technique sur un serveur **HP ProLiant DL360 G6** afin d'identifier l'origine de ses problèmes de démarrage et de rétablir son fonctionnement.

Pour effectuer ce diagnostic, nous avons examiné progressivement les différents composants matériels du serveur, notamment les processeurs, la mémoire vive (RAM), les disques durs et le système de refroidissement.

Une fois les vérifications matérielles terminées, nous avons procédé aux tests de démarrage (POST), puis nous avons confirmé le bon fonctionnement de la machine en accédant à l'environnement **Proxmox Virtual Environment**.

# 2. Examen des composants internes

Nous avons commencé par ouvrir le boîtier du serveur afin d'examiner son architecture interne et de repérer les différents composants.

Cette inspection nous a permis de localiser les processeurs, les emplacements réservés aux barrettes de mémoire RAM, les ventilateurs ainsi que les principaux éléments de la carte mère.

**Figure 1 :** Vue générale de l'intérieur du serveur et des emplacements destinés aux processeurs.

Cette première étape était nécessaire pour évaluer l'état général du matériel et repérer d'éventuelles anomalies physiques avant de poursuivre les tests.

# 3. Contrôle des processeurs

Le serveur HP ProLiant DL360 G6 dispose de deux sockets destinés à accueillir les processeurs, identifiés comme Processor 1 et Processor 2.

Durant cette intervention, nous avons retiré les processeurs, puis procédé à leur réinstallation afin de contrôler leur positionnement et leur fixation.

**Figure 2 :** Processeur installé dans son emplacement.

**Figure 3 :** Processeur retiré pour effectuer une inspection.

Cette manipulation nous a permis d'examiner l'état des composants et de vérifier que leur installation ne présentait aucune anomalie visible.

# 4. Remise en place des dissipateurs thermiques

Après avoir terminé le contrôle des processeurs, nous avons procédé à la réinstallation des dissipateurs thermiques.

Ces éléments jouent un rôle essentiel dans le refroidissement du serveur, puisqu'ils permettent de transférer et d'évacuer la chaleur générée par les processeurs durant leur utilisation.

**Figure 4 :** Dissipateurs thermiques remis en place sur les processeurs.

Leur installation correcte est indispensable pour maintenir une température de fonctionnement appropriée et éviter les problèmes liés à une surchauffe.

# 5. Inspection de la mémoire vive (RAM)

Nous avons ensuite examiné les barrettes de mémoire RAM ainsi que leur disposition dans les différents emplacements DIMM.

Il était important de vérifier que chaque barrette était correctement installée et que sa position respectait la configuration matérielle du serveur.

**Figure 5 :** Barrettes de mémoire RAM installées dans les emplacements DIMM.

Pour faciliter l'identification d'une éventuelle défaillance, nous avons utilisé une approche progressive consistant à tester la mémoire avec un nombre limité de barrettes, puis à réintégrer les autres progressivement.

Cette méthode permet de déterminer plus facilement si un problème provient d'une barrette de mémoire ou d'un emplacement particulier.

# 6. Retrait de certains composants pour les tests

Dans le cadre du processus de diagnostic, nous avons également retiré les disques durs ainsi que plusieurs barrettes de mémoire RAM.

**Figure 6 :** Disques durs HP et barrettes de mémoire retirés durant les opérations de diagnostic.

Le retrait temporaire des disques durs permet de vérifier le comportement du serveur indépendamment du système de stockage. Cela facilite l'identification de l'origine d'un éventuel problème matériel.

Cette étape contribue à isoler les composants et à poursuivre les vérifications dans de meilleures conditions.

# 7. Mise sous tension et validation du POST

Après les différentes manipulations, nous avons remis en place les composants nécessaires et procédé à la mise sous tension du serveur.

Au démarrage, l'écran HP ProLiant a affiché le message suivant :

**Power and Thermal Calibration in Progress**

**Figure 7 :** Séquence de démarrage du serveur HP ProLiant et calibration thermique.

L'affichage de ce message indique que le serveur a commencé sa séquence d'initialisation matérielle.

Le POST (*Power-On Self-Test*) correspond à une série de vérifications effectuées automatiquement au démarrage. Il permet notamment de contrôler les principaux composants avant le lancement du système d'exploitation.

# 8. Analyse de la mémoire à partir du BIOS

Afin d'approfondir les vérifications, nous avons utilisé l'outil **BIOS Memory Diagnostic**, accessible depuis l'environnement de configuration du serveur.

**Figure 8 :** Interface du diagnostic de la mémoire dans le BIOS.

Les informations affichées indiquent la présence de plusieurs barrettes de mémoire d'une capacité individuelle de **16 384 MB (16 Go)**, installées sur le processeur 1.

La capacité totale de mémoire détectée et configurée est de :

**65 536 MB, soit 64 Go de RAM.**

Au moment de la capture, le diagnostic était toujours en cours d'exécution. L'interface indiquait également la quantité de mémoire ayant déjà été testée avec succès.

Cette vérification nous a permis de confirmer que le BIOS reconnaissait les barrettes installées et pouvait accéder à la mémoire disponible.

# 9. Contrôle final et état des composants

Une fois les vérifications des processeurs et de la mémoire terminées, nous avons procédé au remontage des éléments nécessaires au fonctionnement normal du serveur.

Les dissipateurs thermiques et les ventilateurs ont été remis en place afin de rétablir la configuration matérielle complète.

Le tableau suivant présente les résultats des différentes vérifications effectuées :

| Composant | État constaté |
|---|---|
| Processeur 1 | Détecté et fonctionnel |
| Processeur 2 | Installé et vérifié |
| Sockets des processeurs | Inspectés |
| Mémoire RAM | Détectée par le BIOS |
| Capacité mémoire | 65 536 MB (64 Go) |
| Disques durs | Vérifiés et réinstallés |
| Ventilateurs | Remis en place |
| POST | Démarrage réussi |
| BIOS | Accessible |

Ces contrôles nous ont permis de valider les principaux éléments matériels et de poursuivre vers la vérification du système installé sur le serveur.

# 10. Préparation du stockage et configuration RAID

Avant de procéder à l'installation de Proxmox VE, nous avons configuré le système de stockage à l'aide du contrôleur **HP Smart Array P410i**.

Pour cette configuration, nous avons sélectionné trois disques SAS ayant chacun une capacité de 146,8 Go.

Ces trois disques ont été regroupés afin de créer un volume logique utilisant le niveau RAID 5.

Après la configuration, le volume obtenu présente une capacité d'environ **293,56 Go**.

Cette organisation permet de regrouper l'espace de stockage des trois disques dans un volume logique unique, qui sera utilisé pour accueillir l'installation de Proxmox VE.

# 11. Installation et démarrage de Proxmox VE

Après avoir terminé les opérations de diagnostic et préparé le stockage, nous avons procédé à l'installation et au démarrage de **Proxmox Virtual Environment** sur le serveur.

**Figure 9 :** Interface de démarrage de Proxmox Virtual Environment.

Une fois le système lancé, le serveur a affiché le message :

**Welcome to the Proxmox Virtual Environment**

L'accès à l'interface d'administration est possible depuis un navigateur Web en utilisant l'adresse suivante :

**https://192.168.100.2:8006/**

Nous avons également constaté la présence de l'invite de commande :

`root@server1:~#`

Ces éléments confirment que Proxmox VE a démarré correctement et que nous avons pu accéder à son environnement de fonctionnement.

# 12. Conclusion

Ce travail pratique nous a permis de réaliser un diagnostic matériel complet sur un serveur HP ProLiant DL360 G6 et de comprendre les différentes étapes nécessaires à la remise en fonctionnement d'une machine serveur.

Nous avons notamment appris à examiner les composants internes, à manipuler les processeurs, à contrôler la mémoire RAM, à effectuer des vérifications à partir du BIOS et à valider la séquence de démarrage grâce au POST.

Nous avons également découvert la configuration du stockage avec le contrôleur HP Smart Array P410i et la création d'un volume logique en RAID 5.

Enfin, le démarrage réussi de Proxmox Virtual Environment nous a permis de confirmer le bon fonctionnement du serveur et de franchir une première étape vers son utilisation comme plateforme de virtualisation.


