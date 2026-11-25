###### Rapport de déploiement — Application web maxi - guinéen
###### Étudiante : Rougaiyatou Diallo — Matricule : 300156627

###### Programme : Techniques des systèmes informatiques (Collège Boréal)

###### Hôte / VM cible : rougaiyatoudiallo@10.7.236.227

##### Poste source : Windows (C:\Users\Admin\maxi_guineen)

##### Répertoire de déploiement sur la VM : /home/rougaiyatoudiallo/maxi_deploy

##### Ports d'écoute : 61730 (frontend web statique) et 8080 (API REST Python api_server.py)

##### Date : 25 novembre 2026

#### 1. Synthèse du déploiement et accès

##### L'application web maxi - guinéen (compilée avec Flutter Web) et son API Python (api_server.py) sont déployées sur la machine virtuelle Debian (10.7.236.227).

URL d'accès de l'application : [http://10.7.236.227:61730/](http://10.7.236.227:61730/)

##### 🚀 Aperçu du projet

L'objectif de ce projet est de proposer une interface web accessible et réactive permettant de consulter et gérer les contenus de maxi - guinéen (navigation entre les sections, consultation des produits et articles, et publication de nouveaux éléments) tout en s'appuyant sur un service backend dédié hébergé sur la VM du laboratoire.

#### ✨ Fonctionnalités principales

Navigation et interface Flutter Web

Compilation web générée depuis Windows (build/web) et diffusée via HTTP sur le port 61730.

Accès aux différentes vues et sections de l'application (Accueil, Produits, Articles, Publier).

Backend & API REST Python (api_server.py)

Exécution en arrière-plan sur la VM Debian (port 8080) pour répondre aux requêtes de l'application.

Journalisation des activités et erreurs dans ~/maxi_deploy/api.log.

Continuité de service sur la VM

Lancement en arrière-plan (nohup et redirection des logs) et détachement de la session interactive (disown -a) afin de maintenir les services actifs même après la fermeture du terminal.

<img width="1911" height="1035" alt="1" src="https://github.com/user-attachments/assets/6151ce4d-b5b8-458e-9c16-b6ca97542610" />


Port du serveur web statique : 61730 (lié sur 0.0.0.0:61730 pour accepter les connexions réseau)

Port de l'API backend : 8080 (api_server.py exposant les routes /api/health, /api/services, /api/products et /api/articles)

État des services : actifs en arrière-plan et détachés de la session interactive (disown -a) afin de rester disponibles lors de la correction.

#### 2. Architecture technique

#### Le déploiement sépare la compilation et l'exécution :

Compilation (Windows — C:\Users\Admin\maxi_guineen) : génération des fichiers web de production dans build\web (index.html, main.dart.js, flutter_bootstrap.js, assets/, etc.) et préparation des scripts (api_server.py, bin/server.dart).

Transfert sécurisé (scp / ssh) : copie des fichiers vers ~/maxi_deploy/web/ et ~/maxi_deploy/ sur la VM Debian (10.7.236.227).

#### Exécution sur Debian (10.7.236.227) :

Diffusion des fichiers statiques Flutter Web via python3 -m http.server 61730 --directory web --bind 0.0.0.0 (journalisé dans ~/maxi_deploy/web.log).

Exécution de l'API Python via api_server.py sur le port 8080 (journalisé dans ~/maxi_deploy/api.log).

#### 3. Étapes détaillées de mise en œuvre

##### 3.1 Préparation du répertoire distant et transfert des fichiers

Depuis PowerShell (PS C:\Users\Admin>), création de l'arborescence sur la VM et transfert des artefacts :

PowerShell
ssh rougaiyatoudiallo@10.7.236.227 "mkdir -p ~/maxi_deploy/web"
scp -r C:\Users\Admin\maxi_guineen\build\web\* rougaiyatoudiallo@10.7.236.227:~/maxi_deploy/web/
scp C:\Users\Admin\maxi_guineen\bin\server.dart rougaiyatoudiallo@10.7.236.227:~/maxi_deploy/server.dart

Insérer ici la capture d'écran de PowerShell montrant la copie des fichiers build\web\* vers ~/maxi_deploy/web/.
Légende : Transfert des fichiers compilés Flutter Web vers la VM Debian (10.7.236.227).

<img width="942" height="1061" alt="2" src="https://github.com/user-attachments/assets/72e3d916-840d-4024-88b2-9bbecb4bbcd4" />


### 3.2 Diagnostic réseau, SSH et démarrage des services

### Lors des tests, les points suivants ont été vérifiés et corrigés :

#### Adresse et port dans le navigateur : 

l'utilisation de l'URL complète [http://10.7.236.227:61730/](http://10.7.236.227:61730/) dans la barre d'adresse est requise (l'accès sans le port :61730 entraîne ERR_CONNECTION_REFUSED).

#### Stabilité de la connexion SSH (port 22) : 

en cas de fermeture de session (Connection closed by 10.7.236.227 port 22), l'accès console a permis de confirmer l'adresse IP (hostname -I -> 10.7.236.227) et de redémarrer le service SSH (sudo systemctl restart ssh).

Permissions et lancement en arrière-plan : attribution des droits d'accès (chmod -R a+rX web) et lancement des processus en tâche de fond avec redirection des sorties vers web.log et api.log :

Bash
cd ~/maxi_deploy
chmod -R a+rX web
nohup python3 -m http.server 61730 --directory web --bind 0.0.0.0 > web.log 2>&1 < /dev/null &
nohup python3 api_server.py > api.log 2>&1 < /dev/null &

Insérer ici la capture du terminal Debian montrant sudo systemctl restart ssh et hostname -I (10.7.236.227).
Légende : Vérification de l'adresse IP de la VM et redémarrage du démon SSH.

<img width="937" height="976" alt="3" src="https://github.com/user-attachments/assets/546ea2d7-7f4b-4d48-9f9f-19d3fea5cb47" />


#### 3.3 Détachement (disown -a) et contrôle des processus et journaux
Afin que le serveur web ne soit pas arrêté à la fermeture du terminal (pts/0), la commande disown -a a été exécutée, suivie d'un contrôle des processus actifs et du journal HTTP :

Bash
disown -a
ps aux | grep -E "61730|api_server.py"
cat web.log
Résultats observés :

Processus api_server.py actif (PID 8105).

Processus python3 -m http.server 61730 --directory web --bind 0.0.0.0 actif (PID 8573) et détaché.

Journal web.log enregistrant les requêtes GET /, /flutter_bootstrap.js, /main.dart.js et /assets/... avec les codes HTTP 200 et 304.

Insérer ici la capture du terminal montrant disown -a, ps aux | grep -E "61730|api_server.py" et cat web.log.

<img width="941" height="247" alt="4" src="https://github.com/user-attachments/assets/95422cb7-cce2-495f-bfbf-1ee7a482e37e" />


Légende : Confirmation de l'exécution en arrière-plan des services web (port 61730) et API (port 8080), ainsi que des réponses HTTP 200/304.

#### 3.4 Validation fonctionnelle dans le navigateur

L'ouverture de [http://10.7.236.227:61730/](http://10.7.236.227:61730/) dans Chrome a permis de vérifier le chargement complet de l'application maxi - guinéen et la navigation entre ses sections (Accueil, Produits, Articles, Publier).

<img width="1911" height="1035" alt="1" src="https://github.com/user-attachments/assets/3557c975-84ce-467e-842e-96a7da9482fa" />

Insérer ici la capture d'écran de Chrome affichant [http://10.7.236.227:61730/](http://10.7.236.227:61730/) avec l'interface de l'application maxi - guinéen.
Légende : Rendu de l'application web maxi - guinéen servie par la VM Debian sur le port 61730.

#### PRODUITS:

<img width="1917" height="1035" alt="5" src="https://github.com/user-attachments/assets/657c7fa6-f137-4994-bcf5-0fdf17de99dc" />

#### ARTICLES:

<img width="1916" height="1036" alt="6" src="https://github.com/user-attachments/assets/bdb0617b-26e6-4252-9e04-37305b19a4b6" />


#### PUBLIER:

<img width="1917" height="1037" alt="7" src="https://github.com/user-attachments/assets/9e92c11e-b483-4dc1-841b-cef2787226d6" />


#### 4. Points de contrôle pour la correction

#### VM sous tension : 

la machine virtuelle 10.7.236.227 reste allumée et accessible sur le réseau du laboratoire.

#### Services en écoute :

les processus http.server (port 61730) et api_server.py (port 8080) tournent dans ~/maxi_deploy.

Intégrité des fichiers : le dossier ~/maxi_deploy/web et les scripts associés sont en place.

Si tu veux ajouter une section spéciale demandée dans ta grille d'évaluation (par exemple la configuration pare-feu, un test d'endpoint /api/..., ou la configuration systemd pour un redémarrage automatique au boot de la VM), dis-moi quel point ajouter et je l'intègre.

#### 🔒 Bonnes Pratiques & Maintien en ligne

Garder la machine virtuelle Debian (10.7.236.227) allumée jusqu'à la fin de la correction.

Vérifier avec ps aux | grep -E "61730|api_server.py" que les processus restent actifs.

Consulter web.log et api.log dans ~/maxi_deploy/ en cas de besoin de diagnostic.
