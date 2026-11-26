# Projet sur VM Linux — service web de documentation

Le sujet choisi est un mini-site interne qui présente les activités du cours. Le service est exécuté dans une VM Debian ou Ubuntu sur le réseau du laboratoire.

## Installation

```bash
sudo apt update
sudo apt install -y nginx
sudo install -m 0644 index.html /var/www/html/index.html
sudo nginx -t
sudo systemctl enable --now nginx
```

## Tests

```bash
systemctl is-active nginx
curl -fsS http://localhost/ | grep -F "Laboratoire INF1085"
ip -br address
```

Depuis un poste du même réseau, ouvrir `http://ADRESSE_DE_LA_VM/` et vérifier que le titre et le tableau des activités s’affichent. En cas d’erreur, vérifier l’adresse utilisée, l’état du service et les journaux avec `sudo journalctl -u nginx -n 30 --no-pager`.

| Test | Critère de réussite | Résultat réel |
|---|---|---|
| Configuration Nginx | Test de syntaxe réussi | À relever |
| Service | État actif | À relever |
| Requête locale | Page INF1085 renvoyée | À relever |
| Requête depuis un poste du labo | Page visible dans le navigateur | À relever |

Ajouter dans `images/` les captures du test local et du navigateur.
