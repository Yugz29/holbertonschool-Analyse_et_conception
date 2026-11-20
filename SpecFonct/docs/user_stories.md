# User Stories : Système Anti-Fraude

Réécriture du [brief client](./brief_metier_gouvernance.md) sous forme de User Stories INVEST. Toute mention technique (SQL, adresse IP, code HTTP, popup) sont retirées.

## 1. Tri du brief

| Dans le brief | Ce que ça devient |
|---|---|
| « Si le montant du panier dépasse 10 000 euros » | Règle métier : **seuil de contrôle** de 10 000 € (strictement supérieur) |
| « Si le pays est sur la liste noire (Syldavie, Bordurie) » | Règle métier : le **pays de livraison** est évalué selon le **registre des embargos** |
| « On valide toujours » un client VIP | Règle métier : **passe-droit VIP** |
| « Transaction bloquée pour suspicion de fraude » | Règle métier : le paiement est **refusé** et le client est **notifié du refus** |
| `SELECT * FROM blacklist_pays` | Supprimé : c'est un choix de stockage |
| Adresse IP du client | Supprimé : c'est un moyen technique de déterminer un pays |
| Erreur 403 renvoyée par l'API | Supprimé : c'est un protocole de transport |
| Popup rouge `div class="alert-danger"` | Supprimé : c'est un choix d'interface |
| « Merci de coder ça vite » | Supprimé : c'est une contrainte de planning, pas une exigence |

## 2. Langage omniprésent

| Terme | Définition |
|---|---|
| **Paiement** | Règlement d'un panier par un client au moment de la commande. |
| **Montant du panier** | Total à payer, en euros. |
| **Seuil de contrôle** | 10 000 €. Seul un montant **strictement supérieur** déclenche l'évaluation du risque. |
| **Pays de livraison** | Pays vers lequel la commande sera expédiée. |
| **Registre des embargos** | Liste des pays avec lesquels l'entreprise refuse de commercer au-delà du seuil de contrôle (ex. : Syldavie, Bordurie). |
| **Client VIP** | Statut commercial accordé à un client, qui le dispense de l'évaluation du risque. |
| **Refus de transaction** | Le paiement n'est pas encaissé et la commande n'est pas validée. |

## 3. User Stories

### US-01 : Blocage des paiements à risque

> **En tant que** Responsable de la Gouvernance Financière,
> **je veux** que tout paiement dont le montant dépasse le seuil de contrôle soit refusé lorsque le pays de livraison figure au registre des embargos,
> **afin de** protéger l'entreprise contre les transactions potentiellement frauduleuses.

**Critères d'acceptation**

1. Quand le montant du panier dépasse 10 000 € et que le pays de livraison figure au registre des embargos, le paiement est refusé et le client est notifié du refus de transaction pour suspicion de fraude.
2. Quand le montant du panier dépasse 10 000 € et que le pays de livraison ne figure pas au registre des embargos, le paiement est accepté.
3. Quand le montant du panier est inférieur ou égal à 10 000 €, le paiement est accepté, quel que soit le pays de livraison.
4. Un montant d'exactement 10 000 € ne dépasse pas le seuil de contrôle : le paiement est accepté.

### US-02 : Passe-droit des clients VIP

> **En tant que** Responsable de la Gouvernance Financière,
> **je veux** que les paiements des clients VIP soient toujours acceptés, sans évaluation du risque,
> **afin de** ne jamais entraver les clients de confiance qui génèrent le plus de chiffre d'affaires.

**Critères d'acceptation**

1. Quand un client VIP paie un montant supérieur à 10 000 € avec un pays de livraison figurant au registre des embargos, le paiement est accepté.
2. Quand un client VIP paie un montant inférieur ou égal à 10 000 €, le paiement est accepté, quel que soit le pays de livraison.
3. Le passe-droit VIP prime sur toutes les règles de l'US-01.

## 4. Vérification INVEST

| Critère | US-01 | US-02 |
|---|---|---|
| **I**ndependent | Livrable seule : le blocage fonctionne sans la notion de VIP. | Ajoute une exception à l'US-01. Elle reste livrable à part, mais elle n'a de valeur qu'une fois l'US-01 en place, donc à planifier après. |
| **N**egotiable | Décrit la règle, pas la solution : le registre peut être une table, un fichier ou un service externe. | Le statut VIP peut venir du CRM ou d'un attribut du compte : rien n'est imposé. |
| **V**aluable | Réduit les pertes liées à la fraude. | Évite de bloquer les meilleurs clients. |
| **E**stimable | Une règle à deux conditions, avec un seuil et une liste connus. | Une condition prioritaire. |
| **S**mall | Tient largement dans un sprint. | Tient largement dans un sprint. |
| **T**estable | Chaque critère donne un résultat attendu : accepté ou refusé. | Idem. |

## 5. Questions ouvertes pour le métier

- Qui tient le registre des embargos à jour, et à quelle fréquence ?
- Le seuil de 10 000 € s'entend-il TTC ou HT ?
- Un paiement refusé doit-il alerter la Gouvernance Financière, en plus du client ?
