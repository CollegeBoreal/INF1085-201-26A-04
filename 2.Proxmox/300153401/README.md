# 🖥️ INF1085 – Administration Linux

## ⚙️ Rapport de mise en place et d’installation de Proxmox VE

**👤 Nom :** Chaghi  
**👤 Prénom :** Younes  
**🎓 Numéro étudiant :** 300153401  
**📚 Cours :** INF1085 – Administration Linux  
**📅 Session :** Automne 2026


---

## 📌 1. Présentation

L’objectif de ce laboratoire était de préparer un serveur et d’installer **Proxmox VE** afin de pouvoir utiliser le serveur comme plateforme de virtualisation.

Nous avons suivi les différentes étapes d’installation et de configuration, notamment :

- 🚀 le démarrage de l’installateur
- 🔐 la création du mot de passe administrateur
- 🌐 la configuration du réseau

---

## 💿 2. Démarrage de l’installation

Le serveur a été démarré à partir d’une clé USB contenant l’image ISO de **Proxmox VE**.

Pendant le démarrage, nous avons accédé au menu **GRUB** de Proxmox afin de lancer l’installation graphique.

<img width="1600" height="900" alt="Démarrage de l’installateur Proxmox VE" src="https://github.com/user-attachments/assets/b6ffba00-2f6b-4412-8abf-de03e095ad62" />

*📸 Figure 1 : Démarrage de l’installateur Proxmox VE.*

Cette étape permet de lancer l’installation du système sur le serveur.

---

## 🔑 3. Création du mot de passe administrateur

Pendant l’installation, Proxmox demande de définir le mot de passe du compte administrateur **root**.

Une adresse courriel doit également être saisie afin de recevoir les notifications importantes du serveur.

<img width="1600" height="900" alt="Configuration du mot de passe administrateur et de l’adresse courriel" src="https://github.com/user-attachments/assets/11253589-42ea-49a5-ba05-e77149971eec" />

*📸 Figure 2 : Configuration du mot de passe administrateur et de l’adresse courriel.*

Le mot de passe doit être suffisamment sécurisé et contenir plusieurs caractères.

Cette étape permet de protéger l’accès à l’administration de Proxmox.

---

## 🌐 4. Configuration du réseau

Nous avons ensuite configuré les paramètres réseau du serveur.

<img width="1600" height="899" alt="Configuration du réseau dans Proxmox VE" src="https://github.com/user-attachments/assets/b68138cd-07cc-4ec5-82c8-771f454f1911" />

*📸 Figure 3 : Configuration du réseau dans Proxmox VE.*

### 📋 Paramètres configurés

| Élément | Valeur |
|---|---|
| Hostname | `server1.labinfo.local` |
| Adresse IP | `192.168.100.2/24` |
| Gateway | `192.168.100.1` |
| DNS Server | `192.168.100.1` |

Cette configuration permet au serveur de communiquer sur le réseau et d’être accessible depuis un autre ordinateur.

---

## 🛠️ 5. Installation de Proxmox

Après avoir terminé la configuration du compte administrateur et du réseau, nous avons poursuivi l’installation.

### ✅ Principales étapes de l’installation

1. 🚀 Démarrage de l’installateur  
2. 💽 Sélection du disque  
3. ⚙️ Configuration du système  
4. 🔐 Création du mot de passe administrateur  
5. 🌐 Configuration du réseau  
6. 📦 Installation de Proxmox VE  
7. 🔄 Redémarrage du serveur  

---

## 🔌 6. Connexion réseau

Une fois l’installation terminée, le serveur a été redémarré.

Le serveur utilise l’adresse IP suivante :

`192.168.100.2`

L’interface Web de Proxmox peut ensuite être ouverte depuis un navigateur à l’adresse :

`https://192.168.100.2:8006`

Cette interface permet d’administrer le serveur à distance.

---

## ✅ 7. Résultat

L’installation de **Proxmox VE** s’est terminée correctement.

Le serveur possède maintenant :

- ✅ une configuration réseau fonctionnelle
- ✅ une interface Web accessible
- ✅ un compte administrateur **root**
- ✅ un environnement prêt pour la virtualisation

Le compte administrateur root permet de gérer le serveur et de créer des machines virtuelles.

---

## 📝 8. Conclusion

Ce laboratoire nous a permis d’apprendre les principales étapes nécessaires pour installer **Proxmox VE** sur un serveur.

Nous avons démarré l’installation à partir d’une clé USB puis configuré :

- 🔐 le compte administrateur
- 🌐 les paramètres réseau

Après l’installation, le serveur est accessible sur le réseau grâce à son adresse IP.

✅ Le serveur est maintenant prêt à être utilisé pour créer et administrer des machines virtuelles avec **Proxmox VE**.

---

## 📚 INF1085 – Administration Linux

**🖥️ Travail pratique :** Mise en place et installation de Proxmox VE  
**📅 Session :** Automne 2026
