# Modélisation Relationnelle (Merise) & Normalisation

Conception d'une base de données relationnelle propre pour **MegaShop-B2B**, à partir d'un export CSV plat qui génère des anomalies (données dupliquées, pertes d'information à la suppression).

## Structure

```
Modelisation_Relationnelle/
├── data/
│   └── legacy_data.csv      # Export CSV d'origine (données brutes)
├── docs/
│   └── rules.md             # Contexte, entités, règles de gestion, cardinalités
└── scripts/
    └── init_database.sql    # Script de création de la base (à compléter)
```

## Démarche

1. **Analyse des données brutes** : identification des sujets principaux (Client, Commande, Produit) dans `legacy_data.csv`.
2. **Règles de gestion** : phrases simples liant ces sujets, avec leurs cardinalités (min, max).
3. **Script SQL** : traduction du modèle en tables (à venir).
