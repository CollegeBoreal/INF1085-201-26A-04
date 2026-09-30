# Rapport  – HP ProLiant DL360 G6

**Numéro d’étudiant : 300157334**

## 1. Problème

Le serveur HP ProLiant DL360 G6 ne démarrait pas correctement et ne réussissait pas toujours le POST.

L’objectif était d’identifier le composant responsable à l’aide d’une méthode d’élimination.

## 2. Méthode utilisée

Une configuration minimale a été réalisée :

* 1 processeur Intel Xeon
* 1 barrette RAM de 8 Go
* Processeur installé dans le Socket 1
* Aucune carte PCIe supplémentaire
* Une seule alimentation utilisée

Les composants ont ensuite été vérifiés individuellement.

## 3. Tests 

###  processeur

Le serveur détecte correctement le processeur :

**1 Processor(s) detected**

Le POST est réussi.

### la mémoire

Le BIOS détecte correctement :

**8192 MB**

La barrette de 8 Go fonctionne donc dans la configuration testée.

### BIOS

Dans le RBSU, le processeur installé dans **Proc 1** est reconnu correctement.
<img width="1600" height="900" alt="image" src="https://github.com/user-attachments/assets/f38b194e-d894-4e8e-810a-8f35b23f0958" />

### diagnostic

L'utilitaire HP permet d'effectuer les tests :

* CPU Test
* Memory Test
* Boot Disk Test

## 4. Résultat

Le serveur démarre correctement avec une configuration minimale.

Le processeur, la mémoire utilisée et le **Socket 1** sont fonctionnels dans cette configuration.

Le problème peut donc être recherché lors de l'ajout du deuxième processeur, du Socket 2 ou de la mémoire associée.

## 5. Conclusion

La méthode d'élimination a permis d'isoler une partie de la panne. La configuration minimale fonctionne et le POST est réussi.

La prochaine étape consiste à tester séparément le **CPU 2, le Socket 2 et les barrettes de mémoire associées** afin de déterminer précisément l'origine du problème.
