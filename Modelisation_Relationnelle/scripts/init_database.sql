-- Script d'initialisation de la base MegaShop-B2B
-- Auteur : Yann D.

BEGIN;

DROP TABLE IF EXISTS ligne_commande CASCADE;
DROP TABLE IF EXISTS commande CASCADE;
DROP TABLE IF EXISTS produit CASCADE;
DROP TABLE IF EXISTS client CASCADE;

CREATE TABLE client ( 
    id_client UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    contact VARCHAR(100) NOT NULL UNIQUE,
    adr_livraison VARCHAR(255) NOT NULL
);

CREATE TABLE produit (
    code_prod VARCHAR(20) PRIMARY KEY,
    designation VARCHAR(50) NOT NULL,
    prix_unitaire_ht DECIMAL(10, 2) NOT NULL CHECK (prix_unitaire_ht >= 0)
);

CREATE TABLE commande (
    id_cmd VARCHAR(20) PRIMARY KEY,
    date_achat DATE NOT NULL,
    statut VARCHAR(20) NOT NULL CHECK (statut IN ('EN_COURS', 'EXPEDIEE', 'LIVREE', 'ANNULEE')),
    id_client UUID NOT NULL REFERENCES client(id_client)
);

CREATE TABLE ligne_commande (
    id_cmd VARCHAR(20) NOT NULL,
    code_prod VARCHAR(20) NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),
    PRIMARY KEY (id_cmd, code_prod),
    FOREIGN KEY (id_cmd) REFERENCES commande(id_cmd) ON DELETE CASCADE,
    FOREIGN KEY (code_prod) REFERENCES produit(code_prod)
);

COMMIT;
