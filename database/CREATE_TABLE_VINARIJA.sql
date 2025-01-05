DROP DATABASE IF EXISTS vinarija;
CREATE DATABASE vinarija;
USE vinarija;
---------------------------------------Danijel
CREATE TABLE Kupac (
    id INT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    oib CHAR(11) UNIQUE NOT NULL,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    adresa VARCHAR(100),
    email VARCHAR(100),
    telefon VARCHAR(20)
);

CREATE TABLE Odjel (
    id INT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    broj_zaposlenika INT CHECK (broj_zaposlenika >= 0)
);

CREATE TABLE Zaposlenik (
    id INT PRIMARY KEY,
    id_odjel INT NOT NULL,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    adresa VARCHAR(100),
    email VARCHAR(100),
    telefon VARCHAR(20),
    datum_zaposlenja DATE NOT NULL,
    status_zaposlenika ENUM('aktivan', 'neaktivan') NOT NULL,
    FOREIGN KEY (id_odjel) REFERENCES Odjel(id)
----------------------------------------------------- VID
CREATE TABLE skladiste_proizvod (
    id INT PRIMARY KEY,
    id_proizvod INT,
    datum DATETIME,
    tip_transakcije ENUM('ulaz', 'izlaz') NOT NULL,
    kolicina INT NOT NULL,
    lokacija VARCHAR(50),
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id)
);

CREATE TABLE Zahtjev_za_nabavu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_Repromaterijal INT NOT NULL,
    kolicina INT NOT NULL,
    datum_zahtjeva DATETIME NOT NULL,
    status ENUM('u obradi', 'odobreno', 'odbijeno') NOT NULL,
    id_zaposlenik INT NOT NULL,
    FOREIGN KEY (id_Repromaterijal) REFERENCES Repromaterijal(id),
    FOREIGN KEY (id_zaposlenik) REFERENCES Zaposlenik(id)
);


CREATE TABLE dobavljac (
    id INT PRIMARY KEY,
    naziv VARCHAR(50),
    adresa VARCHAR(50),
    email VARCHAR(50),
    telefon VARCHAR(20),
    oib CHAR(11) UNIQUE
);


----------------------------------------------- LAURA
CREATE TABLE repromaterijal_proizvod (
    id INTEGER PRIMARY KEY,
    id_proizvod INTEGER NOT NULL,
    id_repromaterijal INTEGER NOT NULL,
    CONSTRAINT repromaterijal_proizvod__proizvod_fk FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    CONSTRAINT repromaterijal_proizvod__repromaterijal_fk FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id),
    CONSTRAINT repromaterijal_proizvod_uk UNIQUE (id_proizvod, id_repromaterijal)
);


CREATE TABLE zahtjev_za_narudzbu (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_kupac INTEGER NOT NULL,
    id_zaposlenik INTEGER NOT NULL,
    datum_zahtjeva DATETIME NOT NULL,
    ukupni_iznos DECIMAL(8, 2),
    status_narudzbe ENUM('Primljena', 'U obradi', 'Na čekanju', 'Spremna za isporuku', 'Poslana', 'Završena', 'Otkazana') NOT NULL,
    CONSTRAINT zahtjev_za_narudzbu__kupac_fk FOREIGN KEY (id_kupac) REFERENCES kupac(id),
    CONSTRAINT zahtjev_za_narudzbu__zaposlenik_fk FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);


CREATE TABLE stavka_narudzbe (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_zahtjev_za_narudzbu INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    iznos_stavke DECIMAL(8, 2),
    CONSTRAINT stavka_narudzbe__zahtjev_za_narudzbu_fk FOREIGN KEY (id_zahtjev_za_narudzbu) REFERENCES zahtjev_za_narudzbu(id),
    CONSTRAINT stavka_narudzbe__proizvod_fk FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    CONSTRAINT stavka_narudzbe_uk UNIQUE (id_zahtjev_za_narudzbu, id_proizvod),
    CONSTRAINT stavka_narudzbe_kolicina_ck CHECK (kolicina > 0)
);

----------------------------------------------- MARTA
CREATE TABLE prijevoznik (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	naziv VARCHAR(50),
	adresa VARCHAR(50),
	email VARCHAR(50),
	telefon VARCHAR(50),
	oib CHAR(11) UNIQUE
);

CREATE TABLE transport (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	registracija VARCHAR(50) NOT NULL,
	ime_vozaca VARCHAR(50) NOT NULL,
	datum_polaska DATETIME NOT NULL,
	datum_dolaska DATETIME NOT NULL,
	kolicina CHAR(11) UNIQUE,
	status_transporta ENUM('Obavljen', 'Otkazan') NOT NULL
	FOREIGN KEY (id_prijevoznik) REFERENCES prijevoznik(id)
);

CREATE TABLE racun (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
	datum_racuna DATETIME NOT NULL,
	FOREIGN KEY (id_kupac) REFERENCES kupac(id),
	FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
	FOREIGN KEY (id_zahtjev_za_narudzbu) REFERENCES zahtjev_za_narudzbu(id),
	FOREIGN KEY (id_transport) REFERENCES transport(id)
);


-- trigger za izracun iznos_stavke u stavke_narudzbe
DELIMITER //
CREATE TRIGGER bi_stavka_narudzbe
	BEFORE INSERT ON stavka_narudzbe
    FOR EACH ROW
BEGIN
	DECLARE cijena_proizvoda DECIMAL(8,2);
    
    SELECT cijena INTO cijena_proizvoda
		FROM proizvod
        WHERE id = new.id_proizvod;
        
	SET new.iznos_stavke = new.kolicina * cijena_proizvoda;
END //
DELIMITER ; 


-- trigger za izracun ukupni_iznos u zahtjev_za_narudzbu
DELIMITER //
CREATE TRIGGER ai_stavka_narudzbe
	AFTER INSERT ON stavka_narudzbe
	FOR EACH ROW
BEGIN
	UPDATE zahtjev_za_narudzbu
		SET ukupni_iznos = (
			SELECT SUM(iznos_stavke)
				FROM stavka_narudzbe
                WHERE id_zahtjev_za_narudzbu = new.id_zahtjev_za_narudzbu
		)
		WHERE id = new.id_zahtjev_za_narudzbu;
END //
DELIMITER ;
