# 🖥️ Installation de Proxmox VE 9 sur HP ProLiant DL360 G7

| Champ | Valeur |
|-------|--------|
| Prénom | Joris Dylane |
| Nom | Touossock Ngabou |
| Numéro étudiant | 300154479 |
| Serveur | `server239` - [10.7.236.239](https://10.7.236.239:8006) (Rack 2, U32, S/N MXQ1170T6R) |
| Version | Proxmox VE **9.2** (ISO release 1), noyau `7.0.2-6-pve` |
| Date du laboratoire | Octobre 2026 |

> 📸 Photos prises par notre équipe pendant le laboratoire.

## 🌐 Paramètres réseau

| Paramètre | Valeur |
|-----------|--------|
| Réseau | `10.7.236.0/23` |
| Adresse IP | `10.7.236.239/23` |
| Passerelle | `10.7.237.1` |
| DNS | `8.8.8.8` |
| Nom d'hôte (FQDN) | `server239.labinfo.local` |
| Interface de gestion | `nic0` |

---

## Étape 1 - Télécharger l'ISO et préparer la clé USB

![Téléchargement de l'ISO](images/01-telechargement-iso.jpg)

*Figure 1 : Téléchargement de `proxmox-ve_9.2-1.iso` (1.6 Go) depuis le site officiel de Proxmox.*

L'image est écrite sur une clé USB avec **Rufus** (Windows) ou avec `dd` (Linux) :

```bash
sudo dd if=proxmox-ve_9.2-1.iso of=/dev/sdX bs=4M status=progress && sync
```

## Étape 2 - Démarrer sur la clé

Au POST : **F11** → **One Time Boot to USB DriveKey** (voir [1.Diagnostics](../../1.Diagnostics/300154479/README.md)).

![Menu Proxmox](images/02-menu-proxmox.jpg)

*Figure 2 : Écran « Welcome to Proxmox Virtual Environment ». On ne valide pas tout de suite.*

## Étape 3 - Ajouter `nomodeset` dans GRUB

Sur **Install Proxmox VE (Graphical)**, on appuie sur **`e`** pour éditer l'entrée, puis on ajoute `nomodeset` à la fin de la ligne `linux`.

![GRUB nomodeset](images/03-grub-nomodeset.jpg)

*Figure 3 : GNU GRUB 2.12. La ligne devient `linux /boot/linux26 ro ramdisk_size=16777216 rw quiet splash=silent nomodeset`. On démarre avec **Ctrl + X** ou **F10**.*

![Détection DHCP](images/04-detection-dhcp.jpg)

*Figure 4 : Le noyau charge l'installateur, détecte le matériel et envoie des requêtes `DHCPDISCOVER` sur les 4 cartes réseau.*

## Étape 4 - Assistant d'installation

![EULA](images/05-eula.jpg)

*Figure 5 : Acceptation de la licence (EULA).*

![Disque cible](images/06-disque-cible-nvme.jpg)

*Figure 6 : Choix du disque cible : **`/dev/nvme0n1`** (953.87 Go, SK hynix PC611). Attention : toutes les données du disque choisi seront effacées.*

![Fuseau horaire](images/07-fuseau-horaire.jpg)

*Figure 7 : Pays **Canada**, fuseau horaire et clavier **U.S. English**.*

![Mot de passe](images/08-mot-de-passe.jpg)

*Figure 8 : Mot de passe `root` (confirmé) et adresse courriel de l'administrateur pour les alertes.*

---

## ❌ Problèmes rencontrés et solutions

### Problème 1 : mauvais réseau proposé

![Réseau incorrect](images/09-reseau-erreur.jpg)

*Figure 9 : Par défaut, l'installateur proposait `192.168.100.2/24` avec la passerelle et le DNS `192.168.100.1`. Ce n'est pas le réseau du laboratoire : le serveur aurait été injoignable.*

![Réseau corrigé](images/10-reseau-corrige.jpg)

*Figure 10 : Correction : `server239.labinfo.local`, IP `10.7.236.239/23`, passerelle `10.7.237.1`, DNS `8.8.8.8`.*

![Résumé](images/11-resume-server239.jpg)

*Figure 11 : Résumé avant l'installation : ext4 sur `/dev/nvme0n1`, Canada, `nic0`, `server239`, `10.7.236.239/23`.*

![Installation en cours](images/12-installation-en-cours.jpg)

*Figure 12 : Installation en cours (`create LVs`, 3 %).*

### Problème 2 : l'installation a échoué

![Installation échouée](images/13-installation-echouee.jpg)

*Figure 13 : « Installation failed! - installation of package liblockfile-bin_1.17-2_amd64.deb failed ».*

**Cause probable :** erreur de lecture pendant la copie des paquets (clé USB ou image ISO mal écrite) ou restes d'une ancienne installation sur le disque.
**Solution :** redémarrer, relancer l'installation depuis le début et refaire le choix du disque.

![Installation réussie](images/14-installation-reussie.jpg)

*Figure 14 : Deuxième essai : « Installation successful! ». L'interface web est disponible à `https://10.7.236.239:8006`.*

---

## Étape 5 - Premier démarrage

![Démarrage LVM](images/15-premier-demarrage-lvm.jpg)

*Figure 15 : Au démarrage, LVM trouve deux groupes de volumes : le nouveau `pve` et un ancien `pve-OLD-09F5DF34` (reste d'une installation précédente, renommé automatiquement). `/dev/mapper/pve-root` est vérifié : **clean**.*

![Écran de connexion](images/16-ecran-connexion.jpg)

*Figure 16 : Console : « Please use your web browser to configure this server - connect to: https://10.7.236.239:8006/ ».*

![Connexion root](images/17-connexion-root.jpg)

*Figure 17 : Connexion en `root` : `Linux server239 7.0.2-6-pve #1 SMP PREEMPT_DYNAMIC PMX 7.0.2-6 x86_64`.*

## Étape 6 - Test réseau

![ping passerelle](images/18-ping-passerelle.jpg)

*Figure 18 : `ping 10.7.237.1` : la passerelle répond (temps ≈ 0.2 ms, aucune perte). Le serveur est bien connecté au réseau du laboratoire.*

### Commandes de vérification

```bash
cat /proc/cmdline   # paramètres du noyau (nomodeset doit apparaître)
lscpu               # 2 sockets, 4 cœurs/socket, 2 threads/cœur
nproc               # 16
lsmem               # mémoire en ligne
lsblk               # disques et volumes LVM
ip a                # adresse 10.7.236.239/23 sur vmbr0
ping -c 4 8.8.8.8   # accès Internet
```

Résultat attendu de `cat /proc/cmdline` :

```text
BOOT_IMAGE=/boot/vmlinuz-7.0.2-6-pve root=/dev/mapper/pve-root ro nomodeset quiet
```

---

## ❓ Questions de réflexion

**1. À quoi sert `nomodeset` ?**
Il empêche le noyau d'activer le *Kernel Mode Setting* (pilote graphique avancé). Le noyau reste en mode vidéo simple, ce qui évite l'écran noir ou le blocage avec la vieille puce graphique du DL360.

**2. Pourquoi un ancien BIOS peut-il nécessiter `acpi=off` ?**
Les tables ACPI d'un BIOS de 2010-2011 peuvent contenir des erreurs mal interprétées par un noyau récent (blocages, erreurs PCI). `acpi=off` contourne le problème, mais le noyau perd des informations utiles comme la liste des processeurs et la gestion d'énergie.

**3. Quelle est la différence entre ACPI et APIC ?**
- **ACPI** (*Advanced Configuration and Power Interface*) : interface logicielle par laquelle le BIOS décrit le matériel et l'énergie au système d'exploitation.
- **APIC** (*Advanced Programmable Interrupt Controller*) : contrôleur matériel qui distribue les interruptions entre les processeurs.

**4. Pourquoi `nolapic` peut-il réduire le nombre de processeurs visibles ?**
Chaque processeur possède un APIC local (LAPIC) qui sert à le réveiller et à lui envoyer des interruptions. Sans LAPIC, le noyau désactive le multiprocesseur (`smpboot: SMP disabled`) et n'utilise qu'un seul processeur logique.

**5. Quelle commande permet de vérifier les paramètres réellement utilisés au démarrage ?**

```bash
cat /proc/cmdline
```

## ✅ Résultat

- [x] Proxmox VE 9.2 installé sur `server239` (SSD NVMe)
- [x] Réseau du laboratoire configuré (`10.7.236.239/23`)
- [x] Problèmes d'installation diagnostiqués et corrigés
- [x] Connexion `root` en console et passerelle joignable
- [x] Interface web disponible sur `https://10.7.236.239:8006`
