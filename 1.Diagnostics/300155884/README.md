# Rapport de diagnostic : serveurs HP ProLiant DL360

Patricia Nguemedzi (300155884)
Cours INF1085-201 Administration Linux

## 1. Introduction

Ce rapport décrit le diagnostic de serveurs HP ProLiant DL360 dont un ne démarrait pas. Nous avons travaillé avec deux serveurs. L'objectif était de les faire fonctionner jusqu'à l'écran POST, puis de configurer leur stockage.

## 2. Inspection du matériel

Nous avons récupéré le serveur dans la salle des serveurs, puis nous l'avons ouvert. Nous avons observé et identifié chaque composant, et nous avons appris à quoi il sert : alimentations, processeurs, mémoire, ventilateurs, disques durs, contrôleur RAID.

![Baie de serveurs dans la salle des serveurs](images/BaieServeurs.jpg)

![Barrettes de mémoire](images/BarrettesMemoire.jpg)

![Disques durs et un processeur retirés du serveur](images/DisquesDurs.jpg)

## 3. Constat de départ

Nous avons branché le serveur et nous l'avons allumé pour vérifier qu'il fonctionnait normalement. Il ne démarrait pas.

## 4. Diagnostic étape par étape

Pour trouver l'origine du problème, nous avons vérifié les composants un par un : les processeurs et leurs sockets, la mémoire, les dissipateurs thermiques et le bloc d'alimentation.

- Nous avons retiré le dissipateur thermique pour bien vérifier le processeur.
- Avec le premier processeur, le serveur a démarré.
- Avec le second processeur, le serveur n'a pas démarré. Nous avons réinitialisé la carte mère en levant puis en rabaissant un petit switch, mais le serveur ne démarrait toujours pas.
- Nous avons fait une vérification plus approfondie du socket du second processeur.

![Les deux sockets de processeur sur la carte mère](images/SocketsProcesseurs.jpg)

![Un processeur retiré, face des contacts](images/Processeur.jpg)

![Un socket de processeur vide](images/SocketVide.jpg)

## 5. Cause identifiée

Le socket du second processeur était endommagé : ses broches étaient pliées. Nous avons tenté de redresser ces broches et nous avons essayé plusieurs processeurs.

## 6. Solution retenue

Sur le premier serveur, nous avons décidé de n'utiliser qu'un seul processeur, avec 64 GB de mémoire (4 barrettes de 16 GB) installés du côté du processeur en place. Le serveur est arrivé à l'écran POST avec 1 processeur détecté.

![Écran POST avec 1 processeur](images/Post1CPU.jpg)

Sur le deuxième serveur, les deux processeurs fonctionnaient.

## 7. Résultat final

Sur le deuxième serveur, l'écran POST indique : 2 processeurs détectés, 8 cœurs activés, deux Intel Xeon E5540 à 2,53 GHz, 64 GB de mémoire installés et le mode Advanced ECC Support.

![Écran POST avec 2 processeurs et 64 GB](images/Post2CPU.jpg)

Nous avons aussi lancé le diagnostic de la mémoire du BIOS. La photo montre quatre modules de 16384 MB, et l'écran affiche 48960 MB OK sur 65536 MB au moment où elle a été prise.

![Diagnostic de la mémoire du BIOS](images/TestMemoire.jpg)

### Démarrage et options de démarrage

Au démarrage, l'écran propose de poursuivre avec F1, d'entrer dans l'utilitaire de configuration (RBSU) avec F9, d'ouvrir le menu de maintenance avec F10, les options de démarrage avec F11 et le démarrage par le réseau avec F12.

![Écran des touches de démarrage](images/MenuPOST.jpg)

Le menu des options de démarrage permet de démarrer une seule fois sur CD-ROM, disquette, clé USB, disque dur ou réseau, ou d'entrer dans le RBSU, sans modifier l'ordre de démarrage normal.

![Menu des options de démarrage](images/MenuDemarrage.jpg)

### Formatage des disques (configuration du RAID 5)

Pour préparer les disques, nous avons utilisé l'utilitaire de configuration du contrôleur HP Smart Array P410i. Son menu principal permet de créer, d'afficher ou de supprimer un lecteur logique, de gérer les clés de licence et de régler le cache.

![Menu principal de l'utilitaire du contrôleur](images/MenuRaid.jpg)

L'utilitaire affichait le lecteur logique n° 1 : RAID 5, 273,4 GB, à l'état OK.

![Lecteur logique RAID 5 de 273,4 GB](images/LecteurLogique.jpg)

La suppression d'un lecteur logique entraîne une perte complète des données : l'utilitaire demande de confirmer avec la touche F3, ou d'annuler avec la touche Échap.

![Avertissement avant la suppression d'un lecteur logique](images/Avertissement.jpg)

Pour créer un lecteur logique, nous avons sélectionné les trois disques durs SAS de 146,8 GB et l'option RAID 5.

![Sélection des trois disques et du RAID 5](images/RaidSelection.jpg)

La configuration a ensuite été enregistrée.

![Configuration enregistrée](images/ConfigurationEnregistree.jpg)

Cette configuration prépare le serveur à l'installation de Proxmox, réalisée plus tard dans le cours. Le formatage du système de fichiers a lieu pendant cette installation.

## 8. Conclusion

(À écrire avec tes mots)

## 9. Références

- https://fr.wikipedia.org/wiki/LGA_1366
