# Plan De Cours

[:tada: Participation](.scripts/Participation.md)

## :a: Github

:round_pushpin: Creer un compte sur [:octocat: Github](https://github.com)

- [ ] Explorer [Github Education](https://education.github.com)

:round_pushpin: Créer une page 

- [ ] créer un répertoire avec son :id: et ajouter le fichier `README.md`
- [ ] créer un répertoire dans son répertoire :id:, ajouter le répertoire `images` et ajouter le fichier `.gitkeep`
- [ ] Ajouter des images dans le répertoire `images`
- [ ] Ajouter les images au fichier `README.md`

---

```mermaid
flowchart LR

A["
Installation Linux
 - VM Ubuntu
 - Partitions
 - SSH
 - Configuration initiale
"]

--> B["
Ligne de commande
 - Navigation
 - Fichiers
 - Éditeurs
 - Processus
"]

B --> C["
Administration
 - Comptes
 - Groupes
 - Permissions
 - Sudo
"]

C --> D["
Automatisation
 - Bash
 - Variables
 - Scripts
 - Tâches planifiées
"]

D --> E1["
Services Linux
 - Web
 - DNS
 - Réseau
 - Déploiement
"]

D --> E2["
Sécurité
 - Pare-feu
 - SSH sécurisé
 - Journalisation
 - Durcissement
"]

E1 --> F["
Surveillance
 - Logs
 - Performance
 - Dépannage
 - Monitoring
"]

E2 --> F

F --> G["
Projet final
 - Serveur Web
 - Sécurisation
 - Documentation
 - Mise en production
"]
```


Ou une version encore plus condensée et orientée RAC :

```mermaid
flowchart LR

R1["RAC 1<br/>Installation Linux"]
--> R2["RAC 2<br/>Comptes<br/>Groupes<br/>Permissions"]
--> R3["RAC 2<br/>Scripts et automatisation"]

R3 --> R4["RAC 3<br/>Services et sécurité"]
R4 --> R5["RAC 3<br/>Surveillance et optimisation"]
R5 --> R6["Projet<br/>Serveur Web"]
```


Voici une version plus engageante, moderne et « étudiant-friendly » du curriculum INF1085, avec quelques émojis pour illustrer le parcours d'apprentissage.

```mermaid
flowchart LR

A["🐧
Installation Linux
• Ubuntu Server
• Machines virtuelles
• SSH
• Configuration initiale
"]

--> B["💻
Ligne de commande
• Navigation
• Fichiers et dossiers
• Éditeurs texte
• Processus
"]

B --> C["👥
Utilisateurs & Groupes
• Comptes
• Groupes
• Sudo
• Gestion organisationnelle
"]

C --> D["🔐
Permissions & Sécurité
• chmod
• chown
• ACL
• Pare-feu
"]

D --> E2["⚙️
Scripts & Automatisation
• Bash
• Variables
• Boucles
• Tâches planifiées
"]

E1 --> F["🌐
Services Réseau
• Web
• DNS
• SSH
• Applications serveur
"]

E2 --> F["
Services Linux
 - Web
 - DNS
 - Réseau
 - Déploiement
"]

F --> G["📊
Surveillance & Diagnostic
• Logs
• Dépannage
• Performance
• Monitoring
"]

G --> H["📚
Documentation
• Procédures
• Changements
• Bonnes pratiques
"]

H --> I["🚀
Projet Final
Serveur Web complet
• Installation
• Sécurisation
• Configuration
• Documentation
"]
```

Vue « parcours étudiant »
```mermaid
flowchart LR

A["🛠️ Installer"] --> B["💻 Administrer"]
B --> C["👤 Gérer les utilisateurs"]
C --> D["🔒 Sécuriser"]
D --> E["🤖 Automatiser"]
E --> F["🌐 Déployer des services"]
F --> G["📈 Surveiller"]
G --> H["🚀 Exploiter en production"]
```

Résumé du cours en une ligne

🐧 Installer → Administrer → Sécuriser → Automatiser → Déployer → Surveiller → Documenter → Mettre en production un serveur Linux d'entreprise.

| Étape                     | Ce que l'étudiant devient             |
| ------------------------- | ------------------------------------- |
| 🐣 Installation Linux     | Junior Linux User                     |
| 💻 Ligne de commande      | Terminal Ninja                        |
| 👥 Utilisateurs & groupes | Administrateur système                |
| 🔐 Sécurité               | Gardien du serveur                    |
| ⚙️ Scripts Bash           | Automatisation Guru                   |
| 🌐 Services réseau        | Architecte Linux                      |
| 📊 Monitoring             | Dépanneur d'élite                     |
| 🚀 Projet final           | Linux SysAdmin prêt pour l'entreprise |

Cette progression reflète directement les trois RAC du cours : installation, administration des comptes et permissions, puis optimisation, sécurité et surveillance des systèmes Linux.

