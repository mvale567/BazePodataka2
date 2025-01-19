DROP DATABASE IF EXISTS vinarija;
CREATE DATABASE vinarija;
USE vinarija;


----------------------------------------- DANIJEL
CREATE TABLE kupac (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    oib CHAR(11) UNIQUE NOT NULL,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    adresa VARCHAR(100),
    email VARCHAR(100),
    telefon VARCHAR(20)
);

CREATE TABLE odjel (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(100) NOT NULL,
    broj_zaposlenika INT CHECK (broj_zaposlenika >= 0) DEFAULT 0
);

CREATE TABLE zaposlenik (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_odjel INT NOT NULL,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    adresa VARCHAR(100),
    email VARCHAR(100),
    telefon VARCHAR(20),
    datum_zaposlenja DATE NOT NULL,
    status_zaposlenika ENUM('aktivan', 'neaktivan') NOT NULL,
    FOREIGN KEY (id_odjel) REFERENCES Odjel(id)
);



----------------------------------------------- DAVOR
CREATE TABLE vino (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(255) NOT NULL,
    vrsta ENUM('bijelo', 'crno', 'rose', 'pjenušavo') NOT NULL,
    sorta VARCHAR(100) NOT NULL
);


----------------------------------------------- LAURA

CREATE TABLE berba (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_vino INTEGER NOT NULL,
    godina_berbe INTEGER NOT NULL,
    postotak_alkohola DECIMAL(5, 2) NOT NULL,
    FOREIGN KEY (id_vino) REFERENCES vino(id),
    CONSTRAINT berba_postotak_alkohola_ck CHECK (postotak_alkohola BETWEEN 5 AND 25)
);

CREATE INDEX idx_berba_id_vino ON berba(id_vino);


----------------------------------------------- DAVOR

CREATE TABLE proizvod (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_berba INTEGER NOT NULL,
	volumen DECIMAL(4,2) NOT NULL,
    cijena DECIMAL(10, 2) NOT NULL CHECK (cijena > 0),
    CONSTRAINT proizvod__berba_fk FOREIGN KEY (id_berba) REFERENCES berba(id),
    INDEX (id_berba)
);



----------------------------------------------- LAURA
CREATE TABLE punjenje (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_proizvod INTEGER NOT NULL,
    oznaka_serije VARCHAR(20) NOT NULL UNIQUE,
    pocetak_punjenja DATE NOT NULL,
    zavrsetak_punjenja DATE NOT NULL,
    kolicina INTEGER NOT NULL, 
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    CONSTRAINT punjenje_kolicina_ck CHECK (kolicina > 0)
);

CREATE INDEX idx_punjenje_id_proizvod ON punjenje(id_proizvod);



----------------------------------------------------- VID

CREATE TABLE dobavljac (
    id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(50),
    adresa VARCHAR(50),
    email VARCHAR(50),
    telefon VARCHAR(20),
    oib CHAR(11) UNIQUE
);



----------------------------------------------- DAVOR

CREATE TABLE repromaterijal (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_dobavljac INTEGER NOT NULL,
    vrsta VARCHAR(100),
    opis TEXT,
    jedinicna_cijena DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_dobavljac) REFERENCES dobavljac(id),
    CONSTRAINT repromaterijal_cijena_ck CHECK (jedinicna_cijena > 0),
    INDEX (id_dobavljac)
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
    id_prijevoznik INTEGER NOT NULL,
	registracija VARCHAR(50) NOT NULL,
	ime_vozaca VARCHAR(50) NOT NULL,
	datum_polaska DATE NOT NULL,
	datum_dolaska DATE,
	kolicina INTEGER,
	status_transporta ENUM('Obavljen', 'U tijeku', 'Otkazan') NOT NULL,
	FOREIGN KEY (id_prijevoznik) REFERENCES prijevoznik(id)
);



----------------------------------------------- LAURA
CREATE TABLE repromaterijal_proizvod (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_proizvod INTEGER NOT NULL,
    id_repromaterijal INTEGER NOT NULL,
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id),
    CONSTRAINT repromaterijal_proizvod_uk UNIQUE (id_proizvod, id_repromaterijal)
);

CREATE INDEX idx_repromaterijal_proizvod_id_proizvod ON repromaterijal_proizvod(id_proizvod);
CREATE INDEX idx_repromaterijal_proizvod_id_repromaterijal ON repromaterijal_proizvod(id_repromaterijal);


CREATE TABLE zahtjev_za_narudzbu (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_kupac INTEGER NOT NULL,
    id_zaposlenik INTEGER NOT NULL,
	id_transport INTEGER,
    datum_zahtjeva DATE NOT NULL,
    ukupni_iznos DECIMAL(8, 2),
    status_narudzbe ENUM('Primljena', 'U obradi', 'Na čekanju', 'Spremna za isporuku', 'Poslana', 'Završena', 'Otkazana') NOT NULL DEFAULT 'Na čekanju',
    FOREIGN KEY (id_kupac) REFERENCES kupac(id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
    FOREIGN KEY (id_transport) REFERENCES transport(id)
);

CREATE INDEX idx_zahtjev_za_narudzbu_id_kupac ON zahtjev_za_narudzbu(id_kupac);
CREATE INDEX idx_zahtjev_za_narudzbu_id_zaposlenik ON zahtjev_za_narudzbu(id_zaposlenik);
CREATE INDEX idx_zahtjev_za_narudzbu_id_transport ON zahtjev_za_narudzbu(id_transport);
CREATE INDEX idx_zahtjev_za_narudzbu_status_narudzbe ON zahtjev_za_narudzbu(status_narudzbe);
CREATE INDEX idx_zahtjev_za_narudzbu_datum_zahtjeva ON zahtjev_za_narudzbu(datum_zahtjeva);


CREATE TABLE stavka_narudzbe (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_zahtjev_za_narudzbu INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    iznos_stavke DECIMAL(8, 2) NOT NULL,
    FOREIGN KEY (id_zahtjev_za_narudzbu) REFERENCES zahtjev_za_narudzbu(id),
	FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    CONSTRAINT stavka_narudzbe_uk UNIQUE (id_zahtjev_za_narudzbu, id_proizvod),
    CONSTRAINT stavka_narudzbe_kolicina_ck CHECK (kolicina > 0)
);

CREATE INDEX idx_stavka_narudzbe_id_zahtjev_za_narudzbu ON stavka_narudzbe(id_zahtjev_za_narudzbu);
CREATE INDEX idx_stavka_narudzbe_id_proizvod ON stavka_narudzbe(id_proizvod);



----------------------------------------------- MARTA

CREATE TABLE racun (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_zaposlenik INTEGER NOT NULL,
	id_zahtjev_za_narudzbu INTEGER NOT NULL UNIQUE,
	datum_racuna DATE NOT NULL,
	FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
	FOREIGN KEY (id_zahtjev_za_narudzbu) REFERENCES zahtjev_za_narudzbu(id)
);


----------------------------------------------- MARKO

CREATE TABLE plan_proizvodnje (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_proizvod INT NOT NULL,
    datum_pocetka DATE NOT NULL,
    kolicina INT NOT NULL,
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id) 
);

CREATE TABLE skladiste_vino (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_berba INT NOT NULL,
    datum DATE NOT NULL,
    tip_transakcije ENUM('ulaz', 'izlaz') NOT NULL, 
    kolicina INT NOT NULL,
    lokacija VARCHAR(100),
    FOREIGN KEY (id_berba) REFERENCES berba(id)
);

CREATE TABLE skladiste_repromaterijal (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_repromaterijal INT NOT NULL,
    datum DATE NOT NULL,
    tip_transakcije ENUM('ulaz', 'izlaz') NOT NULL,
    kolicina INT NOT NULL,
    lokacija VARCHAR(100),
    FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id) 
);



----------------------------------------------------- VID
CREATE TABLE skladiste_proizvod (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_proizvod INT,
    datum DATE,
    tip_transakcije ENUM('ulaz', 'izlaz') NOT NULL,
    kolicina INT NOT NULL,
    lokacija VARCHAR(50),
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id)
);

CREATE TABLE zahtjev_za_nabavu (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_repromaterijal INT NOT NULL,
    kolicina INT NOT NULL,
    datum_zahtjeva DATE NOT NULL,
    status_nabave ENUM('u obradi', 'odobreno', 'odbijeno', 'dostavljeno') NOT NULL,
    id_zaposlenik INT NOT NULL,
    FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);



----------------------------------------------- DAVOR

-- funkcija koja vraća broj zaposlenika u određenom odjelu

DELIMITER //
CREATE FUNCTION broj_zaposlenika_u_odjelu(p_id_odjel INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj INT;

    SELECT COUNT(*)
    INTO broj
    FROM zaposlenik
    WHERE id_odjel = p_id_odjel AND status_zaposlenika = 'aktivan';

    RETURN broj;
END//
DELIMITER ;

-- SELECT broj_zaposlenika_u_odjelu(2);



----------------------------------------------- LAURA

-- procedura za ažuriranje broja zaposlenika u tablici odjel
DELIMITER //
CREATE PROCEDURE azuriraj_broj_zaposlenika(IN p_id_odjel INTEGER)
BEGIN
	UPDATE odjel
		SET broj_zaposlenika = broj_zaposlenika_u_odjelu(p_id_odjel)
        WHERE id = p_id_odjel;
END //
DELIMITER ;


-- triggeri za insert, update i delete operacije na tablici odjel pozivaju proceduru azuriraj_broj_zaposlenika

DELIMITER //
CREATE TRIGGER ai_zaposlenik
	AFTER INSERT ON zaposlenik
    FOR EACH ROW
BEGIN
	CALL azuriraj_broj_zaposlenika(NEW.id_odjel);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER ad_zaposlenik
	AFTER DELETE ON zaposlenik
    FOR EACH ROW
BEGIN
	CALL azuriraj_broj_zaposlenika(OLD.id_odjel);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER au_zaposlenik
	AFTER UPDATE ON zaposlenik
    FOR EACH ROW
BEGIN
	-- ako je zaposlenik promijenio odjel
	IF NEW.id_odjel != OLD.id_odjel THEN
		CALL azuriraj_broj_zaposlenika(OLD.id_odjel);
		CALL azuriraj_broj_zaposlenika(NEW.id_odjel);
	ELSE  -- ako se promijenio status zaposlenika
		IF NEW.status_zaposlenika != OLD.status_zaposlenika THEN
			CALL azuriraj_broj_zaposlenika(NEW.id_odjel);
		END IF;
    END IF;
END //
DELIMITER ;


-- trigger za izracun iznos_stavke u stavke_narudzbe

DELIMITER //
CREATE TRIGGER bi_stavka_narudzbe
	BEFORE INSERT ON stavka_narudzbe
    FOR EACH ROW
BEGIN
	DECLARE cijena_proizvoda DECIMAL(10,2);
    
    SELECT cijena INTO cijena_proizvoda
		FROM proizvod
        WHERE id = NEW.id_proizvod;
        
	SET NEW.iznos_stavke = NEW.kolicina * cijena_proizvoda;
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
                WHERE id_zahtjev_za_narudzbu = NEW.id_zahtjev_za_narudzbu
		)
		WHERE id = NEW.id_zahtjev_za_narudzbu;
END //
DELIMITER ;


