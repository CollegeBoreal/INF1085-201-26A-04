#!/usr/bin/env bash
set -euo pipefail

output=${1:-/var/www/html/etat-linux.html}
host=$(hostname | tr -cd '[:alnum:]._-')
updated=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
read -r load _ < /proc/loadavg
disk=$(df -hP / | awk 'NR == 2 { print $4 }')
temporary=$(mktemp "${output}.XXXXXX")
trap 'rm -f -- "$temporary"' EXIT

cat > "$temporary" <<HTML
<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<title>État du serveur Linux</title>
<h1>État du serveur Linux</h1>
<dl>
  <dt>Machine</dt><dd>$host</dd>
  <dt>Mise à jour</dt><dd>$updated</dd>
  <dt>Charge moyenne sur une minute</dt><dd>$load</dd>
  <dt>Espace disponible sur /</dt><dd>$disk</dd>
</dl>
</html>
HTML
chmod 0644 "$temporary"
mv -f -- "$temporary" "$output"
