# UML Avancé, Diagrammes de Comportement & Patterns Architecturaux

Modélisation du module de **paiement asynchrone** de **MegaShop-B2B** avant d'écrire le code. Les appels à la banque peuvent durer jusqu'à 15 secondes : le paiement est traité en arrière-plan pour ne jamais bloquer le client.

## Structure

```
UML_Avance/
├── specs/
│   └── cahier_des_charges_paiement.md   # Règles du flux de paiement
└── architecture/
    ├── 01_class_diagram.md              # Diagramme de classes (pattern Repository)
    ├── 02_sequence_diagram.md           # Diagramme de séquence (flux asynchrone)
    └── 03_state_machine.md              # Machine à états de la commande
```

## Diagrammes

1. **Diagramme de classes** : `OrderService` dépend de l'interface `IOrderRepository`, jamais de `PostgresOrderRepository`. Le domaine métier reste indépendant de la base de données (inversion des dépendances).
2. **Diagramme de séquence** : l'API publie un `ProcessPaymentEvent` dans la file de messages et répond immédiatement `HTTP 202` au client. Le `Worker` appelle ensuite la banque, avec un bloc `alt` pour le succès (`PAID`) et l'échec (`FAILED`).
3. **Machine à états** : seules les transitions légales sont autorisées (`DRAFT` → `PENDING_PAYMENT` → `PAID` → `SHIPPED`, avec un retry `FAILED` → `PENDING_PAYMENT`). Une commande ne peut pas être expédiée sans paiement validé.

Les diagrammes sont écrits en **Mermaid** : ils s'affichent directement sur GitHub.
