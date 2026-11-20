# Blueprint StockMaster-Pro

Dossier d'architecture du module de gestion de stock de **MegaShop-B2B**. Il remplace les fichiers Excel de l'entrepôt : chaque emplacement contient un seul produit, et le stock n'est jamais saisi, il se calcule à partir de l'historique des entrées et des sorties. Aucune sortie ne peut dépasser le stock présent.

## Fichiers

| Fichier | Couche | Contenu |
|---|---|---|
| [01_database_schema.sql](./01_database_schema.sql) | Données | Tables `produit`, `emplacement`, `mouvement_stock` et vue `stock_emplacement` (PostgreSQL). |
| [02_behavioral_architecture.md](./02_behavioral_architecture.md) | Comportement | Correspondance API ↔ SQL et diagramme de séquence d'un mouvement (Mermaid). |
| [03_api_contract.yaml](./03_api_contract.yaml) | Contrat | Route `POST /inventory/movements` (OpenAPI 3.0.3). |
| [04_business_specs.feature](./04_business_specs.feature) | Métier | Règles d'entrée et de sortie de stock (Gherkin). |

## Garanties de la base

La base reste correcte même si l'API est contournée :

- `CHECK (quantite > 0)` : une quantité nulle ou négative est refusée ;
- `CHECK (type_mouvement IN ('ENTREE', 'SORTIE'))` : seuls deux types de mouvement existent ;
- trigger `mouvement_stock_immuable` : un mouvement enregistré ne se modifie pas et ne se supprime pas ;
- trigger `mouvement_stock_jamais_negatif` : une sortie supérieure au stock actuel est refusée, avec un verrou sur l'emplacement contre les sorties simultanées.

## Vérification

```bash
docker run -d --name stockmaster-db -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=stockmaster -p 5432:5432 postgres:17-alpine
docker exec -i stockmaster-db psql -U postgres -d stockmaster -v ON_ERROR_STOP=1 < 01_database_schema.sql
spectral lint 03_api_contract.yaml --ruleset ../API_first/.spectral.yaml
```

| Test de l'audit | Résultat |
|---|---|
| Grep du concept *mouvement* | Présent dans les 4 fichiers : `mouvement_stock` (SQL), `MouvementStock` / `typeMouvement` (YAML), table de correspondance (Markdown), « le mouvement est enregistré » (Gherkin). |
| Étanchéité SQL | Une quantité de `-500` ou de `0` est rejetée par le `CHECK`. Une sortie de 11 sur un stock de 10 est rejetée par le trigger, y compris quand deux sorties arrivent en même temps. |
| Spectral | Aucun message, à tous les niveaux de sévérité. |
| Mermaid | Le diagramme de séquence compile avec Mermaid 11. |
