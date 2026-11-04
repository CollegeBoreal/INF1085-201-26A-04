RAPPORT DE LABORATOIRE
Installation et sécurisation d’une machine virtuelle Debian 13 avec Proxmox VE
Nassim Idir  |  No étudiant : 300151504
Cours : INF1085 — Linux / Proxmox  |  Date : 2 novembre 2026
1. Objectif et environnement
L’objectif du laboratoire est d’utiliser Proxmox VE pour démarrer une machine virtuelle Debian 13, vérifier son adresse IP, mettre en service SSH, tester la connexion distante et autoriser la clé publique du professeur. Le compte personnel du collège est utilisé pour accéder à Proxmox.
Hyperviseur	Proxmox VE 9.2.2, nœud server238
Adresse du serveur Proxmox	10.7.236.235:8006
Compte Proxmox observé	B300151504@pam
Machine virtuelle	100 — Nassimidir
Système invité	Debian 13, session GNOME
Ressources visibles	1 CPU, 2 Gio RAM, disque virtuel 32 Gio
Compte Debian	nassimidir2000
IP de Debian	10.7.237.163/23, interface ens18 (DHCP)

Remarque : le type de processeur, le contrôleur de disque et le nom exact du fichier ISO ne sont pas démontrés par les captures et ne sont pas inventés dans ce rapport.

 2. Accès au réseau et à Proxmox
La commande ipconfig permet de vérifier le réseau de mon poste Windows. La connexion au serveur du collège est ensuite effectuée dans l’interface Web Proxmox.
 <img width="838" height="420" alt="image" src="https://github.com/user-attachments/assets/1abac671-0fc1-4ee7-adeb-de651cf40372" />

Figure 1 — Configuration réseau du poste Windows : 10.7.143.134/23.
 <img width="880" height="465" alt="image" src="https://github.com/user-attachments/assets/5a0e74e1-6e30-40d1-b39d-0257d06c9439" />

Figure 2 — VM 100 en cours d’exécution sur Proxmox VE 9.2.2.


 3. Démarrage du système Debian 13
Depuis la console de la VM, je vérifie l’apparition du menu GRUB puis le chargement de Debian. Le système atteint ensuite l’écran de connexion.
 <img width="683" height="390" alt="image" src="https://github.com/user-attachments/assets/24ff03f5-64fa-4e7d-9a9d-679ebab66983" />

Figure 3 — Menu de démarrage GNU GRUB de Debian.

<img width="790" height="435" alt="image" src="https://github.com/user-attachments/assets/1b265683-ffd5-481a-a145-a471b11f9987" />

Figure 4 — Chargement des services Debian pendant le démarrage.

 4. Ouverture de la session graphique
Je me connecte au compte Debian nassimidir2000. L’interface graphique GNOME apparaît, ce qui confirme que le système est utilisable.
 <img width="716" height="398" alt="image" src="https://github.com/user-attachments/assets/8160c812-db9e-4589-aca7-1f0db3de62d2" />

Figure 5 — Écran d’authentification Debian 13.
 <img width="752" height="420" alt="image" src="https://github.com/user-attachments/assets/acefdb2f-9842-493c-9922-f086920830a9" />

Figure 6 — Bureau GNOME après ouverture de session.

 5. Adresse IP de la machine virtuelle
Dans le terminal Debian, la commande ip a affiche l’interface ens18 à l’état UP, avec l’adresse IPv4 10.7.237.163/23 obtenue dynamiquement. Cette adresse est celle de la VM, différente de celle de mon poste Windows.
 <img width="976" height="675" alt="image" src="https://github.com/user-attachments/assets/1b08649d-9cb2-4e5e-ae00-c46de86d670d" />

Figure 7 — Résultat de ip a : adresse IP Debian 10.7.237.163/23.
Commande utilisée
ip a

 6. Installation et activation du serveur SSH
Au départ, ssh.service n’était pas présent. Le paquet openssh-server a été installé, puis le service a été activé et démarré. La vérification indique « active (running) » et une écoute sur le port 22.
 <img width="592" height="383" alt="image" src="https://github.com/user-attachments/assets/a470a99b-dc2e-4c4d-b879-a968ad5ec1ac" />

