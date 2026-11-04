# 🖥️ INF1085 – Administration Linux

# 🏆 Rapport technique : Diagnostic matériel et installation de Proxmox VE

**Étudiant :** Lachi Lahlou
**Numéro étudiant :** 300150410
**Établissement :** Collège Boréal
**Cours :** INF1085 – Administration Linux
**Serveur :** HP ProLiant DL360 G6
**Plateforme :** Proxmox Virtual Environment




# 📋 1. Introduction

Dans le cadre du cours INF1085 – Administration Linux, notre groupe a réalisé un laboratoire pratique consacré au diagnostic, au dépannage et à la configuration d'un serveur physique HP ProLiant DL360 G6.

Au début du laboratoire, le serveur présentait des difficultés de démarrage. Nous avons donc effectué plusieurs vérifications afin d'identifier les problèmes matériels possibles.

Notre travail a principalement porté sur :

* L'inspection des composants internes.
* La vérification des processeurs.
* Le contrôle de la mémoire RAM.
* L'analyse du démarrage POST.
* La configuration du stockage en RAID 5.
* L'installation et le démarrage de Proxmox VE.
* La vérification de l'environnement de virtualisation.

L'objectif était de remettre le serveur en fonctionnement et de préparer une plateforme de virtualisation pour les prochains laboratoires.

---

# 🔧 2. Présentation du matériel

Le serveur utilisé est un **HP ProLiant DL360 G6**, conçu pour les environnements informatiques professionnels.

Il permet d'héberger différents services informatiques et des machines virtuelles.

### Caractéristiques observées

| Composant           | Description                 |
| ------------------- | --------------------------- |
| Modèle              | HP ProLiant DL360 G6        |
| Processeurs         | Deux emplacements CPU       |
| Mémoire RAM         | 64 Go détectés              |
| Type de mémoire     | Barrettes DIMM              |
| Stockage            | 3 disques SAS de 146,8 Go   |
| Contrôleur RAID     | HP Smart Array P410i        |
| Configuration RAID  | RAID 5                      |
| Capacité RAID       | Environ 293,56 Go           |
| BIOS                | HP ProLiant                 |
| Système             | Proxmox Virtual Environment |
| Nom du serveur      | server1                     |
| Adresse IP affichée | 192.168.100.2               |

**Remarque :** Les caractéristiques indiquées correspondent aux informations documentées pendant le laboratoire. Le modèle exact des processeurs et la version de Proxmox ne sont pas précisés dans les captures fournies.

---

# 🔍 3. Inspection physique du serveur

La première étape a consisté à ouvrir le serveur pour accéder aux composants internes.

Nous avons examiné la carte mère, les processeurs, les emplacements mémoire, les ventilateurs et les connecteurs.

Cette inspection permet de rechercher des anomalies visibles, notamment des composants mal installés ou des connexions incorrectes.

<img width="2048" height="2048" alt="Vue interne du serveur HP ProLiant" src="https://github.com/user-attachments/assets/5554cc80-df92-4897-a395-72c773bf9dec" />

**📸 Figure 1 :** Vue interne du serveur HP ProLiant DL360 G6 et des emplacements processeurs.

### Résultat

L'inspection nous a permis d'identifier les principaux composants à vérifier pendant le dépannage.

---

# 🧠 4. Diagnostic des processeurs

Le serveur possède deux emplacements processeurs :

* Processor 1
* Processor 2

Pendant le diagnostic, nous avons retiré et réinstallé les processeurs afin de vérifier leur positionnement.

### Étapes réalisées

1. Arrêt du serveur et déconnexion de son alimentation.
2. Ouverture du boîtier.
3. Retrait des dissipateurs thermiques.
4. Inspection des processeurs et des sockets.
5. Réinstallation des processeurs.
6. Remontage des dissipateurs thermiques.

<img width="2048" height="2048" alt="Processeur installé" src="https://github.com/user-attachments/assets/2821acaf-60b5-45a7-8027-53584006310f" />

**📸 Figure 2 :** Processeur installé dans son socket.

<img width="2048" height="2048" alt="Inspection du processeur" src="https://github.com/user-attachments/assets/4159be66-2469-4538-8f32-2884a83064b6" />

**📸 Figure 3 :** Processeur retiré pour inspection.

### Analyse technique

Un processeur incorrectement installé peut empêcher le serveur de terminer sa séquence de démarrage.

