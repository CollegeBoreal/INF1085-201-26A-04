# 🖥️ Rapport technique – HP ProLiant DL360 G6

### 👨‍🎓 Informations de l'étudiant

- **Nom :** Hamdaoui Laala
- **Numéro d'étudiant :** 300157334
- **Équipement :** HP ProLiant DL360 G6
- **Travail :** Diagnostic matériel et identification d'une panne

---

## 📌 1. Présentation du problème

Pendant notre travail pratique, nous avons rencontré un problème avec le serveur **HP ProLiant DL360 G6**.

Le serveur ne démarrait pas correctement et ne réussissait pas toujours le **POST (Power-On Self-Test)**.

🎯 **Objectif du travail :**

Identifier le composant responsable du problème en utilisant une méthode d'élimination et en testant les composants un par un.

---

## 🔧 2. Configuration matérielle et composants

Le serveur **HP ProLiant DL360 G6** contient plusieurs composants importants :

- 🟦 **Carte mère (System Board)** : relie les composants du serveur.
- 🧠 **Processeur Intel Xeon** : exécute les instructions.
- 🔲 **CPU 1 et CPU 2** : deux sockets pour installer les processeurs.
- 💾 **Mémoire RAM (DIMM)** : stocke temporairement les données.
- 🔌 **Alimentations électriques** : fournissent l'énergie au serveur.
- 🌬️ **Ventilateurs** : assurent le refroidissement.
- ❄️ **Dissipateurs thermiques** : refroidissent les processeurs.
- 💽 **Contrôleur RAID** : gère les disques durs.
- 🗄️ **Baies de disques** : permettent d'installer les disques.
- 🌐 **Carte réseau** : permet la connexion au réseau.
- 🔗 **Connecteurs PCIe** : permettent d'ajouter des cartes d'extension.

### ⚙️ Configuration minimale utilisée

Pour identifier le problème, nous avons utilisé une configuration minimale :

| Composant | Configuration |
|---|---|
| 🧠 Processeur | 1 Intel Xeon |
| 🔲 Socket | CPU 1 |
| 💾 RAM | 8 Go |
| 🔌 Alimentation | 1 alimentation |
| 🖥️ Carte mère | HP ProLiant DL360 G6 |
| 🔗 Cartes PCIe supplémentaires | Aucune |

---

## 🧪 3. Tests et vérifications

### ✅ Test 1 : Processeur

Nous avons installé un seul processeur dans le **Socket 1**.

Après le démarrage du serveur, le système affiche :

**`1 Processor(s) detected`**

✅ **Résultat :** Le processeur est correctement détecté et le POST est réussi.

### ✅ Test 2 : Mémoire RAM

Nous avons installé une seule barrette de mémoire RAM de **8 Go**.

Le BIOS affiche :

**`8192 MB`**

✅ **Résultat :** La mémoire RAM est correctement reconnue par le serveur.

### ✅ Test 3 : Vérification du BIOS

Nous avons accédé au BIOS du serveur à travers l'utilitaire **RBSU (ROM-Based Setup Utility)**.

Dans le BIOS, nous avons vérifié que le processeur installé dans **Proc 1** était correctement reconnu.

📸 **Capture d'écran du BIOS :**

![Vérification du processeur dans le BIOS](https://github.com/user-attachments/assets/f38b194e-d894-4e8e-810a-8f35b23f0958)

✅ **Résultat :** Le processeur installé dans le Socket 1 est reconnu correctement.

### 🔍 Test 4 : Outils de diagnostic HP

L'utilitaire de diagnostic HP permet d'effectuer plusieurs tests :

- 🧠 **CPU Test** : vérification du processeur.
- 💾 **Memory Test** : vérification de la mémoire RAM.
- 💽 **Boot Disk Test** : vérification du disque de démarrage.

Ces outils nous aident à identifier les composants qui peuvent provoquer des problèmes au démarrage.

---

## 📊 4. Résultats obtenus

Après les vérifications, nous avons constaté que le serveur démarre correctement avec la configuration minimale.

| Élément testé | Résultat |
|---|---|
| 🧠 CPU 1 | ✅ Détecté |
| 💾 RAM 8 Go | ✅ Détectée |
| 🔲 Socket 1 | ✅ Fonctionnel dans le test |
| 🖥️ BIOS | ✅ Accessible |
| 🚀 POST | ✅ Réussi |
| 🧠 CPU 2 | ⏳ À vérifier |
| 🔲 Socket 2 | ⏳ À vérifier |
| 💾 RAM associée au CPU 2 | ⏳ À vérifier |

### 🟢 Observation importante

Le serveur fonctionne avec un seul processeur et une barrette RAM de 8 Go.

Cela indique que le problème pourrait être lié aux composants retirés de la configuration initiale.

---

## 🛠️ 5. Prochaines étapes

Pour continuer le diagnostic, nous devons :

1. 🔍 Tester le deuxième processeur (**CPU 2**).
2. 🔲 Vérifier le deuxième socket (**Socket 2**).
3. 💾 Tester les barrettes RAM associées au CPU 2.
4. 🔧 Réinstaller les composants progressivement.
5. 🚀 Redémarrer le serveur après chaque modification.
6. 📝 Noter les résultats pour identifier le composant responsable.

---

## 🏁 6. Conclusion

Pendant ce travail pratique, nous avons utilisé une **méthode d'élimination** pour rechercher la cause du problème de démarrage du serveur HP ProLiant DL360 G6.

Nous avons retiré plusieurs composants pour garder une configuration minimale avec un seul processeur et une barrette RAM de 8 Go.

Après les tests, le serveur a réussi le POST et les composants installés ont été correctement détectés.

✅ **Le serveur fonctionne donc avec la configuration minimale.**

Cependant, nous n'avons pas encore identifié exactement le composant responsable du problème initial.

La prochaine étape sera de tester le **CPU 2, le Socket 2 et les barrettes RAM associées** pour trouver la panne.

---

**👨‍🎓 Réalisé par : Hamdaoui Laala**

**📚 Travail pratique – Diagnostic matériel d'un serveur HP ProLiant DL360 G6**
