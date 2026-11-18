# 🖥️ Rapport de mise en place et d'installation de Proxmox VE

**Administration Linux | Laboratoire de virtualisation**

![Proxmox VE](https://img.shields.io/badge/Proxmox-VE_9-orange?style=for-the-badge)
![Linux](https://img.shields.io/badge/Système-Linux-blue?style=for-the-badge)
![Virtualisation](https://img.shields.io/badge/Virtualisation-KVM%2FQEMU-green?style=for-the-badge)

---

## 📋 1. Présentation du projet

Ce laboratoire avait pour objectif de préparer un serveur physique et d'y installer **Proxmox Virtual Environment (Proxmox VE)** afin de disposer d'une plateforme de virtualisation.

Proxmox VE est une solution de virtualisation open source qui permet de créer, configurer et administrer des machines virtuelles ainsi que des conteneurs depuis une interface Web.

**Objectifs du laboratoire :**
- Préparer le serveur pour l'installation.
- Démarrer l'installateur Proxmox VE depuis une clé USB.
- Configurer le compte administrateur `root`.
- Définir les paramètres réseau du serveur.
- Terminer l'installation et redémarrer le système.
- Préparer l'accès à l'interface d'administration Web.

---

## 🚀 2. Démarrage de l'installation

Le serveur a été démarré à partir d'une clé USB contenant l'image ISO de Proxmox VE.

Pendant le démarrage, nous avons accédé au menu **GRUB** pour lancer l'installation graphique.

![Démarrage de Proxmox VE](https://github.com/user-attachments/assets/b6ffba00-2f6b-4412-8abf-de03e095ad62)

*Figure 1 — Démarrage de l'installateur Proxmox VE.*

**Résultat :** L'installateur Proxmox VE a été lancé, permettant de poursuivre les étapes de configuration.

---

## 🔐 3. Configuration du compte administrateur

Pendant l'installation, Proxmox VE demande de définir un mot de passe pour le compte administrateur `root`.

Une adresse courriel doit également être renseignée pour recevoir les notifications importantes du serveur.

![Configuration administrateur](https://github.com/user-attachments/assets/11253589-42ea-49a5-ba05-e77149971eec)

*Figure 2 — Configuration du mot de passe administrateur et de l'adresse courriel.*

**Points importants :**
- Définir un mot de passe robuste.
- Configurer l'adresse courriel de l'administrateur.
- Protéger l'accès à l'interface d'administration.

---

## 🌐 4. Configuration du réseau

Nous avons ensuite configuré les paramètres réseau du serveur pour permettre sa communication avec les autres équipements du réseau local.

![Configuration réseau](https://github.com/user-attachments/assets/b68138cd-07cc-4ec5-82c8-771f454f1911)

*Figure 3 — Configuration du réseau dans Proxmox VE.*

### Paramètres réseau

| Paramètre | Valeur |
|---|---|
| Nom du serveur (Hostname) | `server1.labinfo.local` |
| Adresse IPv4 | `192.168.100.2` |
| Masque réseau | `/24` (`255.255.255.0`) |
| Passerelle (Gateway) | `192.168.100.1` |
| Serveur DNS | `192.168.100.1` |
| Port d'administration Web | `8006` |

Cette configuration permet au serveur d'être accessible sur le réseau local, sous réserve d'une connectivité correcte entre les équipements.

---

## ⚙️ 5. Installation de Proxmox VE

Après avoir terminé la configuration du compte administrateur et du réseau, nous avons poursuivi l'installation.

### Étapes principales

1. Démarrage du serveur à partir de la clé USB.
2. Lancement de l'installateur Proxmox VE.
3. Sélection du disque de destination.
4. Configuration des paramètres du système.
5. Création du mot de passe administrateur.
6. Configuration des paramètres réseau.
7. Installation des composants Proxmox VE.
8. Redémarrage du serveur.

À la fin de cette procédure, Proxmox VE était installé sur le serveur.

---

## 💻 6. Accès à l'interface Web

Une fois l'installation terminée, le serveur a été redémarré.

L'adresse IP configurée est :

`192.168.100.2`

L'interface Web de Proxmox VE est accessible à partir d'un navigateur sur le réseau autorisé à l'adresse suivante :

### 🔗 https://192.168.100.2:8006

**Informations de connexion :**

| Élément | Valeur |
|---|---|
| Utilisateur | `root` |
| Domaine d'authentification | `Linux PAM` |
| Mot de passe | Défini pendant l'installation |
| Protocole | HTTPS |
| Port | `8006` |

L'interface Web permet notamment de :
- Créer et administrer des machines virtuelles.
- Gérer les ressources du serveur.
- Configurer les réseaux virtuels.
- Administrer les espaces de stockage.
- Surveiller l'utilisation du processeur et de la mémoire.

---

## ✅ 7. Résultats obtenus

Les principales étapes de l'installation ont été réalisées.

| Objectif | Résultat |
|---|---|
| Démarrage à partir d'une clé USB | ✅ Réalisé |
| Lancement de l'installateur | ✅ Réalisé |
| Configuration du compte `root` | ✅ Réalisé |
| Configuration réseau | ✅ Réalisé |
| Installation de Proxmox VE | ✅ Réalisé |
| Redémarrage du serveur | ✅ Réalisé |
| Configuration de l'adresse d'administration | ✅ Réalisé |

**Résultat final :** Le serveur est équipé de Proxmox VE et dispose des paramètres nécessaires à son administration et à la création de machines virtuelles.

---

## 🧠 8. Compétences développées

Ce laboratoire nous a permis de développer plusieurs compétences techniques :

- Installation d'un hyperviseur sur un serveur physique.
- Utilisation du menu de démarrage GRUB.
- Configuration d'un compte administrateur Linux.
- Configuration d'une adresse IPv4 statique.
- Compréhension du rôle des passerelles et des serveurs DNS.
- Découverte de l'administration d'un environnement virtualisé.

---

## 📝 9. Conclusion

Ce laboratoire nous a permis de comprendre les principales étapes de l'installation de **Proxmox Virtual Environment** sur un serveur physique.

Nous avons démarré le serveur à partir d'une clé USB, lancé l'installateur et configuré les paramètres essentiels, notamment le compte administrateur et le réseau.

À la fin de l'installation, le serveur disposait d'une configuration lui permettant d'être administré à distance à travers l'interface Web de Proxmox VE.

Cette expérience constitue une première étape importante dans l'apprentissage de la virtualisation et de l'administration des systèmes Linux.

---

**Projet réalisé dans le cadre du cours d'Administration Linux — Collège Boréal.**
