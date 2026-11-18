# Laboratoire — Installation de Debian 13 sur Proxmox VE

**Nom : Mohammed Mati**  
**Numéro étudiant : 300158185**  
**Cours : INF1085 — Linux / Proxmox**  
**Date des captures : 4 novembre 2026**

## 1. Objectif

Installer une machine virtuelle Debian 13 avec une interface graphique GNOME sur Proxmox VE, vérifier son réseau et préparer son accès distant par SSH.

Ce document présente les résultats visibles dans mes captures. La configuration SSH et les clés publiques restent à vérifier : elles ne sont pas présentées comme des opérations réussies.

## 2. Environnement observé

| Élément | Valeur |
|---|---|
| Hyperviseur | Proxmox VE 9.2.2 |
| Adresse Web Proxmox | https://10.7.236.240:8006 |
| Nœud | server1 |
| Machine virtuelle | 102 — Mohammed |
| Compte Proxmox visible | root@pam |
| Système invité | Debian 13 |
| Image ISO visible | debian-13.7.0-amd64-netinst.iso |
| Processeur virtuel | 1 vCPU |
| Mémoire | 2 Gio |
| Disque virtuel | 32 Gio, soit environ 34,4 Go |
| Nom de machine | mohammed |
| Compte Debian confirmé | mohammed18 |
| Interface réseau | ens18, UP |
| Adresse IPv4 observée | 10.7.236.185/23 |

L'adresse de la VM est différente de celle du serveur Proxmox. Elle devra être revérifiée avant une nouvelle connexion SSH.

![Ressources et état de la VM 102](images/01_ressources_vm.png)

*Figure 1 — VM 102 en cours d'exécution : 1 vCPU, 2 Gio de mémoire et disque de 32 Gio.*

## 3. Problème rencontré au démarrage

Le premier démarrage a échoué avec un message indiquant que le serveur ne prenait pas en charge la fonction CPU AES demandée par la configuration virtuelle. Le réglage proposé a été de remplacer le type de processeur par `host`.

![Erreur CPU AES](images/02_erreur_cpu.png)

*Figure 2 — Message QEMU signalant une fonction AES non prise en charge.*

## 4. Installation graphique de Debian

Après des difficultés avec la saisie dans l'installateur en mode texte, l'installation a été relancée avec **Graphical install**. La configuration a ensuite progressé jusqu'au partitionnement et à l'installation des logiciels.

![Configuration du nom de machine](images/03_installation_graphique.png)

*Figure 3 — Installateur graphique Debian : configuration du nom de machine.*

### Partitionnement

Le disque virtuel `sda` de 34,4 Go a été sélectionné avec le partitionnement assisté. Le schéma retenu est « Tout dans une seule partition ».

| Partition | Taille affichée | Type | Point de montage |
|---|---|---|---|
| sda1 | 32,6 Go | ext4 | / |
| sda5 | 1,8 Go | swap | swap |

![Résumé des partitions](images/04_partitionnement.png)

*Figure 4 — Résumé du partitionnement avant application des changements.*

### Paquets et logiciels

Le pays sélectionné pour le miroir est le Canada et le miroir retenu est `deb.debian.org`. Le champ du mandataire HTTP peut rester vide lorsqu'aucun proxy n'est requis.

![Configuration du miroir](images/05_miroir_canada.png)

*Figure 5 — Sélection du Canada pour le miroir Debian.*

La capture de sélection des logiciels montre l'environnement de bureau Debian, GNOME et les utilitaires usuels cochés. **Le serveur SSH n'est pas coché sur cette capture** ; sa présence doit donc être contrôlée après installation.

![Sélection des logiciels](images/06_logiciels.png)

*Figure 6 — Sélection des logiciels : GNOME et utilitaires usuels.*

### Programme de démarrage

L'installateur propose d'installer GRUB sur le disque principal. Après installation, le disque `scsi0` doit être placé avant le lecteur ISO `ide2` dans l'ordre de démarrage de la VM.

![Installation de GRUB](images/07_grub.png)

*Figure 7 — Confirmation de l'installation du programme de démarrage GRUB.*

## 5. Ouverture de la session GNOME

Debian a atteint le bureau GNOME. Le terminal ouvert ensuite confirme l'utilisation du compte `mohammed18` sur la machine `mohammed`.

![Bureau GNOME](images/08_bureau_gnome.png)

*Figure 8 — Bureau GNOME après ouverture de session.*

## 6. Vérification du compte et du réseau

Dans le terminal Debian, les commandes suivantes ont été exécutées :

```bash
whoami
hostname
ip -br a
```

Résultats observés :

```text
Utilisateur : mohammed18
Machine    : mohammed
Interface  : ens18 — UP
IPv4       : 10.7.236.185/23
```

![Compte et adresse IP Debian](images/09_compte_reseau.png)

*Figure 9 — Résultats de whoami, hostname et ip -br a.*

## 7. Préparation de SSH : problème de droits

La commande suivante a été tentée dans Debian :

```bash
sudo systemctl enable --now ssh
```

Elle a été refusée avec le message indiquant que `mohammed18` n'est pas dans le fichier sudoers. **Cette capture ne confirme donc ni l'activation de SSH, ni l'absence du paquet OpenSSH.**

