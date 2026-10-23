# Modélisation Relationnelle (Merise) & Normalisation

Conception d'une base de données relationnelle propre pour **MegaShop-B2B**, à partir d'un export CSV plat qui génère des anomalies (données dupliquées, pertes d'information à la suppression).

## Structure

```
Modelisation_Relationnelle/
├── data/
│   └── legacy_data.csv      # Export CSV d'origine (données brutes)
├── docs/
│   ├── rules.md             # Contexte, entités, règles de gestion, cardinalités
│   └── mcd.md               # Modèle Conceptuel de Données (Mermaid)
└── scripts/
    └── init_database.sql    # Script DDL PostgreSQL (idempotent)
```

## Démarche

1. **Analyse des données brutes** : identification des sujets principaux (Client, Commande, Produit) dans `legacy_data.csv`.
2. **Règles de gestion** : phrases simples liant ces sujets, avec leurs cardinalités (min, max).
3. **MCD** : entités, associations « Passe » et « Contient » (association porteuse de la quantité).
4. **Script SQL** : 4 tables (`client`, `produit`, `commande`, `ligne_commande`) avec clés primaires et étrangères, `NOT NULL`, `UNIQUE` et `CHECK`.

## Lancer le script

```bash
psql -U postgres -d megashop -f scripts/init_database.sql
```

Le script est idempotent : il peut être relancé sans erreur grâce aux `DROP TABLE IF EXISTS`.
