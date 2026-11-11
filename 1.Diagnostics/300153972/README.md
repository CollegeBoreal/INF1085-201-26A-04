# Rapport de laboratoire – Serveur HP ProLiant DL360 G6

## Identification

| Champ | Information |
| --- | --- |
| Étudiant | Karim Bamba |
| Matricule | 300153972 |
| Programme | Techniques des systèmes informatiques – Collège Boréal |
| Cours | INF1085 – Administration Linux |

---

## Introduction et objectifs

Ce laboratoire consistait à démonter complètement un serveur rack HP ProLiant DL360 G6, à en identifier les composants, puis à le remonter et à valider son bon fonctionnement.

Les objectifs visés étaient les suivants :

- reconnaître et manipuler les composants internes d'un serveur (alimentations, disques, mémoire, processeurs, contrôleur RAID) ;
- vérifier, par des démarrages successifs, que le BIOS détecte correctement chaque composant ;
- configurer le stockage en RAID 5 à l'aide de l'utilitaire du contrôleur ;
- remonter le serveur et confirmer qu'il est prêt pour l'installation d'un système d'exploitation.

---

## Inventaire du matériel

Le serveur est un modèle 1U de génération 6 (G6), basé sur la plateforme Intel Xeon série 5500. Les composants suivants ont été identifiés.

| Composant | Quantité | Caractéristiques |
| --- | --- | --- |
| Processeur | 2 | Intel Xeon E5540, 2,53 GHz, 4 cœurs |
| Barrette RAM | 2 | 16 Go, DDR3 PC3-8500R (registered, ECC) |
| Barrette RAM | 8 | 4 Go, DDR3 PC3-8500R (registered, ECC) |
| Disque dur | 3 | SAS 146,8 Go, 15 000 tr/min, format 2,5 po, hot-swap |
| Bloc d'alimentation | 2 | HP, redondants, hot-plug |
| Contrôleur RAID | 1 | HP Smart Array P410i (slot 0) avec module de mémoire cache |
| Gestion à distance | 1 | HP iLO 2 (Integrated Lights-Out 2) intégré |

---

## Démontage

Avant toute manipulation, le serveur a été mis hors tension et débranché, et un bracelet antistatique a été utilisé pour protéger les composants contre les décharges électrostatiques.

1. **Alimentations** : les deux blocs ont été retirés par l'arrière du châssis en appuyant sur leur loquet de déverrouillage.
2. **Disques durs** : les trois disques SAS ont été extraits des baies hot-swap à l'avant. L'étiquette d'un disque a permis de confirmer sa capacité (146 Go) et sa vitesse (15K).
3. **Capot** : le capot supérieur a été ouvert pour accéder à la carte mère.
4. **Mémoire** : les barrettes ont été libérées en ouvrant les clips des slots DIMM. L'étiquette indique de la mémoire PC3-8500R, soit de la DDR3-1066 registered.
5. **Processeurs** : après le retrait des dissipateurs thermiques, chaque processeur a été libéré de son socket en levant le levier de verrouillage. Les broches du socket n'ont pas été touchées.
6. **Cache du contrôleur RAID** : le module de mémoire cache du contrôleur Smart Array a été repéré et identifié.



---

## Tests de démarrage et diagnostic BIOS

Le serveur a été démarré en ajoutant les composants progressivement. Cette méthode permet d'isoler un composant défectueux : si un démarrage échoue, le dernier composant ajouté est le suspect. L'utilitaire ROM-Based Setup Utility (RBSU) est accessible avec la touche **F9** pendant le POST.

| Test | Configuration | Résultat affiché | Interprétation |
| --- | --- | --- | --- |
| 1 | 1 CPU + 1 × 16 Go | 16 GB Installed, 1 Processor, Xeon E5540 @ 2.53 GHz ; « Proc 2 Not Installed » dans le RBSU | Configuration minimale fonctionnelle, CPU 1 et DIMM OK |
| 2 | 2 CPU + 1 × 16 Go | 16384 MB Memory Configured, Processor 1 et Processor 2 détectés | Le second CPU et son socket sont fonctionnels |

Une règle importante a été respectée : sur cette plateforme, chaque processeur gère ses propres slots mémoire. La mémoire installée dans les slots du CPU 2 n'est utilisable que si le CPU 2 est présent. C'est pourquoi la barrette de test a été placée dans un slot du CPU 1.

Pendant le POST, l'utilitaire de configuration de l'iLO 2 (Integrated Lights-Out 2) a aussi été ouvert. L'iLO permet d'administrer le serveur à distance (console, alimentation, journaux), même lorsque le système d'exploitation est éteint.

