Feature: Traçabilité et sécurisation des mouvements d'inventaire
  En tant que directeur d'entrepôt
  Je veux que chaque entrée et chaque sortie de stock soit enregistrée sans jamais dépasser le stock présent
  Afin de connaître à tout moment le stock réel de chaque emplacement

  Background:
    Given l'emplacement "A-02" qui contient le produit "Carton de vis M6"

  @nominal
  Scenario: Une entrée augmente le stock actuel
    Given le stock actuel de l'emplacement "A-02" est de 10 unités
    When le manutentionnaire déclare une entrée de 5 unités sur l'emplacement "A-02"
    Then le mouvement est enregistré
    And le stock actuel de l'emplacement "A-02" est de 15 unités

  @limite
  Scenario Outline: Une sortie ne peut jamais dépasser le stock actuel
    Given le stock actuel de l'emplacement "A-02" est de <stock_initial> unités
    When le manutentionnaire déclare une sortie de <quantite> unités sur l'emplacement "A-02"
    Then le mouvement est <decision>
    And le stock actuel de l'emplacement "A-02" est de <stock_final> unités

    Examples:
      | stock_initial | quantite | decision   | stock_final |
      | 10            | 1        | enregistré | 9           |
      | 10            | 9        | enregistré | 1           |
      | 10            | 10       | enregistré | 0           |
      | 10            | 11       | refusé     | 10          |
      | 0             | 1        | refusé     | 0           |
      | 10            | 0        | refusé     | 10          |

  @erreur
  Scenario: Le manutentionnaire est informé du stock disponible quand sa sortie est refusée
    Given le stock actuel de l'emplacement "A-02" est de 5 unités
    When le manutentionnaire déclare une sortie de 8 unités sur l'emplacement "A-02"
    Then le mouvement est refusé
    And le manutentionnaire est informé que seules 5 unités sont disponibles sur l'emplacement "A-02"
