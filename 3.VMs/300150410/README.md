🧪 RAPPORT DE LABORATOIRE
Installation et sécurisation d’une machine virtuelle Debian 13 avec Proxmox VE
Lachi Lahlou | No étudiant : 300150410
Compte Debian : lahloulachi@10.7.236.177
Cours : INF1085 — Linux / Proxmox
1. Objectif et environnement
L’objectif de ce laboratoire est d’utiliser Proxmox VE pour installer et configurer une machine virtuelle Debian 13, vérifier son adresse IP, activer le serveur SSH et tester les connexions à distance depuis Windows.
J’ai également configuré l’authentification SSH par clé publique, ajouté la clé du professeur et utilisé SSH-Agent pour faciliter mes connexions sécurisées.
Élément	Configuration
Hyperviseur	Proxmox VE 9.2.2
Nœud Proxmox	server237
Machine virtuelle	104 — lahlou
Système invité	Debian GNU/Linux 13
Interface graphique	GNOME
Compte Debian	lahloulachi
Adresse IP Debian	10.7.236.177/23
Interface réseau	ens18
Poste client	Windows
Terminaux utilisés	PowerShell et Git Bash
2. Accès à Proxmox et installation de Debian
J’ai commencé par accéder à l’interface Web Proxmox VE du collège.
J’ai utilisé le nœud server237 pour installer ma machine virtuelle numéro 104, nommée B300150410VM.
Après l’installation de Debian 13, j’ai démarré la machine virtuelle et vérifié que le système fonctionnait correctement.
Figure 1 — Machine virtuelle Debian 104 dans Proxmox
 
Figure 2 — Démarrage de Debian 13
 
3. Ouverture de la session graphique GNOME
Après le démarrage de Debian, j’ai ouvert ma session avec l’utilisateur lahloulachi.
J’ai installé et configuré l’environnement graphique GNOME afin de pouvoir utiliser Debian avec une interface graphique.
L’apparition du bureau GNOME confirme que le système est opérationnel.
Figure 3 — Bureau GNOME après ouverture de session
 
4. Vérification de l’adresse IP de Debian
Dans le terminal Debian, j’ai utilisé la commande suivante :
ip a
Cette commande permet d’afficher les interfaces réseau et les adresses IP de la machine.
Le résultat indique que mon interface réseau ens18 possède l’adresse IPv4 suivante :
10.7.236.177/23
Cette adresse est utilisée pour établir une connexion SSH depuis mon ordinateur Windows.
Figure 4 — Résultat de la commande ip a
Capture correspondante non identifiée avec certitude dans les images sélectionnées — à compléter.
5. Installation et activation du serveur SSH
Pour permettre l’administration à distance de Debian, j’ai installé le serveur OpenSSH.
J’ai exécuté les commandes suivantes :
sudo apt update
sudo apt install openssh-server -y
sudo systemctl enable --now ssh
sudo systemctl status ssh
La vérification du service indiquait :
Active: active (running)
Cela confirme que le serveur SSH est actif et que Debian peut accepter les connexions SSH.
Figure 5 — Vérification du service SSH actif
Capture correspondante non identifiée avec certitude dans les images sélectionnées — à compléter.
6. Première connexion SSH depuis Windows
Depuis Windows PowerShell, j’ai utilisé la commande suivante :
ssh lahloulachi@10.7.236.177
Après avoir accepté l’empreinte du serveur et saisi mon mot de passe Debian, la connexion a réussi.
Le terminal affichait :
lahloulachi@debian:~$
Cette vérification confirme que mon ordinateur Windows peut accéder à ma machine virtuelle Debian à distance.
Figure 6 — Connexion SSH réussie depuis Windows
 
7. Création d’une clé SSH ED25519
Pour améliorer la sécurité de mes connexions SSH, j’ai créé une paire de clés ED25519 depuis Windows PowerShell.
Commande utilisée :
ssh-keygen -t ed25519 -C "300150410"
Cette commande a généré deux fichiers :
•	id_ed25519 : ma clé privée.
•	id_ed25519.pub : ma clé publique.
J’ai protégé ma clé privée avec une phrase secrète.
Figure 7 — Création de ma clé ED25519
 
