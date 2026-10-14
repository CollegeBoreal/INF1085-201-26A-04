Hamdaoui laala 
Id :300157334
Rapport d’installation d’une machine virtuelle avec Proxmox VE
1. Introduction
L’objectif de ce travail est de créer et de configurer une machine virtuelle sur un serveur Proxmox VE. La machine virtuelle est destinée à installer le système d’exploitation Debian 13.7.
2. Configuration de la machine virtuelle
La machine virtuelle a été créée avec les caractéristiques suivantes :
Caractéristique	Configuration
Nom de la VM	laala
Identifiant (VM ID)	100
Hyperviseur	Proxmox VE 7.0.2
Système d’exploitation	Debian 13.7 64 bits
Mémoire vive (RAM)	2048 Mo (2 Go)
Processeur	1 cœur
Type de processeur	x86-64-v2
Disque dur virtuel	32 Go
Contrôleur de disque	VirtIO SCSI
Interface réseau	VirtIO
Pont réseau	vmbr0
Fichier ISO	debian-13.7.0-amd64-netinst.iso
 
	
 
	
3. Étapes de réalisation
 
Étape 1 : Accès à Proxmox
Connexion à l’interface Web de Proxmox avec un compte utilisateur autorisé.
Étape 2 : Importation du fichier ISO
Téléchargement de l’image ISO de Debian 13.7, puis importation du fichier dans le stockage local de Proxmox.
Étape 3 : Création de la machine virtuelle
Création de la VM numéro 100 avec le nom laala, puis sélection de l’image ISO de Debian.
Étape 4 : Configuration matérielle
Configuration de la mémoire vive, du processeur, du disque dur virtuel et de l’interface réseau.
Étape 5 : Correction de la configuration du processeur
Lors du premier démarrage, une erreur liée à la fonctionnalité AES du processeur a été détectée. Le modèle du processeur virtuel a ensuite été modifié à l’aide de la commande :
qm set 100 --cpu x86-64-v2
 

Étape 6 : Tentative de démarrage
 

Une nouvelle tentative de démarrage a été effectuée avec la commande :
qm start 100
L’état de la machine doit être vérifié pour confirmer que le démarrage a réussi.


 

5. Conclusion

La machine virtuelle laala, identifiée par le numéro 100, a été créée dans Proxmox VE. Le système Debian 13.7 a été sélectionné et les ressources matérielles virtuelles ont été configurées. Une incompatibilité liée au modèle du processeur a été rencontrée, puis une modification de ce modèle a été effectuée.
Le démarrage final doit être confirmé avant de conclure que l’installation de Debian est terminée. Une fois le démarrage réussi, l’installation du système d’exploitation pourra être poursuivie depuis la console de la machine virtuelle.


