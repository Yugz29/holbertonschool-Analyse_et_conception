# Contexte MegaShop-B2B

Notre système actuel génère un fichier CSV plat. 
Nous subissons des anomalies : si Acme Corp change d'adresse, nous devons modifier de multiples lignes. Si nous supprimons la CMD-901, nous perdons l'existence historique du produit "Chaise Ergonomique". 

Votre mission : modéliser une base relationnelle propre.

## Entités

- Client : id_client, client_nom, client_contact, adr_livraison
- Commande : id_cmd, date_achat, statut_cmd
- Produit : code_prod, designation, prix_unitaire_ht

`qte` n'appartient à aucune entité seule, elle dépend à la fois de la commande et du produit (lien Commande ↔ Produit).

## Règles de gestion

| Règle | Cardinalité |
|---|---|
| Un client peut passer plusieurs commandes | (0,n) |
| Une commande est passée par un seul client | (1,1) |
| Une commande contient un ou plusieurs produits | (1,n) |
| Un produit peut apparaître dans plusieurs commandes | (0,n) |

## Données calculées

- total_ligne = prix_unitaire_ht × qte (non stocké, recalculé)