8. Authentification SSH avec ma clé publique
Après la création de ma clé ED25519, j’ai ajouté ma clé publique au fichier authorized_keys de Debian.
J’ai ensuite testé l’authentification SSH par clé publique avec la commande :
ssh -i "$HOME\.ssh\id_ed25519" -o PreferredAuthentications=publickey -o PasswordAuthentication=no lahloulachi@10.7.236.177
La connexion a réussi.
Ce résultat confirme que ma clé publique est correctement configurée et que l’authentification fonctionne sans utiliser le mot de passe de mon compte Debian.
Figure 8 — Connexion SSH avec la clé ED25519
 
9. Vérification des permissions SSH
Pour vérifier la sécurité de mon dossier SSH, j’ai exécuté :
ls -ld ~/.ssh && ls -l ~/.ssh/authorized_keys
J’ai obtenu les permissions suivantes :
Élément	Permissions
Dossier .ssh	700
Fichier authorized_keys	600
J’ai également vérifié l’empreinte de ma clé publique :
ssh-keygen -lf ~/.ssh/authorized_keys
Le résultat confirmait la présence de ma clé ED25519 associée à mon numéro étudiant 300150410.
Figure 9 — Vérification des permissions et de ma clé SSH
 
10. Ajout de la clé publique du professeur
J’ai ajouté la clé publique RSA du professeur au fichier ~/.ssh/authorized_keys de mon compte Debian.
J’ai conservé ma clé personnelle ED25519 afin de ne pas perdre mon accès SSH.
Après l’ajout, j’ai exécuté :
ssh-keygen -lf ~/.ssh/authorized_keys
Le résultat affichait deux clés :
256 SHA256:gqAQ7NLtJ6ed7UBwVErdxOu/1E1Pd6pYwXEY8EEGeoU 300150410 (ED25519)

2048 SHA256:QjsnIAs7R7me0iGwUyFxHcoD4mLZZGfChh3OSCcDTVE b300098957@ramena (RSA)
La première clé correspond à ma clé personnelle.
La deuxième correspond à la clé publique du professeur.
Figure 10 — Vérification de la présence de la clé du professeur
 
J’ai également vérifié les permissions du dossier et du fichier :
ls -ld ~/.ssh && ls -l ~/.ssh/authorized_keys
Les permissions étaient toujours de 700 pour le dossier .ssh et de 600 pour le fichier authorized_keys.
Figure 11 — Vérification des permissions après l’ajout
 
La présence de la clé du professeur a été confirmée localement. Sa connexion avec la clé privée correspondante n’a pas été testée.
11. Création d’une clé RSA de 4096 bits
Pour poursuivre le laboratoire, j’ai utilisé Git Bash afin de créer une nouvelle paire de clés RSA.
Commande utilisée :
ssh-keygen -t rsa -b 4096
J’ai ensuite renommé mes fichiers avec mon numéro étudiant :
mv ~/.ssh/id_rsa ~/.ssh/b300150410
mv ~/.ssh/id_rsa.pub ~/.ssh/b300150410.pub
Mes fichiers portent maintenant les noms suivants :
b300150410
b300150410.pub
Cette configuration me permet de distinguer ma clé RSA de ma clé ED25519.
12. Installation de ma clé RSA sur Debian
Après la création de ma clé RSA, j’ai utilisé la commande ssh-copy-id pour ajouter ma clé publique sur Debian.
ssh-copy-id -i ~/.ssh/b300150410.pub lahloulachi@10.7.236.177
Le terminal a confirmé :
Number of key(s) added: 1
J’ai ensuite testé la connexion avec ma clé privée RSA :
ssh -i ~/.ssh/b300150410 -o PreferredAuthentications=publickey -o PasswordAuthentication=no lahloulachi@10.7.236.177
La connexion a réussi.
Figure 12 — Connexion SSH avec ma clé RSA 4096 bits
 
13. Vérification des trois clés publiques
Après l’installation de ma nouvelle clé RSA, j’ai vérifié les clés autorisées sur Debian.
Commande utilisée :
ssh-keygen -lf ~/.ssh/authorized_keys
Le résultat affichait :
256 SHA256:gqAQ7NLtJ6ed7UBwVErdxOu/1E1Pd6pYwXEY8EEGeoU 300150410 (ED25519)