![Refus des droits sudo](images/10_erreur_sudo.png)

*Figure 10 — Le compte mohammed18 ne dispose pas des droits sudo au moment du test.*

### Procédure restante — à exécuter et à documenter

Dans le terminal de la **VM Debian**, ouvrir une session root avec le mot de passe root de cette VM, s'il a été défini :

```bash
su -
```

Après authentification root réussie, ajouter le compte au groupe sudo :

```bash
usermod -aG sudo mohammed18
```

Se déconnecter de la session graphique, puis se reconnecter pour prendre en compte le nouveau groupe. Si l'accès root échoue, faire vérifier l'accès administrateur avant de poursuivre.

Dans la nouvelle session Debian :

```bash
sudo systemctl status ssh --no-pager
```

Si le service est introuvable :

```bash
sudo apt update
sudo apt install openssh-server -y
```

Activer SSH et vérifier son état :

```bash
sudo systemctl enable --now ssh
sudo systemctl status ssh --no-pager
sudo ss -ltnp 'sport = :22'
```

Captures à ajouter : service `active (running)` et écoute sur le port 22.

## 8. Connexion distante — à tester

Sur le poste **Windows**, ouvrir PowerShell. Vérifier d'abord le réseau du poste :

```powershell
ipconfig
```

Revérifier l'IP de la VM avec `ip -br a`, puis lancer, si elle est toujours identique :

```powershell
ssh mohammed18@10.7.236.185
```

À la première connexion, comparer l'empreinte annoncée avec celle de la VM. Cette dernière s'affiche dans Debian avec :

```bash
sudo ssh-keygen -lf /etc/ssh/ssh_host_ed25519_key.pub
```

Après connexion distante réussie, exécuter :

```bash
whoami
hostname
```

Ajouter une capture du résultat avant d'indiquer que le test SSH est réussi.

## 9. Clés publiques — à configurer

### Clé personnelle

Dans PowerShell Windows, vérifier si une clé existe :

```powershell
Test-Path "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

Uniquement si elle n'existe pas, créer une paire de clés sans écraser une clé existante :

```powershell
ssh-keygen -t ed25519 -C "Mohammed Mati 300158185"
```

Afficher la **clé publique** et copier sa ligne complète :

```powershell
Get-Content "$env:USERPROFILE\.ssh\id_ed25519.pub"
```

Dans Debian, sous le compte `mohammed18` :

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
```

Coller la clé publique sur une ligne distincte, enregistrer avec `Ctrl+O`, valider avec Entrée et quitter avec `Ctrl+X`, puis appliquer :

```bash
chmod 600 ~/.ssh/authorized_keys
```

Tester depuis PowerShell :

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_ed25519" -o IdentitiesOnly=yes -o PreferredAuthentications=publickey mohammed18@10.7.236.185
```

La phrase secrète de la clé peut être demandée. Ne pas joindre la clé privée ni les mots de passe au rapport.

### Clé du professeur

Consulter la consigne officielle, puis ajouter la clé publique complète du professeur sur une nouvelle ligne de `~/.ssh/authorized_keys`, sans effacer la clé personnelle.

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
ssh-keygen -lf ~/.ssh/authorized_keys
ls -ld ~/.ssh
ls -l ~/.ssh/authorized_keys
```

La présence d'une clé ne suffit pas à confirmer une connexion du professeur : ce test doit être effectué avec sa clé privée correspondante.

## 10. Compte personnel Proxmox — à vérifier

Les captures jointes montrent `root@pam`. Elles ne démontrent pas l'utilisation d'un compte personnel du collège. Cette partie doit être réalisée selon les consignes du professeur, avec vérification du compte et de ses permissions. Aucun compte ni rôle supplémentaire n'est déclaré comme créé dans ce document.

## 11. Bilan des preuves

| Vérification | État d'après les captures |
|---|---|
| VM 102 en exécution | Confirmé |
| Ressources : 1 vCPU, 2 Gio, 32 Gio | Confirmé |
| Installation graphique et partitionnement | Documentés |
| Bureau GNOME accessible | Confirmé |
| Compte mohammed18 et machine mohammed | Confirmés |
| ens18 UP, IPv4 10.7.236.185/23 | Confirmé le jour de la capture |
| Droits sudo | Refusés lors du test présenté |
| Service SSH actif | À vérifier |
| Connexion SSH depuis Windows | À tester |
| Connexion avec une clé personnelle | À tester |
| Clé publique du professeur | À ajouter et à vérifier |
| Connexion du professeur | Non démontrée |
| Compte individuel Proxmox | Non démontré |

## 12. Conclusion

J'ai installé Debian 13 sur la VM 102 dans Proxmox VE et accédé au bureau GNOME. Les commandes de vérification ont permis de confirmer mon compte, le nom de la machine et son adresse réseau. La préparation de SSH a révélé un problème de droits sudo. La suite du laboratoire consiste à corriger ces droits, vérifier le service SSH et tester les accès par mot de passe et par clé publique.

## Référence du cours

[Collège Boréal — INF1085 — X.Linux/3.keys](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/X.Linux/3.keys)

Les captures de ce dossier proviennent de la séance du 4 novembre 2026. Les procédures restantes doivent être adaptées à la consigne officielle et complétées par les nouvelles preuves obtenues.
