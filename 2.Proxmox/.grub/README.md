Parfait. On a trouvé exactement d'où vient le paramètre :

```
/etc/default/grub.d/installer.cfg
```

contient :

> GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nomodeset acpi=off"


Donc ton système est actuellement configuré pour démarrer avec :

```
nomodeset acpi=off
```

et c'est ce que confirme :

> cat /proc/cmdline

Pour retirer acpi=off

Édite le fichier :

```bash
nano /etc/default/grub.d/installer.cfg
```

Modifie la ligne :

> GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nomodeset acpi=off"


pour :

> GRUB_CMDLINE_LINUX="$GRUB_CMDLINE_LINUX nomodeset"


Puis :

```bash
update-grub
```

Vérifie :

```bash
grep -n "linux.*vmlinuz" /boot/grub/grub.cfg
```

Tu devrais voir :

> linux /boot/vmlinuz-7.0.2-6-pve ... nomodeset quiet


sans acpi=off.

Puis :

```bash
reboot
```

Aucun besoin de réinstaller

Les paramètres du noyau sont lus à chaque démarrage.

Tu peux les changer autant de fois que tu veux :

```text
acpi=off
noapic
nolapic
nomodeset
```

sans jamais réinstaller Proxmox.

Dans ton cas

Si ce serveur est un DL360 G7 et qu'il démarre correctement sans `acpi=off`, alors :

> nomodeset


devrait suffire.

Après le redémarrage, exécute :

```bash
cat /proc/cmdline
```

puis :

```bash
lscpu
```

et vérifie particulièrement :

```
CPU(s)
Socket(s)
Thread(s) per core
```

L'objectif est de voir si le G7 retrouve :

```
CPU(s):              16
Socket(s):           2
Core(s) per socket:  4
Thread(s) per core:  2
```

Au vu de tes essais précédents, je m'attendrais à ce qu'un G7 supporte beaucoup mieux ACPI qu'un G6 avec son vieux BIOS P64 de 2010.
