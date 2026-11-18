# 🖥️ Rapport de dépannage et validation POST – HP ProLiant DL360 G6

**Matricule : 300151588**  
**Établissement : Collège Boréal**  
**Cours : Administration Linux**  
**Projet : Diagnostic matériel et préparation d'un serveur**

---

## 📋 1. Présentation du projet

Ce laboratoire avait pour objectif de diagnostiquer un problème de démarrage sur un serveur **HP ProLiant DL360 G6**, de vérifier le fonctionnement des composants matériels et de préparer le serveur pour l'installation d'un système de virtualisation.

Le serveur présentait initialement un problème de démarrage, avec une absence de validation POST (*Power-On Self-Test*).

Pour identifier l'origine du problème, nous avons effectué plusieurs tests matériels en utilisant une configuration minimale.

### Objectifs du laboratoire

- Identifier la cause du problème de démarrage.
- Tester les processeurs individuellement.
- Vérifier le fonctionnement des sockets CPU.
- Contrôler la détection de la mémoire RAM.
- Examiner les paramètres du BIOS.
- Vérifier les disques et préparer le stockage.
- Valider le fonctionnement du serveur avant l'installation de Proxmox VE.

![Serveur HP ProLiant DL360 G6](https://github.com/user-attachments/assets/f1f0bbcb-b8b7-4eb7-8bcf-b33f2063bbc0)

*Figure 1 — Serveur HP ProLiant utilisé pendant le laboratoire.*

---

## 🔍 2. Problématique rencontrée

Au début du laboratoire, le serveur ne parvenait pas à terminer correctement son démarrage.

Nous avons donc procédé à une méthode de dépannage par élimination afin d'identifier le composant responsable.

La première étape consistait à retirer le second processeur et à tester individuellement les processeurs dans le premier emplacement (**Socket 1 / PROC 1**).

Cette méthode permettait de vérifier si le problème provenait :
- D'un processeur défectueux.
- Du second socket CPU.
- D'une barrette mémoire.
- D'une mauvaise configuration matérielle.
- D'un autre composant du serveur.

![Inspection du serveur](https://github.com/user-attachments/assets/711d79cc-311e-4659-9e52-26cedcc67b84)

*Figure 2 — Inspection du matériel et préparation des tests.*

---

## ⚙️ 3. Configuration matérielle minimale POST

Pour effectuer les diagnostics, nous avons démarré le serveur avec le minimum de composants nécessaires.

### Configuration utilisée

| Composant | Configuration de test |
|---|---|
| Modèle du serveur | HP ProLiant DL360 G6 |
| Processeur | 1 × Intel Xeon |
| Modèles observés selon les tests | E5620 (2,40 GHz) / E5540 (2,53 GHz) |
| Emplacement CPU | Socket 1 (PROC 1) |
| Mémoire RAM | 1 × 8 Go |
| Emplacement mémoire | PROC 1 DIMM 3 |
| Cartes PCIe supplémentaires | Retirées pour le test |
| Alimentation | Baie 1 alimentée |
| Second processeur | Non installé pendant le test minimal |

**Objectif :** Vérifier si le serveur pouvait terminer son démarrage avec un seul processeur et une barrette mémoire.

---

## 🖥️ 4. Vérification du démarrage POST

Après avoir installé le processeur dans le Socket 1 et conservé une seule barrette mémoire, nous avons redémarré le serveur.

Le BIOS a détecté le processeur et a poursuivi les vérifications matérielles.

### Informations affichées

| Paramètre | Résultat |
|---|---|
| Processeur détecté | 1 processeur |
| Nombre de cœurs | 4 |
| Hyper-Threading | Activé |
| Modèle affiché lors d'un test | Intel Xeon E5620 @ 2,40 GHz |
| Calibration thermique | En cours pendant le démarrage |
| Détection du processeur | Réussie |

![Écran de démarrage POST](https://github.com/user-attachments/assets/9ac5bd2f-276a-4c0d-b681-291de0c0cc2b)

*Figure 3 — Détection du processeur pendant le démarrage POST.*

**Résultat :** Le serveur a franchi l'étape de détection du processeur, ce qui confirme que le processeur testé fonctionne dans le Socket 1.

---

## 🧠 5. Diagnostic de la mémoire RAM

Nous avons ensuite utilisé l'utilitaire de diagnostic mémoire du BIOS pour vérifier la reconnaissance de la barrette installée.

### Résultats

| Élément | Résultat |
|---|---|
| Emplacement mémoire | PROC 1 DIMM 3 |
| Capacité détectée | 8192 MB (8 Go) |
| Autres emplacements | Not Installed |
| Mémoire totale du test | 8192 MB |
| Détection BIOS | Réussie |

La mémoire a été correctement reconnue dans le premier emplacement utilisé pour le test.

Cette vérification permet de confirmer la détection de la barrette mémoire, sans remplacer un test approfondi de son intégrité.

---

## 🔧 6. Vérification de la configuration BIOS (RBSU)

Après le diagnostic mémoire, nous avons accédé à l'utilitaire **ROM-Based Setup Utility (RBSU)** du serveur.

Cet utilitaire permet de consulter et de modifier les paramètres matériels.

### Informations observées

- **Proc 1 :** Intel Xeon détecté.
- **Fréquence observée :** 2,53 GHz lors du test E5540.
- **Mémoire cache L3 :** 8 MB.
- **Proc 2 :** Not Installed.
- **Mémoire :** Configuration minimale détectée, puis vérification de configurations avec davantage de mémoire.

![Configuration BIOS](https://github.com/user-attachments/assets/d4a12ef6-8e92-4b71-bf51-f8b6561e9ad3)

*Figure 4 — Vérification de la configuration matérielle dans le BIOS.*

![Informations du système](https://github.com/user-attachments/assets/8665282a-9f1f-4f7b-924e-63c2d3ae11d8)

*Figure 5 — Informations matérielles affichées dans l'utilitaire RBSU.*

**Résultat :** Le processeur installé dans le premier socket est correctement reconnu par le BIOS.

---

## 🛠️ 7. Utilisation de l'utilitaire de diagnostic HP

Nous avons également accédé à l'utilitaire de diagnostic système HP, version 2.15.

Cet outil permet d'effectuer plusieurs vérifications matérielles.

### Tests disponibles

| Test | Fonction |
|---|---|
| CPU Test | Vérifier le fonctionnement du processeur |
| Memory Test | Détecter certaines erreurs de mémoire RAM |
| Boot Disk Test | Vérifier le disque de démarrage |

L'accès à cet utilitaire nous a permis de poursuivre l'investigation du problème matériel.

---

## 💾 8. Vérification et formatage des disques

Après les tests du processeur et de la mémoire, nous avons abordé la préparation du système de stockage.

Cette étape est importante avant l'installation d'un système d'exploitation ou d'un hyperviseur comme Proxmox VE.

### 8.1 Vérification des disques

Nous avons vérifié la présence des disques dans le serveur ainsi que leur reconnaissance par le contrôleur de stockage.

Les vérifications nécessaires comprennent :

1. Contrôler la connexion physique des disques.
2. Accéder à l'utilitaire du contrôleur RAID HP.
3. Vérifier la détection des disques physiques.
4. Examiner la configuration RAID existante.
5. Identifier le volume logique destiné à l'installation.

### 8.2 Configuration du stockage RAID

Le serveur peut utiliser une configuration RAID pour regrouper plusieurs disques physiques dans un volume logique.

Dans le cadre du laboratoire, la configuration de stockage prévue repose sur **trois disques SAS en RAID 5**.

Le RAID 5 utilise une répartition des données et de la parité sur les disques, ce qui permet de tolérer la panne d'un disque.

| Élément | Configuration |
|---|---|
| Type de disques | SAS |
| Nombre de disques | 3 |
| Niveau RAID | RAID 5 |
| Tolérance de panne | 1 disque |
| Utilisation | Stockage du système et des machines virtuelles |

### 8.3 Préparation et formatage du disque

Une fois le volume logique configuré et reconnu, il est possible de préparer le stockage pour l'installation du système.

La procédure générale comprend :

1. Accéder à l'installateur du système d'exploitation.
2. Sélectionner le volume logique créé.
3. Vérifier la capacité du disque affichée.
4. Choisir le système de fichiers ou le schéma de stockage.
5. Confirmer l'installation sur le disque sélectionné.
6. Laisser l'installateur préparer les partitions et les systèmes de fichiers nécessaires.

**Attention :** Le formatage peut supprimer les données présentes sur le disque. Il faut donc vérifier que le volume sélectionné ne contient pas de données importantes.

Dans le cas de Proxmox VE, l'installateur peut effectuer automatiquement le partitionnement et le formatage du volume choisi.

### 8.4 Vérification du stockage sous Linux

Après l'installation, plusieurs commandes permettent de vérifier la configuration des disques :

```bash
lsblk
```

Affiche les disques et les partitions détectés.

```bash
lsblk -f
```

Affiche les systèmes de fichiers et les points de montage.

```bash
df -h
```

Affiche l'espace utilisé et disponible sur les systèmes de fichiers montés.

```bash
fdisk -l
```

Affiche les informations de partitionnement des disques (avec les privilèges nécessaires).

Ces commandes sont utiles pour confirmer que le système reconnaît correctement les volumes de stockage.

---

## ✅ 9. Résultats du diagnostic

Les différents tests ont permis d'obtenir les résultats suivants :

| Vérification | Résultat |
|---|---|
| Démarrage en configuration minimale | ✅ Réussi |
| Détection du processeur dans Socket 1 | ✅ Réussie |
| Détection de 4 cœurs | ✅ Réussie |
| Hyper-Threading | ✅ Activé |
| Détection de la RAM de 8 Go | ✅ Réussie |
| Accès au BIOS RBSU | ✅ Réussi |
| Accès à l'utilitaire de diagnostic HP | ✅ Réussi |
| Diagnostic définitif du Socket 2 | À confirmer |
| Vérification et formatage du stockage | Procédure documentée |

### Analyse de la panne

Les tests ont permis de confirmer que le processeur testé dans le Socket 1 était reconnu et permettait au serveur de poursuivre le démarrage.

Le problème initial pourrait provenir du second socket, de ses broches, de son circuit mémoire ou de la configuration associée au second processeur.

Cependant, des tests complémentaires seraient nécessaires pour identifier précisément le composant défectueux.

---

## 🎯 10. Compétences développées

Ce laboratoire nous a permis d'acquérir plusieurs compétences :

- Diagnostic d'un serveur physique.
- Identification des composants matériels.
- Vérification du fonctionnement des processeurs.
- Utilisation de la configuration minimale POST.
- Diagnostic de la mémoire RAM.
- Administration des paramètres BIOS et RBSU.
- Compréhension du fonctionnement du RAID 5.
- Préparation et formatage des volumes de stockage.
- Utilisation de commandes Linux pour vérifier les disques.

---

## 📝 11. Conclusion

Ce laboratoire nous a permis de comprendre les principales méthodes de dépannage d'un serveur **HP ProLiant DL360 G6**.

Nous avons commencé par isoler les composants matériels afin d'identifier l'origine du problème de démarrage.

Les tests ont confirmé que le processeur utilisé dans le premier socket était correctement détecté et que le serveur pouvait poursuivre son démarrage avec une configuration minimale.

Nous avons également vérifié la détection de la mémoire RAM, consulté les informations du BIOS et étudié la préparation du stockage à l'aide d'une configuration RAID 5.

Ces différentes étapes constituent une base importante pour la maintenance des serveurs physiques et leur préparation à l'installation d'un système de virtualisation comme **Proxmox VE**.

---

**Projet réalisé dans le cadre du cours d'Administration Linux — Collège Boréal.**
