# Preuves du TP — Gestion des comptes administrateurs Proxmox

Les trois captures ci-dessous proviennent des vérifications sur `server237`.

| Fichier | Commande | Statut |
|---|---|---|
| `01-compte-linux.png` | `id B300142636` | ✅ Vérifié |
| `02-utilisateur-proxmox.png` | `pveum user list` | ✅ Vérifié |
| `03-permissions-acl.png` | `pveum acl list` | ✅ Vérifié |

**Vie privée :** les captures 02 et 03 ont été recadrées pour ne pas afficher les identifiants et coordonnées des autres participants du laboratoire.

## Preuves complémentaires non encore reçues

- `04-session-web.png` : session connectée en `B300142636@pam` (masquer les informations sensibles).
- `05-connexion-ssh.png` : session SSH individuelle vers `server237`.
- `06-cle-publique-permissions.png` : permissions `.ssh` et `authorized_keys` (ne pas montrer la clé).
- `07-test-ssh-cle.png` : résultat de la connexion SSH par clé.

Ne pas publier de mot de passe, de clé privée ni le contenu de `authorized_keys`.