Il est donc important de vérifier son positionnement et l'état des contacts.

### Résultat

Les processeurs ont été inspectés puis réinstallés. Le serveur a ensuite pu poursuivre sa séquence de démarrage.

---

# 🌡️ 5. Vérification du système de refroidissement

Les processeurs produisent de la chaleur pendant leur fonctionnement.

Les dissipateurs thermiques permettent de transférer cette chaleur vers le système de refroidissement.

Après les vérifications, nous avons remis les dissipateurs en place.

<img width="2048" height="2048" alt="Dissipateurs thermiques" src="https://github.com/user-attachments/assets/d6dd21c5-7bb3-481e-b28f-a5180b72191a" />

**📸 Figure 4 :** Dissipateurs thermiques installés sur les processeurs.

### Importance

Un mauvais refroidissement peut provoquer :

* Une augmentation de la température des processeurs.
* Une diminution des performances.
* Un arrêt automatique du serveur.
* Des problèmes de stabilité.

### Résultat

Les dissipateurs ont été remontés et le système de refroidissement a été remis en place avant le démarrage.

---

# 💾 6. Vérification de la mémoire RAM

La mémoire RAM est essentielle au fonctionnement du serveur.

Nous avons inspecté les barrettes de mémoire et vérifié leur installation dans les emplacements DIMM.

<img width="2048" height="2048" alt="Barrettes de mémoire RAM" src="https://github.com/user-attachments/assets/ed2457af-e6a4-42ee-aff0-db00e5a06951" />

**📸 Figure 5 :** Mémoire RAM installée dans les emplacements DIMM.

### Méthode de diagnostic

Pour rechercher une panne de mémoire, il est possible de tester les barrettes progressivement, en respectant les configurations minimales et les emplacements recommandés par HP.

Cette méthode permet d'isoler une éventuelle barrette défectueuse.

### Résultat

Le BIOS a reconnu une configuration totale de **65 536 MB**, soit **64 Go de RAM**.

---

# 🛠️ 7. Retrait des composants pendant le dépannage

Afin de faciliter le diagnostic, plusieurs composants ont été temporairement retirés.

Il s'agissait principalement des disques durs et de certaines barrettes de mémoire.

<img width="2048" height="2048" alt="Disques SAS et mémoire RAM" src="https://github.com/user-attachments/assets/bb12bc21-a606-4ff2-85e3-c0c4c76d279e" />

**📸 Figure 6 :** Disques durs et barrettes de mémoire retirés pendant les vérifications.

### Objectif

Cette opération permet de réduire le nombre de composants à examiner simultanément.

Le POST peut ainsi être testé sans dépendre du chargement du système d'exploitation.

---

# ⚙️ 8. Vérification du démarrage POST

Après la réinstallation des composants nécessaires, nous avons remis le serveur sous tension.

L'écran de démarrage HP ProLiant est apparu.

Le message suivant était visible :

`Power and Thermal Calibration in Progress`

<img width="2048" height="2048" alt="Écran POST HP ProLiant" src="https://github.com/user-attachments/assets/c7bfeec7-673e-4861-9473-f646a1668090" />

**📸 Figure 7 :** Démarrage du serveur et calibration thermique.

### Explication du POST

Le POST signifie **Power-On Self-Test**.

Il s'agit d'une procédure de vérification matérielle exécutée au démarrage.

Le serveur contrôle notamment :

* La présence des processeurs.
* La mémoire RAM.
* Les composants essentiels de la carte mère.
* Certains périphériques et contrôleurs.

### Résultat

Le serveur a poursuivi son démarrage et nous avons pu accéder aux outils de diagnostic du BIOS.

---

# 🧪 9. Diagnostic de la mémoire dans le BIOS

Nous avons utilisé l'utilitaire **BIOS Memory Diagnostic** afin de vérifier la mémoire reconnue par le serveur.

<img width="2048" height="2048" alt="Diagnostic mémoire BIOS" src="https://github.com/user-attachments/assets/dcc7ecf2-1d36-4a39-a506-28deb7b4d997" />

**📸 Figure 8 :** Diagnostic de la mémoire dans le BIOS.

### Informations observées

| Paramètre                        | Résultat      |
| -------------------------------- | ------------- |
| Mémoire totale                   | 65 536 MB     |
| Équivalent                       | 64 Go         |
| Capacité des barrettes indiquées | 16 384 MB     |
| État du diagnostic sur la photo  | Test en cours |
| Reconnaissance par le BIOS       | Confirmée     |

