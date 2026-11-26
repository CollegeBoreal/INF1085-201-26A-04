# Rapport de diagnostic et validation POST — HP ProLiant DL360 G6

| | |
|---|---|
| **Cours** | INF1085-201-26A-04 — 1. Diagnostics |
| **Étudiante** | Salma Baali (300158383) |
| **Équipement** | Serveur HP ProLiant DL360 G6 |
| **Travail réalisé** | En équipe |

---

## Table des matières

1. [Contexte et problématique](#1-contexte-et-problématique)
2. [Inspection du serveur](#2-inspection-du-serveur)
3. [Manipulation du dissipateur thermique](#3-manipulation-du-dissipateur-thermique)
4. [Vérification des processeurs](#4-vérification-des-processeurs)
5. [Configuration minimale POST](#5-configuration-minimale-post)
6. [Démarrage et résultats du POST](#6-démarrage-et-résultats-du-post)
7. [BIOS et RBSU](#7-bios-et-rbsu)
8. [Mémoire système](#8-mémoire-système)
9. [Analyse des causes possibles](#9-analyse-des-causes-possibles)
10. [Composants complémentaires et dépannage observés en équipe](#10-composants-complémentaires-et-dépannage-observés-en-équipe)
11. [Disques : détection et configuration RAID](#11-disques--détection-et-configuration-raid)
12. [Formatage et montage sous Linux](#12-formatage-et-montage-sous-linux)
13. [Conclusion](#13-conclusion)
14. [Difficultés rencontrées et leçons apprises](#14-difficultés-rencontrées-et-leçons-apprises)
15. [Glossaire](#15-glossaire)
16. [Références](#16-références)

---

## 1. Contexte et problématique

Le serveur présentait un problème de démarrage : le **deuxième processeur n'était pas détecté**. Selon la procédure d'isolation de panne du laboratoire, on teste le processeur concerné **seul dans le socket 1 (PROC 1)**, avec une configuration minimale. Le but est de savoir si le défaut vient **du processeur lui-même** ou **du socket 2**.

**Méthode : procéder par élimination.**

1. Retirer tout ce qui n'est pas indispensable (configuration minimale POST).
2. Démarrer et observer les messages du POST.
3. Vérifier la détection du CPU et de la mémoire dans le BIOS.
4. En déduire quel élément est fautif.

### Fiche technique du matériel

| Élément | Détail |
|---|---|
| Serveur | HP ProLiant DL360 G6, format rack **1U** |
| Sockets processeur | 2 × **LGA1366** |
| Processeurs rencontrés | Intel Xeon **E5620** (2,40 GHz, 4 cœurs, 8 threads, 12 Mo de cache L3) et Intel Xeon **E5540** (2,53 GHz, 4 cœurs, 8 threads, 8 Mo de cache L3) |
| Mémoire | DDR3 ECC, **9 emplacements DIMM par processeur** (18 au total) |
| Contrôleur de stockage | Smart Array **P410i** intégré |
| Alimentation | 2 blocs *hot-plug* (baies 1 et 2) |
| Refroidissement | Ventilateurs *hot-plug* |
| BIOS observé | P64 (03/01/2010), RBSU 3.00, utilitaire de diagnostic 2.15 |

![Vue générale du serveur ouvert](images/01-vue-generale-serveur.jpg)

*Figure 1 — Vue générale de l'intérieur du serveur : processeur avec dissipateur, ventilateurs, emplacements mémoire et barrettes retirées.*

---

## 2. Inspection du serveur

Avant toute manipulation, le capot est retiré et on observe les composants internes : ventilateurs hot-plug, dissipateurs, carte mère et emplacements mémoire (DIMM).

![Serveur ouvert](images/03-serveur-ouvert.jpg)

*Figure 2 — Serveur ouvert, prêt pour l'inspection.*

Les emplacements mémoire sont répartis en slots **blancs** et **noirs**. Le premier slot blanc de chaque processeur est celui à utiliser en configuration minimale.

![Emplacements DIMM](images/02-slots-dimm.jpg)

*Figure 3 — Emplacements DIMM (blancs et noirs) à côté du processeur 2.*

---

## 3. Manipulation du dissipateur thermique

Pour accéder aux processeurs, il faut retirer le dissipateur. Cette étape permet d'observer le processeur et son socket (broches, pâte thermique).

> **Précautions :** serveur éteint et débranché, décharge électrostatique (bracelet antistatique), manipulation du processeur par les bords uniquement, ne jamais toucher les broches du socket.

![Manipulation du dissipateur](images/04-manipulation-dissipateur.jpg)

*Figure 4 — Manipulation du dissipateur thermique.*

---

## 4. Vérification des processeurs

Le DL360 G6 comporte deux sockets. L'inspection visuelle permet de voir les deux processeurs et leur emplacement.

![Les deux processeurs](images/06-deux-processeurs.jpg)

*Figure 5 — Vue des deux processeurs sur la carte mère.*

L'inspection visuelle seule **ne suffit pas** à confirmer la cause du problème : un test croisé est nécessaire (voir [section 9](#9-analyse-des-causes-possibles)).

---

## 5. Configuration minimale POST

| Élément | Configuration utilisée |
|---|---|
| Processeur | 1 Intel Xeon dans le socket 1 (PROC 1) |
| Mémoire | 1 barrette de 8 Go |
| Emplacement mémoire | PROC 1 DIMM 3 (slot blanc A1) |
| Cartes PCIe | Aucune carte supplémentaire |
| Alimentation | Bloc dans la baie 1 uniquement |

Processeurs rencontrés : **Intel Xeon E5620 (2,40 GHz)** et **Intel Xeon E5540 (2,53 GHz)**.

> Avec un seul bloc d'alimentation, le message **« 1615 – Power Supply Failure or Power Supply Unplugged in Bay 2 »** s'affiche. C'est **normal** : seule la baie 1 est alimentée.

---

## 6. Démarrage et résultats du POST

### 6.1 Calibration thermique

Au démarrage apparaît l'écran HP ProLiant avec le message **« Power and Thermal Calibration in Progress… »**. Il s'affiche pendant l'initialisation du serveur.

![Calibration thermique](images/07-calibration-thermique.jpg)

*Figure 6 — Écran de calibration thermique au démarrage.*

### 6.2 Détection du processeur

Le serveur passe le POST (Power-On Self-Test) et affiche :

- `1 Processor(s) detected, 4 total cores enabled, Hyperthreading is enabled` ;
- modèle : Intel Xeon E5620 @ 2,40 GHz (ou E5540 @ 2,53 GHz selon le processeur testé) ;
- chargement du BIOS **sans erreur critique de socket**.

![Écran POST](images/09-post-16go.jpg)

*Figure 7 — Écran POST : `16 GB Installed`, BIOS P64 (03/01/2010), `1 Processor(s) detected, 4 total cores enabled, Hyperthreading is enabled`, `Proc 1 : Intel Xeon E5620 @ 2.40GHz`, `QPI Speed : 5.8 GT/s`, `Advanced ECC Support`.*

---

## 7. BIOS et RBSU

À la fin du POST, le menu suivant s'affiche :

![Menu de démarrage](images/08-menu-bios.jpg)

*Figure 8 — Menu affiché à la fin du POST.*

| Touche | Fonction |
|---|---|
| **F1** | Continuer le démarrage |
| **F9** | ROM-Based Setup Utility (RBSU) |
| **F10** | System Maintenance Menu |
| **F11** | Default Boot Override Options |
| **F12** | Network Boot (démarrage réseau) |

### Configuration processeur dans le RBSU (version 3.00)

| Élément | Valeur observée |
|---|---|
| Proc 1 | Intel 2,53 GHz, 8 Mo de cache L3 |
| Proc 2 | Not Installed |

### Utilitaire de diagnostic HP (version 2.15)

Il permet de lancer des tests ciblés : **Memory Test**, **CPU Test**, **Boot Disk Test**.

---

## 8. Mémoire système

| Vérification | Résultat |
|---|---|
| Configuration minimale (1 barrette) | PROC 1 DIMM 3 : **8 192 Mo** détectés |
| Autres emplacements (PROC 1 et PROC 2) | Not Installed |
| Autre essai au POST | 16 GB Installed |
| Configuration finale au POST | 64 GB Installed |
| Diagnostic mémoire (configuration finale) | 65 536 Mo configurés et disponibles |

Les capacités affichées changent selon le nombre de barrettes installées à chaque essai. Chaque valeur correspond à une configuration différente, pas à une anomalie.

### 8.1 POST avec 16 Go

Voir la figure 7 : `16 GB Installed`.

### 8.2 BIOS Memory Diagnostic (configuration finale)

![Diagnostic mémoire](images/10-diagnostic-memoire.jpg)

*Figure 9 — BIOS Memory Diagnostic : 4 barrettes de 16 384 Mo, le reste des slots en `Not Installed`. Total : `65536MB Available / 65536MB Configured`.*

---

## 9. Analyse des causes possibles

Le test demandé par la procédure du laboratoire est de placer **le processeur seul dans le socket 1**, avec une barrette dans le premier slot de PROC 1. Le résultat observé : le serveur **passe le POST** (voir la section 6).

| Hypothèse | Indice observé | Conclusion |
|---|---|---|
| Processeur défectueux | Le processeur testé seul dans le socket 1 démarre et réussit le POST (CPU Diagnostic : OK) | **Écartée** |
| Mauvais emplacement du processeur | Le message « *Processor in incorrect slot – System Halted* » apparaît quand l'unique processeur est dans le socket 2 | **Cause confirmée de l'arrêt** : un seul CPU doit être dans le socket 1 |
| Socket 2 défectueux (broches pliées ou endommagées) | Non démontré : un processeur seul dans le socket 2 s'arrête de toute façon, même si le socket est sain | **À confirmer** par un test croisé |
| Canal mémoire du CPU 2 | Les emplacements de PROC 2 sont « Not Installed » | **Possible** |
| Module de cache RAID, pile CMOS | Retrait du cache et remplacement de la pile ont permis d'avancer vers le POST | **Corrigés** |
| Barrette mémoire défectueuse | Configuration minimale validée avec 8 Go | **Peu probable** |
| Alimentation | Seul l'avertissement normal 1615 de la baie 2 | **Écartée** |

**Point important :** un serveur avec un seul processeur ne démarre pas si celui-ci est dans le socket 2. L'arrêt observé dans ce cas ne prouve donc **pas** que le socket 2 est endommagé.

**Test croisé pour conclure sur le socket 2 :** installer un processeur reconnu sain (celui qui vient de passer le POST dans le socket 1) dans le **socket 2 avec un second processeur dans le socket 1**. Si le serveur ne détecte alors pas le processeur du socket 2 (RBSU : *Proc 2 : Not Installed*), le défaut vient du **socket 2 ou de son canal mémoire**. Si les deux sont détectés, le socket est sain.

---

## 10. Composants complémentaires et dépannage observés en équipe

Le laboratoire a été réalisé en équipe : les observations ci-dessous sont celles du groupe (voir aussi les rapports des coéquipiers [300142542](../300142542/README.md) et [300145955](../300145955/README.md)).

### 10.1 Composants identifiés

| Composant | Observation |
|---|---|
| Disques | **3 disques SAS de 146 Go** dans des tiroirs amovibles accessibles par l'avant |
| Modèle de disque observé | Dell Savvio 15K.2 : SAS 6 Gb/s, **15 000 tr/min**, classe entreprise |
| Contrôleur de disques | HP Smart Array **P410i** |
| Module de cache | **512 Mo**, branché sur le contrôleur P410i |
| Alimentations | 2 blocs redondants, **PS1 et PS2** |
| Pile CMOS | Pile bouton **CR2032** sur la carte mère |
| Interrupteur de maintenance | **SW1** : l'interrupteur n°6 réinitialise la configuration |
| Gestion à distance | iLO 2 |

![Les trois disques SAS](images/eq-04-trois-disques.jpeg)

*Figure 10 — Les trois disques SAS de 146 Go retirés de leurs baies.*

![Disque Dell Savvio 15K.2](images/eq-05-disque-dell.jpeg)

*Figure 11 — Gros plan sur un disque : Dell Savvio 15K.2, 146 Go, SAS 6 Gb/s, 15 000 tr/min.*

![Module de cache 512 Mo](images/eq-06-module-cache.jpeg)

*Figure 12 — Module de cache de 512 Mo du contrôleur Smart Array P410i.*

![Blocs d'alimentation PS1 et PS2](images/eq-07-alimentations.jpeg)

*Figure 13 — Les deux blocs d'alimentation redondants (PS1 et PS2).*

### 10.2 Démarche de dépannage appliquée

Le groupe a procédé **un changement à la fois**, en observant le résultat de chacun :

| Étape | Action | Pourquoi |
|---|---|---|
| 1 | Retrait du **module de cache** du contrôleur RAID | Un module défaillant ou à batterie usée peut empêcher le serveur d'atteindre le POST |
| 2 | Remplacement de la **pile CMOS** | Une pile usée peut corrompre les réglages du BIOS |
| 3 | Réinitialisation par l'interrupteur **SW1 n°6** | Revenir à la configuration d'usine |
| 4 | Déplacement du processeur dans le **socket 1** | Message d'arrêt « *Processor in incorrect slot – System Halted* » |

![Pile CMOS sur la carte mère](images/eq-08-pile-cmos.jpeg)

*Figure 14 — Pile CMOS sur la carte mère.*

![Interrupteur de maintenance SW1](images/eq-09-interrupteur-sw1.jpeg)

*Figure 15 — Interrupteur de maintenance SW1 (l'interrupteur n°6 réinitialise la configuration).*

**Procédure de réinitialisation par SW1 n°6 :**

1. Éteindre le serveur et débrancher les câbles d'alimentation.
2. Basculer l'interrupteur n°6 sur **ON**.
3. Rebrancher et allumer : la configuration est effacée.
4. Éteindre de nouveau.
5. **Remettre l'interrupteur n°6 sur OFF** ; sinon le serveur se réinitialise à chaque démarrage.
6. Rallumer normalement.

### 10.3 Le message « Processor in incorrect slot »

![Message Processor in incorrect slot](images/eq-12-processor-incorrect-slot.jpeg)

*Figure 16 — Arrêt du serveur : « Processor in incorrect slot – System Halted! ».*

Avec **un seul processeur**, celui-ci doit être dans le **socket 1 (Proc 1)**. Placé dans le socket 2, le serveur s'arrête avant le POST. Le déplacer dans le socket 1 a permis de démarrer : le BIOS fonctionnait, et la panne venait de l'**emplacement du processeur**.

### 10.4 Vérification du processeur

![BIOS CPU Diagnostic](images/eq-18-diagnostic-cpu.jpeg)

*Figure 17 — BIOS CPU Diagnostic : le processeur du socket Proc 1 a le statut OK.*

---

## 11. Disques : détection et configuration RAID

Après la validation du processeur et de la mémoire, la dernière étape du diagnostic est de vérifier les **disques** : un serveur qui passe le POST doit aussi voir son stockage avant de pouvoir installer un système.

Le DL360 G6 utilise un contrôleur **Smart Array P410i** intégré, avec un module de cache de 512 Mo. Dans notre serveur, il gère **3 disques SAS de 146 Go** (voir la [section 10](#10-composants-complémentaires-et-dépannage-observés-en-équipe)). Il présente au système des **volumes logiques** (*logical drives*) construits à partir des disques physiques ; les disques individuels ne sont donc pas visibles directement par Linux.

### 10.1 Détection au POST

Pendant le POST, le message du contrôleur Smart Array liste les disques détectés et l'état des volumes logiques. On y lit :

- le nombre de disques physiques détectés (baies SFF 2,5") ;
- l'état du volume logique (*OK*, *Failed*, *Not configured*) ;
- l'invite **F8 : Option ROM Configuration for Arrays** pour entrer dans l'utilitaire de configuration.

> Si aucun volume logique n'est configuré, le POST l'indique et le système ne verra aucun disque : c'est l'étape suivante à réaliser.

### 10.2 Configuration d'un volume logique (ORCA / ACU)

| Étape | Action |
|---|---|
| 1 | Appuyer sur **F8** à l'invite du Smart Array pour ouvrir l'ORCA (*Option ROM Configuration for Arrays*) |
| 2 | Choisir **Create Logical Drive** |
| 3 | Cocher les disques physiques à inclure dans le volume |
| 4 | Choisir le niveau **RAID** selon le besoin (tableau ci-dessous) |
| 5 | Valider avec **F8 (Save)**, puis redémarrer |

| RAID | Disques min. | Capacité utile | Tolérance de panne | Usage |
|---|---|---|---|---|
| RAID 0 | 2 | 100 % | Aucune | Performance, laboratoire jetable |
| RAID 1 | 2 | 50 % | 1 disque | Système (miroir) |
| RAID 1+0 | 4 | 50 % | 1 disque par miroir | Performance et sécurité |
| RAID 5 | 3 | N − 1 disques | 1 disque | Capacité et sécurité |

Pour un serveur de laboratoire, le **RAID 1** (système) ou le **RAID 5** (données) sont les choix usuels. L'utilitaire graphique **HP Array Configuration Utility (ACU)** permet les mêmes opérations avec une interface plus complète (extension d'un volume, disque de secours).

### 10.3 Vérification après configuration

Au redémarrage, le POST doit afficher le volume logique créé avec l'état **OK**. Un volume à l'état *Failed* ou *Rebuilding* signale un disque défectueux : on remplace le disque et le contrôleur reconstruit le volume.

---

## 12. Formatage et montage sous Linux

Une fois le volume logique créé, Linux le voit comme un disque ordinaire (par exemple `/dev/sda`). Il reste à le partitionner, à le formater et à le monter.

### 11.1 Identifier le disque

```bash
lsblk
sudo fdisk -l
```

`lsblk` liste les disques, leurs partitions et leurs points de montage. **Toujours vérifier le nom du disque avant de le formater** : formater le mauvais disque détruit ses données.

### 11.2 Partitionner

```bash
sudo parted /dev/sdb --script mklabel gpt
sudo parted /dev/sdb --script mkpart primary ext4 0% 100%
```

Ici `/dev/sdb` est un exemple : à remplacer par le disque identifié à l'étape précédente. Le schéma **GPT** est le choix moderne pour les disques de plus de 2 To.

### 11.3 Formater

```bash
sudo mkfs.ext4 /dev/sdb1
```

Le système de fichiers **ext4** est le plus courant sous Linux. Le formatage crée la structure qui permet de stocker des fichiers.

### 11.4 Monter

```bash
sudo mkdir -p /mnt/data
sudo mount /dev/sdb1 /mnt/data
df -h
```

`df -h` confirme que la partition est montée et affiche sa taille.

### 11.5 Montage permanent

Pour que le montage survive au redémarrage, on ajoute une ligne dans `/etc/fstab`, en utilisant l'**UUID** (plus stable que le nom `/dev/sdb1`) :

```bash
sudo blkid /dev/sdb1
echo 'UUID=<uuid-affiché> /mnt/data ext4 defaults 0 2' | sudo tee -a /etc/fstab
sudo mount -a
```

`mount -a` teste le fichier `fstab` : une erreur ici doit être corrigée avant tout redémarrage, sinon le système peut ne pas démarrer.

### 11.6 Résumé du flux

| Étape | Outil | Résultat |
|---|---|---|
| Créer le volume logique | ORCA (F8) / ACU | Disque visible par Linux |
| Identifier | `lsblk`, `fdisk -l` | Nom du disque (`/dev/sdX`) |
| Partitionner | `parted` | Table GPT + partition |
| Formater | `mkfs.ext4` | Système de fichiers |
| Monter | `mount`, `/etc/fstab` | Disque utilisable et persistant |

---

## 13. Conclusion

- Le **processeur testé et le socket 1 sont fonctionnels** : le serveur réussit le POST (`1 Processor(s) detected`), le CPU Diagnostic indique **OK** et la mémoire est détectée (8 192 Mo sur PROC 1 DIMM 3).
- L'arrêt « *Processor in incorrect slot* » vient de l'**emplacement du processeur** : avec un seul CPU, il doit être dans le socket 1.
- Le retrait du **module de cache RAID**, le remplacement de la **pile CMOS** et la réinitialisation par **SW1 n°6** ont permis au serveur d'atteindre le POST.
- Le RBSU indique **Proc 2 : Not Installed**. Le **socket 2** reste une hypothèse à confirmer par le test croisé décrit en section 9.
- Le serveur contient **3 disques SAS de 146 Go** derrière un Smart Array P410i (cache 512 Mo) : ils se gèrent en deux temps, avec le **volume logique** créé dans le contrôleur (ORCA/ACU), puis Linux qui le **partitionne, formate et monte** (`parted`, `mkfs.ext4`, `/etc/fstab`).
- Ce laboratoire a permis de pratiquer l'isolation de panne par configuration minimale, la lecture des messages POST, l'utilisation du RBSU, du diagnostic mémoire et CPU, et la préparation du stockage.

---

## 14. Difficultés rencontrées et leçons apprises

| Difficulté | Solution / leçon |
|---|---|
| Le deuxième processeur n'était pas détecté | Isolation par **configuration minimale** et test du processeur seul dans le socket 1 (le socket 2 reste à confirmer par un test croisé) |
| Message **1615** (alimentation baie 2) | Normal avec un seul bloc branché : ne pas le confondre avec une panne |
| Capacité mémoire différente d'un essai à l'autre (8, 16, 64 Go) | Chaque valeur correspond à la configuration testée, pas à une anomalie |
| Arrêt au démarrage : « Processor in incorrect slot » | Un seul processeur doit être dans le **socket 1** ; le déplacer a permis de démarrer |
| Le serveur n'atteignait pas le POST | Retrait du module de cache RAID, remplacement de la pile CMOS, réinitialisation par SW1 n°6 |
| Distinguer un défaut de CPU d'un défaut de socket | Le **test croisé** est indispensable : l'inspection visuelle seule ne suffit pas |

**Bonnes pratiques retenues :**

- Travailler serveur éteint et débranché, avec un bracelet antistatique.
- Ne jamais toucher les broches du socket LGA1366 ; manipuler le processeur par les bords.
- Ne changer qu'**un seul élément à la fois** pour pouvoir conclure.
- Retirer le **module de cache** du contrôleur RAID dès le début du diagnostic.
- Après une réinitialisation par **SW1 n°6**, remettre l'interrupteur sur OFF.
- Lire attentivement les **messages du POST** : ils indiquent souvent la cause directement.
- Noter chaque configuration testée et son résultat.
- Vérifier le nom du disque avec `lsblk` avant tout formatage.

---

## 15. Glossaire

| Terme | Définition |
|---|---|
| **POST** | *Power-On Self-Test* : auto-test exécuté au démarrage |
| **BIOS** | Micrologiciel qui initialise le matériel au démarrage |
| **RBSU** | *ROM-Based Setup Utility* : configuration du BIOS HP (touche F9) |
| **ORCA** | *Option ROM Configuration for Arrays* : configuration RAID au démarrage (touche F8) |
| **ACU** | *Array Configuration Utility* : outil HP de gestion des volumes RAID |
| **LGA1366** | Socket Intel où les broches sont sur la carte mère |
| **DIMM** | Barrette de mémoire vive |
| **ECC** | Mémoire avec correction d'erreurs |
| **QPI** | *QuickPath Interconnect* : lien entre processeurs et chipset Intel |
| **RAID** | Regroupement de disques pour la performance ou la tolérance de panne |
| **GPT** | Table de partitions moderne, adaptée aux grands disques |
| **UUID** | Identifiant unique d'une partition, stable dans `/etc/fstab` |

---

## 16. Références

- LGA 1366 : <https://fr.wikipedia.org/wiki/LGA_1366>
- Spécifications Intel Xeon E5620 / E5540 : fiches produit Intel ARK (ark.intel.com)
- Dépôt du cours : <https://github.com/CollegeBoreal/INF1085-201-26A-04>
