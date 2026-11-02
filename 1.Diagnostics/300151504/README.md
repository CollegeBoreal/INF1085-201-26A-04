# INF1085 – Administration Linux

Rapport de dépannage, validation matérielle et installation Proxmox
Serveur HP ProLiant DL360 G6
1. Introduction
Dans le cadre de ce travail pratique, nous avons effectué le diagnostic et la remise en fonctionnement d’un serveur HP ProLiant DL360 G6.
Le serveur présentait des problèmes de démarrage. Pour trouver l’origine du problème, nous avons procédé étape par étape en vérifiant les principaux composants matériels comme les processeurs, la mémoire RAM et les disques durs.
Après les tests matériels et la validation du POST, nous avons également réussi à démarrer le serveur et à accéder à Proxmox Virtual Environment.

3. Inspection du matériel
La première étape consistait à ouvrir le serveur afin d’accéder aux composants internes.
Nous avons identifié les processeurs, les emplacements de mémoire RAM, les ventilateurs et les autres composants de la carte mère.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/5554cc80-df92-4897-a395-72c773bf9dec" />

Figure 1 : Vue interne du serveur et des deux emplacements processeurs
Cette inspection permet de vérifier si les processeurs sont correctement installés et s’il existe un problème visible au niveau des sockets ou de la carte mère.
3. Vérification des processeurs
Le serveur possède deux emplacements pour processeurs appelés Processor 1 et Processor 2.
Pendant le diagnostic, les processeurs ont été retirés et réinstallés afin de vérifier leur fonctionnement.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/2821acaf-60b5-45a7-8027-53584006310f" />

Figure 2 : Processeur installé dans son socket
Cette étape permet de vérifier le positionnement du processeur ainsi que le système de fixation.
Nous avons également observé le processeur après son retrait.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/4159be66-2469-4538-8f32-2884a83064b6" />

Figure 3 : Processeur retiré du serveur pour inspection
Cette vérification est importante afin de s’assurer que les contacts du processeur ne sont pas endommagés.
4. Installation des dissipateurs thermiques
Après avoir vérifié les processeurs, les dissipateurs thermiques ont été remis en place.
Ils permettent d’évacuer la chaleur produite par les processeurs pendant le fonctionnement.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/d6dd21c5-7bb3-481e-b28f-a5180b72191a" />

Figure 4 : Dissipateurs thermiques installés sur les processeurs
Une mauvaise installation du dissipateur peut provoquer une surchauffe et empêcher le serveur de fonctionner normalement.
5. Vérification de la mémoire RAM
La mémoire RAM a également été vérifiée pendant le diagnostic.
Les barrettes doivent être placées dans les bons emplacements DIMM selon la configuration du serveur et les processeurs utilisés.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/ed2457af-e6a4-42ee-aff0-db00e5a06951" />

Figure 5 : Mémoire RAM installée dans les emplacements DIMM
Pour faciliter le dépannage, il est possible de commencer avec une seule barrette de mémoire puis d’ajouter progressivement les autres barrettes.
Cette méthode permet de vérifier si une barrette ou un emplacement mémoire est responsable du problème.
6. Composants retirés pendant le diagnostic
Les disques durs et plusieurs barrettes de RAM ont également été retirés pendant les tests.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/bb12bc21-a606-4ff2-85e3-c0c4c76d279e" />

Figure 6 : Disques durs HP et barrettes de mémoire retirés pendant le diagnostic
Le retrait des disques permet de réaliser le POST indépendamment du système de stockage.
Il devient alors plus facile de déterminer si le problème vient du processeur, de la mémoire ou du stockage.
7. Démarrage du serveur et test POST
Après avoir réinstallé les composants nécessaires, le serveur a été mis sous tension.
Le serveur affiche l’écran HP ProLiant et commence l’étape :
Power and Thermal Calibration in Progress
<img width="2048" height="2048" alt="1" src="https://github.com/user-attachments/assets/c7bfeec7-673e-4861-9473-f646a1668090" />

Figure 7 : Démarrage du HP ProLiant et calibration thermique
Cette étape montre que le serveur est capable de commencer correctement sa séquence de démarrage.
Le POST, ou Power-On Self-Test, permet au serveur de vérifier les principaux composants avant de lancer le système d’exploitation.
8. Diagnostic de la mémoire avec le BIOS
Nous avons ensuite utilisé l’utilitaire BIOS Memory Diagnostic.
<img width="2048" height="2048" alt="2" src="https://github.com/user-attachments/assets/dcc7ecf2-1d36-4a39-a506-28deb7b4d997" />