Figure 8 — Avant installation : service SSH introuvable.
 <img width="755" height="488" alt="image" src="https://github.com/user-attachments/assets/a3a1b437-1414-4134-bfa9-7c1c761991bb" />

Figure 9 — Après installation : service SSH actif et activé.
Commandes : sudo apt update ; sudo apt install openssh-server -y ; sudo systemctl enable --now ssh ; sudo systemctl status ssh.

 7. Connexion à distance et authentification par clé
Depuis Windows, je me connecte à Debian avec ssh nassimidir2000@10.7.237.163. Une paire de clés ED25519 déjà présente sur Windows a ensuite été ajoutée au fichier ~/.ssh/authorized_keys de Debian. Un test désactivant l’authentification par mot de passe a réussi : la connexion utilise bien la clé publique.
 <img width="854" height="435" alt="image" src="https://github.com/user-attachments/assets/17186442-cea7-4818-93d1-643da0b2355e" />

Figure 10 — Première connexion SSH depuis Windows vers Debian.
 <img width="954" height="480" alt="image" src="https://github.com/user-attachments/assets/efab176c-21ac-4a89-86f3-05e28327cbd7" />

Figure 11 — Connexion SSH par clé publique, sans mot de passe Debian.

 8. Compte individuel Proxmox et accès SSH
La connexion au serveur Proxmox est effectuée avec mon compte personnel B300151504, plutôt qu’avec le compte root. Cela suit la bonne pratique de comptes administrateurs nominatifs. La capture confirme l’accès SSH au serveur, mais ne prouve pas à elle seule les rôles et ACL attribués au compte.
 <img width="1013" height="507" alt="image" src="https://github.com/user-attachments/assets/c93ad75e-25c9-4326-b1db-9dc7e2cc3f65" />

Figure 12 — Connexion SSH au nœud Proxmox server238 (10.7.236.235).
Commandes de gestion étudiées
adduser B300151504  |  pveum user add B300151504@pam  |  pveum user list  |  pveum acl list
Ces commandes sont indiquées comme procédure du cours. Leur exécution complète n’est pas attestée par les captures.

 9. Ajout de la clé publique du professeur
Le fichier README.md du cours X.Linux/3.keys fournit une clé publique RSA étiquetée b300098957@ramena. Je l’ai ajoutée au fichier ~/.ssh/authorized_keys du compte Debian sans supprimer ma clé personnelle. Les permissions du dossier et du fichier ont été fixées à 700 et 600.
 <img width="926" height="465" alt="image" src="https://github.com/user-attachments/assets/1c46d747-db5e-422d-a1c8-53157b80ce95" />

Figure 13 — Ajout de la clé du professeur et vérification de sa présence.
 <img width="818" height="420" alt="image" src="https://github.com/user-attachments/assets/2a062977-e005-4b75-aa12-7bed95b31ce7" />

Figure 14 — Vérification : une entrée ssh-rsa présente dans authorized_keys.
La présence de la clé a été confirmée localement. Le professeur devra encore tester sa connexion avec la clé privée correspondante.

 10. Bilan du laboratoire
Démarrage de Debian 13	Confirmé par les captures
Session GNOME	Confirmée
VM 100 running dans Proxmox	Confirmé
Adresse IP ens18	10.7.237.163/23 confirmée
Service SSH	Actif et activé
SSH Windows → Debian	Réussi
SSH avec ma clé ED25519	Réussi
SSH Windows → Proxmox	Réussi avec mot de passe
Clé publique du professeur	Présente dans authorized_keys
Connexion effective du professeur	Non testée
Fichiers « img » et « txt »	Exigence exacte non confirmée

11. Conclusion
Ce laboratoire m’a permis de démarrer Debian 13 sur Proxmox VE, de vérifier son adressage réseau et de mettre en service un accès SSH distant. J’ai testé l’authentification par clé depuis Windows et ajouté la clé publique du professeur au compte Debian. Les captures présentées démontrent les principales vérifications réalisées. Les fichiers « img » et « txt » mentionnés dans un commentaire reçu par un autre étudiant devront être précisés à partir de la consigne officielle avant la remise.
12. Référence
Collège Boréal, dépôt INF1085-201-26A-04, section X.Linux/3.keys/README.md : https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/X.Linux/3.keys
Captures personnelles réalisées pendant le laboratoire, 2 novembre 2026.
