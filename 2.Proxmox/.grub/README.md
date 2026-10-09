
> grep -R "GRUB_CMDLINE" /etc

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

```lua
Architecture:                x86_64
  CPU op-mode(s):            32-bit, 64-bit
  Address sizes:             40 bits physical, 48 bits virtual
  Byte Order:                Little Endian
CPU(s):                      16
  On-line CPU(s) list:       0-15
Vendor ID:                   GenuineIntel
  Model name:                Intel(R) Xeon(R) CPU           X5550  @ 2.67GHz
    CPU family:              6
    Model:                   26
    Thread(s) per core:      2
    Core(s) per socket:      4
    Socket(s):               2
    Stepping:                5
    CPU(s) scaling MHz:      89%
    CPU max MHz:             2666.0000
    CPU min MHz:             1600.0000
    BogoMIPS:                5334.12
    Flags:                   fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe syscall 
                             nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc cpuid aperfmperf pni dtes64 monitor ds_cp
                             l vmx est tm2 ssse3 cx16 xtpr pdcm dca sse4_1 sse4_2 popcnt lahf_lm pti ssbd ibrs ibpb stibp tpr_shadow flexpriority ept vpid
                              dtherm ida vnmi flush_l1d
Virtualization features:     
  Virtualization:            VT-x
Caches (sum of all):         
  L1d:                       256 KiB (8 instances)
  L1i:                       256 KiB (8 instances)
  L2:                        2 MiB (8 instances)
  L3:                        16 MiB (2 instances)
NUMA:                        
  NUMA node(s):              2
  NUMA node0 CPU(s):         0,2,4,6,8,10,12,14
  NUMA node1 CPU(s):         1,3,5,7,9,11,13,15
Vulnerabilities:             
  Gather data sampling:      Not affected
  Ghostwrite:                Not affected
  Indirect target selection: Not affected
  Itlb multihit:             KVM: Mitigation: Split huge pages
  L1tf:                      Mitigation; PTE Inversion; VMX conditional cache flushes, SMT vulnerable
  Mds:                       Vulnerable: Clear CPU buffers attempted, no microcode; SMT vulnerable
  Meltdown:                  Mitigation; PTI
  Mmio stale data:           Not affected
  Old microcode:             Not affected
  Reg file data sampling:    Not affected
  Retbleed:                  Not affected
  Spec rstack overflow:      Not affected
  Spec store bypass:         Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:                Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:                Mitigation; Retpolines; IBPB conditional; IBRS_FW; STIBP conditional; RSB filling; PBRSB-eIBRS Not affected; BHI Not affected
  Srbds:                     Not affected
  Tsa:                       Not affected
  Tsx async abort:           Not affected
  Vmscape:                   Not affected
```
