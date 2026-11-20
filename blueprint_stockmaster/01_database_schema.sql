BEGIN;

DROP VIEW IF EXISTS stock_emplacement;
DROP TABLE IF EXISTS mouvement_stock CASCADE;
DROP TABLE IF EXISTS emplacement CASCADE;
DROP TABLE IF EXISTS produit CASCADE;
DROP FUNCTION IF EXISTS refuser_modification_mouvement();

CREATE TABLE produit (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code_barre VARCHAR(50) NOT NULL UNIQUE,
    designation VARCHAR(100) NOT NULL
);

CREATE TABLE emplacement (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code_emplacement VARCHAR(20) NOT NULL UNIQUE,
    allee VARCHAR(10) NOT NULL,
    rayon VARCHAR(10) NOT NULL,
    id_produit INT NOT NULL,
    UNIQUE (allee, rayon),
    FOREIGN KEY (id_produit) REFERENCES produit(id) ON DELETE RESTRICT
);

CREATE TABLE mouvement_stock (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_emplacement INT NOT NULL,
    type_mouvement VARCHAR(10) NOT NULL CHECK (type_mouvement IN ('ENTREE', 'SORTIE')),
    quantite INT NOT NULL CHECK (quantite > 0),
    date_mouvement TIMESTAMPTZ NOT NULL DEFAULT now(),
    FOREIGN KEY (id_emplacement) REFERENCES emplacement(id) ON DELETE RESTRICT
);

CREATE INDEX idx_mouvement_stock_emplacement ON mouvement_stock(id_emplacement);

-- Un mouvement ne se modifie pas : on le corrige par un mouvement inverse.
CREATE FUNCTION refuser_modification_mouvement() RETURNS trigger AS $$
BEGIN
    RAISE EXCEPTION 'Le mouvement de stock % est immuable : enregistrez un mouvement inverse', OLD.id;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER mouvement_stock_immuable
    BEFORE UPDATE OR DELETE ON mouvement_stock
    FOR EACH ROW EXECUTE FUNCTION refuser_modification_mouvement();

-- Stock actuel = somme des entrées - somme des sorties.
CREATE VIEW stock_emplacement AS
SELECT
    e.id AS id_emplacement,
    e.code_emplacement,
    e.id_produit,
    COALESCE(SUM(
        CASE m.type_mouvement
            WHEN 'ENTREE' THEN m.quantite
            WHEN 'SORTIE' THEN -m.quantite
        END
    ), 0) AS stock_actuel
FROM emplacement e
LEFT JOIN mouvement_stock m ON m.id_emplacement = e.id
GROUP BY e.id, e.code_emplacement, e.id_produit;

COMMIT;
