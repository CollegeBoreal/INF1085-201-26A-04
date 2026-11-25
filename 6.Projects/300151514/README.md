# Projet — Page d’état d’un serveur Ubuntu avec Nginx

Le projet déploie sur la VM Ubuntu une page qui affiche le nom de la machine, l’heure UTC, la charge moyenne et l’espace disque disponible. Le script Bash actualise la page et un minuteur systemd le relance automatiquement.

## Déploiement dans la VM

```bash
sudo apt update
sudo apt install -y nginx curl
sudo install -m 0755 actualiser-etat.sh /usr/local/bin/actualiser-etat.sh
sudo install -m 0644 etat-linux.service etat-linux.timer /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl start etat-linux.service
sudo systemctl enable --now nginx etat-linux.timer
```

## Vérifications

```bash
curl -fsS http://localhost/etat-linux.html
systemctl list-timers etat-linux.timer
journalctl -u etat-linux.service -n 10 --no-pager
```

La page est destinée au réseau du laboratoire. Le déploiement et son URL sur la VM du groupe restent à confirmer.

[Consignes du groupe du mercredi](https://github.com/CollegeBoreal/INF1085-201-26A-04/tree/main/6.Projects)
