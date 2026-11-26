# Travail 4 — Comptes administrateurs Proxmox

**Meriem Abdedou — INF1085, groupe 04**

## Objectif

Créer un compte administrateur nominatif dans Proxmox et vérifier ses droits sur les ressources du laboratoire.

## Démarche

1. Créer un compte Linux sur le nœud Proxmox.
2. Dans **Datacenter → Permissions → Users**, ajouter ce compte avec le domaine **Linux PAM**.
3. Dans **Datacenter → Permissions**, attribuer au compte le rôle et le périmètre prévus pour le laboratoire.
4. Ouvrir une nouvelle session avec ce compte et vérifier qu’il peut gérer la VM qui lui est attribuée.
5. Si l’accès SSH est demandé, ajouter la clé publique au fichier `~/.ssh/authorized_keys` et tester la connexion.

## Résultats du laboratoire

- Compte et domaine utilisés :
- Rôle et périmètre attribués :
- Résultat du test de connexion :
