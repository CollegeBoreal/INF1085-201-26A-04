

🖥️ Démontage et remontage d'un serveur HP ProLiant DL360 G6
Étudiante : Fairouz Sadoun
Matricule : 300155881
Programme : Techniques des systèmes informatiques
Module : INF1085 – Administration Linux

Note : Les valeurs techniques ci-dessous proviennent du modèle de laboratoire fourni. Il faut les vérifier à l'aide des photos et observations faites en classe avant d'affirmer qu'il s'agit de nos résultats.

🎯 Objectif du laboratoire
L'objectif est de démonter, identifier et remonter les principaux composants matériels d'un serveur HP ProLiant DL360 G6. Le laboratoire porte également sur les vérifications au démarrage (POST/BIOS), la détection des processeurs et de la mémoire, ainsi que la configuration du stockage RAID.

🔍 Matériel identifié dans le modèle
💽 3 disques durs SAS de 146 Go
🔌 2 blocs d'alimentation HP
🧠 2 barrettes RAM de 16 Go
🧠 8 barrettes RAM de 4 Go
⚙️ 2 processeurs Intel Xeon E5540 à 2,53 GHz
💾 Contrôleur RAID avec module de mémoire cache
Confirmer ces composants avec les photos de notre serveur.

🔧 Partie 1 — Démontage du serveur
🔌 Étape 1 — Retrait des blocs d'alimentation
Lors du démontage présenté en laboratoire, les blocs d'alimentation du serveur sont identifiés puis retirés après la mise hors tension et le débranchement du matériel.
![Blocs d'alimentation du serveur HP](images/IMG_2702.jpg)


💽 Étape 2 — Retrait des disques durs
Les trois disques SAS sont retirés des baies hot-swap situées à l'avant du serveur. Leurs caractéristiques sont observées sur les étiquettes.





🧠 Étape 3 — Retrait des barrettes RAM
Les barrettes RAM sont identifiées selon leur capacité et leur emplacement. Le modèle mentionne de la mémoire PC3-8500R, dont des barrettes de 16 Go et de 4 Go.



⚙️ Étape 4 — Retrait du processeur
Après retrait du système de refroidissement par une personne autorisée, le processeur et son socket sont examinés. Les contacts sont fragiles et ne doivent pas être manipulés sans supervision.



💾 Étape 5 — Identification du module de mémoire cache
Le module de mémoire cache associé au contrôleur RAID est repéré dans le serveur.



🧪 Partie 2 — Tests des composants
🟢 Étape 6 — Premier démarrage avec un processeur
![BIOS avec 16 Go de RAM](images/WhatsApp%20Image%202026-11-19%20at%2000.33.23.jpeg)
Dans le modèle, le premier test utilise un processeur et une barrette de RAM de 16 Go. L'écran de démarrage indique :

16 GB Installed
1 Processor
Intel Xeon E5540 @ 2.53 GHz
La touche F9 donne accès à l'utilitaire de configuration. L'écran ROM-Based Setup Utility affiche Proc 2 Not Installed.


### Vérification du BIOS avec 64 Go de RAM

Lors d'un autre démarrage, j'ai observé que le serveur HP ProLiant détectait 64 Go de RAM et un processeur Intel Xeon E5620 à 2,40 GHz avec quatre cœurs activés.
![Mon BIOS avec 64 Go de RAM](images/WhatsApp%20Image%202026-11-19%20at%2000.33.52.jpeg)



🟢 Étape 7 — Deuxième démarrage avec deux processeurs
Dans le deuxième test du modèle, deux processeurs et une barrette RAM de 16 Go sont installés. Le BIOS indique 16384 MB Memory Configured et détecte Processor 1 ainsi que Processor 2.



💽 Partie 3 — Configuration du stockage RAID
🛠️ Étape 8 — Accès à l'utilitaire RAID
L'utilitaire HP Array Configuration Utility permet de consulter, créer et supprimer des volumes logiques (Logical Drives).



🗑️ Étape 9 — Vérification de l'ancien volume
Le modèle présente un ancien volume RAID 5 d'environ 273,4 Go. Sa suppression est décrite dans l'exemple ; une telle opération efface l'accès aux données du volume et ne doit pas être répétée sans l'autorisation du professeur.



💿 Étape 10 — Sélection des trois disques
Les trois disques SAS sont sélectionnés dans l'utilitaire. Le niveau de RAID retenu dans le modèle est RAID 5, qui répartit les données et la parité sur plusieurs disques.



💾 Étape 11 — Enregistrement de la configuration RAID
La configuration est vérifiée avant d'être sauvegardée. Dans l'exemple, la touche F8 permet de confirmer la sauvegarde.



✅ Étape 12 — Vérification du volume logique
L'exemple indique :

Logical Drive : #1
RAID : 5
Capacité : environ 273,4 Go
Status : OK


🔩 Partie 4 — Remontage du serveur
🧠 Étape 13 — Réinstallation des barrettes RAM
Les composants sont réinstallés, puis le diagnostic mémoire est consulté. Le modèle affiche environ 61440 MB Available, soit approximativement 60 Go de mémoire disponible.



🖥️ Étape 14 — Vérification finale
La vérification finale porte sur la détection des processeurs, de la mémoire, des disques et du volume RAID.



📊 Résultats présentés dans le modèle
Composant	Configuration du modèle
Serveur	HP ProLiant DL360 G6
Processeurs	2 × Intel Xeon E5540 à 2,53 GHz
Mémoire installée annoncée	2 × 16 Go + 8 × 4 Go = 64 Go
Mémoire disponible observée	Environ 60 Go
Disques	3 × SAS 146 Go
RAID	RAID 5
Volume logique	Environ 273,4 Go
Alimentations	2 blocs HP
À compléter : confirmer les valeurs effectivement observées sur notre serveur et expliquer toute différence entre mémoire installée et mémoire disponible.

✅ Conclusion
Ce laboratoire permet de comprendre l'organisation matérielle du serveur HP ProLiant DL360 G6. Le démontage et le remontage donnent l'occasion d'identifier les alimentations, les disques SAS, les barrettes RAM, les processeurs et le module RAID. Les écrans POST et BIOS permettent d'examiner la détection des composants, tandis que l'utilitaire RAID présente la configuration du volume logique. Les captures prises pendant le laboratoire permettront de documenter les résultats réellement constatés.