Figure 8 : Diagnostic de la mémoire dans le BIOS
Le diagnostic montre plusieurs barrettes de 16 384 MB, soit 16 Go chacune, installées sur le processeur 1.
La mémoire totale configurée affichée est de :
65 536 MB, soit environ 64 Go de RAM.
Sur la photo, le test mémoire est toujours en cours. Le BIOS affiche également la quantité de mémoire déjà testée avec succès.
Cette étape permet de vérifier que les barrettes sont reconnues par le serveur et que le BIOS peut accéder à la mémoire installée.
9. Vérification finale du matériel
Après la vérification des processeurs et de la mémoire, les dissipateurs ont été correctement remontés et les ventilateurs ont été remis en place.

Le serveur peut ensuite fonctionner avec sa configuration normale.
À cette étape, les principaux composants ont été vérifiés :
Composant	Résultat
Processeur 1	Détecté et fonctionnel
Processeur 2	Installé et vérifié
Sockets processeurs	Vérifiés
Mémoire RAM	Détectée
Mémoire configurée	65 536 MB / 64 Go
Disques durs	Vérifiés et réinstallés
Ventilateurs	Fonctionnels
POST	Réussi
BIOS	Accessible


10. Installation et démarrage de Proxmox
Après avoir terminé le diagnostic matériel, nous avons installé et démarré Proxmox Virtual Environment sur le serveur.
<img width="2048" height="2048" alt="image" src="https://github.com/user-attachments/assets/d9d05c3e-1e72-47cd-9c99-fff5d9b313a6" />

Figure 9 : Proxmox Virtual Environment démarré sur le serveur
L’écran affiche :
Welcome to the Proxmox Virtual Environment

Le serveur est accessible à partir d’un navigateur Web à l’adresse :
https://192.168.100.2:8006/

Le système affiche également l’invite :
root@server1:~#

Cela confirme que Proxmox fonctionne correctement et que le serveur a réussi à charger le système d’exploitation.
11. Validation du fonctionnement du serveur
Le démarrage de Proxmox constitue une étape importante dans la validation du serveur.
Cela permet de confirmer que plusieurs composants fonctionnent correctement :
- les processeurs
- la mémoire RAM
- le contrôleur de stockage
- les disques
- la carte réseau
- le BIOS
- le système de refroidissement
Le serveur dispose maintenant d’un environnement de virtualisation fonctionnel qui peut être administré depuis un navigateur Web.
12. Résultats obtenus
À la fin du travail, nous avons réussi à :
1. Ouvrir et inspecter le serveur.
2. Retirer les processeurs pour les vérifier.
3. Vérifier les sockets des processeurs.
4. Réinstaller correctement les processeurs.
5. Vérifier les barrettes de mémoire.
6. Tester la mémoire avec le BIOS.
7. Vérifier les disques durs.
8. Réinstaller les dissipateurs thermiques.
9. Réussir le POST du serveur.
10. Démarrer correctement le serveur.
11. Installer et lancer Proxmox Virtual Environment.
12. Accéder au système avec le compte root.
13. Conclusion
Ce travail pratique nous a permis de réaliser le dépannage complet d’un serveur HP ProLiant DL360 G6.
Nous avons commencé par vérifier les composants matériels un par un afin d’isoler la cause du problème de démarrage.
Les processeurs ont été retirés puis vérifiés et réinstallés. La mémoire RAM a également été testée à l’aide de l’utilitaire de diagnostic du BIOS.
Le serveur a finalement réussi son POST et le BIOS a détecté jusqu’à 64 Go de mémoire RAM dans la configuration testée.
Après la validation du matériel, nous avons pu démarrer Proxmox Virtual Environment. L’interface indique que le serveur est disponible sur le réseau à l’adresse 192.168.100.2 avec le port 8006.
Le serveur est donc maintenant fonctionnel et prêt à être utilisé comme plateforme de virtualisation.
Cette activité nous a permis de comprendre qu’un dépannage efficace doit être réalisé progressivement en testant les composants séparément avant de remettre le serveur dans sa configuration complète.