### Analyse

La mémoire totale affichée correspond à :

`65 536 ÷ 1 024 = 64 Go`

Cette information confirme que le BIOS reconnaît les 64 Go de mémoire configurés.

**Attention :** La capture montre un test en cours. Elle ne suffit donc pas, à elle seule, à prouver que tous les tests mémoire ont été terminés sans erreur.

---

# 💽 10. Configuration du stockage RAID 5

Avant l'installation de Proxmox VE, nous avons préparé les disques à l'aide du contrôleur :

**HP Smart Array P410i**

### Disques utilisés

| Disque        | Capacité |
| ------------- | -------: |
| Disque SAS 1  | 146,8 Go |
| Disque SAS 2  | 146,8 Go |
| Disque SAS 3  | 146,8 Go |
| Configuration |   RAID 5 |

### Pourquoi utiliser RAID 5 ?

Le RAID 5 répartit les données et les informations de parité entre plusieurs disques.

Il permet de continuer à accéder aux données lorsqu'un seul disque tombe en panne, sous réserve que les autres disques restent fonctionnels.

### Calcul de la capacité

La formule théorique est :

`Capacité RAID 5 = (Nombre de disques - 1) × Capacité du plus petit disque`

Dans notre cas :

`(3 - 1) × 146,8 = 293,6 Go`

La capacité affichée pendant le laboratoire était d'environ **293,56 Go**.

<img width="2048" height="2048" alt="Configuration RAID 5 HP Smart Array" src="https://github.com/user-attachments/assets/241f6118-a928-4373-8596-d35a9b722c0a" />

**📸 Figure 9 :** Sélection des trois disques SAS et configuration du RAID 5.

### Résultat

Un volume logique RAID 5 a été préparé pour le stockage du serveur.

**Remarque :** Le RAID 5 améliore la tolérance aux pannes, mais ne remplace pas une sauvegarde.

---

# 🖥️ 11. Installation et démarrage de Proxmox VE

Après la préparation du matériel et du stockage, nous avons procédé à l'installation de Proxmox Virtual Environment.

Proxmox VE est une plateforme de virtualisation permettant d'administrer des machines virtuelles et des conteneurs.

Une fois le système installé, le serveur a démarré et affiché le message :

`Welcome to the Proxmox Virtual Environment`

<img width="2048" height="2048" alt="Proxmox Virtual Environment" src="https://github.com/user-attachments/assets/d9d05c3e-1e72-47cd-9c99-fff5d9b313a6" />

**📸 Figure 10 :** Proxmox Virtual Environment démarré sur le serveur.

### Informations affichées

| Paramètre             | Valeur        |
| --------------------- | ------------- |
| Plateforme            | Proxmox VE    |
| Nom du serveur        | server1       |
| Adresse IP            | 192.168.100.2 |
| Port Web              | 8006          |
| Protocole             | HTTPS         |
| Compte administrateur | root          |

L'adresse d'administration affichée est :

`https://192.168.100.2:8006/`

L'invite de commande est :

`root@server1:~#`

### Résultat

Le démarrage de Proxmox VE confirme que le système d'exploitation a pu être chargé.

L'adresse affichée permet d'identifier le point d'accès prévu pour l'administration Web.

La connexion effective depuis un autre ordinateur doit être vérifiée séparément.

---

# 🔐 12. Administration du serveur

Proxmox VE peut être administré à partir de son interface Web ou de la ligne de commande Linux.

Le compte administrateur principal est :

`root`

### Commandes utiles pour les prochaines vérifications

**Afficher le nom du serveur :**

```bash
hostname
```

**Afficher les adresses IP :**

```bash
ip addr
```

**Afficher les informations du processeur :**

```bash
lscpu
```

**Afficher la mémoire disponible :**

```bash
free -h
```

**Afficher les disques :**

```bash
lsblk
```

**Afficher la version de Proxmox :**

```bash
pveversion
```

Ces commandes pourront être utilisées pour documenter les prochaines étapes du laboratoire.

Elles sont présentées comme des vérifications possibles et non comme des commandes déjà exécutées.

---

# 📊 13. Tableau récapitulatif des vérifications

