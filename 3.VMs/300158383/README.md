# Rapport de laboratoire : déploiement d'une VM Debian 13 sur Proxmox VE

| | |
|---|---|
| **Cours** | INF1085-201-26A-04 — 3. VMs |
| **Étudiante** | Salma Baali (300158383) |
| **Hyperviseur** | Proxmox VE 9.2.2 |
| **Nœud** | `server1` |
| **Accès Web** | `https://10.7.236.240:8006` |
| **Machine virtuelle** | `104 — salma` |
| **Système invité** | Debian GNU/Linux 13 « trixie » |

---

## 1. Objectifs

- Créer une VM sur Proxmox VE.
- Installer Debian 13 et démarrer depuis le disque virtuel.
- Utiliser l'interface web et la console de Proxmox pour administrer la VM.

## 2. Environnement

La VM 104 est hébergée sur le nœud `server1` du serveur Proxmox du laboratoire (`10.7.236.240`). Ce serveur héberge aussi les VM d'autres étudiants : mon travail concerne uniquement la VM 104.

## 3. Installation de Debian 13

Debian 13 « trixie » est installé sur la VM 104. À la fin de l'installation, l'écran de connexion affiche l'utilisateur `salma`.

![Écran de connexion Debian 13 de la VM 104](images/01-debian-ecran-connexion.png)

*Figure 1 — Console de la VM 104 (nœud `server1`) : écran de connexion de Debian 13.*

Après la connexion, le bureau affiche l'écran d'accueil « Bienvenue dans Debian GNU/Linux 13 (trixie) ». Le bureau installé est **GNOME**.

![Écran d'accueil Debian 13](images/02-debian-bienvenue.png)

*Figure 2 — VM 104 : bureau GNOME et message de bienvenue, dans la console de l'interface Proxmox VE 9.2.2 (`https://10.7.236.240:8006`).*

## 4. Conclusion

La VM `104 — salma` a été créée sur le nœud `server1` de Proxmox VE 9.2.2. Debian 13 « trixie » y est installé et démarre depuis le disque virtuel : l'écran de connexion et le bureau GNOME sont accessibles depuis la console de l'interface web de Proxmox.
