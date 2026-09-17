# 🔌 Diagnostic

<image src=images/Designer.png width=% height=% > </image>

---

Cas 1 : Quelques broches légèrement pliées

C'est le scénario le plus favorable.

Les sockets LGA1366 ont les broches sur la carte mère.
Avec une loupe, un bon éclairage et parfois une aiguille très fine ou une pince de précision, il est souvent possible de redresser les broches.
J'ai déjà vu des serveurs revenir à la vie avec seulement 1 ou 2 broches réalignées.

✅ Coût : 0 $
 ✅ Réparation réaliste pour un serveur de laboratoire

Cas 2 : Socket endommagé

Si plusieurs broches sont :

cassées,
arrachées,
écrasées,
ou si le plastique du socket est endommagé,

alors il faut remplacer le socket LGA1366.

Cela nécessite :

Station à air chaud ou infrarouge BGA
Équipement de rework professionnel
Nouveau socket LGA1366
Beaucoup d'expérience

Pour un DL360 G6 :

💰 Le coût de la réparation dépasse souvent la valeur du serveur.

Cas 3 : Remplacer la carte système

Pour un G6, c'est généralement la meilleure solution.

Une carte mère DL360 G6 usagée se trouve souvent pour moins cher qu'une réparation professionnelle du socket.

Avant de conclure que le socket est mort

Je te suggère ce test très rapide :

Retire CPU2.
Place CPU2 seul dans Socket 1.
Installe un DIMM dans le premier slot de CPU1.
Démarre.

Si le serveur POST :

✅ CPU2 est bon
 ➡️ le problème est probablement Socket 2 ou son circuit mémoire.

Si le serveur ne POST pas :

✅ forte probabilité que CPU2 soit défectueux.

Autre indice important sur le DL360 G6

Quand tu installes CPU2 :

Les ventilateurs montent-ils immédiatement à 100 % ?
Le voyant système rouge s'allume-t-il ?
As-tu un code de diagnostic sur le panneau avant ?

Ces symptômes peuvent souvent distinguer :

Symptôme	Cause probableÉcran noir, ventilateurs à fond	Socket 2 ou CPU2
Voyant rouge CPU	CPU2 défectueux
Bips mémoire	DIMM dans le mauvais emplacement
Démarre puis s'éteint	Problème d'alimentation ou court-circuit du socket

Pour un DL360 G6 de plus de 15 ans, je testerais d'abord CPU2 seul dans Socket 1 avant de démonter le socket. C'est le test qui permet d'éliminer rapidement 50 % des causes possibles.

# References

[Socket LGA 1366](https://fr.wikipedia.org/wiki/LGA_1366)
