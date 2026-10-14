Atelier pratique : Installation de Proxmox VE sur un serveur physique

--1. Présentation de l’atelier

Dans le cadre de mon cours d’administration Windows, j’ai réalisé un atelier pratique pour découvrir l’installation de **Proxmox VE sur un serveur physique**.

L’objectif était de préparer une clé USB d’installation, de démarrer le serveur à partir de cette clé et d’accéder au programme d’installation de Proxmox.

--2. Matériel utilisé

Pour réaliser cet atelier, j’ai utilisé :

- Un serveur physique
- Un écran
- Une clé USB
- Un ordinateur Windows
- Le fichier ISO de Proxmox VE
- Le logiciel Rufus pour créer la clé USB bootable

-- 3. Préparation de la clé USB

J’ai commencé par télécharger le fichier ISO de Proxmox VE, puis j’ai utilisé Rufus pour créer une clé USB bootable.

Cette étape permet de rendre la clé USB utilisable pour démarrer le serveur et lancer l’installation du système.

-- 4. Démarrage du serveur

Une fois la clé USB préparée, je l’ai branchée au serveur et j’ai allumé la machine.

J’ai dû essayer plusieurs options de démarrage avant de trouver la bonne méthode.

- **F8 :** j’ai fait un premier essai pour accéder aux options de démarrage.
- **F11 :** cette option m’a dirigé vers le démarrage réseau, ce qui n’était pas ce que je recherchais.
- **F10 :** j’ai ensuite accédé au menu de démarrage.
- J’ai sélectionné **« One Time Boot to USB DriveKey »** pour démarrer directement sur la clé USB.

Après cette manipulation, le menu de démarrage de Proxmox VE est apparu à l’écran.

--5. Accès à l’installateur Proxmox

Dans le menu de Proxmox VE, plusieurs options étaient proposées. J’ai repéré l’option **« Install Proxmox VE (Graphical) »**, qui permet de lancer l’installation avec une interface graphique.

À cette étape, j’ai pu accéder au programme d’installation.

--6. Difficulté rencontrée

Pendant mes premières manipulations, j’ai rencontré une difficulté concernant le support de stockage sélectionné. Je pense avoir choisi un mauvais support au lieu du disque sur lequel je voulais installer Proxmox.

Cette erreur m’a permis de comprendre qu’il faut bien vérifier le disque sélectionné avant de poursuivre une installation, car les données présentes sur le disque choisi peuvent être effacées.

--7. Ce que j’ai appris

Cet atelier m’a permis de mieux comprendre :

- Comment créer une clé USB bootable avec Rufus.
- Comment accéder au menu de démarrage d’un serveur.
- La différence entre le démarrage sur USB et le démarrage réseau.
- Comment lancer l’installateur de Proxmox VE.
- Pourquoi il est important de vérifier le support de stockage avant d’installer un système.

--8. Captures d’écran

Les captures d’écran ci-dessous permettent de suivre les principales étapes de mon travail.

### Démarrage du serveur

![Démarrage du serveur]

### Sélection du démarrage USB

![Menu de démarrage USB]

### Menu d’installation de Proxmox

![Installateur Proxmox]

## 9. Conclusion

Cette première partie de l’atelier m’a permis de me familiariser avec le démarrage d’un serveur physique et la préparation d’une installation de Proxmox VE.

J’ai rencontré quelques difficultés, mais elles m’ont aidé à mieux comprendre les différentes options de démarrage et l’importance de choisir le bon support de stockage.

La prochaine étape consiste à terminer l’installation, puis à vérifier que le serveur démarre correctement sur le disque choisi.
