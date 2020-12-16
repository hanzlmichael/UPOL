CREATE TABLE zakaznik (
  id SERIAL PRIMARY KEY NOT NULL,
  jmeno VARCHAR(50) CHECK (jmeno != '') NOT NULL
);

CREATE TABLE faktura (
  id SERIAL PRIMARY KEY NOT NULL,
  datum_vystaveni TIMESTAMP NOT NULL, 
  zakaznik_id INTEGER REFERENCES zakaznik(id) NOT NULL
);

CREATE TABLE polozka_faktury (
  faktura_id INTEGER REFERENCES faktura(id) NOT NULL,
  zbozi_id INTEGER REFERENCES zbozi(id) NOT NULL,
  mnozstvi INTEGER CHECK (mnozstvi > 0) NOT NULL
);

CREATE TABLE zbozi (
  id SERIAL PRIMARY KEY NOT NULL,
  jmeno VARCHAR(50) NOT NULL,
  cena REAL CHECK (zbozi.cena > 0) NOT NULL,
  mnozstvi_skladem INTEGER DEFAULT 0 CHECK (mnozstvi_skladem >= 0) NOT NULL
);

-- 1
CREATE VIEW nahled_faktury AS
    SELECT 
        faktura.id AS faktura,
        SUM(zbozi.cena * polozka_faktury.mnozstvi) AS celkova_cena
    FROM 
        faktura,
        zbozi,
        polozka_faktury
    WHERE
        faktura.id = polozka_faktury.faktura_id
        AND 
        zbozi.id = polozka_faktury.zbozi_id
    GROUP BY
        faktura
    ORDER BY
        celkova_cena

-- 2
SELECT 
    zakaznik.jmeno,
    MAX(celkova_cena) as celkova_cena
FROM
    zakaznik,
    faktura,
    (SELECT 
        faktura.id AS faktura,
        SUM(zbozi.cena * polozka_faktury.mnozstvi) AS celkova_cena
     FROM 
        faktura,
        zbozi,
        polozka_faktury
     WHERE
        faktura.id = polozka_faktury.faktura_id
        AND 
        zbozi.id = polozka_faktury.zbozi_id
     GROUP BY 
        faktura) as total_faktura
WHERE
    zakaznik.id = faktura.zakaznik_id
    AND
    faktura.id = faktura
GROUP BY
    zakaznik.jmeno
ORDER BY
    celkova_cena 

-- 3
BEGIN;

INSERT INTO faktura (zakaznik_id) VALUES (2);
INSERT INTO polozka_faktury VALUES (4, 3, 1);
INSERT INTO polozka_faktury VALUES (4, 4, 11);

UPDATE zbozi
    SET mnozstvi_skladem = mnozstvi_skladem - 1
    WHERE zbozi.id = 3

UPDATE zbozi
    SET mnozstvi_skladem = mnozstvi_skladem - 11
    WHERE zbozi.id = 4

COMMIT;

-- 4
CREATE TABLE historie_cen (
    id SERIAL PRIMARY KEY NOT NULL,
    zbozi_id INTEGER REFERENCES(zbozi.id) CHECK (zbozi_id > 0) NOT NULL,
    datum_zmeny TIMESTAMP NOT NULL,
    cena REAL CHECK (historie_cen.cena > 0) NOT NULL
)

CREATE OR REPLACE FUNCTION zmena_ceny() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO  historie_cen(zbozi_id, datum_zmeny, cena)
        VALUES (zbozi_id, now(), new.cena)
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

CREATE TRIGGER cena_trigger AFTER UPDATE ON zbozi EXECUTE PROCEDURE zmena_ceny(); 