# Laboratoire — Installation de Debian 13 sur Proxmox VE

**Nom : Mohammed Mati**  
**Numéro étudiant : 300158185**  
**Cours : INF1085 — Linux / Proxmox**  
**Dates des captures : 4 novembre 2026**

## 1. Objectif

Installer une machine virtuelle Debian 13 avec une interface graphique GNOME sur Proxmox VE, vérifier son réseau et préparer son accès distant par SSH.

J’ai vérifié l’adresse IP de la VM et l’état du service SSH le 18 novembre 2026. Le test de connexion avec la clé du professeur reste à faire.

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

L’interface Web de Proxmox est à l’adresse `10.7.236.240:8006`. Pour se connecter en SSH à la VM Debian, l’adresse observée le 18 novembre est `10.7.236.185`.

![Ressources et état de la VM 102](https://github.com/user-attachments/assets/047da3df-360f-43fe-91f8-ad0b4c51bb49)


*Figure 1 — VM 102 en cours d'exécution : 1 vCPU, 2 Gio de mémoire et disque de 32 Gio.*

## 3. Problème rencontré au démarrage

Le premier démarrage a échoué avec un message indiquant que le serveur ne prenait pas en charge la fonction CPU AES demandée par la configuration virtuelle. Le réglage proposé a été de remplacer le type de processeur par `host`.

![Erreur CPU AES](https://github.com/user-attachments/assets/f8dadf0e-1056-457c-a7df-3b585b325caf)


*Figure 2 — Message QEMU signalant une fonction AES non prise en charge.*

## 4. Installation graphique de Debian

Après des difficultés avec la saisie dans l'installateur en mode texte, l'installation a été relancée avec **Graphical install**. La configuration a ensuite progressé jusqu'au partitionnement et à l'installation des logiciels.

![Configuration du nom de machine](https://github.com/user-attachments/assets/ba15567e-1845-4d2e-b6e4-e80b0e3bf77e)

*Figure 3 — Installateur graphique Debian : configuration du nom de machine.*

### Partitionnement

Le disque virtuel `sda` de 34,4 Go a été sélectionné avec le partitionnement assisté. Le schéma retenu est « Tout dans une seule partition ».

| Partition | Taille affichée | Type | Point de montage |
|---|---|---|---|
| sda1 | 32,6 Go | ext4 | / |
| sda5 | 1,8 Go | swap | swap |

![Résumé des partitions](https://github.com/user-attachments/assets/a7d0d4d5-5acb-4440-bdad-14a3d0b5eab8)

*Figure 4 — Résumé du partitionnement avant application des changements.*

### Paquets et logiciels

Le pays sélectionné pour le miroir est le Canada et le miroir retenu est `deb.debian.org`. Le champ du mandataire HTTP peut rester vide lorsqu'aucun proxy n'est requis.

![Configuration du miroir](https://github.com/user-attachments/assets/a4e025cd-725c-4b0d-96f2-eb1021053c8a)


*Figure 5 — Sélection du Canada pour le miroir Debian.*

La capture de sélection des logiciels montre l'environnement de bureau Debian, GNOME et les utilitaires usuels cochés. La case **Serveur SSH** est décochée sur cette capture de l’installateur. La section 7 confirme l’état du service dans la VM installée.

![Sélection des logiciels](https://github.com/user-attachments/assets/2fe3189f-9baf-499e-a161-8fdbe1c3420d)


*Figure 6 — Sélection des logiciels : GNOME et utilitaires usuels.*

### Programme de démarrage

L'installateur propose d'installer GRUB sur le disque principal. Après installation, le disque `scsi0` doit être placé avant le lecteur ISO `ide2` dans l'ordre de démarrage de la VM.

![Installation de GRUB](https://github.com/user-attachments/assets/0bcc5c71-aee3-4737-b378-77cf8ed9bb69)


*Figure 7 — Confirmation de l'installation du programme de démarrage GRUB.*

## 5. Ouverture de la session GNOME

Debian a atteint le bureau GNOME. Le terminal ouvert ensuite confirme l'utilisation du compte `mohammed18` sur la machine `mohammed`.

![Bureau GNOME](https://github.com/user-attachments/assets/128cdb8b-0605-4d9f-9132-a694d87ff773)


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

![Compte et adresse IP Debian](https://github.com/user-attachments/assets/af446784-066a-4f99-97bf-a1dcfc0f439f)


*Figure 9 — Résultats de whoami, hostname et ip -br a.*

La vérification du 18 novembre confirme les mêmes valeurs.

![Vérification du compte et de l’adresse IP le 18 novembre]<img width="960" height="294" alt="image" src="https://github.com/user-attachments/assets/bdffc13c-d0d9-402a-a4a0-8b5e1ffb8481" />


*Figure 10 — VM 102 sur `server1`. L’interface `ens18` est active et porte l’adresse `10.7.236.185/23`.*

## 7. Vérification du service SSH

Une première tentative avec `sudo` a échoué parce que le compte `mohammed18` n’avait pas les droits nécessaires pour exécuter la commande. Le 18 novembre, j’ai vérifié l’état du service depuis le terminal Debian.

```bash
systemctl status ssh --no-pager
```

Le service OpenSSH est **actif** (`active (running)`) et configuré pour démarrer automatiquement (`enabled`).

![État du serveur OpenSSH dans Debian]<img width="900" height="320" alt="image" src="https://github.com/user-attachments/assets/aeeef97c-6bb7-4c32-86bd-8952ce5d7099" />


*Figure 11 — Service SSH actif et activé au démarrage dans la VM Debian.*

## 8. Test depuis Windows

J’ai lancé la commande suivante dans PowerShell.

```powershell
ssh mohammed18@10.7.236.185
```

Le serveur SSH de la VM a répondu et demandé le mot de passe. La tentative s’est terminée par `Permission denied (publickey,password)`. La VM est donc joignable en SSH depuis mon poste Windows. L’ouverture de session reste à valider.

![Message d’authentification SSH refusée dans PowerShell]<img width="1587" height="818" alt="image" src="https://github.com/user-attachments/assets/6fc7b718-a98a-4210-b780-4a3c48988eff" />


*Figure 12 — La VM répond à la demande de connexion, puis refuse l’authentification.*

## 9. Clé publique du professeur

Lors de la vérification dans la VM, le fichier `/home/mohammed18/.ssh/authorized_keys` était absent. La clé publique du professeur a été ajoutée lors d’une session sur `server1` (`10.7.236.240`), sous le compte `B300158185`. Pour permettre l’accès à **la VM Debian**, la clé doit être enregistrée dans le fichier du compte `mohammed18` sur la VM (`10.7.236.185`).

### Configuration à terminer dans la VM

Dans la console Proxmox de la **VM 102**, sous le compte `mohammed18` :

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
```

Ajouter la clé publique du professeur sur une seule ligne et conserver les clés déjà présentes. Enregistrer avec **Ctrl+O**, **Entrée**, puis quitter avec **Ctrl+X**.

```bash
chmod 600 ~/.ssh/authorized_keys
ssh-keygen -lf ~/.ssh/authorized_keys
```

Comparer l’empreinte affichée à celle de la clé fournie par le professeur. Pour valider le critère « Accessible par clé du prof », faire confirmer une connexion du professeur à `mohammed18@10.7.236.185` avec sa clé, puis ajouter le résultat au rapport.

## 10. Accès au nœud Proxmox

Une session SSH sur `server1` est visible sous le compte Linux `B300158185`. Les captures de l’interface Web montrent le compte `root@pam`. Les permissions d’un compte individuel dans l’interface Web restent à vérifier si la consigne le demande.

## 11. Bilan du laboratoire

| Vérification | Résultat |
|---|---|
| 🥉 VM créée | Confirmé. La VM 102 est en marche et Debian ouvre le bureau GNOME. |
| 🥈 Adresse IP assignée | Confirmé. L’interface `ens18` est active avec l’adresse `10.7.236.185/23`. |
| Service SSH dans Debian | Confirmé. OpenSSH est actif et activé au démarrage. |
| Connexion depuis Windows | Le serveur répond. L’authentification du compte `mohammed18` a échoué. |
| 🥇 Accès à la VM par la clé du professeur | À valider. L’ajout de la clé dans la VM et la connexion du professeur restent à confirmer. |

## 12. Conclusion

J’ai installé Debian 13 avec GNOME sur la VM 102 et confirmé son adresse IPv4. J’ai vérifié que le service SSH est actif. Mon poste Windows atteint la VM et la tentative d’ouverture de session a échoué à l’authentification. Il reste à confirmer l’ajout de la clé publique du professeur dans la VM et à faire tester sa connexion.

## Référence du cours

[Collège Boréal — INF1085 — X.Linux/3.keys](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/X.Linux/3.keys)
