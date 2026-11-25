# Diagnostic d’un serveur qui ne démarre pas

## Objectif

Déterminer si le deuxième processeur (CPU 2) ou son emplacement
(socket 2) empêche le serveur de passer le POST, le test matériel
effectué au démarrage.

## Démarche

1. Serveur hors tension, préparer un montage témoin avec le CPU 1
   dans le socket 1 et une seule barrette de mémoire.
2. Démarrer et vérifier si le serveur passe le POST.
3. Éteindre le serveur, remplacer le CPU 1 par le CPU 2 dans le
   même socket et garder la même barrette.
4. Au redémarrage, vérifier le POST, les voyants et les codes d’erreur.

## Interprétation

- Si les deux processeurs passent le POST dans le socket 1,
  vérifier le socket 2 et son circuit mémoire.
- Si le CPU 1 passe le POST et que le CPU 2 échoue dans le même
  montage, le CPU 2 devient le principal suspect.
- Si les deux échouent, vérifier le montage de référence, la mémoire
  et l’alimentation avant de conclure.

## Résultat du groupe

Le résultat observé et les photos du test restent à confirmer.