| Élément         | Vérification              | Résultat documenté      |
| --------------- | ------------------------- | ----------------------- |
| Serveur HP      | Inspection physique       | Réalisée                |
| Processeurs     | Retrait et réinstallation | Réalisés                |
| Sockets CPU     | Inspection                | Réalisée                |
| Dissipateurs    | Remontage                 | Réalisé                 |
| Mémoire RAM     | Reconnaissance BIOS       | 64 Go                   |
| Test mémoire    | Diagnostic BIOS           | En cours sur la capture |
| Disques SAS     | Inspection                | Réalisée                |
| Contrôleur RAID | Configuration             | RAID 5                  |
| Capacité RAID   | Volume logique            | Environ 293,56 Go       |
| POST            | Séquence de démarrage     | Démarrage poursuivi     |
| BIOS            | Accès aux diagnostics     | Confirmé                |
| Proxmox VE      | Démarrage                 | Confirmé                |
| Console root    | Invite affichée           | Confirmée               |
| Interface Web   | Adresse affichée          | 192.168.100.2:8006      |

---

# 🧩 14. Problèmes rencontrés et solutions

Pendant le laboratoire, nous avons travaillé sur plusieurs points importants.

| Problème ou difficulté             | Intervention                  | Résultat                    |
| ---------------------------------- | ----------------------------- | --------------------------- |
| Difficultés de démarrage           | Inspection des composants     | Diagnostic matériel réalisé |
| Vérification des processeurs       | Retrait et réinstallation     | Démarrage poursuivi         |
| Vérification de la mémoire         | Inspection et diagnostic BIOS | 64 Go reconnus              |
| Préparation du stockage            | Configuration RAID 5          | Volume logique préparé      |
| Mise en place de la virtualisation | Installation de Proxmox VE    | Système démarré             |

### Analyse

Le dépannage progressif nous a permis de vérifier les composants séparément avant de remettre le serveur dans sa configuration de fonctionnement.

Cette méthode est utile en administration système, car elle évite de modifier plusieurs éléments simultanément sans pouvoir identifier l'origine d'un problème.

La cause matérielle exacte des difficultés initiales n'a pas été isolée de manière certaine dans les preuves présentées.

---

# ✅ 15. Résultats du laboratoire

À la fin de notre travail, nous avons réussi à :

1. Inspecter le serveur HP ProLiant DL360 G6.
2. Identifier ses principaux composants.
3. Vérifier les processeurs et leurs sockets.
4. Réinstaller les processeurs.
5. Remonter les dissipateurs thermiques.
6. Examiner les barrettes de mémoire RAM.
7. Accéder au diagnostic mémoire du BIOS.
8. Confirmer la reconnaissance de 64 Go de RAM.
9. Inspecter les disques durs.
10. Poursuivre la séquence de démarrage POST.
11. Préparer trois disques SAS en RAID 5.
12. Obtenir un volume logique d'environ 293,56 Go.
13. Installer et démarrer Proxmox VE.
14. Accéder à la console Linux du serveur.
15. Identifier l'adresse d'administration Web de Proxmox.

Ces résultats montrent que le serveur a pu être remis en service pour les activités de virtualisation.

---

# 🎯 16. Conclusion

Ce laboratoire nous a permis d'acquérir des connaissances pratiques sur le diagnostic et la préparation d'un serveur physique.

Nous avons commencé par inspecter les composants internes du HP ProLiant DL360 G6 afin de comprendre les difficultés de démarrage rencontrées.

Les processeurs ont été vérifiés et réinstallés, tandis que la mémoire RAM a été examinée à l'aide des outils du BIOS.

Le serveur a ensuite poursuivi son démarrage et reconnu une configuration mémoire de 64 Go.

Nous avons également préparé les disques SAS avec une configuration RAID 5 afin de disposer d'un volume logique destiné à la virtualisation.

Finalement, nous avons installé et démarré Proxmox Virtual Environment.

L'adresse d'administration affichée par le serveur est :

`https://192.168.100.2:8006/`

Ce travail nous a permis de comprendre l'importance d'une démarche méthodique pour diagnostiquer un problème matériel.

Il nous a également familiarisés avec le fonctionnement des serveurs professionnels, les configurations RAID et les environnements de virtualisation Linux.

---

### 👨‍🎓 Informations de l'étudiant

**Nom :** Lachi Lahlou
**Numéro étudiant :** 300150410
**Cours :** INF1085 – Administration Linux
**Établissement :** Collège Boréal
**Travail :** Diagnostic matériel et installation de Proxmox VE