![Utilitaire de configuration iLO 2](images/20260917_142240.jpg)


---

## Configuration RAID 5

Les trois disques SAS ont été regroupés en un volume logique RAID 5 de 273,4 Go, avec le statut OK.

1. Accès à l'utilitaire du contrôleur (Option ROM Configuration for Arrays) pendant le démarrage.
2. Suppression de l'ancien Logical Drive (touche **F3**), afin de repartir d'une configuration propre. Un avertissement rappelle que toutes les données du volume seront perdues.
3. Création d'un nouveau Logical Drive : sélection des trois disques et choix du niveau RAID 5.
4. Vérification des paramètres, puis sauvegarde avec la touche **F8**.
5. Affichage de la configuration : Logical Drive #1, RAID 5, statut OK.

![Avertissement avant la suppression de l'ancien volume](images/20260917_142343.jpg)

![Logical Drive #1 en RAID 5 de 273,4 Go, statut OK](images/20260917_142823.jpg)

**Pourquoi RAID 5 ?** Les données et la parité sont réparties sur les trois disques. Si un disque tombe en panne, le contrôleur reconstruit son contenu à partir des deux autres. C'est un bon compromis entre capacité, performance en lecture et tolérance aux pannes.

**Calcul de la capacité utile** : en RAID 5, l'équivalent d'un disque sert à la parité.

```math
C_{utile} = (n - 1) \times C_{disque} = (3 - 1) \times 146{,}8 \text{ Go} = 293{,}6 \text{ Go}
```

Le contrôleur affiche 273,4 Go parce qu'il compte en unités binaires : 293,6 × 10⁹ octets ÷ 1 073 741 824 = 273,4 GiB. Il n'y a donc aucune perte d'espace anormale.


---

## Remontage et diagnostic final

Après le remontage complet, le RBSU indique **61440MB Memory Configured**, alors que 65 536 Mo sont installés. Il manque 4 096 Mo, soit exactement une barrette de 4 Go. Les deux processeurs (Intel 2,53 GHz, 8 Mo de cache L3) sont bien détectés.

![RBSU après remontage : 61440 MB et 2 processeurs](images/20260917_144105.jpg)

| Élément | Attendu | Observé | Écart |
| --- | --- | --- | --- |
| Mémoire | 2 × 16 Go + 8 × 4 Go = 64 Go (65 536 Mo) | 61 440 Mo (60 Go) | − 4 096 Mo |
| Processeurs | 2 | 2 | Aucun |
| Volume RAID | RAID 5, 3 disques | Logical Drive #1, RAID 5, OK | Aucun |
| Alimentations | 2 | 2 | Aucun |

**Analyse de l'écart mémoire.** Un manque d'exactement 4 Go indique qu'une barrette de 4 Go n'est pas prise en compte. Les causes possibles sont :

- une barrette mal insérée (clips non verrouillés) ;
- une barrette placée dans un slot non supporté par la règle de peuplement HP ;
- une barrette défectueuse, désactivée par le BIOS après le test mémoire.

**Démarche de résolution proposée :**

1. Consulter les messages du POST et l'Integrated Management Log (IML) pour savoir quel slot est signalé.
2. Réinsérer la barrette concernée en vérifiant les clips.
3. Comparer l'emplacement avec le schéma de peuplement sous le capot du serveur.
4. Si le problème persiste, échanger la barrette avec une barrette fonctionnelle pour confirmer si la barrette ou le slot est en cause.


---

## Récapitulatif et conclusion

| Composant | Configuration finale |
| --- | --- |
| Serveur | HP ProLiant DL360 G6 |
| Processeurs | 2 × Intel Xeon E5540 @ 2,53 GHz |
| Mémoire installée | 2 × 16 Go + 8 × 4 Go (64 Go) |
| Mémoire détectée | 60 Go (61 440 Mo) |
| Stockage | 3 × SAS 146 Go en RAID 5 |
| Volume logique | 273,4 Go, statut OK |
| Alimentations | 2 blocs HP redondants |

Ce laboratoire m'a permis de manipuler concrètement le matériel d'un serveur d'entreprise et de comprendre son rôle : alimentations redondantes, disques hot-swap, mémoire ECC et contrôleur RAID avec cache.

Les démarrages progressifs ont montré l'intérêt d'ajouter les composants un à un pour diagnostiquer une panne. La configuration RAID 5 a produit un volume de 273,4 Go tolérant la panne d'un disque.

Le diagnostic final a révélé un écart de 4 Go de mémoire, attribuable à une barrette non détectée. Une fois cet écart corrigé, le serveur est prêt pour l'installation d'un système d'exploitation.
