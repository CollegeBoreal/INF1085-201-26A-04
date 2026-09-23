# ⚙️ ACPI = Advanced Configuration and Power Interface

C'est bien :

acpi=off


✅ ACPI = Advanced Configuration and Power Interface

Ce n'est pas :

apci=off


❌ apci n'existe pas comme paramètre de démarrage Linux.

Tu peux vérifier les paramètres réellement utilisés par le noyau avec :

cat /proc/cmdline


Dans ton cas, tu as actuellement :

BOOT_IMAGE=/boot/vmlinuz-7.0.2-6-pve root=/dev/mapper/pve-root ro nomodeset acpi=off quiet


Donc les paramètres actifs sont :

nomodeset
acpi=off


Pour mémoire :

Paramètre	Significationnomodeset	Désactive l'initialisation graphique avancée
acpi=off	Désactive ACPI
noapic	Désactive l'I/O APIC
nolapic	Désactive le Local APIC (et casse souvent le SMP)

Dans tes tests sur le DL360 G6, la combinaison qui semble fonctionner est :

nomodeset acpi=off


et qui te donne :

2 Xeon E5540
8 cœurs physiques détectés
64 Go RAM
Proxmox 9 fonctionnel


sans les problèmes causés par nolapic.
