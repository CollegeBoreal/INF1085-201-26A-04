# ⚙️ ACPI = Advanced Configuration and Power Interface

### ⚠️ Attention: C'est bien

```
acpi=off
```

✅ ACPI = Advanced Configuration and Power Interface

Ce n'est pas :

```
apci=off
```

❌ apci n'existe pas comme paramètre de démarrage Linux.

Tu peux vérifier les paramètres réellement utilisés par le noyau avec :

```bash
cat /proc/cmdline
```


Dans ton cas, tu as actuellement :

```bash
BOOT_IMAGE=/boot/vmlinuz-7.0.2-6-pve root=/dev/mapper/pve-root ro nomodeset acpi=off quiet
```

Donc les paramètres actifs sont :

```
nomodeset
acpi=off
```

Pour mémoire :

| Paramètre	| Signification |
|-|-|
| nomodeset	| Désactive l'initialisation graphique avancée
| acpi=off	| Désactive ACPI
| noapic	  | Désactive l'I/O APIC
| nolapic	  | Désactive le Local APIC (et casse souvent le SMP)

Dans tes tests sur le DL360 G6, la combinaison qui semble fonctionner est :

```
nomodeset acpi=off
```

et qui te donne :

```
2 Xeon E5540
8 cœurs physiques détectés
64 Go RAM
Proxmox 9 fonctionnel
```


sans les problèmes causés par nolapic.

---

Dans ton cas, je ne pense pas que ACPI soit directement la cause du "Illegal Opcode" (Illegal Instruction).

Je pense plutôt que désactiver ACPI évite un chemin de code du BIOS ou du noyau qui finit par provoquer l'erreur.

Ce qu'est un "Illegal Opcode"

Un processeur affiche généralement :

```
Invalid Opcode
Illegal Instruction
#UD (Undefined Instruction)
```

lorsqu'il tente d'exécuter une instruction machine qu'il ne reconnaît pas.

Causes possibles :

```
microcode CPU bogué
BIOS bogué
table ACPI corrompue
RAM corrompue
noyau utilisant une mauvaise information matérielle
firmware très ancien
```

### Pourquoi ACPI peut influencer cela

Lors du démarrage, Linux lit les tables ACPI fournies par le BIOS :

```
DSDT
SSDT
MADT
SRAT
...
```

Ces tables décrivent :

```
les processeurs
les APIC
le NUMA
la gestion de l'énergie
les interruptions
```

Si le BIOS fournit une table incorrecte ou incompatible avec un noyau moderne :

```
Linux lit les tables
↓
configure le matériel
↓
active certaines fonctions CPU
↓
plantage
```

Avec :

> acpi=off


Linux ignore complètement ces tables.

Pourquoi je soupçonne ton BIOS

Tu as :

```
BIOS P64
03/01/2010
```

C'est extrêmement ancien.

On a aussi observé :

### NMI: PCI system error (SERR)


lorsque tu retirais certains paramètres.

Cela indique déjà que le matériel et le firmware ont des difficultés à coopérer avec un noyau moderne.

Ce qui est surprenant

Ton système fonctionne maintenant avec :

```
nomodeset acpi=off
```

et Linux voit :

```
2 sockets
8 cœurs
```

Donc le noyau fonctionne même sans ACPI.

Cela suggère que :

```
les MP Tables (ancienne méthode Intel) sont suffisantes
Linux n'a pas besoin des tables ACPI pour détecter les CPU sur ce G6
```

On le voit dans ton journal :

> found SMP MP-table


Linux utilise une ancienne table SMP au lieu des tables ACPI.

### Vérification intéressante

Tu peux regarder les erreurs ACPI du démarrage :

```
dmesg | grep -i acpi
```

ou :

```
dmesg | grep -i error
```

Souvent sur ces vieux serveurs on voit :

```
ACPI BIOS Error
ACPI Exception
```

Mon hypothèse pour ton DL360 G6

Vu tout ce qu'on a observé :

```
BIOS très ancien (2010)
Proxmox 9 avec noyau moderne
besoin de acpi=off
erreur PCI SERR
CPU2 parfois rapporté comme "Idle"
```

je soupçonne fortement un problème de compatibilité firmware plutôt qu'un véritable problème du CPU E5540.

Autrement dit :

```
ACPI activé
↓
Linux utilise les tables ACPI du BIOS
↓
bug firmware
↓
plantage / comportement anormal

ACPI désactivé
↓
Linux utilise les anciennes MP Tables
↓
le système démarre correctement
```

C'est exactement le type de comportement qu'on rencontre parfois sur des serveurs de 2009-2010 lorsqu'on installe un noyau Linux moderne comme celui de Proxmox 9.
