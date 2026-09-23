# 🛂 APIC - Advanced Programmable Interrupt Controller

C'est un composant matériel qui aide le système à gérer les interruptions.

## Qu'est-ce qu'une interruption ?

Une interruption est un signal envoyé au processeur pour lui dire :

« Hé CPU, j'ai quelque chose à traiter maintenant ! »

Exemples :

```
Une touche est pressée sur le clavier
Une carte réseau reçoit un paquet
Un disque termine une lecture
Un contrôleur RAID termine une opération
```

Sans interruptions, le CPU devrait constamment vérifier tous les périphériques :

```
Disque ? Rien ?
Réseau ? Rien ?
USB ? Rien ?
Disque ? Rien ?
```

Ce serait inefficace.

APIC sur un serveur multiprocesseur

Dans ton DL360 G6 :

```
2 Xeon E5540
8 cœurs physiques
```

Le système doit décider :

Quelle interruption va à quel cœur ?


Par exemple :

```
Carte réseau → CPU2
RAID P410i → CPU5
USB → CPU0
```

C'est le rôle de l'APIC.

## Deux types d'APIC

### Local APIC (LAPIC)

Un APIC intégré à chaque processeur.

Par exemple :

```
CPU0 → LAPIC
CPU1 → LAPIC
CPU2 → LAPIC
...
```

Utilisé pour :

```
SMP (multiprocesseur)
communication entre CPU
répartition des tâches
```
Lorsque tu utilisais :

```
nolapic
```

tu désactivais ces APIC locaux.

Résultat :

> smpboot: SMP disabled


et Linux n'utilisait plus qu'un seul CPU.

> I/O APIC

Gère les interruptions provenant du matériel :

```
RAID
USB
NIC
Clavier
```

et les distribue aux CPU.

Lorsque tu utilisais :

```
noapic
```

tu désactivais cet APIC.

Exemple simplifié

- Sans APIC :

```
Disque → CPU0
Réseau → CPU0
USB → CPU0
```

Tout passe par le même cœur.

- Avec APIC :

```
Disque → CPU3
Réseau → CPU6
USB → CPU1
```

La charge est répartie.

Dans ton enquête sur le DL360 G6

Tu as testé :

nomodeset noapic nolapic acpi=off


Le résultat :

CPU(s): 1


Pourquoi ?

Parce que :

nolapic


a empêché Linux d'utiliser les autres CPU.

Ensuite :

nomodeset acpi=off


Résultat :

CPU(s): 8
Socket(s): 2


Donc les LAPIC fonctionnent à nouveau.

Pour voir les APIC sous Linux

Afficher les ID APIC :

cat /proc/cpuinfo | grep apicid


Sur ton serveur :

apicid : 0
apicid : 2
apicid : 4
apicid : 6
...


Afficher les interruptions :

cat /proc/interrupts


Très utile pour comprendre quels périphériques génèrent des interruptions.

Résumé INF1085
Terme	FonctionIRQ	Interruption matérielle
APIC	Contrôleur d'interruptions avancé
LAPIC	APIC local intégré à chaque CPU
I/O APIC	APIC qui distribue les interruptions du matériel
noapic	Désactive l'I/O APIC
nolapic	Désactive le Local APIC
SMP	Utilisation de plusieurs processeurs/cœurs

💡 Dans ton cas, le paramètre nolapic était le véritable responsable du problème, car il empêchait le noyau d'activer les autres cœurs et conduisait à :

smpboot: SMP disabled
CPU(s): 1


Une fois retiré, Proxmox a retrouvé les 2 processeurs et les 8 cœurs physiques.
