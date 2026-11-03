# 🖥️ Installation de Proxmox VE 9 sur HP ProLiant DL360 G7

| Champ | Valeur |
|-------|--------|
| Nom | Yacoub Bâ |
| Numéro étudiant | 300153932 |
| Serveurs | `server237` - [10.7.236.237](https://10.7.236.237:8006) et `server239` - [10.7.236.239](https://10.7.236.239:8006) |
| Version | Proxmox VE **9.2** (ISO release 1), noyau `7.0.2-6-pve` |
| Date du laboratoire | Octobre 2026 |

> 📸 Les photos ont été prises par notre équipe pendant le laboratoire.

## 🌐 Paramètres réseau

| Paramètre | Valeur |
|-----------|--------|
| Réseau | `10.7.236.0/23` |
| Passerelle | `10.7.237.1` |
| DNS | `8.8.8.8` |
| Interface de gestion | `nic0` (pont `vmbr0` après l'installation) |

---

## Étape 1 - Télécharger l'ISO et préparer la clé USB

![Téléchargement de l'ISO](images/01-telechargement-iso.jpg)

*Figure 1 : Téléchargement de `proxmox-ve_9.2-1.iso` (1.6 Go) depuis le site de Proxmox.*

L'ISO est ensuite écrite sur une clé USB avec **Rufus** (Windows) ou avec `dd` (Linux) :

```bash
sudo dd if=proxmox-ve_9.2-1.iso of=/dev/sdX bs=4M status=progress && sync
```

## Étape 2 - Démarrer sur la clé

Au POST, **F11** puis **One Time Boot to USB DriveKey** (voir [1.Diagnostics](../../1.Diagnostics/300153932/README.md)).

![Menu Proxmox](images/02-menu-proxmox.jpg)

*Figure 2 : Le menu « Welcome to Proxmox Virtual Environment ». On ne valide pas tout de suite.*

## Étape 3 - Ajouter `nomodeset` dans GRUB

Sur **Install Proxmox VE (Graphical)**, on appuie sur **`e`** pour modifier la ligne `linux`, puis on ajoute `nomodeset` à la fin.

![GRUB nomodeset](images/03-grub-nomodeset.jpg)

*Figure 3 : Édition dans GNU GRUB 2.12. La ligne devient `linux /boot/linux26 ro ramdisk_size=16777216 rw quiet splash=silent nomodeset`. On démarre avec **Ctrl + X** ou **F10**.*

![Chargement](images/04-chargement-installateur.jpg)

*Figure 4 : « Loading Proxmox VE Installer… ».*

![Détection DHCP](images/05-detection-dhcp.jpg)

*Figure 5 : Le noyau détecte le matériel et envoie des requêtes DHCP sur les 4 cartes réseau.*

## Étape 4 - Assistant d'installation

![EULA](images/06-eula.jpg)

*Figure 6 : Acceptation de la licence (EULA).*

![Disque cible](images/07-disque-cible.jpg)

*Figure 7 : Choix du disque cible. Deux choix sont proposés : le volume RAID 5 `/dev/sda` (273.4 Go) et le SSD NVMe `/dev/nvme0n1` (953.9 Go).*

![Fuseau horaire](images/08-fuseau-horaire.jpg)

*Figure 8 : Pays **Canada**, fuseau **America/Toronto**, clavier **U.S. English**.*

![Mot de passe](images/09-mot-de-passe.jpg)

*Figure 9 : Mot de passe `root` et adresse courriel de l'administrateur.*

![Réseau](images/10-reseau.jpg)

*Figure 10 : Configuration réseau de `server237` : `10.7.236.237/23`, passerelle `10.7.237.1`, DNS `8.8.8.8`.*

![Résumé server237](images/11-resume-server237.jpg)

*Figure 11 : Résumé avant l'installation de `server237` : ext4 sur `/dev/sda`, hostname `server237`.*

---

## ❌ Problèmes rencontrés sur `server239`

### Problème 1 : mauvais réseau

![Réseau incorrect](images/12-reseau-erreur.jpg)

*Figure 12 : L'installateur proposait par défaut `192.168.100.2` avec la passerelle `192.168.100.1`. Ce n'est pas le réseau du laboratoire : le serveur n'aurait pas été joignable.*

![Réseau corrigé](images/13-reseau-corrige.jpg)

*Figure 13 : Correction : hostname `server239.labinfo.local`, IP `10.7.236.239/23`, passerelle `10.7.237.1`, DNS `8.8.8.8`.*

![Résumé server239](images/14-resume-server239.jpg)

*Figure 14 : Résumé de `server239`. Cette fois, Proxmox est installé sur le SSD **`/dev/nvme0n1`**, fuseau `America/Cambridge_Bay`.*

### Problème 2 : l'installation a échoué

![Installation échouée](images/15-installation-echouee.jpg)

*Figure 15 : « Installation failed! - installation of package liblockfile-bin_1.17-2_amd64.deb failed ».*

**Cause probable :** une erreur de lecture pendant la copie des paquets (clé USB ou image ISO mal écrite) ou des restes d'une ancienne installation sur le disque. **Solution :** nous avons redémarré, relancé l'installation depuis le début et refait le choix du disque.

![Installation réussie](images/16-installation-reussie.jpg)

*Figure 16 : Deuxième essai : « Installation successful! ». L'interface web est disponible à `https://10.7.236.239:8006`.*

---

## Étape 5 - Premier démarrage et vérifications

![Login et cmdline](images/17-login-cmdline.jpg)

*Figure 17 : Connexion en `root` sur `server237`, puis `cat /proc/cmdline`.*

```text
BOOT_IMAGE=/boot/vmlinuz-7.0.2-6-pve root=/dev/mapper/pve-root ro nomodeset quiet
```

✅ Le paramètre `nomodeset` est bien conservé après l'installation.

![nproc](images/18-nproc.jpg)

*Figure 18 : Fin de `lscpu` (vulnérabilités du processeur) puis `nproc` → **16**. Les 2 CPU × 4 cœurs × 2 threads sont bien vus.*

![lsmem](images/19-lsmem.jpg)

*Figure 19 : `lsmem` → **66G online**, 0B offline. Toute la mémoire est utilisable.*

![lsblk](images/20-lsblk.jpg)

*Figure 20 : `lsblk`. Proxmox est sur `sda` (RAID 5 de 273.4 Go) avec les volumes LVM `pve-swap` (8G), `pve-root` (78G) et `pve-data` (166.6G). Le NVMe contient encore un ancien groupe LVM renommé `pve-OLD-810787F6`.*

![lspci](images/21-lspci.jpg)

*Figure 21 : `lspci` : les ponts et contrôleurs Intel Xeon 5500/Core i7 de la carte mère.*

![lsmod](images/22-lsmod.jpg)

*Figure 22 : `lsmod` : les modules chargés, dont `nvme`, `hpsa` (pilote du Smart Array) et `dm_thin_pool` (LVM-thin).*

![nolapic et cmdline](images/23-nolapic-cmdline.jpg)

*Figure 23 : `nolapic` et `noapic` ne sont pas des commandes : ce sont des **paramètres du noyau**. On vérifie qu'ils ne sont pas utilisés avec `cat /proc/cmdline` (attention à l'espace : `cat/proc/cmdline` ne fonctionne pas).*

![interrupts](images/24-interrupts.jpg)

*Figure 24 : `cat /proc/interrupts` : les interruptions sont réparties entre les 16 CPU.*

## Étape 6 - Tests réseau

![ping](images/25-ping.jpg)

*Figure 25 : `vmbr0` a bien l'adresse `10.7.236.237/23`. Le `ping 10.7.237.1` (passerelle) répond, mais le premier `ping 8.8.8.8` donne *Destination Host Unreachable* (pas de route vers Internet à ce moment-là).*

![ping Internet](images/25b-ping-internet.jpg)

*Figure 25b : Au test suivant, la passerelle répond (12 paquets, 0 % de perte) et `ping -c 4 8.8.8.8` répond aussi : le serveur a accès à Internet.*

![SSH](images/26-ssh.jpg)

*Figure 26 : Connexion SSH depuis un portable : `ssh root@10.7.236.237`. On accepte l'empreinte ED25519 du serveur à la première connexion.*

---

## ❓ Questions de réflexion

**1. À quoi sert `nomodeset` ?**
Il empêche le noyau d'initialiser le pilote graphique avancé (*Kernel Mode Setting*). Le noyau garde un mode vidéo simple. Sur le vieux contrôleur graphique du DL360, cela évite l'écran noir pendant l'installation.

**2. Pourquoi un ancien BIOS peut-il nécessiter `acpi=off` ?**
Les tables ACPI d'un BIOS de 2011 peuvent contenir des erreurs que les noyaux récents interprètent mal (blocage, erreurs PCI). Désactiver l'ACPI contourne le problème, mais le noyau perd alors des informations importantes, comme la liste des processeurs.

**3. Différence entre ACPI et APIC ?**
- **ACPI** : interface par laquelle le BIOS décrit le matériel (processeurs, énergie, périphériques) au système d'exploitation.
- **APIC** : contrôleur matériel qui distribue les interruptions entre les processeurs.

**4. Pourquoi `nolapic` peut-il réduire le nombre de processeurs ?**
Chaque CPU a son APIC local, qui sert à le démarrer et à lui envoyer des interruptions. Sans LAPIC, le noyau désactive le multiprocesseur (`SMP disabled`) et n'utilise qu'un seul processeur logique.

**5. Quelle commande montre les paramètres du noyau au démarrage ?**

```bash
cat /proc/cmdline
```

## ✅ Résultat

- [x] Proxmox VE 9.2 installé sur `server237` (RAID 5) et `server239` (NVMe)
- [x] `nomodeset` actif au démarrage
- [x] 16 CPU logiques et 66 Go de mémoire détectés
- [x] Interface web accessible sur le port 8006
- [x] Accès SSH fonctionnel