CREATE TABLE stanje_skladista_vina (
	id_berba INTEGER PRIMARY KEY,
    kolicina DECIMAL(8,2) NOT NULL,
    FOREIGN KEY (id_berba) REFERENCES berba(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_kolicinu_vina (IN p_id_berba INTEGER, IN p_tip_transakcije ENUM('ulaz', 'izlaz'), IN p_kolicina DECIMAL(8,2))
BEGIN
    DECLARE nova_kolicina DECIMAL(8,2);
    
    IF NOT EXISTS (SELECT 1 FROM stanje_skladista_vina WHERE id_berba = p_id_berba) THEN
		IF p_tip_transakcije = 'ulaz' THEN
			INSERT INTO stanje_skladista_vina VALUES (p_id_berba, p_kolicina);
        ELSE
			SIGNAL SQLSTATE '45002' SET MESSAGE_TEXT = 'Nije moguće dodati izlaznu transakciju za berbu koja nema ulaznih transakcija!';
        END IF;
	ELSE
		IF p_tip_transakcije = 'ulaz' THEN
			UPDATE stanje_skladista_vina
				SET kolicina = kolicina + p_kolicina
                WHERE id_berba = p_id_berba;
		ELSE 
			UPDATE stanje_skladista_vina
				SET kolicina = kolicina - p_kolicina
                WHERE id_berba = p_id_berba;
		END IF;
    END IF;
    
    SELECT kolicina INTO nova_kolicina
		FROM stanje_skladista_vina
		WHERE id_berba = p_id_berba; 
    
    IF nova_kolicina < 0 THEN
		SIGNAL SQLSTATE '45003' SET MESSAGE_TEXT = 'Količina vina ne može biti negativna!';
	END IF;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ai_skladiste_vino_akv
	AFTER INSERT ON skladiste_vino
	FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_vina(NEW.id_berba, NEW.tip_transakcije, NEW.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ad_skladiste_vino_akv
	AFTER DELETE ON skladiste_vino
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_vina(OLD.id_berba, OLD.tip_transakcije, -OLD.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER au_skladiste_vino_akv
	AFTER UPDATE ON skladiste_vino
    FOR EACH ROW
BEGIN 
	CALL azuriraj_kolicinu_vina(OLD.id_berba, OLD.tip_transakcije, -OLD.kolicina);
    CALL azuriraj_kolicinu_vina(NEW.id_berba, NEW.tip_transakcije, NEW.kolicina);
END //
DELIMITER ;


CREATE TABLE stanje_skladista_proizvoda (
	id_proizvod INTEGER PRIMARY KEY,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_kolicinu_proizvoda (IN p_id_proizvod INTEGER, IN p_tip_transakcije ENUM('ulaz', 'izlaz'), IN p_kolicina INTEGER)
BEGIN
	DECLARE nova_kolicina INTEGER;
    
	IF NOT EXISTS (SELECT 1 FROM stanje_skladista_proizvoda WHERE id_proizvod = p_id_proizvod) THEN
		IF p_tip_transakcije = 'ulaz' THEN
			INSERT INTO stanje_skladista_proizvoda VALUES (p_id_proizvod, p_kolicina);
		ELSE
			SIGNAL SQLSTATE '45004' SET MESSAGE_TEXT = 'Nije moguće dodati izlaznu transakciju za proizvod koji nema ulaznih transakcija!';
		END IF;
	ELSE 
		IF p_tip_transakcije = 'ulaz' THEN
			UPDATE stanje_skladista_proizvoda
				SET kolicina = kolicina + p_kolicina
                WHERE id_proizvod = p_id_proizvod;
        ELSE 
			UPDATE stanje_skladista_proizvoda
				SET kolicina = kolicina - p_kolicina
                WHERE id_proizvod = p_id_proizvod;
		END IF;
    END IF;
    
    SELECT kolicina INTO nova_kolicina
		FROM stanje_skladista_proizvoda
        WHERE id_proizvod = p_id_proizvod;
        
	IF nova_kolicina < 0 THEN
		SIGNAL SQLSTATE '45005' SET MESSAGE_TEXT = 'Količina proizvoda ne može biti negativna!';
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ai_skladiste_proizvod
	AFTER INSERT ON skladiste_proizvod
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_proizvoda(NEW.id_proizvod, NEW.tip_transakcije, NEW.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ad_skladiste_proizvod
	AFTER DELETE ON skladiste_proizvod
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_proizvoda(OLD.id_proizvod, OLD.tip_transakcije, -OLD.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER au_skladiste_proizvod
	AFTER UPDATE ON skladiste_proizvod
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_proizvoda(OLD.id_proizvod, OLD.tip_transakcije, -OLD.kolicina);
    CALL azuriraj_kolicinu_proizvoda(NEW.id_proizvod, NEW.tip_transakcije, NEW.kolicina);
END //
DELIMITER ;


CREATE TABLE stanje_skladista_repromaterijala (
	id_repromaterijal INTEGER PRIMARY KEY,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_kolicinu_repromaterijala (IN p_id_repromaterijal INTEGER, IN p_tip_transakcije ENUM('ulaz', 'izlaz'), p_kolicina INTEGER)
BEGIN
	DECLARE nova_kolicina INTEGER;
    
    IF NOT EXISTS (SELECT 1 FROM stanje_skladista_repromaterijala WHERE id_repromaterijal = p_id_repromaterijal) THEN
		IF p_tip_transakcije = 'ulaz' THEN
			INSERT INTO stanje_skladista_repromaterijala VALUES (p_id_repromaterijal, p_kolicina);
		ELSE
			SIGNAL SQLSTATE '45006' SET MESSAGE_TEXT = 'Nije moguće dodati izlaznu transakciju za repromaterijal koji nema ulaznih transakcija!';
        END IF;
	ELSE
		IF p_tip_transakcije = 'ulaz' THEN
			UPDATE stanje_skladista_repromaterijala
				SET kolicina = kolicina + p_kolicina
                WHERE id_repromaterijal = p_id_repromaterijal;
		ELSE
			UPDATE stanje_skladista_repromaterijala
				SET kolicina = kolicina - p_kolicina
                WHERE id_repromaterijal = p_id_repromaterijal;
        END IF;
    END IF;
    
    SELECT kolicina INTO nova_kolicina
		FROM stanje_skladista_repromaterijala
        WHERE id_repromaterijal = p_id_repromaterijal;
        
	IF nova_kolicina < 0 THEN
		SIGNAL SQLSTATE '45007' SET MESSAGE_TEXT = 'Količina repromaterijala ne može biti negativna!';
    END IF;
    
END //
DELIMITER ;



DELIMITER //
CREATE TRIGGER ai_skladiste_repromaterijal
	AFTER INSERT ON skladiste_repromaterijal
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_repromaterijala(NEW.id_repromaterijal, NEW.tip_transakcije, NEW.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ad_skladiste_repromaterijal
	AFTER DELETE ON skladiste_repromaterijal
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_repromaterijala(OLD.id_repromaterijal, OLD.tip_transakcije, -OLD.kolicina); 
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER au_skladiste_repromaterijal
	AFTER UPDATE ON skladiste_repromaterijal
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_repromaterijala(OLD.id_repromaterijal, OLD.tip_transakcije, -OLD.kolicina); 
    CALL azuriraj_kolicinu_repromaterijala(NEW.id_repromaterijal, NEW.tip_transakcije, NEW.kolicina);
END //
DELIMITER ;


INSERT INTO kupac (naziv, oib, ime, prezime, adresa, email, telefon) 
VALUES 
('Interspar', '12345678901', 'Ivan', 'Horvat', 'Ulica vinograda 10, Zagreb', 'ivan.horvat@email.com', '0912345678'),
('Studenac', '22345678901', 'Ana', 'Jurić', 'Vinogradska 15, Dubrovnik', 'ana.juric@email.com', '0921234567'),
('Vinoteka Matić', '32345678901', 'Petar', 'Matić', 'Berbina 8, Pula', 'petar.matic@email.com', '0987654321'),
('Vinoteka Kovač', '42345678901', 'Marija', 'Kovač', 'Sortna 3, Zadar', 'marija.kovac@email.com', '0918765432'),
('Vinoteka Perić', '52345678901', 'Katarina', 'Perić', 'Trsova 22, Split', 'katarina.peric@email.com', '0911239876'),
('Vina Novak', '62345678901', 'Ivan', 'Novak', 'Grozdova 5, Zagreb', 'ivan.novak@email.com', '0954563212'), 
('Vinski podrum', '72345678901', 'Nina', 'Horvat', 'Vinska 9, Osijek', 'nina.horvat@email.com', '0971237654'),
('Vinski Klub Zagreb', '74639284711', 'Katarina', 'Klubić', 'Klubska 12, Zagreb', 'katarina.klubic@vinskiklub.hr', '+385912347891'), 
('Vina M&G', '38201938401', 'Marta', 'Gorić', 'Mlinska 5, Split', 'marta.goric@vinamg.hr', '+385912317678'), 
('Sommelierov Raj', '93840192837', 'Dino', 'Sommelijerski', 'Sommelijska 20, Rijeka', 'dino.somm@sommelierovraj.hr', '+385919843210'), 
('Vina Exclusive', '63098410293', 'Maja', 'Exclusiva', 'Ekskluzivna 2, Dubrovnik', 'maja.exclusive@vina.hr', '+385915678432'), 
( 'Vinski Izbor', '92018374623', 'Petar', 'Izborić', 'Izborna 15, Osijek', 'petar.izboric@izbor.hr', '+385918673452'), 
('Vinska Enoteka', '83048392010', 'Ivana', 'Enotić', 'Enotečna 45, Split', 'ivana.enotic@enoteka.hr', '+385912345678'), 
('Sommelier Select', '72048392011', 'Marina', 'Selektiva', 'Selektivna 18, Rijeka', 'marina.selektiva@sommelier.hr', '+385913567890'), 
('Vino Grande', '62048392012', 'Tina', 'Velika', 'Velikih 3, Zagreb', 'tina.velika@vinogrande.hr', '+385914567123'), 
('Vinski Kutak', '52048392013', 'Nikola', 'Kutaković', 'Kutni 7, Dubrovnik', 'nikola.kutakovic@kutak.hr', '+385915673412'), 
('Exquisite Wines', '42048392014', 'Ema', 'Ekskluziva', 'Ekskluzivnih 1, Split', 'ema.eksclusive@exquisite.hr', '+385916784321'), 
('Vinoteka Pojatno', '32048392015', 'Luka', 'Pojatnić', 'Pojatna 13, Rijeka', 'luka.pojatnic@vinoteka.hr', '+385917895642'), 
('Vina Istra', '22048392016', 'Dora', 'Istrijanka', 'Istarska 8, Pula', 'dora.istrijanka@istra.hr', '+385918906754'), 
('Sommelier Elite', '12048392017', 'Karlo', 'Elitić', 'Elitna 4, Zagreb', 'karlo.elitic@sommelier.hr', '+385919123476'), 
('Vinski Raj', '93048392018', 'Petra', 'Rajska', 'Rajska 2, Osijek', 'petra.rajska@vinskraj.hr', '+385913456789'), 
('Vina Aromatica', '83048392019', 'Anja', 'Aromatična', 'Aromatična 6, Dubrovnik', 'anja.aromaticka@vina.hr', '+385914321678'), 
('Vina Splendor', '73048392020', 'Filip', 'Splendorić', 'Splendornih 8, Split', 'filip.splendoric@vina.hr', '+385915673421'), 
('Vinoteka Premium', '63048392021', 'Tea', 'Prestižna', 'Prestižnih 5, Zagreb', 'tea.prestizna@vinoteka.hr', '+385916784567'), 
('Vinogradni Raj', '53048392022', 'Ante', 'Vinozović', 'Vinskih 9, Osijek', 'ante.vinozovic@raj.hr', '+385917895673'), 
('Vinska Avantura', '43048392023', 'Lucija', 'Avanturić', 'Avanturistička 7, Rijeka', 'lucija.avanturic@vina.hr', '+385918906732'), 
('VinoArt', '33048392024', 'Andrija', 'Artinić', 'Umjetnička 12, Dubrovnik', 'andrija.artinic@vinoart.hr', '+385919123765'), 
('Exclusive Wines', '23048392025', 'Iva', 'Ekskluzivić', 'Ekskluzivna 1, Split', 'iva.eksclusive@exclusive.hr', '+385913467890'), 
('Vina Premium Select', '13048392026', 'Marin', 'Selekt', 'Selektivna 2, Rijeka', 'marin.selekt@premium.hr', '+385914678123'), 
('VinoVibe', '03048392027', 'Ana', 'Vibetić', 'Vibetna 3, Pula', 'ana.vibetic@vibe.hr', '+385915789654');


INSERT INTO odjel (naziv) 
VALUES 
('Prodaja'),
('Proizvodnja'),
('Marketing'),
('Logistika'),
('Kontrola kvalitete'), 
('IT podrška'), 
('Administracija'), 
('Nabava'), 
('Računovodstvo');


INSERT INTO zaposlenik (id_odjel, ime, prezime, adresa, email, telefon, datum_zaposlenja, status_zaposlenika)
VALUES
(2, 'Marko', 'Kovačić', 'Široka ulica 5, Split', 'marko.kovacic@email.com', '0956781234', '2023-07-30', 'aktivan'),
(4, 'Ivana', 'Marić', 'Trg slobode 10, Rijeka', 'ivana.maric@email.com', '0991234567', '2023-07-28', 'aktivan'),
(2, 'Luka', 'Barišić', 'Zeleno polje 4, Osijek', 'luka.barisic@email.com', '0976543210', '2023-08-01', 'aktivan'),
(8, 'Maja', 'Knežević', 'Maslina 7, Karlovac', 'maja.knezevic@email.com', '0915678901', '2023-07-31', 'aktivan'),
(1, 'Tomislav', 'Kralj', 'Mirna ulica 2, Zagreb', 'tomislav.kralj@email.com', '0981122334', '2024-08-03', 'aktivan'),
(2, 'Hrvoje', 'Pavić', 'Riva 3, Split', 'hrvoje.pavic@email.com', '0915567788', '2023-08-02', 'aktivan'),
(6, 'Lidija', 'Mandić', 'Gajeva 7, Rijeka', 'lidija.mandic@email.com', '0923344556', '2023-08-05', 'neaktivan'),
(2, 'Petar', 'Marković', 'Vlaška 10, Zagreb', 'petar.markovic@firma.hr', '+385915672341', '2023-08-04', 'aktivan'),
(1, 'Ana', 'Novak', 'Perivoj 8, Split', 'ana.novak@firma.hr', '+385914568123', '2024-06-10', 'aktivan'),
(8, 'Luka', 'Vuković', 'Kneza Branimira 5, Rijeka', 'luka.vukovic@firma.hr', '+385913456789', '2023-09-05', 'aktivan'),
(2, 'Katarina', 'Horvat', 'Dubravska 3, Dubrovnik', 'katarina.horvat@firma.hr', '+385912345678', '2023-08-07', 'aktivan'),
(2, 'Dino', 'Petrović', 'Sjenjak 2, Osijek', 'dino.petrovic@firma.hr', '+385918901234', '2023-08-09', 'aktivan'),
(2, 'Ema', 'Jurić', 'Vukovarska 7, Zagreb', 'ema.juric@firma.hr', '+385919876543', '2023-07-29', 'aktivan'),
(8, 'Filip', 'Knežević', 'Palmotićeva 4, Split', 'filip.knezevic@firma.hr', '+385916754321', '2023-08-06', 'aktivan'),
(2, 'Maja', 'Tomić', 'Frankopanska 6, Rijeka', 'maja.tomic@firma.hr', '+385914567890', '2023-10-15', 'aktivan'),
(9, 'Nikola', 'Grgić', 'Put Sv. Roka 9, Dubrovnik', 'nikola.grgic@firma.hr', '+385912346789', '2023-11-03', 'aktivan'),
(1, 'Tina', 'Šarić', 'Trg Ivana Pavla 1, Osijek', 'tina.saric@firma.hr', '+385918234567', '2024-01-05', 'aktivan'),
(2, 'Karlo', 'Lovrić', 'Savska 11, Zagreb', 'karlo.lovric@firma.hr', '+385919123876', '2023-08-04', 'aktivan'),
(6, 'Marin', 'Vidović', 'Šetalište Bačvice 15, Split', 'marin.vidovic@firma.hr', '+385915673219', '2024-04-22', 'aktivan'),
(1, 'Iva', 'Babić', 'Križanićeva 8, Rijeka', 'iva.babic@firma.hr', '+385913421678', '2023-08-12', 'neaktivan'),
(5, 'Lucija', 'Pavlović', 'Pera Čingrije 14, Dubrovnik', 'lucija.pavlovic@firma.hr', '+385912437658', '2023-12-14', 'aktivan'),
(4, 'Petra', 'Matković', 'Rokova 12, Osijek', 'petra.matkovic@firma.hr', '+385918234987', '2023-07-27', 'aktivan'),
(3, 'Ante', 'Božić', 'Jankomir 13, Zagreb', 'ante.bozic@firma.hr', '+385919654123', '2024-11-15', 'aktivan'),
(7, 'Andrija', 'Krpan', 'Istarska 10, Split', 'andrija.krpan@firma.hr', '+385916321789', '2023-08-16', 'aktivan'),
(2, 'Marina', 'Mikulić', 'Adamićeva 17, Rijeka', 'marina.mikulic@firma.hr', '+385914567312', '2023-07-30', 'aktivan'),
(4, 'Filip', 'Blažević', 'Ante Topića 18, Dubrovnik', 'filip.blazevic@firma.hr', '+385912348765', '2023-07-26', 'aktivan'),
(7, 'Katarina', 'Perić', 'Radnička 19, Osijek', 'katarina.peric@firma.hr', '+385918320456', '2023-08-02', 'aktivan'),
(2, 'Marta', 'Klarić', 'Novaka Radonića 20, Zagreb', 'marta.klaric@firma.hr', '+385919123754', '2023-08-08', 'aktivan'),
(2, 'Dora', 'Barbir', 'Kralja Zvonimira 22, Split', 'dora.barbir@firma.hr', '+385915789012', '2023-08-05', 'aktivan'),
(4, 'Tina', 'Jakšić', 'Svačićeva 25, Rijeka', 'tina.jaksic@firma.hr', '+385913476590', '2023-09-18', 'aktivan');


INSERT INTO vino (naziv, vrsta, sorta) VALUES
('Zagorska Graševina', 'bijelo', 'Graševina'),
('Zeleni Breg', 'bijelo', 'Škrlet'),
('Bijela Zvijezda', 'bijelo', 'Chardonnay'),
('Ružičasti Horizont', 'rose', 'Pinot Sivi'),
('Lagana Rosa', 'rose', 'Frankovka'),
('Crni Biser', 'crno', 'Frankovka'),
('Tamni Val', 'crno', 'Pinot Crni');


INSERT INTO berba (id_vino, godina_berbe, postotak_alkohola) VALUES
-- Prva četiri vina proizvode se od 2023.
(1, 2023, 12.5), (1, 2024, 13.0),
(2, 2023, 12.0), (2, 2024, 12.5),
(3, 2023, 13.5), (3, 2024, 14.0),
(4, 2023, 13.0), (4, 2024, 13.5),

-- Zadnja tri vina proizvode se od 2024.
(5, 2024, 12.5),
(6, 2024, 11.5),
(7, 2024, 12.5);


INSERT INTO proizvod (id_berba, volumen, cijena) VALUES
-- Berbe za vino 1 (Zagorska Graševina)
(1, '0.5', 11.00), (1, '0.75', 16.00), (1, '1.00', 21.00),
(2, '0.5', 12.00), (2, '0.75', 17.50), (2, '1.00', 23.00),

-- Berbe za vino 2 (Zeleni Breg)
(3, '0.5', 13.00), (3, '0.75', 19.00), (3, '1.00', 25.00),
(4, '0.5', 14.00), (4, '0.75', 20.50), (4, '1.00', 27.00),

-- Berbe za vino 3 (Bijela Zvijezda)
(5, '0.5', 15.00), (5, '0.75', 22.00), (5, '1.00', 29.00),
(6, '0.5', 16.00), (6, '0.75', 23.50), (6, '1.00', 31.00),

-- Berbe za vino 4 (Ružičasti Horizont)
(7, '0.5', 14.00), (7, '0.75', 20.50), (7, '1.00', 27.00),
(8, '0.5', 15.00), (8, '0.75', 22.00), (8, '1.00', 29.00),

-- Berbe za vino 5 (Lagana Rosa)
(9, '0.5', 12.00), (9, '0.75', 17.00), (9, '1.00', 23.00),

-- Berbe za vino 6 (Crni Biser)
(10, '0.5', 13.00), (10, '0.75', 19.00), (10, '1.00', 25.00),

-- Berbe za vino 7 (Tamni Val)
(11, '0.5', 14.00), (11, '0.75', 20.50), (11, '1.00', 27.00);


INSERT INTO punjenje (id_proizvod, oznaka_serije, pocetak_punjenja, zavrsetak_punjenja, kolicina)
VALUES
-- 2023-09-28
(1, 'A0001', '2023-09-28', '2023-09-30', 500),
(2, 'B0001', '2023-09-28', '2023-09-30', 2100),
(3, 'C0001', '2023-09-28', '2023-09-30', 3000),
(7, 'D0001', '2023-09-28', '2023-09-30', 520),
(8, 'E0001', '2023-09-28', '2023-09-30', 2200),
(9, 'F0001', '2023-09-28', '2023-09-30', 3100),
(13, 'G0001', '2023-09-28', '2023-09-30', 500),
(14, 'H0001', '2023-09-28', '2023-09-30', 2100),
(15, 'I0001', '2023-09-28', '2023-09-30', 3000),
(19, 'J0001', '2023-09-28', '2023-09-30', 510),
(20, 'K0001', '2023-09-28', '2023-09-30', 2100),
(21, 'L0001', '2023-09-28', '2023-09-30', 2950),
-- 2023-10-15
(1, 'A0002', '2023-10-15', '2023-10-17', 520),
(2, 'B0002', '2023-10-15', '2023-10-17', 2200),
(3, 'C0002', '2023-10-15', '2023-10-17', 3100),
(7, 'D0002', '2023-10-15', '2023-10-17', 500),
(8, 'E0002', '2023-10-15', '2023-10-17', 2100),
(9, 'F0002', '2023-10-15', '2023-10-17', 3000),
(13, 'G0002', '2023-10-15', '2023-10-17', 520),
(14, 'H0002', '2023-10-15', '2023-10-17', 2200),
(15, 'I0002', '2023-10-15', '2023-10-17', 3100),
(19, 'J0002', '2023-10-15', '2023-10-17', 490),
(20, 'K0002', '2023-10-15', '2023-10-17', 2000),
(21, 'L0002', '2023-10-15', '2023-10-17', 2900),
-- 2024-01-10
(1, 'A0003', '2024-01-10', '2024-01-11', 250),
(2, 'B0003', '2024-01-10', '2024-01-11', 1300),
(3, 'C0003', '2024-01-10', '2024-01-11', 1500),
(7, 'D0003', '2024-01-10', '2024-01-11', 240),
(8, 'E0003', '2024-01-10', '2024-01-11', 1350),
(9, 'F0003', '2024-01-10', '2024-01-11', 1450),
(13, 'G0003', '2024-01-10', '2024-01-11', 250),
(14, 'H0003', '2024-01-10', '2024-01-11', 1300),
(15, 'I0003', '2024-01-10', '2024-01-11', 1500),
(19, 'J0003', '2024-01-10', '2024-01-11', 240),
(20, 'K0003', '2024-01-10', '2024-01-11', 1250),
(21, 'L0003', '2024-01-10', '2024-01-11', 1400),
-- 2024-09-28
(4, 'AA0001', '2024-09-28', '2024-09-30', 480),
(5, 'AB0001', '2024-09-28', '2024-09-30', 2000),
(6, 'AC0001', '2024-09-28', '2024-09-30', 2900),
(10, 'AD0001', '2024-09-28', '2024-09-30', 490),
(11, 'AE0001', '2024-09-28', '2024-09-30', 2050),
(12, 'AF0001', '2024-09-28', '2024-09-30', 2950),
(16, 'AG0001', '2024-09-28', '2024-09-30', 480),
(17, 'AH0001', '2024-09-28', '2024-09-30', 2000),
(18, 'AI0001', '2024-09-28', '2024-09-30', 2900),
(22, 'AJ0001', '2024-09-28', '2024-09-30', 500),
(23, 'AK0001', '2024-09-28', '2024-09-30', 2000),
(24, 'AL0001', '2024-09-28', '2024-09-30', 2850),
(25, 'AM0001', '2024-09-28', '2024-09-30', 510),
(26, 'AN0001', '2024-09-28', '2024-09-30', 2100),
(27, 'AO0001', '2024-09-28', '2024-09-30', 3000),
(28, 'AP0001', '2024-09-28', '2024-09-30', 500),
(29, 'AQ0001', '2024-09-28', '2024-09-30', 2050),
(30, 'AR0001', '2024-09-28', '2024-09-30', 2950),
(31, 'AS0001', '2024-09-28', '2024-09-30', 490),
(32, 'AT0001', '2024-09-28', '2024-09-30', 2000),
(33, 'AU0001', '2024-09-28', '2024-09-30', 2850),
-- 2024-10-15
(4, 'AA0002', '2024-10-15', '2024-10-17', 510),
(5, 'AB0002', '2024-10-15', '2024-10-17', 2150),
(6, 'AC0002', '2024-10-15', '2024-10-17', 3000),
(10, 'AD0002', '2024-10-15', '2024-10-17', 530),
(11, 'AE0002', '2024-10-15', '2024-10-17', 2100),
(12, 'AF0002', '2024-10-15', '2024-10-17', 3000),
(16, 'AG0002', '2024-10-15', '2024-10-17', 510),
(17, 'AH0002', '2024-10-15', '2024-10-17', 2150),
(18, 'AI0002', '2024-10-15', '2024-10-17', 3000),
(22, 'AJ0002', '2024-10-15', '2024-10-17', 520),
(23, 'AK0002', '2024-10-15', '2024-10-17', 2150),
(24, 'AL0002', '2024-10-15', '2024-10-17', 2950),
(25, 'AM0002', '2024-10-15', '2024-10-17', 520),
(26, 'AN0002', '2024-10-15', '2024-10-17', 2200),
(27, 'AO0002', '2024-10-15', '2024-10-17', 3100),
(28, 'AP0002', '2024-10-15', '2024-10-17', 510),
(29, 'AQ0002', '2024-10-15', '2024-10-17', 2150),
(30, 'AR0002', '2024-10-15', '2024-10-17', 3000),
(31, 'AS0002', '2024-10-15', '2024-10-17', 500),
(32, 'AT0002', '2024-10-15', '2024-10-17', 2100),
(33, 'AU0002', '2024-10-15', '2024-10-17', 2950),
-- 2024-10-30
(4, 'AA0003', '2024-10-30', '2024-10-31', 230),
(5, 'AB0003', '2024-10-30', '2024-10-31', 1200),
(6, 'AC0003', '2024-10-30', '2024-10-31', 1400),
(10, 'AD0003', '2024-10-30', '2024-10-31', 220),
(11, 'AE0003', '2024-10-30', '2024-10-31', 1300),
(12, 'AF0003', '2024-10-30', '2024-10-31', 1450),
(16, 'AG0003', '2024-10-30', '2024-10-31', 230),
(17, 'AH0003', '2024-10-30', '2024-10-31', 1200),
(18, 'AI0003', '2024-10-30', '2024-10-31', 1400),
(22, 'AJ0003', '2024-10-30', '2024-10-31', 220),
(23, 'AK0003', '2024-10-30', '2024-10-31', 1200),
(24, 'AL0003', '2024-10-30', '2024-10-31', 1400),
(25, 'AM0003', '2024-10-30', '2024-10-31', 230),
(26, 'AN0003', '2024-10-30', '2024-10-31', 1300),
(27, 'AO0003', '2024-10-30', '2024-10-31', 1500),
(28, 'AP0003', '2024-10-30', '2024-10-31', 220),
(29, 'AQ0003', '2024-10-30', '2024-10-31', 1250),
(30, 'AR0003', '2024-10-30', '2024-10-31', 1400),
(31, 'AS0003', '2024-10-30', '2024-10-31', 240),
(32, 'AT0003', '2024-10-30', '2024-10-31', 1200),
(33, 'AU0003', '2024-10-30', '2024-10-31', 1400);


INSERT INTO dobavljac (naziv, adresa, email, telefon, oib) 
VALUES 
('Vinski Repromaterijal d.o.o.', 'Adresa 2, Rijeka', 'vinski.repromaterijal@email.com', '051234567', '98765432112'),
('Cork & Cap d.o.o.', 'Adresa 3, Split', 'corkcap@email.com', '021876543', '98765432113'), 
('WinePro Supplies', 'Adresa 4, Zagreb', 'winepro@email.com', '013123456', '98765432114'),
('Etikete d.o.o.', 'Adresa 7, Karlovac', 'etikete@email.com', '047123987', '98765432117');


INSERT INTO repromaterijal (id_dobavljac, vrsta, opis, jedinicna_cijena) VALUES
(1, 'Kutija', 'Kartonska kutija, za 6 boca volumena 0.5 L', 0.50),
(1, 'Kutija', 'Kartonska kutija, za 6 boca volumena 0.75 L', 0.60),
(1, 'Kutija', 'Kartonska kutija, za 6 boca volumena 1.00 L', 0.70),

(2, 'Čep', 'Pluteni čep za vina', 0.35),
(2, 'Čep', 'Sintetički čep za vina', 0.22),

-- Boce za bijelo vino (različiti volumeni)
(3, 'Staklena boca', 'Boca od 0.5 L za bijelo vino', 1.20),
(3, 'Staklena boca', 'Boca od 0.75 L za bijelo vino', 1.50),
(3, 'Staklena boca', 'Boca od 1.00 L za bijelo vino', 1.80),

-- Boce za crno vino (različiti volumeni)
(3, 'Staklena boca', 'Boca od 0.5 L za crno vino', 1.60),
(3, 'Staklena boca', 'Boca od 0.75 L za crno vino', 1.90),
(3, 'Staklena boca', 'Boca od 1.00 L za crno vino', 2.20),

-- Boce za rose vino (različiti volumeni)
(3, 'Staklena boca', 'Boca od 0.5 L za rose vino', 1.40),
(3, 'Staklena boca', 'Boca od 0.75 L za rose vino', 1.70),
(3, 'Staklena boca', 'Boca od 1.00 L za rose vino', 2.00),

-- Naljepnice za svaki tip vina i volumen
(4, 'Naljepnica', 'Naljepnica za Zagorsku Graševinu 0.5 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Zagorsku Graševinu 0.75 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Zagorsku Graševinu 1.00 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Zeleni Breg 0.5 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Zeleni Breg 0.75 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Zeleni Breg 1.00 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Bijelu Zvijezdu 0.5 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Bijelu Zvijezdu 0.75 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Bijelu Zvijezdu 1.00 L, mat finiš', 0.12),
(4, 'Naljepnica', 'Naljepnica za Ružičasti Horizont 0.5 L, pastelne boje', 0.18),
(4, 'Naljepnica', 'Naljepnica za Ružičasti Horizont 0.75 L, pastelne boje', 0.18),
(4, 'Naljepnica', 'Naljepnica za Ružičasti Horizont 1.00 L, pastelne boje', 0.18),
(4, 'Naljepnica', 'Naljepnica za Laganu Rosu 0.5 L, pastelne boje', 0.18),
(4, 'Naljepnica', 'Naljepnica za Laganu Rosu 0.75 L, pastelne boje', 0.18),
(4, 'Naljepnica', 'Naljepnica za Laganu Rosu 1.00 L, pastelne boje', 0.18),
(4, 'Naljepnica', 'Naljepnica za Crni Biser 0.5 L, sjajni finiš', 0.15),
(4, 'Naljepnica', 'Naljepnica za Crni Biser 0.75 L, sjajni finiš', 0.15),
(4, 'Naljepnica', 'Naljepnica za Crni Biser 1.00 L, sjajni finiš', 0.15),
(4, 'Naljepnica', 'Naljepnica za Tamni Val 0.5 L, sjajni finiš', 0.15),
(4, 'Naljepnica', 'Naljepnica za Tamni Val 0.75 L, sjajni finiš', 0.15),
(4, 'Naljepnica', 'Naljepnica za Tamni Val 1.00 L, sjajni finiš', 0.15);


INSERT INTO prijevoznik (naziv, adresa, email, telefon, oib)
VALUES
('Transport d.o.o.', 'Zagrebačka avenija 7, Zagreb', 'info@transport.hr', '051987654', '11223344556'),
('CargoPlus', 'Savska cesta 5, Zagreb', 'info@cargoplus.hr', '051555555', '11223344577'),
('Brzo & Sigurno', 'Krapinska 10, Zabok', 'info@brzoisigurno.hr', '012345678', '11223344588'),
('Transport Vuković', 'Slavonska avenija 30, Zagreb', 'vukovic@email.com', '021876555', '11223344599'),
('LogistikTransport d.o.o.', 'Zagorska ulica 10, Krapina', 'logistik@email.com', '031456789', '11223344600'),
('Brza Dostava d.o.o.', 'Zagrebačka cesta 8, Sesvete', 'brzi@email.com', '023123456', '11223344611'),
('SafeTrans d.o.o.', 'Varaždinska ulica 12, Donja Stubica', 'safetrans@email.com', '013112233', '11223344622');


INSERT INTO transport (id_prijevoznik, registracija, ime_vozaca, datum_polaska, datum_dolaska, kolicina, status_transporta)
VALUES
(6, 'ZG1234AA', 'Ivan Horvat', '2024-11-09', '2024-11-09', 1860, 'Obavljen'),
(4, 'ZG5678BB', 'Marko Marić', '2024-11-12', '2024-11-12', 1070, 'Obavljen'),
(1, 'KA9012CC', 'Stjepan Kovaček', '2024-11-15', '2024-11-15', 4610, 'Obavljen'),
(3, 'KA7890EE', 'Ante Vuk', '2024-11-22', '2024-11-22', 260, 'Obavljen'),
(2, 'ZG1122FF', 'Krešimir Lončar', '2024-11-25', '2024-11-25', 1700, 'Obavljen'),
(1, 'KA9999HH', 'Fran Jurić', '2024-12-02', '2024-12-02', 3430, 'Obavljen'),
(5, 'ZG3333II', 'Filip Zadro', '2024-12-05', '2024-12-05', 2690, 'Obavljen'),
(2, 'ZG4444JJ', 'Hrvoje Bašić', '2024-12-08', '2024-12-08', 1030, 'Obavljen'),
(4, 'KA5555KK', 'Zoran Božić', '2024-12-11', '2024-12-11', 2640, 'Obavljen'),
(3, 'ZG6666LL', 'Tihomir Pavlović', '2024-12-14', '2024-12-14', 1460, 'Obavljen'),
(6, 'KA7777MM', 'Petar Krpan', '2024-12-17', '2024-12-17', 720, 'Obavljen'),
(4, 'ZG8888NN', 'Damir Vlašić', '2024-12-20', '2024-12-20', 1520, 'Obavljen'),
(5, 'ZG9999OO', 'Zvonimir Kovačić', '2024-12-23', '2024-12-23', 2450, 'Obavljen'),
(1, 'ZG1111PP', 'Ivica Barić', '2024-12-26', '2024-12-26', 930, 'Obavljen'),
(2, 'KA2222QQ', 'Viktor Grgić', '2024-12-29', '2024-12-29', 3940, 'Obavljen'),
(5, 'ZG6666UU', 'Franjo Jurić', '2025-01-12', '2025-01-12', 330, 'Obavljen'),
(3, 'KA7777VV', 'Ante Vuk', '2025-01-13', NULL, 2260, 'U tijeku'),
(1, 'ZG8888WW', 'Zvonimir Kovačić', '2025-01-18', NULL, 1710, 'U tijeku'),
(2, 'ZG9999XX', 'Filip Marković', '2025-01-22', NULL, 2240, 'U tijeku');


INSERT INTO repromaterijal_proizvod (id_proizvod, id_repromaterijal)
VALUES
-- Zagorska Graševina (Berbe 1 i 2)
(1, 6), -- Boca 0.5 L za bijelo vino
(1, 4), -- Pluteni čep
(1, 15), -- Naljepnica za Zagorsku Graševinu 0.5 L
(1, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(2, 7), -- Boca 0.75 L za bijelo vino
(2, 4), -- Pluteni čep
(2, 16), -- Naljepnica za Zagorsku Graševinu 0.75 L
(2, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(3, 8), -- Boca 1.00 L za bijelo vino
(3, 4), -- Pluteni čep
(3, 17), -- Naljepnica za Zagorsku Graševinu 1.00 L
(3, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L
(4, 6), -- Boca 0.5 L za bijelo vino
(4, 4), -- Pluteni čep
(4, 15), -- Naljepnica za Zagorsku Graševinu 0.5 L
(4, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(5, 7), -- Boca 0.75 L za bijelo vino
(5, 4), -- Pluteni čep
(5, 16), -- Naljepnica za Zagorsku Graševinu 0.75 L
(5, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(6, 8), -- Boca 1.00 L za bijelo vino
(6, 4), -- Pluteni čep
(6, 17), -- Naljepnica za Zagorsku Graševinu 1.00 L
(6, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L

-- Zeleni Breg (Berbe 3 i 4)
(7, 6), -- Boca 0.5 L za bijelo vino
(7, 4), -- Pluteni čep
(7, 18), -- Naljepnica za Zeleni Breg 0.5 L
(7, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(8, 7), -- Boca 0.75 L za bijelo vino
(8, 4), -- Pluteni čep
(8, 19), -- Naljepnica za Zeleni Breg 0.75 L
(8, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(9, 8), -- Boca 1.00 L za bijelo vino
(9, 4), -- Pluteni čep
(9, 20), -- Naljepnica za Zeleni Breg 1.00 L
(9, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L
(10, 6), -- Boca 0.5 L za bijelo vino
(10, 4), -- Pluteni čep
(10, 18), -- Naljepnica za Zeleni Breg 0.5 L
(10, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(11, 7), -- Boca 0.75 L za bijelo vino
(11, 4), -- Pluteni čep
(11, 19), -- Naljepnica za Zeleni Breg 0.75 L
(11, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(12, 8), -- Boca 1.00 L za bijelo vino
(12, 4), -- Pluteni čep
(12, 20), -- Naljepnica za Zeleni Breg 1.00 L
(12, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L

-- Bijela Zvijezda (Berbe 5 i 6)
(13, 6), -- Boca 0.5 L za bijelo vino
(13, 4), -- Pluteni čep
(13, 21), -- Naljepnica za Bijelu Zvijezdu 0.5 L
(13, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(14, 7), -- Boca 0.75 L za bijelo vino
(14, 4), -- Pluteni čep
(14, 22), -- Naljepnica za Bijelu Zvijezdu 0.75 L
(14, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(15, 8), -- Boca 1.00 L za bijelo vino
(15, 4), -- Pluteni čep
(15, 23), -- Naljepnica za Bijelu Zvijezdu 1.00 L
(15, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L
(16, 6), -- Boca 0.5 L za bijelo vino
(16, 4), -- Pluteni čep
(16, 21), -- Naljepnica za Bijelu Zvijezdu 0.5 L
(16, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(17, 7), -- Boca 0.75 L za bijelo vino
(17, 4), -- Pluteni čep
(17, 22), -- Naljepnica za Bijelu Zvijezdu 0.75 L
(17, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(18, 8), -- Boca 1.00 L za bijelo vino
(18, 4), -- Pluteni čep
(18, 23), -- Naljepnica za Bijelu Zvijezdu 1.00 L
(18, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L

-- Ružičasti Horizont (Berbe 7 i 8)
(19, 12), -- Boca 0.5 L za rose vino
(19, 5), -- Sintetički čep
(19, 24), -- Naljepnica za Ružičasti Horizont 0.5 L
(19, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(20, 13), -- Boca 0.75 L za rose vino
(20, 5), -- Sintetički čep
(20, 25), -- Naljepnica za Ružičasti Horizont 0.75 L
(20, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(21, 14), -- Boca 1.00 L za rose vino
(21, 5), -- Sintetički čep
(21, 26), -- Naljepnica za Ružičasti Horizont 1.00 L
(21, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L
(22, 12), -- Boca 0.5 L za rose vino
(22, 5), -- Sintetički čep
(22, 24), -- Naljepnica za Ružičasti Horizont 0.5 L
(22, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(23, 13), -- Boca 0.75 L za rose vino
(23, 5), -- Sintetički čep
(23, 25), -- Naljepnica za Ružičasti Horizont 0.75 L
(23, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(24, 14), -- Boca 1.00 L za rose vino
(24, 5), -- Sintetički čep
(24, 26), -- Naljepnica za Ružičasti Horizont 1.00 L
(24, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L

-- Lagana Rosa (Berba 9)
(25, 12), -- Boca 0.5 L za rose vino
(25, 5), -- Sintetički čep
(25, 27), -- Naljepnica za Laganu Rosu 0.5 L
(25, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(26, 13), -- Boca 0.75 L za rose vino
(26, 5), -- Sintetički čep
(26, 28), -- Naljepnica za Laganu Rosu 0.75 L
(26, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(27, 14), -- Boca 1.00 L za rose vino
(27, 5), -- Sintetički čep
(27, 29), -- Naljepnica za Laganu Rosu 1.00 L
(27, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L

-- Crni Biser (Berba 10)
(28, 9), -- Boca 0.5 L za crno vino
(28, 4), -- Pluteni čep
(28, 30), -- Naljepnica za Crni Biser 0.5 L
(28, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(29, 10), -- Boca 0.75 L za crno vino
(29, 4), -- Pluteni čep
(29, 31), -- Naljepnica za Crni Biser 0.75 L
(29, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(30, 11), -- Boca 1.00 L za crno vino
(30, 4), -- Pluteni čep
(30, 32), -- Naljepnica za Crni Biser 1.00 L
(30, 3), -- Kartonska kutija, za 6 boca volumena 1.00 L

-- Tamni Val (Berba 11)
(31, 9), -- Boca 0.5 L za crno vino
(31, 4), -- Pluteni čep
(31, 33), -- Naljepnica za Tamni Val 0.5 L
(31, 1), -- Kartonska kutija, za 6 boca volumena 0.5 L
(32, 10), -- Boca 0.75 L za crno vino
(32, 4), -- Pluteni čep
(32, 34), -- Naljepnica za Tamni Val 0.75 L
(32, 2), -- Kartonska kutija, za 6 boca volumena 0.75 L
(33, 11), -- Boca 1.00 L za crno vino
(33, 4), -- Pluteni čep
(33, 35), -- Naljepnica za Tamni Val 1.00 L
(33, 3); -- Kartonska kutija, za 6 boca volumena 1.00 L


INSERT INTO zahtjev_za_narudzbu (id_kupac, id_zaposlenik, id_transport, datum_zahtjeva, status_narudzbe)
VALUES
(15, 5, 1, '2024-11-02', 'Završena'),
(7, 20, 2, '2024-11-05', 'Završena'),
(19, 9, 3, '2024-11-08', 'Završena'),
(2, 17, 3, '2024-11-08', 'Završena'),
(25, 20, 4, '2024-11-15', 'Završena'),
(12, 5, 5, '2024-11-18', 'Završena'),
(6, 9, 6, '2024-11-25', 'Završena'),
(30, 17, 6, '2024-11-25', 'Završena'),
(3, 5, 7, '2024-11-28', 'Završena'),
(9, 20, 8, '2024-12-01', 'Završena'),
(22, 9, 9, '2024-12-04', 'Završena'),
(10, 17, 10, '2024-12-07', 'Završena'),
(5, 20, 11, '2024-12-10', 'Završena'),
(27, 5, 12, '2024-12-13', 'Završena'),
(1, 9, 13, '2024-12-16', 'Završena'),
(28, 17, 14, '2024-12-19', 'Završena'),
(16, 20, 15, '2024-12-22', 'Završena'),
(4, 9, 15, '2024-12-22', 'Završena'),
(21, 5, 15, '2024-12-22', 'Završena'),
(18, 17, NULL, '2025-01-02', 'Primljena'),
(8, 9, NULL, '2025-01-03', 'Otkazana'),
(14, 5, NULL, '2025-01-04', 'Na čekanju'),
(26, 20, 16, '2025-01-05', 'Završena'),
(29, 17, 17, '2025-01-06', 'Poslana'),
(11, 9, NULL, '2025-01-07', 'Primljena'),
(13, 5, NULL, '2025-01-08', 'U obradi'),
(17, 20, NULL, '2025-01-09', 'Na čekanju'),
(24, 17, NULL, '2025-01-10', 'Spremna za isporuku'),
(20, 9, 18, '2025-01-11', 'Poslana'),
(23, 5, NULL, '2025-01-12', 'Primljena'),
(30, 20, NULL, '2025-01-13', 'U obradi'),
(19, 17, NULL, '2025-01-14', 'Na čekanju'),
(6, 9, NULL, '2025-01-14', 'Spremna za isporuku'),
(15, 5, 19, '2025-01-15', 'Poslana'),
(7, 20, NULL, '2025-01-15', 'Primljena');


INSERT INTO stavka_narudzbe (id_zahtjev_za_narudzbu, id_proizvod, kolicina)
VALUES
-- Narudžba 1
(1, 5, 720), (1, 10, 340), (1, 15, 800),

-- Narudžba 2
(2, 8, 290), (2, 3, 780),

-- Narudžba 3
(3, 20, 620), (3, 1, 320), (3, 12, 740), (3, 6, 370),

-- Narudžba 4
(4, 11, 680), (4, 25, 340), (4, 18, 810), (4, 2, 730),

-- Narudžba 5
(5, 19, 260),

-- Narudžba 6
(6, 14, 390), (6, 7, 500), (6, 23, 810),

-- Narudžba 7
(7, 4, 150), (7, 9, 770), (7, 13, 820), (7, 22, 650),

-- Narudžba 8
(8, 26, 730), (8, 5, 310),

-- Narudžba 9
(9, 15, 290), (9, 30, 620), (9, 21, 700), (9, 17, 330), (9, 11, 750),

-- Narudžba 10
(10, 2, 350), (10, 19, 680),

-- Narudžba 11
(11, 28, 730), (11, 6, 370), (11, 24, 800), (11, 12, 740),

-- Narudžba 12
(12, 3, 310), (12, 20, 360), (12, 14, 790),

-- Narudžba 13
(13, 18, 720),

-- Narudžba 14
(14, 31, 690), (14, 22, 450), (14, 1, 380),

-- Narudžba 15
(15, 16, 300), (15, 27, 810), (15, 13, 320), (15, 4, 240), (15, 8, 780),

-- Narudžba 16
(16, 29, 710), (16, 7, 220),

-- Narudžba 17
(17, 5, 380), (17, 25, 780), (17, 10, 800),

-- Narudžba 18
(18, 2, 280),

-- Narudžba 19
(19, 19, 270), (19, 24, 700), (19, 9, 730),

-- Narudžba 20
(20, 17, 640), (20, 12, 750), (20, 15, 300), (20, 6, 690),

-- Narudžba 21
(21, 21, 340), (21, 26, 720), (21, 30, 810),

-- Narudžba 22
(22, 11, 740), (22, 28, 750), (22, 13, 700), (22, 1, 360),

-- Narudžba 23
(23, 3, 330),

-- Narudžba 24
(24, 16, 320), (24, 18, 740), (24, 7, 420), (24, 4, 780),

-- Narudžba 25
(25, 14, 380), (25, 8, 760),

-- Narudžba 26
(26, 27, 340), (26, 20, 790), (26, 5, 750),

-- Narudžba 27
(27, 31, 310), (27, 2, 380), (27, 9, 730), (27, 19, 600),

-- Narudžba 28
(28, 32, 710), (28, 6, 320), (28, 12, 290),

-- Narudžba 29
(29, 15, 280), (29, 26, 690), (29, 30, 740),

-- Narudžba 30
(30, 17, 670), (30, 25, 820), (30, 10, 310),

-- Narudžba 31
(31, 23, 290), (31, 13, 370), (31, 20, 720),

-- Narudžba 32
(32, 29, 730), (32, 16, 320), (32, 28, 780),

-- Narudžba 33
(33, 1, 310), (33, 33, 710),

-- Narudžba 34
(34, 8, 740), (34, 11, 690), (34, 27, 810),

-- Narudžba 35
(35, 7, 350), (35, 18, 730), (35, 14, 380), (35, 3, 360);


INSERT INTO plan_proizvodnje (id_proizvod, datum_pocetka, kolicina)
VALUES
-- Zagorska Graševina (berba 2024)
(4, '2025-02-01', 100), -- 0.5L
(5, '2025-02-01', 200), -- 0.75L
(6, '2025-02-01', 200), -- 1.00L

-- Zeleni Breg (berba 2024)
(10, '2025-02-01', 100), -- 0.5L
(11, '2025-02-01', 200), -- 0.75L
(12, '2025-02-01', 200), -- 1.00L

-- Bijela Zvijezda (berba 2024)
(16, '2025-02-01', 100), -- 0.5L
(17, '2025-02-01', 200), -- 0.75L
(18, '2025-02-01', 200), -- 1.00L

-- Ružičasti Horizont (berba 2024)
(22, '2025-02-01', 100), -- 0.5L
(23, '2025-02-01', 200), -- 0.75L
(24, '2025-02-01', 200), -- 1.00L

-- Lagana Rosa (berba 2024)
(25, '2025-02-01', 100), -- 0.5L
(26, '2025-02-01', 200), -- 0.75L
(27, '2025-02-01', 200), -- 1.00L

-- Crni Biser (berba 2024)
(28, '2025-02-01', 100), -- 0.5L
(29, '2025-02-01', 200), -- 0.75L
(30, '2025-02-01', 200), -- 1.00L

-- Tamni Val (berba 2024)
(31, '2025-02-01', 100), -- 0.5L
(32, '2025-02-01', 200), -- 0.75L
(33, '2025-02-01', 200); -- 1.00L


INSERT INTO skladiste_vino (id_berba, datum, tip_transakcije, kolicina, lokacija)
VALUES
-- Ulazne transakcije za berbu 2023
(1, '2023-08-15', 'ulaz', 14500, 'Skladište A'), 
(3, '2023-08-20', 'ulaz', 14700, 'Skladište B'), 
(5, '2023-08-25', 'ulaz', 14900, 'Skladište C'), 
(7, '2023-09-01', 'ulaz', 14350, 'Skladište A'), 


-- Izlazne transakcije za berbu 2023
(1, '2023-09-28', 'izlaz', 4825.0, 'Skladište A'),
(3, '2023-09-28', 'izlaz', 5010.0, 'Skladište B'),
(5, '2023-09-28', 'izlaz', 4825.0, 'Skladište C'),
(7, '2023-09-28', 'izlaz', 4780.0, 'Skladište A'),
(1, '2023-10-15', 'izlaz', 5010.0, 'Skladište A'),
(3, '2023-10-15', 'izlaz', 4825.0, 'Skladište B'),
(5, '2023-10-15', 'izlaz', 5010.0, 'Skladište C'),
(7, '2023-10-15', 'izlaz', 4645.0, 'Skladište A'),
(1, '2024-01-10', 'izlaz', 2600.0, 'Skladište A'),
(3, '2024-01-10', 'izlaz', 2582.5, 'Skladište B'),
(5, '2024-01-10', 'izlaz', 2600.0, 'Skladište C'),
(7, '2024-01-10', 'izlaz', 2457.5, 'Skladište A'),

-- Ulazne transakcije za berbu 2024
(2, '2024-08-15', 'ulaz', 15200, 'Skladište B'), 
(4, '2024-08-25', 'ulaz', 15000, 'Skladište C'), 
(6, '2024-08-30', 'ulaz', 15500, 'Skladište A'), 
(8, '2024-09-01', 'ulaz', 15400, 'Skladište B'), 
(9, '2024-09-05', 'ulaz', 15800, 'Skladište C'),
(10, '2024-09-10', 'ulaz', 15300, 'Skladište A'), 
(11, '2024-09-15', 'ulaz', 15100, 'Skladište B'), 

-- Izlazne transakcije za berbu 2024
(2, '2024-09-28', 'izlaz', 4640.0, 'Skladište B'),
(4, '2024-09-28', 'izlaz', 4732.5, 'Skladište C'),
(6, '2024-09-28', 'izlaz', 4640.0, 'Skladište A'),
(8, '2024-09-28', 'izlaz', 4600.0, 'Skladište B'),
(9, '2024-09-28', 'izlaz', 4830.0, 'Skladište C'),
(10, '2024-09-28', 'izlaz', 4737.5, 'Skladište A'),
(11, '2024-09-28', 'izlaz', 4595.0, 'Skladište B'),
(2, '2024-10-15', 'izlaz', 4867.5, 'Skladište B'),
(4, '2024-10-15', 'izlaz', 4840.0, 'Skladište C'),
(6, '2024-10-15', 'izlaz', 4867.5, 'Skladište A'),
(8, '2024-10-15', 'izlaz', 4822.5, 'Skladište B'),
(9, '2024-10-15', 'izlaz', 5010.0, 'Skladište C'),
(10, '2024-10-15', 'izlaz', 4867.5, 'Skladište A'),
(11, '2024-10-15', 'izlaz', 4775.0, 'Skladište B'),
(2, '2024-10-30', 'izlaz', 2415.0, 'Skladište B'),
(4, '2024-10-30', 'izlaz', 2535.0, 'Skladište C'),
(6, '2024-10-30', 'izlaz', 2415.0, 'Skladište A'),
(8, '2024-10-30', 'izlaz', 2410.0, 'Skladište B'),
(9, '2024-10-30', 'izlaz', 2590.0, 'Skladište C'),
(10, '2024-10-30', 'izlaz', 2447.5, 'Skladište A'),
(11, '2024-10-30', 'izlaz', 2420.0, 'Skladište B');



-------------------------------------------------------- LAURA 


INSERT INTO skladiste_proizvod (id_proizvod, datum, tip_transakcije, kolicina, lokacija)
SELECT id_proizvod, zavrsetak_punjenja AS datum, 'ulaz' AS tip_transakcije, kolicina, 'Skladište E' AS lokacija
	FROM punjenje
UNION ALL
SELECT sn.id_proizvod, DATE_ADD(zzn.datum_zahtjeva, INTERVAL 7 DAY) AS datum, 'izlaz' AS tip_transakcije, sn.kolicina, 'Skladište E' AS lokacija
	FROM stavka_narudzbe sn
	JOIN zahtjev_za_narudzbu zzn ON sn.id_zahtjev_za_narudzbu = zzn.id
	WHERE zzn.status_narudzbe IN ('Spremna za isporuku', 'Poslana', 'Završena')
	ORDER BY datum;

INSERT INTO skladiste_repromaterijal (id_repromaterijal, datum, tip_transakcije, kolicina, lokacija)
SELECT rp.id_repromaterijal, DATE_SUB(p.pocetak_punjenja, INTERVAL 2 WEEK) AS datum, 'ulaz' AS tip_transakcije, SUM(p.kolicina) + ROUND(RAND(123) * 100 + 50) AS kolicina, 'Skladište D' AS lokacija
	FROM punjenje p
	JOIN repromaterijal_proizvod rp ON p.id_proizvod = rp.id_proizvod
    WHERE rp.id_repromaterijal NOT IN (1, 2, 3)
	GROUP BY datum, rp.id_repromaterijal
UNION ALL
	SELECT rp.id_repromaterijal, p.pocetak_punjenja AS datum, 'izlaz' AS tip_transakcije, SUM(p.kolicina) AS kolicina, 'Skladište D' AS lokacija
	FROM punjenje p
	JOIN repromaterijal_proizvod rp ON p.id_proizvod = rp.id_proizvod
    WHERE rp.id_repromaterijal NOT IN (1, 2, 3)
	GROUP BY datum, rp.id_repromaterijal
UNION ALL
SELECT rp.id_repromaterijal, DATE_ADD(p.zavrsetak_punjenja, INTERVAL 10 DAY) AS datum, 'ulaz' AS tip_transakcije, SUM(CEIL(p.kolicina/6)) + ROUND(RAND(100) * 50 + 5) AS kolicina, 'Skladište D' AS lokacija
	FROM punjenje p
	JOIN repromaterijal_proizvod rp ON p.id_proizvod = rp.id_proizvod
    WHERE rp.id_repromaterijal IN (1, 2, 3)
	GROUP BY datum, rp.id_repromaterijal
UNION ALL
	SELECT rp.id_repromaterijal, sp.datum, 'izlaz' AS tip_transakcije, SUM(CEIL(sp.kolicina/6)) AS kolicina, 'Skladište D' AS lokacija
	FROM skladiste_proizvod sp
	JOIN repromaterijal_proizvod rp ON sp.id_proizvod = rp.id_proizvod
    WHERE rp.id_repromaterijal IN (1, 2, 3) AND sp.tip_transakcije = 'izlaz'
	GROUP BY datum, rp.id_repromaterijal
    ORDER BY datum, id_repromaterijal;


INSERT INTO zahtjev_za_nabavu (id_repromaterijal, kolicina, datum_zahtjeva, status_nabave, id_zaposlenik)
SELECT id_repromaterijal, kolicina, DATE_SUB(datum, INTERVAL 14 DAY) AS datum_zahtjeva, 'dostavljeno' AS status_nabave,
CASE 
	WHEN id % 3 = 1 THEN 4
	WHEN id % 3 = 2 THEN 10
	ELSE 14
END AS id_zaposlenik
	FROM skladiste_repromaterijal
	WHERE tip_transakcije = 'ulaz';

INSERT INTO racun (id_zaposlenik, id_zahtjev_za_narudzbu, datum_racuna)
SELECT 16 AS id_zaposlenik, zzn.id AS id_zahtjev_za_narudzbu, DATE_ADD(zzn.datum_zahtjeva, INTERVAL 3 DAY) AS datum_racuna
	FROM zahtjev_za_narudzbu zzn
	WHERE zzn.status_narudzbe IN ('Spremna za isporuku', 'Poslana', 'Završena');


CREATE TABLE kvartalni_pregled_prodaje (
	id_proizvod INTEGER,
    kolicina INTEGER NOT NULL,
    ukupni_iznos DECIMAL(10,2) NOT NULL,
	kvartal VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_proizvod, kvartal),
    FOREIGN KEY (id_proizvod) REFERENCES proizvod(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_prodane_proizvode(IN p_id_proizvod INTEGER, IN p_kolicina INTEGER, IN p_ukupni_iznos DECIMAL(10,2), p_kvartal VARCHAR(20))
BEGIN
	IF NOT EXISTS (SELECT 1 FROM kvartalni_pregled_prodaje WHERE id_proizvod = p_id_proizvod AND kvartal = p_kvartal) THEN
		INSERT INTO kvartalni_pregled_prodaje VALUES (p_id_proizvod, p_kolicina, p_ukupni_iznos, p_kvartal);
	ELSE
		UPDATE kvartalni_pregled_prodaje 
			SET kolicina = kolicina + p_kolicina, ukupni_iznos = ukupni_iznos + p_ukupni_iznos
        WHERE id_proizvod = p_id_proizvod
			AND kvartal = p_kvartal;
    END IF;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE azuriraj_prodaju(IN p_pocetni_datum DATE, IN p_zavrsni_datum DATE)
BEGIN
	DECLARE var_id_proizvod, var_kolicina INTEGER;
    DECLARE var_ukupni_iznos DECIMAL(10,2);
    DECLARE var_kvartal VARCHAR(20);
	DECLARE handler_broj INTEGER DEFAULT 0;
    
    DECLARE cur CURSOR FOR
		SELECT id_proizvod, kolicina, iznos_stavke
			FROM stavka_narudzbe
			WHERE id_zahtjev_za_narudzbu IN (
				SELECT id_zahtjev_za_narudzbu
					FROM racun
					WHERE datum_racuna BETWEEN p_pocetni_datum AND p_zavrsni_datum
				);
    DECLARE CONTINUE HANDLER FOR NOT FOUND 
    BEGIN
		SET handler_broj = 1;
    END;  
	IF DATE_FORMAT(p_pocetni_datum, '%d.%m.') NOT IN ('01.01.', '01.04.', '01.07.', '01.10.') THEN
		SIGNAL SQLSTATE '45008' SET MESSAGE_TEXT = 'Neispravan unos, početni datum mora biti početak kvartala!';
	END IF;
	
    IF DATE_FORMAT(p_zavrsni_datum, '%d.%m.') NOT IN ('31.03.', '30.6.', '30.09.', '31.12.') THEN
		SIGNAL SQLSTATE '45009' SET MESSAGE_TEXT = 'Neispravan unos, završni datum mora biti završetak kvartala!';
	END IF;
    
    IF p_pocetni_datum > p_zavrsni_datum THEN
		SIGNAL SQLSTATE '45010' SET MESSAGE_TEXT = 'Početni datum ne može biti nakon završnog datuma!';
	END IF;
    
    SELECT 
		CASE 
            WHEN p_zavrsni_datum > p_pocetni_datum + INTERVAL 3 MONTH THEN 'Krivi unos!'
			WHEN MONTH(p_pocetni_datum) = 1 AND MONTH(p_zavrsni_datum) = 3 THEN CONCAT('Q1 ', YEAR(p_pocetni_datum))
			WHEN MONTH(p_pocetni_datum) = 4 AND MONTH(p_zavrsni_datum) = 6 THEN CONCAT('Q2 ', YEAR(p_pocetni_datum))
			WHEN MONTH(p_pocetni_datum) = 7 AND MONTH(p_zavrsni_datum) = 9 THEN CONCAT('Q3 ', YEAR(p_pocetni_datum))
			WHEN MONTH(p_pocetni_datum) = 10 AND MONTH(p_zavrsni_datum) = 12 THEN CONCAT('Q4 ', YEAR(p_pocetni_datum))
            ELSE 'Krivi unos!'
		END
	INTO var_kvartal;
    
    IF var_kvartal = 'Krivi unos!' THEN
		SIGNAL SQLSTATE '45013' SET MESSAGE_TEXT = 'Uneseni datumi ne odgovaraju niti jednom kvartalu!';
	END IF;
    
    OPEN cur;
    
    petlja: LOOP
		FETCH cur INTO var_id_proizvod, var_kolicina, var_ukupni_iznos;
        
        IF handler_broj = 1 THEN
			LEAVE petlja;
        END IF;
		
		CALL azuriraj_prodane_proizvode(var_id_proizvod, var_kolicina, var_ukupni_iznos, var_kvartal);
        
    END LOOP petlja;
    
    CLOSE cur;
END //
DELIMITER ;


CALL azuriraj_prodaju(STR_TO_DATE('01.10.2024.', '%d.%m.%Y.'), STR_TO_DATE('31.12.2024.', '%d.%m.%Y.'));

-- SELECT * FROM kvartalni_pregled_prodaje;

CREATE EVENT kvartalni_izvjestaj
ON SCHEDULE EVERY 3 MONTH
STARTS '2025-04-01 00:00:00'
DO	
	CALL azuriraj_prodaju(CURDATE() - INTERVAL 3 MONTH, CURDATE() - INTERVAL 1 DAY);

SHOW EVENTS;


DELIMITER //
CREATE PROCEDURE izracunaj_kolicinu_transporta(IN p_id_transport INTEGER)
BEGIN
	DECLARE kolicina_transporta INTEGER;
    
    SELECT SUM(sn.kolicina) INTO kolicina_transporta
		FROM stavka_narudzbe sn
		JOIN zahtjev_za_narudzbu zzn ON zzn.id = sn.id_zahtjev_za_narudzbu
		JOIN transport t ON t.id = zzn.id_transport
		WHERE zzn.id_transport = p_id_transport;
        
	IF kolicina_transporta IS NULL THEN
		SIGNAL SQLSTATE '45011' SET MESSAGE_TEXT = 'Transport mora biti dodijeljen barem jednoj narudžbi!';
	ELSE
		UPDATE transport
			SET kolicina = kolicina_transporta
            WHERE id = p_id_transport;
	END IF;
END //
DELIMITER ;


START TRANSACTION;

INSERT INTO transport (id_prijevoznik, registracija, ime_vozaca, datum_polaska, status_transporta) 
VALUES (2, 'ZG4748GG', 'Juraj Jurić', CURDATE(), 'U tijeku'); 

SET @novi_transport = LAST_INSERT_ID();

UPDATE zahtjev_za_narudzbu
	SET id_transport = @novi_transport, status_narudzbe = 'Poslana'
    WHERE id IN (28, 33);
  
CALL izracunaj_kolicinu_transporta(@novi_transport);

COMMIT;


DELIMITER //
CREATE TRIGGER au_zahtjev_za_narudzbu_otkazana
	AFTER UPDATE ON zahtjev_za_narudzbu
    FOR EACH ROW
BEGIN 
	IF NEW.status_narudzbe = 'Otkazana' THEN
		DELETE FROM stavka_narudzbe
        WHERE id_zahtjev_za_narudzbu = NEW.id;
    END IF;
END //
DELIMITER ;

/* provjera
SELECT * FROM stavka_narudzbe;
UPDATE zahtjev_za_narudzbu 
	SET status_narudzbe = 'Otkazana'
    WHERE id = 27;
*/

DELIMITER //
CREATE TRIGGER bu_transport_datum_dolaska
	BEFORE UPDATE ON transport
    FOR EACH ROW
BEGIN
	IF NEW.datum_dolaska < NEW.datum_polaska THEN
		SIGNAL SQLSTATE '45012' SET MESSAGE_TEXT = 'Datum dolaska ne može biti prije datuma polaska!';
    END IF;
	IF NEW.datum_dolaska IS NOT NULL THEN
		SET NEW.status_transporta = 'Obavljen';
	END IF;
END //
DELIMITER ;

/* provjera
-- SELECT * FROM transport;
-- UPDATE transport SET datum_dolaska = '2022-05-20' WHERE id = 20;
*/

DELIMITER //
CREATE TRIGGER au_transport_datum_dolaska
	AFTER UPDATE ON transport
    FOR EACH ROW
BEGIN
	IF NEW.datum_dolaska IS NOT NULL THEN
		UPDATE zahtjev_za_narudzbu
			SET status_narudzbe = 'Završena'
            WHERE id_transport = NEW.id;
	END IF;
END //
DELIMITER ;


/* provjera

SELECT * FROM transport;
SELECT * FROM zahtjev_za_narudzbu;

UPDATE transport 
	SET datum_dolaska = CURDATE()
    WHERE id = 17;

*/




-- Funkcija koja racuna zbroj iznosa svih zavrsenih narudzbi koje je neki zaposlenik obradio

DELIMITER //
CREATE FUNCTION ukupan_iznos_zaposlenik(p_id_zaposlenik INTEGER) RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
	DECLARE var_iznos DECIMAL(10, 2);
    
    SELECT SUM(ukupni_iznos) INTO var_iznos
		FROM zahtjev_za_narudzbu
		WHERE status_narudzbe = 'Završena'
			AND id_zaposlenik = p_id_zaposlenik;
    
    RETURN var_iznos;
END //
DELIMITER ;

-- SELECT ukupan_iznos_zaposlenik(5);



-- Upit – koji zaposlenik prodaje je obradio narudzbe s najvecim sveukupnim iznosom 

SELECT z.id, z.ime, z.prezime, o.naziv AS odjel, ukupan_iznos_zaposlenik(z.id) AS zbroj_iznosa_obradenih_narudzbi
	FROM zaposlenik z
    JOIN odjel o ON o.id = z.id_odjel
    WHERE o.naziv = 'Prodaja'
    ORDER BY ukupan_iznos_zaposlenik(z.id) DESC
    LIMIT 1;



-- Funkcija koja racuna ukupnu kolicinu litara vina u određenoj godini prema tome koliko litara vina iz berbi iz te godine je uslo u skladiste vina

DELIMITER //
CREATE FUNCTION kolicina_vina_godina(p_godina INTEGER) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
	DECLARE var_kolicina_vina VARCHAR(20);
    
	SELECT CONCAT(COALESCE(SUM(sv.kolicina),0), ' L') INTO var_kolicina_vina
		FROM skladiste_vino sv
		JOIN berba b ON b.id = sv.id_berba
		WHERE tip_transakcije = 'ulaz'
			AND b.godina_berbe = p_godina;
            
	RETURN var_kolicina_vina;
END //
DELIMITER ;

-- SELECT kolicina_vina_godina(2023);



-- Pogled – prikaz podataka o vinu uz količinu litara vina po berbi za berbe vina s natprosjecnom berbom

CREATE VIEW vino_berba AS
	SELECT v.naziv, v.vrsta, v.sorta, b.godina_berbe, b.postotak_alkohola, SUM(sv.kolicina) AS ukupna_kolicina
		FROM vino v
        JOIN berba b ON v.id = b.id_vino
        JOIN skladiste_vino sv ON b.id = sv.id_berba
        WHERE sv.tip_transakcije = 'ulaz'
        GROUP BY b.id
        HAVING ukupna_kolicina > (SELECT AVG(kolicina) FROM skladiste_vino WHERE tip_transakcije = 'ulaz');

-- SELECT * FROM vino_berba;



-- Pogled – prikaz svih serija proizvoda punjenih u 2024. godini i njihovih kolicina

CREATE VIEW serije_proizvoda_2024 AS
SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, pu.oznaka_serije, pu.kolicina
	FROM vino v
	JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON b.id = p.id_berba
    JOIN punjenje pu ON p.id = pu.id_proizvod
    WHERE YEAR(pocetak_punjenja) = 2024;

-- SELECT * FROM serije_proizvoda_2024;



-- Pogled - detaljan prikaz svih računa i njihovih stavki

CREATE VIEW racuni_stavke AS
SELECT r.id AS id_racun, k.naziv AS kupac, r.datum_racuna, CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, sn.kolicina, sn.iznos_stavke, CONCAT(z.ime, ' ', z.prezime) AS zaposlenik
	FROM vino v
	JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON b.id = p.id_berba
    JOIN stavka_narudzbe sn ON p.id = sn.id_proizvod
	JOIN zahtjev_za_narudzbu zzn ON zzn.id = sn.id_zahtjev_za_narudzbu
    JOIN kupac k ON k.id = zzn.id_kupac
    JOIN racun r ON zzn.id = r.id_zahtjev_za_narudzbu
    JOIN zaposlenik z ON z.id = r.id_zaposlenik
    ORDER BY r.id;

-- SELECT * FROM racuni_stavke;




-- Upit – 5 najvise prodavanih proizvoda (gledajući narudzbe za koje je izdan racun)

SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, SUM(sn.kolicina) AS ukupno_prodano 
	FROM vino v
	JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON b.id = p.id_berba
    JOIN stavka_narudzbe sn ON p.id = sn.id_proizvod
    JOIN zahtjev_za_narudzbu zzn ON zzn.id = sn.id_zahtjev_za_narudzbu
    WHERE zzn.id IN (SELECT id_zahtjev_za_narudzbu FROM racun)
    GROUP BY p.id
    ORDER BY ukupno_prodano DESC
    LIMIT 5;



-- Funkcija – postotak proizvoda u ukupnoj prodaji (prema izdanim računima)

DELIMITER //
CREATE FUNCTION postotak_proizvoda(p_id_proizvod INTEGER) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE var_ukupno_prodano, var_prodano_proizvod INTEGER;
    
    SELECT SUM(sn.kolicina) AS ukupno_prodano INTO var_ukupno_prodano
		FROM stavka_narudzbe sn 
		JOIN zahtjev_za_narudzbu zzn ON zzn.id = sn.id_zahtjev_za_narudzbu
		WHERE zzn.id IN (SELECT id_zahtjev_za_narudzbu FROM racun);
        
	SELECT SUM(sn.kolicina) AS ukupno_prodano INTO var_prodano_proizvod
		FROM stavka_narudzbe sn 
		JOIN zahtjev_za_narudzbu zzn ON zzn.id = sn.id_zahtjev_za_narudzbu
		WHERE zzn.id IN (SELECT id_zahtjev_za_narudzbu FROM racun)
			AND id_proizvod = p_id_proizvod;
            
	RETURN CONCAT('Postotak prodaje proizvoda id ', p_id_proizvod, ' u ukupnoj prodaji je ', ROUND(((var_prodano_proizvod/var_ukupno_prodano)*100), 2), '%');
END //
DELIMITER ;

-- SELECT postotak_proizvoda(11);


-- Pogled - prikaz proizvoda, njihove ukupne prodane količine, zarade i postotka u prodaji koristeći funkciju

CREATE VIEW proizvod_prodaja AS
SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, SUM(sn.kolicina) AS ukupno_prodano, p.cijena * SUM(sn.kolicina) AS ukupna_zarada, postotak_proizvoda(p.id) AS postotak_prodaje
	FROM vino v
	JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON b.id = p.id_berba
    JOIN stavka_narudzbe sn ON p.id = sn.id_proizvod
    JOIN zahtjev_za_narudzbu zzn ON zzn.id = sn.id_zahtjev_za_narudzbu
    WHERE zzn.id IN (SELECT id_zahtjev_za_narudzbu FROM racun)
    GROUP BY p.id;

-- SELECT * FROM proizvod_prodaja;


-- Upit - prikazi sve proizvode koji su prodani u ukupnoj kolicini vecoj od 1000

SELECT proizvod, ukupno_prodano
	FROM proizvod_prodaja
    WHERE ukupno_prodano > 1000
    ORDER BY ukupno_prodano DESC;
    


DELIMITER //
CREATE PROCEDURE analiziraj_narudzbe_po_mjesecu(IN p_mjesec INTEGER, IN p_godina INTEGER, OUT p_info_mjesec VARCHAR(200))
BEGIN
	DECLARE var_broj_narudzbi INTEGER;
    DECLARE var_prosjecni_iznos, var_najmanji_iznos, var_najveci_iznos DECIMAL(10,2);
    SELECT COUNT(id), ROUND(AVG(ukupni_iznos), 2), MIN(ukupni_iznos), MAX(ukupni_iznos) INTO var_broj_narudzbi, var_prosjecni_iznos, var_najmanji_iznos, var_najveci_iznos
		FROM zahtjev_za_narudzbu
        WHERE MONTH(datum_zahtjeva) = p_mjesec
			AND YEAR(datum_zahtjeva) = p_godina
		GROUP BY YEAR(datum_zahtjeva), MONTH(datum_zahtjeva);
	
    SET p_info_mjesec = CONCAT('U ', p_mjesec, '. mjesecu ', p_godina, '. godine je bilo ', var_broj_narudzbi, ' narudžbi. Najmanji iznos narudžbe je bio €', var_najmanji_iznos, ' a najveći €', var_najveci_iznos, '. Prosječan iznos narudžbe je iznosio €', var_prosjecni_iznos, '.');
END //
DELIMITER ;

-- CALL analiziraj_narudzbe_po_mjesecu(11, 2024, @info);
-- SELECT @info;



-- Upit – koji proizvod je najvise proizveden u zadnjih godinu dana

SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod
	FROM vino v
	JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON b.id = p.id_berba
    WHERE p.id = (
		SELECT id_proizvod
		FROM punjenje
		WHERE zavrsetak_punjenja >= CURDATE() - INTERVAL 1 YEAR
		GROUP BY id_proizvod
		ORDER BY SUM(kolicina) DESC
		LIMIT 1
	);


-- Procedura – prikazi sve narudzbe koje sadrze neki proizvod


DELIMITER //
CREATE PROCEDURE prikazi_narudzbe_za_proizvod(IN p_id_proizvod INTEGER)
BEGIN
	DECLARE var_id, var_kolicina INTEGER;
    DECLARE var_datum DATE;
    DECLARE handler_broj INTEGER DEFAULT 0;
    
    DECLARE cur CURSOR FOR
		SELECT zzn.id, zzn.datum_zahtjeva, sn.kolicina
			FROM zahtjev_za_narudzbu zzn
            JOIN stavka_narudzbe sn ON zzn.id = sn.id_zahtjev_za_narudzbu
            WHERE sn.id_proizvod = p_id_proizvod;
            
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET handler_broj = 1;

	CREATE TEMPORARY TABLE narudzbe_za_proizvod (
		id_narudzba INTEGER,
        datum_narudzbe DATE,
		kolicina_proizvoda INTEGER
    );
    
    OPEN cur;
		
	petlja: LOOP
		FETCH cur INTO var_id, var_datum, var_kolicina;
        
        IF handler_broj = 1 THEN
			LEAVE petlja;
		END IF;
		
		INSERT INTO narudzbe_za_proizvod VALUES (var_id, var_datum, var_kolicina);
    
    END LOOP petlja;
    
    CLOSE cur;
    
    SELECT * FROM narudzbe_za_proizvod;
    DROP TEMPORARY TABLE narudzbe_za_proizvod;
END //
DELIMITER ;

-- CALL prikazi_narudzbe_za_proizvod(1);



-- Funkcija – vraća koliko dugo je neki zaposlenik zaposlen u vinariji


DELIMITER //
CREATE FUNCTION radni_staz(p_id_zaposlenik INTEGER) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	DECLARE var_broj_dana, var_godine, var_mjeseci, var_dani INTEGER;
    
    SELECT DATEDIFF(CURDATE(), datum_zaposlenja) INTO var_broj_dana
		FROM zaposlenik
        WHERE id = p_id_zaposlenik;
	
	SET var_godine = FLOOR(var_broj_dana/365);
	SET var_mjeseci = FLOOR((var_broj_dana % 365)/30);
	SET var_dani = (var_broj_dana % 365) % 30;
        
    RETURN CONCAT('Zaposlenik radi u vinariji ', var_godine, ' godinu, ', var_mjeseci, ' mjeseci i ', var_dani, ' dana.'); 
END //
DELIMITER ;

-- SELECT radni_staz(1);


-- Upit - prikaz zaposlenik s aktivnim statusom uz odjel i njihov radni staž 

SELECT CONCAT(z.ime, ' ', z.prezime) AS zaposlenik, o.naziv AS odjel, radni_staz(z.id) AS radni_staz
	FROM zaposlenik z
    JOIN odjel o ON o.id = z.id_odjel
    WHERE status_zaposlenika = 'aktivan';



-- Funkcija – vraća broj transporta s registracijskim tablicama nekog grada 



DELIMITER //
CREATE FUNCTION tablice_grad(p_tablice CHAR(2)) RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE var_broj_tablica INTEGER;

	SELECT COUNT(*) INTO var_broj_tablica 
		FROM transport
		WHERE registracija LIKE CONCAT(p_tablice, '%');
        
	RETURN var_broj_tablica;
END //
DELIMITER ;

-- SELECT tablice_grad('ZG');
-- SELECT * FROM transport;


-- Pogled – sve narudzbe koje nisu poslane/zavrsene/otkazane, a od datuma zahtjeva je proslo vise od tjedan dana

CREATE VIEW zaostale_narudzbe AS
SELECT zzn.id, k.naziv AS kupac, CONCAT(z.ime, ' ', z.prezime) AS zaposlenik, zzn.datum_zahtjeva, zzn.ukupni_iznos, zzn.status_narudzbe
	FROM zahtjev_za_narudzbu zzn
    JOIN kupac k ON k.id = zzn.id_kupac
    JOIN zaposlenik z ON z.id = zzn.id_zaposlenik
    WHERE status_narudzbe NOT IN ('Završena', 'Poslana', 'Otkazana')
		AND DATEDIFF(CURDATE(), datum_zahtjeva) > 7;


-- Funkcija – broj zaposlenih u nekom odjelu u zadnjih godinu dana

DELIMITER //
CREATE FUNCTION zaposleni_odjel(p_id_odjel INTEGER) RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE var_broj_zaposlenih INTEGER;
    
    SELECT COUNT(*) INTO var_broj_zaposlenih
		FROM zaposlenik
        WHERE id_odjel = p_id_odjel
			AND datum_zaposlenja > CURDATE() - INTERVAL 1 YEAR;
    
    RETURN var_broj_zaposlenih;
END //	
DELIMITER ;

-- SELECT zaposleni_odjel(6);



-- Upit - odjel(i) s najviše zaposlenih u zadnjih godinu dana

SELECT id, naziv, zaposleni_odjel(id) AS zaposleni_unutar_godinu_dana
	FROM odjel o
    WHERE zaposleni_odjel(id) = (SELECT MAX(zaposleni_odjel(id)) FROM odjel);





-- Funkcija – vraća broj kupaca i zaposlenika iz nekog mjesta

DELIMITER //
CREATE FUNCTION broj_mjesta(p_mjesto VARCHAR(20)) RETURNS INTEGER
DETERMINISTIC
BEGIN
	DECLARE var_broj INTEGER;
    
    SELECT COUNT(*) INTO var_broj
		FROM (
			SELECT adresa FROM zaposlenik
            UNION ALL
            SELECT adresa FROM kupac
		) AS zk
        WHERE zk.adresa LIKE CONCAT('%', p_mjesto);
        
	RETURN var_broj;    
END //
DELIMITER ;

-- SELECT broj_mjesta('Dubrovnik');


-- Upit - prikazi sve kupce i broj njihovih racuna, pritom prikazati samo one kupce koji imaju barem dva racuna

SELECT k.*, COUNT(*) AS broj_racuna
	FROM kupac k
	JOIN zahtjev_za_narudzbu zzn ON k.id = zzn.id_kupac
	JOIN racun r ON zzn.id = r.id_zahtjev_za_narudzbu 
	GROUP BY k.id
	HAVING COUNT(*) > 1;



-- Procedura za novi zahtjev za nabavu

DELIMITER //
CREATE PROCEDURE dodaj_novu_nabavu(IN p_id_repromaterijal INTEGER, p_kolicina INTEGER, IN p_id_zaposlenik INTEGER)
BEGIN 
	DECLARE var_trenutna_kolicina INTEGER;
    
    SELECT kolicina INTO var_trenutna_kolicina
		FROM stanje_skladista_repromaterijala
        WHERE id_repromaterijal = p_id_repromaterijal;
        
	IF var_trenutna_kolicina IS NULL THEN
		SIGNAL SQLSTATE '45014' SET MESSAGE_TEXT = 'Repromaterijal ne postoji u skladištu!';
	ELSEIF var_trenutna_kolicina > 300 THEN
		INSERT INTO zahtjev_za_nabavu (id_repromaterijal, kolicina, datum_zahtjeva, status_nabave, id_zaposlenik) VALUES (p_id_repromaterijal, p_kolicina, CURDATE(), 'odbijeno', p_id_zaposlenik);
        SIGNAL SQLSTATE '45015' SET MESSAGE_TEXT = 'Stanje repromaterijala na skladištu je dostatno, zahtjev za nabavu je odbijen!';
	ELSE
		INSERT INTO zahtjev_za_nabavu (id_repromaterijal, kolicina, datum_zahtjeva, status_nabave, id_zaposlenik) VALUES (p_id_repromaterijal, p_kolicina, CURDATE(), 'odobreno', p_id_zaposlenik);
	END IF;
END //
DELIMITER ;

/* provjera
CALL dodaj_novu_nabavu(37, 100, 4);

SELECT * FROM stanje_skladista_repromaterijala;
SELECT * FROM zahtjev_za_nabavu;
*/



-- procedure i pogledi za upotrebu u aplikaciji


DELIMITER //
CREATE PROCEDURE dodaj_novu_berbu (IN p_id_vino INTEGER, IN p_godina_berbe INTEGER, IN p_postotak_alkohola DECIMAL(5, 2))
BEGIN
    INSERT INTO berba (id_vino, godina_berbe, postotak_alkohola)
    VALUES (p_id_vino, p_godina_berbe, p_postotak_alkohola);
END //
DELIMITER ;


CREATE VIEW repromaterijal_po_proizvodu AS
SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, r.opis AS repromaterijal
	FROM vino v
    JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON p.id_berba = b.id
	JOIN repromaterijal_proizvod rp ON rp.id_proizvod = p.id
    JOIN repromaterijal r ON rp.id_repromaterijal = r.id;
    

CREATE VIEW vino_skladiste AS 
SELECT CONCAT(v.naziv,' ', b.godina_berbe) AS vino, ssv.kolicina
	FROM vino v
    JOIN berba b ON v.id = b.id_vino
    JOIN stanje_skladista_vina ssv ON ssv.id_berba = b.id;


CREATE VIEW proizvod_skladiste AS
SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, ssp.kolicina
	FROM vino v
    JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON p.id_berba = b.id
    JOIN stanje_skladista_proizvoda ssp ON p.id = ssp.id_proizvod;


CREATE VIEW repromaterijal_skladiste AS
SELECT r.opis AS repromaterijal, ssr.kolicina
	FROM repromaterijal r
    JOIN stanje_skladista_repromaterijala ssr ON r.id = ssr.id_repromaterijal;


CREATE VIEW kvartalna_prodaja AS
SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, kpp.kolicina, kpp.ukupni_iznos, kpp.kvartal
	FROM vino v
    JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON p.id_berba = b.id
    JOIN kvartalni_pregled_prodaje kpp ON p.id = kpp.id_proizvod
    ORDER BY kpp.ukupni_iznos DESC;

CREATE VIEW punjenje_pogled AS
SELECT CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, pu.oznaka_serije, pu.pocetak_punjenja, pu.zavrsetak_punjenja, pu.kolicina 
	FROM vino v
    JOIN berba b ON v.id = b.id_vino
    JOIN proizvod p ON p.id_berba = b.id
    JOIN punjenje pu ON p.id = pu.id_proizvod
    ORDER BY pu.pocetak_punjenja ASC, pu.oznaka_serije ASC;
 
 
CREATE VIEW narudzbe AS
SELECT zzn.id, k.naziv AS kupac, CONCAT(z.ime, ' ', z.prezime) AS zaposlenik, (CASE WHEN zzn.id_transport IS NULL THEN 'N/A' ELSE zzn.id_transport END) AS id_transport, zzn.datum_zahtjeva, zzn.ukupni_iznos, zzn.status_narudzbe
	FROM zahtjev_za_narudzbu zzn
    JOIN zaposlenik z ON z.id = zzn.id_zaposlenik
    JOIN kupac k ON k.id = zzn.id_kupac
    ORDER BY zzn.id;
  
  
CREATE VIEW stavke AS
SELECT sn.id, sn.id_zahtjev_za_narudzbu, CONCAT(v.naziv, ' ', b.godina_berbe, ' ', p.volumen, ' L') AS proizvod, sn.kolicina, sn.iznos_stavke
	FROM stavka_narudzbe sn
    JOIN proizvod p ON p.id = sn.id_proizvod
    JOIN berba b ON b.id = p.id_berba
    JOIN vino v ON v.id = b.id_vino
    ORDER BY sn.id;
    

DROP ROLE IF EXISTS zaposlenik_prodaje;
DROP USER IF EXISTS 'Prodavac1'@'localhost';

CREATE ROLE zaposlenik_prodaje;

GRANT SELECT, INSERT, UPDATE ON vinarija.kupac TO zaposlenik_prodaje;
GRANT SELECT, INSERT, UPDATE ON vinarija.proizvod TO zaposlenik_prodaje;
GRANT SELECT, INSERT, UPDATE ON vinarija.zahtjev_za_narudzbu TO zaposlenik_prodaje;
GRANT SELECT, INSERT, UPDATE ON vinarija.stavka_narudzbe TO zaposlenik_prodaje;
GRANT SELECT, INSERT, UPDATE ON vinarija.racun TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.stanje_skladista_proizvoda TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.kvartalni_pregled_prodaje TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.racuni_stavke TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.proizvod_prodaja TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.zaostale_narudzbe TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.proizvod_skladiste TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.kvartalna_prodaja TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.narudzbe TO zaposlenik_prodaje;
GRANT SELECT ON vinarija.stavke TO zaposlenik_prodaje;
GRANT EXECUTE ON PROCEDURE vinarija.azuriraj_prodaju TO zaposlenik_prodaje;
GRANT EXECUTE ON PROCEDURE vinarija.azuriraj_prodane_proizvode TO zaposlenik_prodaje;
GRANT EXECUTE ON PROCEDURE vinarija.analiziraj_narudzbe_po_mjesecu TO zaposlenik_prodaje;
GRANT EXECUTE ON PROCEDURE vinarija.prikazi_narudzbe_za_proizvod TO zaposlenik_prodaje;
GRANT EXECUTE ON FUNCTION vinarija.postotak_proizvoda TO zaposlenik_prodaje;


CREATE USER 'Prodavac1'@'localhost' IDENTIFIED BY 'Prodavac1_password';

GRANT zaposlenik_prodaje TO 'Prodavac1'@'localhost';
SET DEFAULT ROLE zaposlenik_prodaje TO 'Prodavac1'@'localhost';

-- SHOW GRANTS FOR 'Prodavac1'@'localhost';
-- SHOW GRANTS FOR zaposlenik_prodaje;




------------------------------------------- VID

-- upit, koji zaposlenik je primio najviše narudžbi

SELECT z.id, z.ime, z.prezime, COUNT(zzn.id) AS broj_narudzbi
FROM zaposlenik z
JOIN zahtjev_za_narudzbu zzn ON z.id = zzn.id_zaposlenik
GROUP BY z.id, z.ime, z.prezime
ORDER BY broj_narudzbi DESC
LIMIT 1;

-- koji prijevoznik ima najviše obavljenih dostava

SELECT p.id, p.naziv, COUNT(t.id) AS broj_voznji
FROM prijevoznik p
JOIN transport t ON p.id = t.id_prijevoznik
WHERE t.status_transporta = 'Obavljen'
GROUP BY p.id, p.naziv
ORDER BY broj_voznji DESC
LIMIT 1;

-- kojeg vina ima najviše na skladištu
SELECT v.naziv, v.vrsta, (SUM(CASE WHEN sv.tip_transakcije = 'ulaz' THEN sv.kolicina ELSE 0 END) -
                         SUM(CASE WHEN sv.tip_transakcije = 'izlaz' THEN sv.kolicina ELSE 0 END)) AS trenutno_na_skladistu
FROM vino v
JOIN berba b ON v.id = b.id_vino
JOIN skladiste_vino sv ON b.id = sv.id_berba
GROUP BY v.id, v.naziv, v.vrsta
ORDER BY trenutno_na_skladistu DESC
LIMIT 1;

-- Triggeri

-- trigger za provjeru količine pri ulazu u skladište repromaterijala

DELIMITER //
CREATE TRIGGER bi_negativna_kolicina
BEFORE INSERT ON skladiste_repromaterijal
FOR EACH ROW
BEGIN
    IF NEW.kolicina < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Količina ne može biti negativna.';
    END IF;
END //
DELIMITER ;

--
CREATE TABLE mp_stanje_skladista_vina (
	lokacija VARCHAR(100),
    kolicina INT
);

-- trigger za promjenu statusa u "Primljena" pri izradi nove stavke narudžbe

DELIMITER //
CREATE TRIGGER postavi_status_na_cekanju
	AFTER INSERT ON stavka_narudzbe
	FOR EACH ROW
BEGIN
    UPDATE zahtjev_za_narudzbu
    SET status_narudzbe = 'Primljena'
    WHERE id = NEW.id_zahtjev_za_narudzbu;
END //
DELIMITER ;

-- PROCEDURA

-- Procedura za ažuriranje stanja skladišta vina

DELIMITER //
CREATE PROCEDURE azuriraj_stanje(IN p_tip_transakcije ENUM('ulaz', 'izlaz'), IN p_lokacija VARCHAR(100), IN p_kolicina INT)

BEGIN
	DECLARE l_postoji INT;
    SELECT COUNT(*) INTO l_postoji
		FROM mp_stanje_skladista_vina
        WHERE lokacija = p_lokacija;
	SET SQL_SAFE_UPDATES = 0;   
	IF p_tip_transakcije = 'ulaz' THEN
		IF l_postoji = 0 THEN
			INSERT INTO mp_stanje_skladista_vina VALUES(p_lokacija, p_kolicina);
		ELSE
			UPDATE mp_stanje_skladista_vina 
            SET kolicina = kolicina + p_kolicina WHERE lokacija = p_lokacija;
        END IF;
	END IF;
    IF p_tip_transakcije = 'izlaz' THEN
		IF l_postoji = 0 THEN
				INSERT INTO mp_stanje_skladista_vina VALUES(p_lokacija, p_kolicina);
			ELSE
				UPDATE mp_stanje_skladista_vina 
				SET kolicina = kolicina - p_kolicina WHERE lokacija = p_lokacija;
			END IF;
    
	END IF;
    SET SQL_SAFE_UPDATES = 1;
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ai_skladiste_vino
	AFTER INSERT ON skladiste_vino
    FOR EACH ROW
BEGIN
	CALL azuriraj_stanje(new.tip_transakcije, new.lokacija, new.kolicina);
END //
DELIMITER ;


/* Test procedure:
CALL azuriraj_stanje('ulaz', 'Zagreb Skladište A', 50);

SELECT * FROM mp_stanje_skladista_vina; */

-- Procedura za dodavanje novog proizvoda:

DELIMITER //
CREATE PROCEDURE dodaj_novo_vino(
    IN p_naziv VARCHAR(255),
    IN p_vrsta ENUM('bijelo', 'crno', 'rose', 'pjenušavo'),
    IN p_sorta VARCHAR(100)
)
BEGIN
    INSERT INTO vino (naziv, vrsta, sorta)
    VALUES (p_naziv, p_vrsta, p_sorta);
END //
DELIMITER ;

-- Test: 
CALL dodaj_novo_vino('Chardonnay', 'bijelo', 'Chardonnay');

-- Funkcije
-- funkcija za vraćanje statusa narudžbe po ID-u
DELIMITER //
CREATE FUNCTION vrati_status_narudzbe(order_id INT)
RETURNS ENUM('Primljena', 'U obradi', 'Na čekanju', 'Spremna za isporuku', 'Poslana', 'Završena', 'Otkazana')
DETERMINISTIC
BEGIN
    DECLARE status_nar ENUM('Primljena', 'U obradi', 'Na čekanju', 'Spremna za isporuku', 'Poslana', 'Završena', 'Otkazana');
    
    
    SELECT status_narudzbe INTO status_nar
    FROM zahtjev_za_narudzbu
    WHERE id = order_id;
    
    
    RETURN status_nar;
END //
DELIMITER ;
  
-- SELECT vrati_status_narudzbe(32) AS status_narudzbe2;

-- SHOW FUNCTION STATUS WHERE Db = 'vinarija';


-- Funkcija koja vraća ukupnu vrijednost svih narudžba

DELIMITER //
CREATE FUNCTION ukupno_narudzbe()
RETURNS INT
DETERMINISTIC
BEGIN
	DECLARE z INT;
    
	SELECT SUM(ukupni_iznos) INTO z
    FROM zahtjev_za_narudzbu;
    
    RETURN z;
END //
DELIMITER ;

-- SELECT ukupno_narudzbe() AS ukupni_iznos_narudzbi;


-- Transakcije


-- 1. Transakcija, ažuriranje statusa narudžbe u 'Otkazana' i brisanje povezanog računa

INSERT INTO zahtjev_za_narudzbu (id, id_kupac, id_zaposlenik, datum_zahtjeva, ukupni_iznos, status_narudzbe)
VALUES (36, 1, 1, '2025-01-01', 100.00, 'Primljena');

INSERT INTO racun (id, id_zaposlenik, id_zahtjev_za_narudzbu, datum_racuna)
VALUES (33, 1, 31, '2025-01-02');

START TRANSACTION;

UPDATE zahtjev_za_narudzbu
SET status_narudzbe = 'Otkazana'
WHERE id = 36;

DELETE FROM racun
WHERE id_zahtjev_za_narudzbu = 33;

COMMIT;


-- SELECT * FROM zahtjev_za_narudzbu WHERE id = 36;
-- SELECT * FROM racun WHERE id_zahtjev_za_narudzbu = 1;



-- Pogledi:

-- Pogled, svi prijevoznici s adresom u Zagrebu
CREATE VIEW prijevoznici_adresa_zagreb AS
SELECT
    id, naziv, adresa, email, telefon, oib
FROM prijevoznik
WHERE adresa LIKE '%Zagreb%'
  AND adresa NOT LIKE 'Zagrebačka cesta%';
SELECT * FROM prijevoznici_adresa_zagreb;

-- Pogled, proizvodi s cijenom većom od prosjećne

CREATE VIEW proizvodi_iznad_prosjeka AS
SELECT *
FROM proizvod
WHERE cijena > (SELECT AVG(cijena) FROM proizvod);

-- SELECT * FROM proizvodi_iznad_prosjeka;









----------------------------------------------- DAVOR

-- trigger koji generira jedinstvenu znaku serijskog broja za novi unos u tablicu punjenje
DELIMITER //
CREATE TRIGGER bi_generiraj_serijski_broj_proizvoda
BEFORE INSERT ON punjenje
FOR EACH ROW
BEGIN
    SET NEW.oznaka_serije = CONCAT('SR-', NEW.id_proizvod, '-', UNIX_TIMESTAMP());
END//
DELIMITER ;

-- SELECT * FROM punjenje;
-- INSERT INTO punjenje (id_proizvod, pocetak_punjenja, zavrsetak_punjenja, kolicina) VALUES(27, '2024-09-28', '2024-09-30', 320);


-- trigger koji dodaje rabat od 10% ako ukupni iznos narudžbe prelazi 10000

DELIMITER //
CREATE TRIGGER bi_dodaj_rabat_za_velike_narudzbe
BEFORE INSERT ON zahtjev_za_narudzbu
FOR EACH ROW
BEGIN
    IF NEW.ukupni_iznos > 10000 THEN
        SET NEW.ukupni_iznos = NEW.ukupni_iznos * 0.9;
    END IF;
END//
DELIMITER ;

-- SELECT * FROM zahtjev_za_narudzbu;
-- INSERT INTO zahtjev_za_narudzbu (id_kupac, id_zaposlenik, id_transport, datum_zahtjeva, ukupni_iznos, status_narudzbe) VALUES(15, 5, 2, '2024-12-12', 12500, 'Primljena');


-- trigger koji provjerava je li godina berbe ispravna (tekuća ili neka od prethodnih godina)


DELIMITER //
CREATE TRIGGER bi_provjera_godine_berbe 
BEFORE INSERT ON berba
FOR EACH ROW
BEGIN
    IF NEW.godina_berbe > YEAR(NOW()) THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Godina berbe ne može biti u budućnosti.';
    END IF;
END//
DELIMITER ;




-- INSERT INTO berba VALUES (64, 2, 2027, 14.00);

-- SELECT * FROM berba;
    
-- trigger koji dodaje repromaterijal u skladiste_repromaterijal na temelju promijene statusa zahtjeva za nabavu u 'dostavljeno'

-- DROP TRIGGER au_dodaj_dostavljeni_repromaterijal;
DELIMITER //
CREATE TRIGGER au_dodaj_dostavljeni_repromaterijal
AFTER UPDATE ON zahtjev_za_nabavu
FOR EACH ROW
BEGIN	   
    IF NEW.status_nabave = 'dostavljeno' THEN		
        INSERT INTO skladiste_repromaterijal (id_repromaterijal, datum, tip_transakcije, kolicina, lokacija) VALUES(NEW.id_repromaterijal, NOW(), 'ulaz', NEW.kolicina, 'Skladište D');  
    END IF;
END//
DELIMITER ;

/* provjera
SELECT * FROM zahtjev_za_nabavu;
SELECT * FROM skladiste_repromaterijal;

UPDATE zahtjev_za_nabavu
	SET status_nabave = 'dostavljeno'
	WHERE id = 23;
*/
    
-- procedura za ispis detaljnog izvještaja o stanju skladišta

DELIMITER //
CREATE PROCEDURE izvjestaj_stanja_skladista(
    IN p_pocetni_datum DATE,
    IN p_zavrsni_datum DATE
)
BEGIN
    SELECT
        p.id,
        v.naziv AS naziv_proizvoda,
        s.kolicina,
        s.lokacija,
        s.datum
    FROM skladiste_proizvod s
    JOIN proizvod p ON p.id = s.id_proizvod
    JOIN berba b ON b.id = p.id_berba
    JOIN vino v ON v.id = b.id_vino
    WHERE s.datum BETWEEN p_pocetni_datum AND p_zavrsni_datum;
END//
DELIMITER ;

-- SELECT * FROM skladiste_proizvod;

-- CALL izvjestaj_stanja_skladista('2023-01-01', '2023-12-31');


-- procedura koja omogućuje ažuriranje statusa narudžbe u tablici zahtjev_za_narudzbu

DELIMITER //
CREATE PROCEDURE azuriraj_status_narudzbe (
    IN p_id_narudzbe INT,
    IN p_novi_status ENUM('Primljena', 'U obradi', 'Na čekanju', 'Spremna za isporuku', 'Poslana', 'Završena', 'Otkazana')
)
BEGIN
    UPDATE zahtjev_za_narudzbu
    SET status_narudzbe = p_novi_status
    WHERE id = p_id_narudzbe;
END//
DELIMITER ;

-- SELECT * FROM zahtjev_za_narudzbu;

-- CALL azuriraj_status_narudzbe(25, 'Na čekanju');


-- procedura koja generira račun za određeni zahtjev za narudžbu i automatski ga dodaje u tablicu racun

DELIMITER //
CREATE PROCEDURE generiraj_racun (
    IN p_id_zaposlenik INT,
    IN p_id_narudzba INT
)
BEGIN
    INSERT INTO racun (id_zaposlenik, id_zahtjev_za_narudzbu, datum_racuna)
    VALUES (p_id_zaposlenik, p_id_narudzba, CURDATE());
END//
DELIMITER ;

-- SELECT * FROM racun;

-- CALL generiraj_racun(1, 35);

-- funkcija za dobivanje imena kupca prema oibu

DELIMITER //
CREATE FUNCTION ime_kupca_prema_oib(k_oib CHAR(11))
RETURNS VARCHAR(150)
DETERMINISTIC
BEGIN
    DECLARE ime_prezime VARCHAR(150);
    SELECT CONCAT(ime, ' ', prezime) 
    INTO ime_prezime    
    FROM kupac
    WHERE oib = k_oib;
    RETURN ime_prezime;
END//
DELIMITER ;

-- SELECT * FROM kupac;
-- SELECT ime_kupca_prema_oib(22345678901);

-- funkcija za provjeru dostupnosti proizvoda u skladištu

DELIMITER //
CREATE FUNCTION provjera_dostupnosti_proizvoda(
    ssp_id_proizvod INT,
    ssp_potrebna_kolicina INT
)
RETURNS VARCHAR(10)
DETERMINISTIC
BEGIN
    DECLARE dostupno INT;
    SELECT kolicina INTO dostupno
    FROM stanje_skladista_proizvoda
    WHERE id_proizvod = ssp_id_proizvod;
    IF dostupno >= ssp_potrebna_kolicina THEN
        RETURN 'Dostupno';
    ELSE
        RETURN 'Nedostupno';
    END IF;
END//
DELIMITER ;

-- SELECT * FROM stanje_skladista_proizvoda;
-- SELECT provjera_dostupnosti_proizvoda(33, 2000);


-- funkcija koja vraća broj završenih narudžbi za određenog kupca


DELIMITER //
CREATE FUNCTION broj_narudzbi_kupca(p_id_kupac INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj INT;
    SELECT COUNT(*)
    INTO broj
    FROM zahtjev_za_narudzbu
    WHERE id_kupac = p_id_kupac AND status_narudzbe = 'Završena';

    RETURN broj;
END//
DELIMITER ;

-- SELECT broj_narudzbi_kupca(15);

-- transakcija koja dodaje novog dobavljača i s njim povezani repromaterijal

DELIMITER //
CREATE PROCEDURE dodaj_dobavljaca_i_repromaterijal(
    IN p_naziv_dobavljaca VARCHAR(50),
    IN p_adresa_dobavljaca VARCHAR(50),
    IN p_email_dobavljaca VARCHAR(50),
    IN p_telefon_dobavljaca VARCHAR(20),
    IN p_oib_dobavljaca CHAR(11),
    IN p_vrsta_repromaterijal VARCHAR(100),
    IN p_opis_repromaterijal VARCHAR(100),
    IN p_jedinicna_cijena DECIMAL(10, 2)
)
BEGIN
    DECLARE new_id_dobavljac INT;    
    START TRANSACTION;    
		INSERT INTO dobavljac (naziv, adresa, email, telefon, oib)
		VALUES (p_naziv_dobavljaca, p_adresa_dobavljaca, p_email_dobavljaca, p_telefon_dobavljaca, p_oib_dobavljaca);
		
		SET new_id_dobavljac = LAST_INSERT_ID();
		
		INSERT INTO repromaterijal (id_dobavljac, vrsta, opis, jedinicna_cijena)
		VALUES (new_id_dobavljac, p_vrsta_repromaterijal, p_opis_repromaterijal, p_jedinicna_cijena);
    COMMIT;
END//

DELIMITER ;

/* provjera
SELECT * FROM dobavljac;
SELECT * FROM repromaterijal;

CALL dodaj_dobavljaca_i_repromaterijal(
    'ABC d.o.o.',           
    'Ulica 123, Zagreb',    
    'kontakt@abc.hr',     
    '123486789',          
    '12645678901',       
    'Čelik',  
    'Naljepnica za Ždrijebčevu krv',
    150.50                 
);
*/

-- Prikaz proizvoda i njihovih povezanih repromaterijala s ukupnim troškovima repromaterijala po proizvodu
CREATE VIEW proizvodni_troskovi AS
	SELECT 
		p.id AS proizvod_id,
		v.naziv,
		b.godina_berbe,
		p.cijena AS cijena_proizvoda, 
		ROUND(SUM(CASE WHEN r.vrsta = 'Kutija' THEN r.jedinicna_cijena / 6
			ELSE r.jedinicna_cijena
		END), 2) AS ukupni_trosak_repromaterijala
	FROM 
		proizvod p
	JOIN 
		repromaterijal_proizvod rp ON p.id = rp.id_proizvod
	JOIN 
		repromaterijal r ON rp.id_repromaterijal = r.id
	JOIN
		berba b ON b.id = p.id_berba
	JOIN 
		vino v ON v.id = b.id_vino
	GROUP BY 
		p.id, v.naziv, b.godina_berbe, p.cijena;

-- SELECT * FROM proizvodni_troskovi;
-- SELECT * FROM repromaterijal;

-- Prikaz narudžbi koje su još uvijek u obradi, zajedno s informacijama o kupcima koji su ih naručili

SELECT 
    zzn.id AS narudzba_id, 
    zzn.datum_zahtjeva, 
    k.naziv AS kupac_naziv, 
    k.ime, 
    k.prezime, 
    zzn.ukupni_iznos
FROM 
    zahtjev_za_narudzbu zzn
JOIN 
    kupac k ON zzn.id_kupac = k.id
WHERE 
    zzn.status_narudzbe = 'U obradi';
    
-- Prikaz svih punjenja s ukupnim vremenom trajanja i količinom proizvoda punjenog u određenom razdoblju

SELECT 
    p.id AS punjenje_id, 
    p.pocetak_punjenja, 
    p.zavrsetak_punjenja, 
    DATEDIFF(p.zavrsetak_punjenja, p.pocetak_punjenja) AS trajanje_u_danima,
    p.kolicina
FROM 
    punjenje p
WHERE 
    p.pocetak_punjenja BETWEEN '2023-01-01' AND '2023-12-31';   


    
-- Prikaz zaposlenika koji su naručivali repromaterijal, zajedno s brojem odobrenih zahtjeva za nabavu

SELECT 
    z.id AS zaposlenik_id, 
    z.ime, 
    z.prezime, 
    COUNT(zzn.id) AS broj_odobrenih_zahtjeva
FROM 
    zaposlenik z
JOIN 
    zahtjev_za_nabavu zzn ON z.id = zzn.id_zaposlenik
WHERE 
    zzn.status_nabave = 'odobreno'
GROUP BY 
    z.id, z.ime, z.prezime;
    
-- SELECT * FROM zahtjev_za_nabavu;









-------------------------------------------- Danijel

-- Pogledi

-- Zaposlenici koji rade u prodaji

CREATE VIEW View_Zaposlenici_Prodaja AS
SELECT z.id, z.ime, z.prezime, z.adresa, z.email, z.telefon
FROM zaposlenik z
JOIN odjel o ON z.id_odjel = o.id
WHERE o.naziv = 'Prodaja';

-- Kupci koji imaju e-mail domenu @vina.hr

CREATE VIEW View_Kupci_Vina_HR AS
SELECT naziv, oib, ime, prezime, adresa, email, telefon
FROM kupac
WHERE email LIKE '%@vina.hr';

-- Podaci o zaposlenicima s odjelom i statusom

CREATE VIEW View_Zaposlenici_S_ODjelom AS
SELECT z.id, z.ime, z.prezime, z.adresa, z.email, z.telefon, z.datum_zaposlenja, z.status_zaposlenika, o.naziv AS odjel
FROM zaposlenik z
JOIN odjel o ON z.id_odjel = o.id;


•	Procedure

-- Kreiranje procedure za ažuriranje podataka o zaposleniku
DELIMITER $$

CREATE PROCEDURE update_zaposlenik(
    IN p_id INT,
    IN p_ime VARCHAR(255),
    IN p_prezime VARCHAR(255),
    IN p_adresa VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telefon VARCHAR(20),
    IN p_status_zaposlenika VARCHAR(50)
)
BEGIN
    UPDATE zaposlenik
    SET ime = p_ime, prezime = p_prezime, adresa = p_adresa, email = p_email, telefon = p_telefon, status_zaposlenika = p_status_zaposlenika
    WHERE id = p_id;
END $$

DELIMITER ;

-- Kreiranje procedure za unos novog zaposlenika
DELIMITER $$

CREATE PROCEDURE insert_zaposlenik(
    IN p_id_odjel INT,
    IN p_ime VARCHAR(255),
    IN p_prezime VARCHAR(255),
    IN p_adresa VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_telefon VARCHAR(20),
    IN p_datum_zaposlenja DATE,
    IN p_status_zaposlenika VARCHAR(50)
)
BEGIN
    INSERT INTO zaposlenik (id_odjel, ime, prezime, adresa, email, telefon, datum_zaposlenja, status_zaposlenika)
    VALUES (p_id_odjel, p_ime, p_prezime, p_adresa, p_email, p_telefon, p_datum_zaposlenja, p_status_zaposlenika);
END $$

DELIMITER ;

• Triggers

--Automatski unos datuma zapošljavanja novog zaposlenika

DELIMITER //

CREATE TRIGGER bi_postavi_datum_zaposlenja
BEFORE INSERT ON zaposlenik
FOR EACH ROW
BEGIN
    IF NEW.datum_zaposlenja IS NULL THEN
        SET NEW.datum_zaposlenja = CURDATE();
    END IF;
END//

DELIMITER ;

DELIMITER ;



-- Upiti

-- Zaposlenici koji su zaposleni više od 2 godine

SELECT ime, prezime, datum_zaposlenja
FROM zaposlenik
WHERE datum_zaposlenja <= CURDATE() - INTERVAL 2 YEAR;

-- Kupci koji su unutar Splita i Dubrovnika

SELECT naziv, ime, prezime, adresa
FROM kupac
WHERE adresa LIKE '%Split%' OR adresa LIKE '%Dubrovnik%';

-- Kupci koji nisu iz Zagreba

SELECT naziv, ime, prezime, adresa, email, telefon
FROM kupac
WHERE adresa NOT LIKE '%Zagreb%';

-- Transakcije

-- Brisanje zaposlenika i ažuriranje broja zaposlenika u odjelu

START TRANSACTION;

DELETE FROM zaposlenik WHERE id = 8;

UPDATE odjel SET broj_zaposlenika = broj_zaposlenika - 1 WHERE id = 2;

COMMIT;

-- Ažuriranje podataka o kupcu i zaposleniku

START TRANSACTION;

UPDATE kupac SET telefon = '+385919876543' WHERE oib = '12345678912';

UPDATE zaposlenik SET telefon = '+385919876543' WHERE id = 15;

COMMIT;









-------------------------------------------------------- MARTA
-- upiti

-- 1. Upit: Dohvati ukupnu količinu robe koju je prevezao svaki prijevoznik
SELECT p.naziv AS prijevoznik, SUM(t.kolicina) AS ukupna_kolicina
FROM prijevoznik p
JOIN transport t ON p.id = t.id_prijevoznik
GROUP BY p.naziv
ORDER BY ukupna_kolicina DESC;

-- 2. Upit: Pronađi transportne transakcije koje su još u tijeku
SELECT * 
FROM transport 
WHERE status_transporta = 'u tijeku';

-- 3. Upit: Prikaz svih prijevoznika koji su prevezli više od određene količine robe
SELECT p.naziv AS prijevoznik, SUM(t.kolicina) AS ukupna_kolicina
FROM prijevoznik p
JOIN transport t ON p.id = t.id_prijevoznik
GROUP BY p.naziv
HAVING SUM(t.kolicina) > 1000;



-- pogledi

-- 1. Pogled: Prikaz svih transporta s nazivima prijevoznika
CREATE VIEW transport_prikaz AS
SELECT t.id AS id_transport, t.datum_polaska, t.datum_dolaska, t.kolicina, t.status_transporta, p.naziv AS prijevoznik
FROM transport t
JOIN prijevoznik p ON t.id_prijevoznik = p.id;

-- 2. Pogled: Prikaz prijevoznika i njihovih ukupnih količina transporta
CREATE VIEW prijevoznik_kolicina AS
SELECT p.naziv AS prijevoznik, SUM(t.kolicina) AS ukupna_kolicina
FROM prijevoznik p
LEFT JOIN transport t ON p.id = t.id_prijevoznik
GROUP BY p.naziv;



-- transakcije

-- 1. Transakcija: Dodavanje novog transporta
START TRANSACTION;
INSERT INTO transport (id_prijevoznik, registracija, ime_vozaca, datum_polaska, datum_dolaska, kolicina, status_transporta)
VALUES (1, 'ZG6423JK', 'Goran Lukić', '2025-01-12', '2025-01-15', 500, 'u tijeku');
COMMIT;

-- 2. Transakcija: Brisanje transporta
START TRANSACTION;
DELETE FROM transport WHERE id = 21;
COMMIT;



-- trigeri

-- 1. Triger:  Sprečavanje promjene statusa transporta na "Obavljen" ako nije unijet datum dolaska

DELIMITER //
CREATE TRIGGER prije_transport_update
BEFORE UPDATE ON transport
FOR EACH ROW
BEGIN
    IF NEW.status_transporta = 'Obavljen' AND (NEW.datum_dolaska IS NULL OR NEW.datum_dolaska = '') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Unesi datum_dolaska.';
    END IF;
END;//
DELIMITER ;

-- 2. Triger: Automatsko ažuriranje datuma dolaska prilikom promjene statusa transporta na "Otkazan"
DELIMITER //
CREATE TRIGGER za_otkazani_transport
BEFORE UPDATE ON transport
FOR EACH ROW
BEGIN
    IF NEW.status_transporta = 'Otkazan' AND OLD.status_transporta <> 'Otkazan' THEN
        SET NEW.datum_dolaska = NULL;
    END IF;
END;//
DELIMITER ;



-- procedure

-- 1. Procedura: Dodavanje novog transporta
DELIMITER //
CREATE PROCEDURE dodaj_transport (
    IN p_id_prijevoznik INT,
    IN p_tip_robe VARCHAR(50),
    IN p_datum DATE,
    IN p_kolicina DECIMAL(10, 2),
    IN p_status ENUM('u tijeku', 'završeno', 'otkazano')
)
BEGIN
    INSERT INTO transport (id_prijevoznik, tip_robe, datum_transporta, kolicina, status)
    VALUES (p_id_prijevoznik, p_tip_robe, p_datum, p_kolicina, p_status);
END//
DELIMITER ;

-- 2. Procedura: Dodavanje novog prijevoznika
DELIMITER //
CREATE PROCEDURE dodaj_prijevoznika (
    IN p_naziv VARCHAR(100),
    IN p_oib CHAR(11),
    IN p_kontakt VARCHAR(100)
)
BEGIN
    INSERT INTO prijevoznik (naziv, oib, kontakt)
    VALUES (p_naziv, p_oib, p_kontakt);
END//
DELIMITER ;



-- funkcije

-- 1. Funkcija: Izračunaj ukupnu količinu robe za određenog prijevoznika
DELIMITER //
CREATE FUNCTION ukupna_kolicina_prijevoznika(id_prijevoznik INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE ukupno DECIMAL(10, 2);
    SELECT SUM(kolicina) INTO ukupno
    FROM transport
    WHERE id_prijevoznik = id_prijevoznik;
    RETURN ukupno;
END//
DELIMITER ;

-- 2. Funkcija: Dohvati broj transporta za određenog prijevoznika
DELIMITER //
CREATE FUNCTION broj_transporta_prijevoznika(id_prijevoznik INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_transporta INT;
    SELECT COUNT(*) INTO broj_transporta
    FROM transport
    WHERE id_prijevoznik = id_prijevoznik;
    RETURN broj_transporta;
END//
DELIMITER ;








-- -----------------------------------------------------MARKO---------------------------------------------------------------------------------
-- Dodavanje tablice uloge
CREATE TABLE uloge (
    uloga_id INT AUTO_INCREMENT PRIMARY KEY,
    naziv VARCHAR(50) NOT NULL
);

INSERT INTO uloge (naziv) 
VALUES ('admin'),        
    ('menadžer'),    
    ('moderator'), 
    ('zaposlenik');

-- SELECT * FROM zaposlenik;

-- SELECT * FROM uloge;

-- Proširivanje tablice zaposlenik i dodavanje privilegija za prijavu
ALTER TABLE zaposlenik
ADD COLUMN uloga_id INT NOT NULL DEFAULT 4,  -- automatski stavlja ulogu zaposlenika na korisnika na kojem nije definiran
ADD COLUMN lozinka VARCHAR(255) NOT NULL DEFAULT '212mj!#$#!',
ADD CONSTRAINT fk_uloga FOREIGN KEY (uloga_id) REFERENCES uloge(uloga_id);  

-- Dodavanje uloge i lozinke korisniku
UPDATE zaposlenik
SET 
    uloga_id = 1,
    lozinka = 'admin123'
WHERE id = 7;

SELECT *
FROM zaposlenik
WHERE uloga_id = '1';

-- Dodavanje tablice uloga_pristupa, definira kojim akcijama korisnik ima pristup
CREATE TABLE uloge_pristupa (
    uloge_pristupa_id INT AUTO_INCREMENT PRIMARY KEY,
    uloga_id INT,
    akcija VARCHAR(100) NOT NULL,
    FOREIGN KEY (uloga_id) REFERENCES uloge(uloga_id) 
);

INSERT INTO uloge_pristupa (uloga_id, akcija)
VALUES 
(1, 'dodaj korisnika'),
(1, 'izbriši korisnika'),
(1, 'pristup svim podacima'),
(2, 'pristup vlastitim podacima'),
(2, 'ne može brisati korisnike'),
(4, 'nema nikakv pristup');

SELECT * FROM uloge_pristupa;

-- Dohvaćanje naziva uloge koju zaposlenik ima
DROP FUNCTION IF EXISTS provjera_prava_korisnika;

DELIMITER //
CREATE FUNCTION provjera_prava_korisnika(id_zaposlenik INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE pravo VARCHAR(50);
    
    SELECT uloge.naziv
    INTO pravo
    FROM zaposlenik
    JOIN uloge ON zaposlenik.uloga_id = uloge.uloga_id
    WHERE zaposlenik.id = id_zaposlenik
    LIMIT 1;

    -- Ako zaposlenik ne postoji, vraća 'korisnik_ne_postoji'
    RETURN IFNULL(pravo, 'korisnik_ne_postoji');
END;
//
DELIMITER ;

-- Testiranje funkcije
SELECT provjera_prava_korisnika(7);

-- Funkcija za broj admin korisnika
DROP FUNCTION IF EXISTS broj_admin_korisnika;
DELIMITER //
CREATE FUNCTION broj_admin_korisnika()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE broj_admina INT;

    SELECT COUNT(*) INTO broj_admina
    FROM zaposlenik
    WHERE zaposlenik.uloga_id = 1; -- id 1 je id za admina

    RETURN broj_admina;
END;
//
DELIMITER ;
SELECT broj_admin_korisnika(); 

-- Ažuriranje uloge zaposlenika
DELIMITER //
CREATE PROCEDURE azuriraj_ulogu_zaposlenika (
    IN p_id INT,
    IN p_uloga_id INT  
)
BEGIN
    IF EXISTS (SELECT 1 FROM zaposlenik WHERE id = p_id) 
    THEN
        UPDATE zaposlenik
        SET uloga_id = p_uloga_id
        WHERE id = p_id;
    ELSE
        SELECT 'Zaposlenik s ovim ID-om ne postoji!' AS poruka;
    END IF;
END;
//
DELIMITER ;
CALL azuriraj_ulogu_zaposlenika(7, 1);  -- postavljamo zaposlenika s id=7 kao admina, preko tablice uloga id=1

-- Pogled koji pokazuje sve zaposlenike koji imaju prava admina
DROP VIEW IF EXISTS pogled_administratori;
CREATE VIEW pogled_administratori AS
SELECT zaposlenik.id, zaposlenik.ime, zaposlenik.prezime, uloge.naziv AS uloga
FROM zaposlenik
JOIN uloge ON zaposlenik.uloga_id = uloge.uloga_id
WHERE uloge.naziv = 'admin';

SELECT * FROM pogled_administratori;

-- Pogled koji pokazuje sve zaposlenike neaktivne
DROP VIEW IF EXISTS pogled_neaktivni_korisnici;
CREATE VIEW pogled_neaktivni_korisnici AS
SELECT zaposlenik.id, zaposlenik.ime, zaposlenik.prezime, zaposlenik.status_zaposlenika
FROM zaposlenik
WHERE zaposlenik.status_zaposlenika = 'neaktivan';
SELECT * FROM pogled_neaktivni_korisnici;

-- Ažuriranje statusa zaposlenika aktivan i neaktivan
DELIMITER //
CREATE PROCEDURE azuriraj_status_zaposlenika (
    IN p_id INT,
    IN p_status ENUM('aktivan', 'neaktivan')
)
BEGIN
    IF EXISTS (SELECT 1 FROM zaposlenik WHERE id = p_id) THEN
        UPDATE zaposlenik
        SET status_zaposlenika = p_status
        WHERE id = p_id;
    ELSE
        SELECT 'Zaposlenik s ovim ID-om ne postoji!' AS poruka;
    END IF;
END;
//
DELIMITER ;
CALL azuriraj_status_zaposlenika(7, 'aktivan');

-- Trigger za automatsko postavljanje statusa na 'aktivan' prilikom unosa novog zaposlenika
DELIMITER //
CREATE TRIGGER postavi_status_na_aktivan
BEFORE INSERT ON zaposlenik
FOR EACH ROW
BEGIN
    IF NEW.status_zaposlenika IS NULL THEN
        SET NEW.status_zaposlenika = 'aktivan';
    END IF;
END;
//
DELIMITER ;

-- Procedura koja vraća popis dopuštenja koje ima zaposlenik po id
DELIMITER //
CREATE PROCEDURE prikazi_prava_korisnika(
    IN p_id_zaposlenik INT
)
BEGIN
    DECLARE uloga_naziv VARCHAR(50);
    SELECT uloge.naziv
    INTO uloga_naziv
    FROM zaposlenik
    JOIN uloge ON zaposlenik.uloga_id = uloge.uloga_id
    WHERE zaposlenik.id = p_id_zaposlenik
    LIMIT 1;

    SELECT uloge.naziv AS uloga, uloge_pristupa.akcija
    FROM uloge
    JOIN uloge_pristupa ON uloge.uloga_id = uloge_pristupa.uloga_id
    WHERE uloge.naziv = uloga_naziv;

END;
//
DELIMITER ;

CALL prikazi_prava_korisnika(7);

SELECT * FROM uloge;


CREATE VIEW pogled_transakcija_skladista AS
SELECT 
    id_berba,
    lokacija,
    tip_transakcije,
    SUM(kolicina) AS ukupna_kolicina,
    COUNT(*) AS broj_transakcija
FROM skladiste_vino
GROUP BY id_berba, lokacija, tip_transakcije
ORDER BY id_berba, lokacija, tip_transakcije;




DROP USER IF EXISTS 'SkladisteSef'@'localhost';
DROP USER IF EXISTS 'HRManager'@'localhost';

CREATE USER 'SkladisteSef'@'localhost' IDENTIFIED BY 'skladiste123';

GRANT SELECT, INSERT, UPDATE ON vinarija.skladiste_proizvod TO 'SkladisteSef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.skladiste_vino TO 'SkladisteSef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.skladiste_repromaterijal TO 'SkladisteSef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.stanje_skladista_proizvoda TO 'SkladisteSef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.stanje_skladista_repromaterijala TO 'SkladisteSef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.stanje_skladista_vina TO 'SkladisteSef'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.mp_stanje_skladista_vina TO 'SkladisteSef'@'localhost';
GRANT SELECT ON vinarija.vino_skladiste TO 'SkladisteSef'@'localhost';
GRANT SELECT ON vinarija.proizvod_skladiste TO 'SkladisteSef'@'localhost';
GRANT SELECT ON vinarija.repromaterijal_skladiste TO 'SkladisteSef'@'localhost';

CREATE USER 'HRManager'@'localhost' IDENTIFIED BY 'ljudi123';

GRANT SELECT, INSERT, UPDATE ON vinarija.odjel TO 'HRManager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.zaposlenik TO 'HRManager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON vinarija.kupac TO 'HRManager'@'localhost';





-- -------------------------------------------------------------------------------------------------------------------------------Marko
DROP USER IF EXISTS 'admin'@'localhost';
DROP USER IF EXISTS 'manager_prodaje_role';
DROP USER IF EXISTS 'manager_prodaje'@'localhost';


CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON vinarija.* TO 'admin'@'localhost';


CREATE ROLE 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.berba TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.dobavljac TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.kupac TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.plan_proizvodnje TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.prijevoznik TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.proizvod TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.skladiste_vino TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.stanje_skladista_vina TO 'manager_prodaje_role';
GRANT SELECT, INSERT, UPDATE ON vinarija.transport TO 'manager_prodaje_role';


CREATE USER 'manager_prodaje'@'localhost' IDENTIFIED BY 'manager_prodaje';

GRANT 'manager_prodaje_role' TO 'manager_prodaje'@'localhost';
SET DEFAULT ROLE 'manager_prodaje_role' TO 'manager_prodaje'@'localhost';

-- SHOW GRANTS FOR 'manager_prodaje'@'localhost';
-- SHOW GRANTS FOR 'manager_prodaje_role';
-- SHOW GRANTS FOR 'admin'@'localhost';

SELECT User, Host FROM mysql.user;
-- --------------------------------------------------------------------------------------------------------------------------