2048 SHA256:QjsnIAs7R7me0iGwUyFxHcoD4mLZZGfChh3OSCcDTVE b300098957@ramena (RSA)

4096 SHA256:SHI/b+YvGU5hGmHLnDQ3Yi5COE6esCjEfYiIHvD139Y islem@PCDEMOMO (RSA)
Ces résultats confirment la présence de trois clés :
1.	Ma clé personnelle ED25519.
2.	La clé publique RSA du professeur.
3.	Ma clé personnelle RSA de 4096 bits.
Figure 13 — Vérification des trois clés SSH
 
14. Configuration de SSH-Agent
Pour faciliter l’utilisation de ma clé privée RSA, j’ai configuré SSH-Agent depuis Git Bash.
J’ai commencé par démarrer l’agent :
eval $(ssh-agent)
Le résultat affichait :
Agent pid 1925
J’ai ensuite ajouté ma clé privée RSA :
ssh-add ~/.ssh/b300150410
Après avoir saisi ma phrase secrète, le terminal a confirmé :
Identity added: /c/Users/islem/.ssh/b300150410 (islem@PCDEMOMO)
Figure 14 — Ajout de ma clé RSA dans SSH-Agent
 
15. Vérification de SSH-Agent
Pour vérifier que ma clé RSA était chargée dans SSH-Agent, j’ai exécuté :
ssh-add -l
Le terminal affichait :
4096 SHA256:SHI/b+YvGU5hGmHLnDQ3Yi5COE6esCjEfYiIHvD139Y islem@PCDEMOMO (RSA)
Cela confirme que ma clé RSA de 4096 bits est correctement chargée dans SSH-Agent.
Figure 15 — Vérification de ma clé dans SSH-Agent
 
16. Connexion SSH avec SSH-Agent
Pour terminer le laboratoire, j’ai effectué un dernier test de connexion SSH depuis Git Bash.
J’ai utilisé la commande :
ssh -o PreferredAuthentications=publickey -o PasswordAuthentication=no lahloulachi@10.7.236.177
La connexion a réussi sans demander le mot de passe Debian ni une nouvelle saisie de ma phrase secrète.
Le terminal affichait :
lahloulachi@debian:~$
Ce résultat confirme que SSH-Agent fonctionne correctement avec ma clé RSA.
Figure 16 — Connexion SSH réussie avec SSH-Agent
 
17. Bilan du laboratoire
Vérification	Résultat
Installation de Debian 13	Réussie
Machine virtuelle 104 sur Proxmox	Fonctionnelle
Interface graphique GNOME	Fonctionnelle
Adresse IP Debian	10.7.236.177/23
Service SSH	Actif
Connexion SSH Windows vers Debian	Réussie
Création de la clé ED25519	Réussie
Connexion SSH avec ED25519	Réussie
Permissions SSH	700 et 600 vérifiées
Clé publique du professeur	Présente
Création de la clé RSA 4096 bits	Réussie
Installation avec ssh-copy-id	Réussie
Connexion SSH avec la clé RSA	Réussie
Trois clés dans authorized_keys	Confirmées
Configuration de SSH-Agent	Réussie
Vérification avec ssh-add -l	Réussie
Connexion SSH avec SSH-Agent	Réussie
Connexion effective du professeur	Non testée
18. Conclusion
Ce laboratoire m’a permis d’installer et de configurer une machine virtuelle Debian 13 avec Proxmox VE.
J’ai vérifié la configuration réseau de Debian et installé le serveur OpenSSH afin de permettre l’administration à distance depuis Windows.
J’ai ensuite créé et configuré mes clés SSH ED25519 et RSA, ajouté la clé publique du professeur et vérifié les permissions du fichier authorized_keys.
Enfin, j’ai configuré SSH-Agent et confirmé que je pouvais me connecter à Debian sans saisir à nouveau ma phrase secrète.
Ce travail m’a permis d’améliorer mes compétences en virtualisation, en administration Linux, en gestion des clés SSH et en sécurisation des connexions à distance.
Les captures d’écran de ce rapport présentent les différentes étapes réalisées dans mon environnement de laboratoire.
Rapport réalisé par : Lachi Lahlou
Numéro étudiant : 300150410
Cours : INF1085 — Linux / Proxmox
