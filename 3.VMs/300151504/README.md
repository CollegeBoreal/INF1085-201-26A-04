Installation et démarrage d’une machine virtuelle Debian 13 avec Proxmox VE

Préparé par : Nassim Idir

Numéro d’étudiant : 300151504

Cours : INF1085 — Linux / Proxmox

Date : 2 novembre 2026

1. Introduction

L’objectif de ce laboratoire est d’utiliser Proxmox Virtual Environment pour accéder à une machine virtuelle, démarrer Debian 13 et confirmer que le système est utilisable avec une session graphique. Les captures prises pendant le travail montrent les étapes de démarrage, la connexion au compte Debian et l’état de la machine dans Proxmox.

2. Environnement utilisé

Élément

Information constatée

Plateforme de virtualisation

Proxmox Virtual Environment 9.2.2

Nœud Proxmox

server238

Machine virtuelle

VM 100 — Nassimidir

État de la VM

running (en cours d’exécution)

Système invité

Debian 13, environnement graphique GNOME

Processeur

1 CPU virtuel

Mémoire

2,00 Gio (environ 2 Go)

Disque de démarrage

32,00 Gio

Console distante

noVNC depuis le navigateur

Compte Debian affiché

nassimidir2000

Remarque : les valeurs du modèle de CPU, du contrôleur de disque, du fichier ISO et du pont réseau ne sont pas visibles sur les captures fournies. Elles ne sont donc pas présentées comme vérifiées.

3. Vérification du réseau sur Windows

La commande ipconfig a été utilisée dans l’invite de commandes Windows afin de relever les paramètres du réseau Wi-Fi du poste utilisé pour accéder à Proxmox. Cette adresse appartient au poste Windows, et non nécessairement à la machine virtuelle Debian.

Adresse IPv4 du poste : 10.7.143.134  |  Masque : 255.255.254.0 (/23)  |  Passerelle : 10.7.142.1  |  Domaine DNS : borealc.on.ca.

4. Captures et étapes de réalisation

Étape 1 — Relever la configuration réseau

Dans Windows, ouverture de l’invite de commandes et consultation des paramètres réseau. La connectivité vers le réseau du collège dépend de cette configuration.



Figure 1 — Résultat de ipconfig sur le poste Windows.

Étape 2 — Démarrer Debian depuis GRUB

Dans la console noVNC de la VM, le menu GNU GRUB propose « Debian GNU/Linux ». Cette entrée a été sélectionnée pour démarrer le système.



Figure 2 — Menu GNU GRUB de Debian.

Étape 3 — Observer le chargement du système

Pendant le démarrage, Debian exécute des vérifications et démarre plusieurs services systemd. Les lignes « OK » montrent des opérations achevées avec succès. Malgré quelques messages matériels affichés, la suite des captures confirme que Debian atteint l’écran de connexion.



Figure 3 — Messages de démarrage du système Debian.

Étape 4 — Accéder à la session Debian

Après le démarrage, l’écran de connexion Debian 13 apparaît. Le compte utilisateur « nassimidir2000 » est affiché. La connexion nécessite le mot de passe du compte, qui ne doit pas figurer dans ce rapport.



Figure 4 — Écran de connexion Debian 13.

Étape 5 — Vérifier le bureau graphique

Une fois la connexion réussie, l’interface graphique GNOME s’affiche avec ses applications. Cette capture confirme que la session utilisateur est ouverte et que le système Debian fonctionne avec une interface graphique.



Figure 5 — Bureau GNOME de Debian 13 après connexion.

Étape 6 — Confirmer l’état de la VM dans Proxmox

Dans l’interface Web de Proxmox, la VM 100 « Nassimidir » apparaît sur le nœud « server238 ». Le statut est « running ». Le résumé indique 1 CPU, une mémoire allouée de 2,00 Gio et un disque de démarrage de 32,00 Gio. La console est disponible depuis le menu latéral.



Figure 6 — Résumé de la VM 100 dans Proxmox VE 9.2.2.

5. Résultats et vérifications

Vérification

Résultat

Accès à l’interface Proxmox

Réussi — interface Web affichée

VM 100 reconnue

Réussi — Nassimidir sur server238

Démarrage Debian

Réussi — menu GRUB puis messages système

Ouverture de la session

Réussie — bureau GNOME visible

Statut dans Proxmox

running

Adresse IP de Debian

Non vérifiée dans les captures

Connectivité réseau depuis Debian

Non vérifiée par ping ou commande ip

6. Difficultés et observations

Au cours du démarrage, des messages liés à ACPI et à un périphérique SCSI ont été affichés. Ils n’ont pas empêché l’arrivée à l’écran de connexion ni l’ouverture du bureau GNOME. La capture Proxmox affiche également des erreurs de mise à jour de la base des paquets sur le nœud : ces messages ne permettent pas, à eux seuls, de conclure que la VM Debian présente une erreur.

La configuration du processeur x86-64-v2 et une éventuelle erreur AES sont mentionnées dans l’exemple fourni par un autre étudiant, mais ne sont pas visibles dans mes captures. Je ne les attribue donc pas à mon travail.

7. Conclusion

Ce laboratoire m’a permis d’utiliser l’interface Web de Proxmox VE, d’ouvrir la console noVNC et de vérifier le démarrage d’une machine virtuelle Debian 13. Les captures montrent que la VM 100 « Nassimidir » fonctionne, que l’écran de connexion apparaît et que le bureau GNOME est accessible. Les caractéristiques principales visibles sont 1 CPU virtuel, 2 Gio de RAM et un disque de 32 Gio. Les prochaines vérifications possibles seraient de relever l’adresse IP directement dans Debian et de tester sa connectivité réseau.

8. Références et éléments remis

• Captures d’écran personnelles réalisées le 2 novembre 2026 (figures 1 à 6).

• Interface Web Proxmox VE 9.2.2 — VM 100, nœud server238.

• Dépôt GitHub : lien à ajouter si requis pour la remise (non encore fourni).

Nassim Idir  •  300151504  |  Rapport de laboratoire
