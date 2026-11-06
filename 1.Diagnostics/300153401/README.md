
# 🖥️ INF1085 – Administration Linux

## 🔧 Rapport de dépannage, validation matérielle et installation de Proxmox VE

**🖥️ Serveur :** HP ProLiant DL360 G6  
**📚 Cours :** INF1085 – Administration Linux

---

## 📋 1. Introduction

Dans le cadre de ce travail pratique, nous avons effectué le diagnostic et la remise en fonctionnement d'un serveur HP ProLiant DL360 G6.

Le serveur présentait des problèmes de démarrage. Pour trouver l'origine du problème, nous avons procédé étape par étape en vérifiant les principaux composants matériels :

- 🔹 Les processeurs
- 🔹 La mémoire RAM
- 🔹 Les disques durs
- 🔹 Les ventilateurs
- 🔹 La carte mère

Après les tests matériels et la validation du POST, nous avons réussi à démarrer le serveur et à accéder à Proxmox Virtual Environment.

---

## 🔍 2. Inspection du matériel

La première étape consistait à ouvrir le serveur afin d'accéder aux composants internes.

Nous avons identifié les processeurs, les emplacements de mémoire RAM, les ventilateurs et les autres composants de la carte mère.

<img width="2048" height="2048" alt="Vue interne du serveur" src="https://github.com/user-attachments/assets/5554cc80-df92-4897-a395-72c773bf9dec" />

*📸 Figure 1 : Vue interne du serveur et des deux emplacements processeurs.*

Cette inspection permet de vérifier si les processeurs sont correctement installés et s'il existe un problème visible au niveau des sockets ou de la carte mère.

---

## 🧠 3. Vérification des processeurs

Le serveur possède deux emplacements pour processeurs :

- **Processor 1**
- **Processor 2**

Pendant le diagnostic, les processeurs ont été retirés et réinstallés afin de vérifier leur fonctionnement.

<img width="2048" height="2048" alt="Processeur installé" src="https://github.com/user-attachments/assets/2821acaf-60b5-45a7-8027-53584006310f" />

*📸 Figure 2 : Processeur installé dans son socket.*

Cette étape permet de vérifier le positionnement du processeur ainsi que son système de fixation.

Nous avons également observé le processeur après son retrait.

<img width="2048" height="2048" alt="Processeur retiré" src="https://github.com/user-attachments/assets/4159be66-2469-4538-8f32-2884a83064b6" />

*📸 Figure 3 : Processeur retiré du serveur pour inspection.*

Cette vérification est importante afin de s'assurer que les contacts du processeur et du socket ne sont pas endommagés.

---

## 🌡️ 4. Installation des dissipateurs thermiques

Après avoir vérifié les processeurs, les dissipateurs thermiques ont été remis en place.

Ils permettent d'évacuer la chaleur produite par les processeurs pendant le fonctionnement.

<img width="2048" height="2048" alt="Dissipateurs thermiques" src="https://github.com/user-attachments/assets/d6dd21c5-7bb3-481e-b28f-a5180b72191a" />

*📸 Figure 4 : Dissipateurs thermiques installés sur les processeurs.*

⚠️ Une mauvaise installation du dissipateur peut provoquer une surchauffe et empêcher le serveur de fonctionner normalement.

---

## 💾 5. Vérification de la mémoire RAM

La mémoire RAM a également été vérifiée pendant le diagnostic.

Les barrettes doivent être placées dans les bons emplacements DIMM selon la configuration du serveur et les processeurs utilisés.

<img width="2048" height="2048" alt="Mémoire RAM" src="https://github.com/user-attachments/assets/ed2457af-e6a4-42ee-aff0-db00e5a06951" />

*📸 Figure 5 : Mémoire RAM installée dans les emplacements DIMM.*

Pour faciliter le dépannage, il est possible de commencer avec une seule barrette de mémoire compatible, puis d'ajouter progressivement les autres barrettes.

Cette méthode permet de vérifier si une barrette ou un emplacement mémoire est responsable du problème.

---

## 🛠️ 6. Composants retirés pendant le diagnostic

Les disques durs et plusieurs barrettes de RAM ont également été retirés pendant les tests.

