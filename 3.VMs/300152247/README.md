<img width="1917" height="1078" alt="image" src="https://github.com/user-attachments/assets/cc087ead-5fed-4c41-adb7-620fc220a8ca" />
Rapport — Création d’un compte administrateur dans Proxmox VE

Objectif : Sécuriser l’accès à Proxmox VE en utilisant un compte administrateur individuel plutôt que le compte partagé root@pam.

J’ai créé une nouvelle machine virtuelle nommée AnissCh, avec 2 Go de mémoire vive, 2 cœurs CPU et un disque virtuel de 32 Go. J’ai également créé un compte Linux associé à mon identifiant Boréal B300152247, puis configuré un compte Proxmox correspondant et lui ai attribué le rôle Administrator.

J’ai vérifié la création de l’utilisateur avec la commande id B300152247 et consulté les utilisateurs et les permissions avec les commandes pveum user list et pveum acl list. Enfin, j’ai réussi à me connecter à l’interface Web de Proxmox avec mon compte personnel.

Résultat : La machine virtuelle a été créée et le compte personnel a été configuré. Cette approche permet d’identifier individuellement les administrateurs et d’améliorer la traçabilité des actions effectuées sur le serveur.

<img width="981" height="243" alt="image" src="https://github.com/user-attachments/assets/7e5c3b98-2ce5-463a-b015-f84db408beb0" />
<img width="1640" height="912" alt="image" src="https://github.com/user-attachments/assets/ba1c2af2-2524-4b84-a44c-30a79b58ea5d" />



