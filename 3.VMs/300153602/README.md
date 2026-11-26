# Travail 3 — Création d’une machine virtuelle

**Meriem Abdedou — INF1085, groupe 04**

## Objectif

Créer une machine virtuelle Ubuntu Server sur le nœud Proxmox de mon groupe et vérifier sa connexion réseau.

## Démarche

1. Dans Proxmox, cliquer sur **Create VM**, choisir un identifiant libre et entrer le nom de la VM.
2. Sélectionner l’image ISO d’Ubuntu Server et configurer le disque, la mémoire et le processeur selon les ressources attribuées.
3. Connecter la VM au pont réseau du laboratoire et installer Ubuntu Server.
4. Après le redémarrage, vérifier le nom de la machine avec `hostnamectl`, l’adresse IP avec `ip -br address` et la passerelle avec `ip route`.
5. Si SSH est configuré, tester la connexion depuis un autre poste du laboratoire.

## Résultats du laboratoire

- Nom et identifiant de la VM :
- Adresse IP et passerelle :
- Résultat du test SSH :