<img width="2048" height="2048" alt="Disques et mémoire retirés" src="https://github.com/user-attachments/assets/bb12bc21-a606-4ff2-85e3-c0c4c76d279e" />

*📸 Figure 6 : Disques durs HP et barrettes de mémoire retirés pendant le diagnostic.*

Le retrait des disques permet de réaliser le POST indépendamment du système de stockage.

Il devient alors plus facile de déterminer si le problème vient du processeur, de la mémoire ou du stockage.

---

## 🚀 7. Démarrage du serveur et test POST

Après avoir réinstallé les composants nécessaires, le serveur a été mis sous tension.

Le serveur affiche l'écran HP ProLiant et commence l'étape :

**Power and Thermal Calibration in Progress**

<img width="2048" height="2048" alt="Démarrage HP ProLiant" src="https://github.com/user-attachments/assets/c7bfeec7-673e-4861-9473-f646a1668090" />

*📸 Figure 7 : Démarrage du HP ProLiant et calibration thermique.*

Cette étape montre que le serveur est capable de commencer sa séquence de démarrage.

Le POST (Power-On Self-Test) permet au serveur de vérifier les principaux composants avant de lancer le système d'exploitation.

✅ Le démarrage a ensuite pu se poursuivre.

---

## 🧪 8. Diagnostic de la mémoire avec le BIOS

Nous avons ensuite utilisé l'utilitaire **BIOS Memory Diagnostic**.

<img width="2048" height="2048" alt="Diagnostic mémoire BIOS" src="https://github.com/user-attachments/assets/dcc7ecf2-1d36-4a39-a506-28deb7b4d997" />

*📸 Figure 8 : Diagnostic de la mémoire dans le BIOS.*

Le diagnostic montre plusieurs barrettes de 16 384 MB, soit 16 Go chacune, installées sur le processeur 1.

### 📊 Mémoire détectée

| Élément | Résultat |
|---|---|
| Capacité d'une barrette | 16 384 MB |
| Mémoire totale configurée | 65 536 MB |
| Capacité totale | 64 Go |
| Utilitaire | BIOS Memory Diagnostic |
| État sur la capture | Test en cours |

Sur la photo, le test mémoire est toujours en cours. Le BIOS affiche également la quantité de mémoire déjà testée avec succès.

Cette étape permet de vérifier que les barrettes sont reconnues par le serveur et que le BIOS peut accéder à la mémoire installée.

---

## ✅ 9. Vérification finale du matériel

Après la vérification des processeurs et de la mémoire, les dissipateurs ont été remontés et les ventilateurs ont été remis en place.

### 📋 Tableau de validation

| Composant | Résultat |
|---|---|
| 🧠 Processeur 1 | Détecté et fonctionnel |
| 🧠 Processeur 2 | Installé et vérifié |
| 🔧 Sockets processeurs | Vérifiés |
| 💾 Mémoire RAM | Détectée |
| 📊 Mémoire configurée | 65 536 MB / 64 Go |
| 💿 Disques durs | Vérifiés et réinstallés |
| 🌬️ Ventilateurs | Fonctionnels |
| 🚀 POST | Réussi |
| ⚙️ BIOS | Accessible |

Le serveur a pu poursuivre son démarrage avec les composants réinstallés.

---

## 💿 10. Préparation des disques et configuration RAID 5

Avant l'installation de Proxmox VE, nous avons préparé les disques du serveur avec le contrôleur **HP Smart Array P410i**.

### 🔧 Configuration du stockage

Les trois disques SAS de 146,8 Go ont été sélectionnés afin de créer un volume logique en RAID 5.

| Élément | Configuration |
|---|---|
| Contrôleur | HP Smart Array P410i |
| Type de disques | SAS |
| Nombre de disques | 3 |
| Capacité par disque | 146,8 Go |
| Niveau RAID | RAID 5 |
| Capacité logique approximative | 293,56 Go |

<img width="2048" height="2048" alt="Configuration RAID 5" src="https://github.com/user-attachments/assets/241f6118-a928-4373-8596-d35a9b722c0a" />

*📸 Figure 9 : Sélection des trois disques SAS et configuration du RAID 5.*

### ✅ Résultat

Le RAID 5 permet de répartir les données et les informations de parité sur les trois disques.

