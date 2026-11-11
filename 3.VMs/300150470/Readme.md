<div align="center">

# 🐧 3.VMs — Ma VM Debian sur Proxmox



![Debian 13](https://img.shields.io/badge/Debian-13-A81D33?style=flat-square&logo=debian&logoColor=white)
![Proxmox 9.2.2](https://img.shields.io/badge/Proxmox-9.2.2-E57000?style=flat-square)
![VM 102](https://img.shields.io/badge/VM-102-00693C?style=flat-square)
![IP 10.7.236.207](https://img.shields.io/badge/IP-10.7.236.207-00A88F?style=flat-square)

</div>

---

## ✨ Introduction

> Ce projet consiste à créer une machine virtuelle Debian 13 sur le serveur Proxmox server237, puis à la préparer pour un accès SSH, avec une adresse fixe et la clé du professeur.

📛 **Nom du projet :** 3.VMs — Création d'une machine virtuelle Debian

👤 **Nom et prénom :** Ifticene Hacene

🎓 **Numéro étudiant :** 300150470

📚 **Cours :** INF1085 — Administration Linux

👥 **Groupe :** 1

🏙️ ubuntu@10.7.236.207




---

## 📸 Explication des images

### 🔐 1. Connexion et création du compte

#### Capture 1 — Connexion SSH

![Capture 1](images/01-ssh-root-adduser.png)

*Connexion SSH à server237, compte B300150470 créé avec adduser.*

#### Capture 2 — Informations du compte

![Capture 2](images/02-adduser-informations.png)

*Informations du compte pendant adduser.*

#### Capture 3 — Confirmation

![Capture 3](images/03-adduser-confirmation.png)

*Compte confirmé avec Y.*

#### Capture 4 — Vérification

![Capture 4](images/04-id-pveum-user-list.png)

*Vérification avec id, B300150470@pam absent de la liste.*

#### Capture 5 — Ajout Proxmox

![Capture 5](images/05-pveum-user-add.png)

*Compte Proxmox ajouté, il apparaît dans la liste.*

#### Capture 6 — Rôle Administrator

![Capture 6](images/06-pveum-acl-administrator.png)

*Rôle Administrator donné au compte.*

---

### 🖥️ 2. VM et installation

#### Capture 7 — Menu Debian

![Capture 7](images/07-menu-installateur-debian.png)

*Menu d'installation Debian, Graphical install.*

#### Capture 8 — Logiciels

![Capture 8](images/08-choisir-installer-logiciels.png)

*Installation des logiciels en cours.*

Debian 13 installée en français, compte `b300150470`, disque sda 32,6 Go `/` + 1,8 Go swap, serveur SSH coché, GRUB sur `/dev/sda`.

---

### 🌐 3. Réseau et clé du prof

#### Capture 9 — Adresse fixe

![Capture 9](images/09-hostname-207-whoami.png)

*IP 10.7.236.207 vérifiée, compte b300150470.*

```bash
ssh b300150470@10.7.236.207
```

#### Capture 10 — Clé du prof

![Capture 10](images/10-cle-prof-authorized-keys.png)

*Clé du prof ajoutée dans authorized_keys, droits 600, SSH réussi.*

---

## ✅ Conclusion

> La VM 102 fonctionne : Debian 13 est installée, l'adresse fixe `10.7.236.207` est vérifiée, et la clé du professeur est ajoutée.



<div align="center">

*INF1085 • Collège Boréal • 2026-11-04*

</div>
