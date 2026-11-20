# Spécifications Fonctionnelles, User Stories & Gherkin (BDD)

Spécification du contrôle **anti-fraude** des paiements de **MegaShop-B2B**. Le brief du client mélange son besoin métier avec des solutions techniques (SQL, code HTTP, popup) : ce projet en extrait les règles métier, les rédige en User Stories INVEST, puis les modélise en **Gherkin**. Le fichier `.feature` devient la source unique de vérité, lisible par le métier comme par l'équipe technique.

## Structure

```
SpecFonct/
├── docs/
│   ├── brief_metier_gouvernance.md   # Brief brut du client
│   └── user_stories.md               # Tri du brief, glossaire, US-01 / US-02, grille INVEST
└── specs/
    └── anti_fraude.feature           # Spécification exécutable en Gherkin
```

## Règles métier

1. **Blocage** : un paiement dont le montant **dépasse** 10 000 € est refusé si le pays de livraison figure au registre des embargos (Syldavie, Bordurie). Un montant d'exactement 10 000 € est accepté.
2. **Passe-droit VIP** : le paiement d'un client VIP est toujours accepté, quels que soient le montant et le pays.

## Contenu de `anti_fraude.feature`

| Élément | Rôle |
|---|---|
| `Background` | Déclare les pays du registre des embargos pour tous les scénarios. |
| `@nominal` Validation d'un paiement standard sans risque | 5 000 € vers la France : accepté. |
| `@vip` Exemption de contrôle pour les clients VIP | 15 000 € vers la Syldavie par un client VIP : accepté. |
| `@limite` Scenario Outline sur la matrice de risque | 9 exemples autour de la frontière des 10 000 € (9 999, 10 000, 10 000,01, 10 001), sur un pays hors registre et sur les deux pays sous embargo. |

## Revue des Trois Amigos

### Validation syntaxique (VS Code + extension Cucumber)

- [x] Les mots-clés `Feature`, `Background`, `Scenario`, `Scenario Outline`, `Examples`, `Given`, `When`, `Then`, `And` sont colorés.
- [x] Le tableau `Examples` est aligné (`Shift + Option + F` ne le modifie pas).
- [x] Les en-têtes `montant_cmd`, `destination` et `decision` correspondent exactement aux paramètres `<montant_cmd>`, `<destination>` et `<decision>` des étapes.
- [x] Un seul `When` par scénario, identique partout : « le client soumet son paiement ».

L'avertissement « Undefined step » de l'extension est attendu : le projet décrit le comportement, il n'a pas de code d'exécution (*step definitions*).

### Validation sémantique (« test de la grand-mère »)

- [x] Aucun terme technique dans le `.feature` : pas de table, de requête, d'adresse IP, de code HTTP ni d'élément d'interface.
- [x] Lu à voix haute, le fichier se résume ainsi : « on bloque les grosses sommes qui partent vers des pays sous embargo, sauf pour les clients VIP ».