Cette configuration offre une tolérance à la panne d'un disque.

Le volume logique prépare l'espace de stockage destiné à l'installation de Proxmox VE.

**Remarque :** la création du RAID prépare le volume logique. Le partitionnement et le formatage du système de fichiers sont des opérations distinctes réalisées pendant l'installation.

---

## 🖥️ 11. Installation et démarrage de Proxmox VE

Après avoir terminé le diagnostic matériel et préparé le stockage, nous avons installé et démarré **Proxmox Virtual Environment** sur le serveur.

<img width="2048" height="2048" alt="Démarrage de Proxmox VE" src="https://github.com/user-attachments/assets/d9d05c3e-1e72-47cd-9c99-fff5d9b313a6" />

*📸 Figure 10 : Proxmox Virtual Environment démarré sur le serveur.*

L'écran affiche :

**Welcome to the Proxmox Virtual Environment**

### 🌐 Adresse d'administration

Le serveur indique l'adresse suivante :

`https://192.168.100.2:8006/`

### 🔑 Accès au système

L'invite de commande affichée est :

```bash
root@server1:~#
```

✅ Cela confirme que Proxmox a démarré et que le système est accessible en console.

L'adresse affichée permet d'accéder à l'interface Web depuis un navigateur connecté au réseau approprié.

---

## 🔎 12. Validation du fonctionnement du serveur

Le démarrage de Proxmox constitue une étape importante dans la validation du serveur.

Les tests réalisés et le démarrage réussi permettent de confirmer le fonctionnement des principaux éléments nécessaires :

- ✅ Processeurs
- ✅ Mémoire RAM reconnue
- ✅ Contrôleur de stockage
- ✅ Disques et volume logique
- ✅ BIOS
- ✅ Système de refroidissement
- ✅ Démarrage de Proxmox VE

Le serveur dispose maintenant d'un environnement de virtualisation fonctionnel.

---

## 🏆 13. Résultats obtenus

À la fin du travail, nous avons réussi à :

1. ✅ Ouvrir et inspecter le serveur.
2. ✅ Retirer les processeurs pour les vérifier.
3. ✅ Vérifier les sockets des processeurs.
4. ✅ Réinstaller les processeurs.
5. ✅ Vérifier les barrettes de mémoire RAM.
6. ✅ Lancer le diagnostic mémoire avec le BIOS.
7. ✅ Vérifier les disques durs.
8. ✅ Réinstaller les dissipateurs thermiques.
9. ✅ Réussir le POST du serveur.
10. ✅ Configurer les trois disques en RAID 5.
11. ✅ Démarrer correctement le serveur.
12. ✅ Installer et lancer Proxmox Virtual Environment.
13. ✅ Accéder à la console avec le compte root.
14. ✅ Obtenir l'adresse Web d'administration de Proxmox.

---

## 📝 14. Conclusion

Ce travail pratique nous a permis de réaliser le dépannage d'un serveur **HP ProLiant DL360 G6**.

Nous avons commencé par vérifier les composants matériels un par un afin d'isoler la cause du problème de démarrage.

Les processeurs ont été retirés, inspectés et réinstallés. La mémoire RAM a également été vérifiée à l'aide de l'utilitaire de diagnostic du BIOS.

Le serveur a finalement réussi son POST et le BIOS a reconnu une configuration de **64 Go de mémoire RAM**.

Nous avons ensuite préparé les trois disques SAS en configurant un RAID 5 avec le contrôleur HP Smart Array P410i.

Après la validation du matériel et la préparation du stockage, nous avons réussi à installer et à démarrer **Proxmox Virtual Environment**.

L'écran du serveur indique l'adresse d'administration :

`https://192.168.100.2:8006/`

✅ **Le serveur est maintenant fonctionnel et prêt à être utilisé comme plateforme de virtualisation.**

Cette activité nous a permis de comprendre qu'un dépannage efficace doit être réalisé progressivement, en testant les composants séparément avant de remettre le serveur dans sa configuration complète.

---

### 📚 INF1085 – Administration Linux

**🔧 Travail pratique :** Diagnostic matériel et installation Proxmox VE  
**🖥️ Matériel :** HP ProLiant DL360 G6  
**📅 Session :** Automne 2026

