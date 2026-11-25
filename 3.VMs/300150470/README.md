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

🏙️ b300150470@10.7.236.207

Debian Utilisateur: b300150470




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

### 🔧 4. Correction réseau — 2026-11-25

Problème : la VM était en `10.7.236.207/24` avec passerelle `10.7.236.1`, qui n'existe pas. Le ping de la passerelle échouait, `Destination Host Unreachable`.

Cause : sur server237, le vrai réseau est `10.7.236.0/23` avec passerelle `10.7.237.1`.

Correction, en root dans la VM, connexion `Wired connection 1` :

```bash
nmcli connection modify "Wired connection 1" ipv4.addresses 10.7.236.207/23 ipv4.gateway 10.7.237.1
nmcli connection modify "Wired connection 1" ipv4.dns 8.8.8.8
nmcli connection up "Wired connection 1"
```

Config finale : `10.7.236.207/23`, passerelle `10.7.237.1`, DNS `8.8.8.8`.

#### Capture 11 — Route sur server237

![Capture 11](images/11-ip-route-server237.png)

*`ip route` sur server237 : default via 10.7.237.1, réseau 10.7.236.0/23.*

#### Capture 12 — Ping passerelle

![Capture 12](images/12-ping-passerelle-237-1.png)

*Ping 10.7.237.1 OK, ~0,5 ms.*

#### Capture 13 — Ping Internet

![Capture 13](images/13-ping-8888.png)

*Ping 8.8.8.8 OK, ~3 ms.*

#### Capture 14 — Ping google.com

![Capture 14](images/14-ping-google.png)

*Ping google.com OK, 142.250.137.138, ~2,8 ms. Le DNS fonctionne.*

---

## ✅ Conclusion

> La VM 102 fonctionne : Debian 13 est installée, l'adresse fixe `10.7.236.207/23` est vérifiée, passerelle `10.7.237.1`, DNS `8.8.8.8`, et la clé du professeur est ajoutée. Internet fonctionne : ping passerelle, 8.8.8.8 et google.com OK le 2026-11-25.



<div align="center">

*INF1085 • Collège Boréal • 2026-11-04, mis à jour 2026-11-25*

</div>
