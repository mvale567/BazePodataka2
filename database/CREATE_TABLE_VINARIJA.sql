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
    CONSTRAINT berba_vino_fk FOREIGN KEY (id_vino) REFERENCES vino(id)
);


----------------------------------------------- DAVOR

CREATE TABLE proizvod (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_berba INTEGER NOT NULL,
	volumen DECIMAL(4,2) NOT NULL,
    cijena DECIMAL(10, 2) NOT NULL CHECK (cijena > 0),
    CONSTRAINT proizvod__berba_fk FOREIGN KEY (id_berba) REFERENCES berba(id)
);



----------------------------------------------- LAURA
CREATE TABLE punjenje (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_proizvod INTEGER NOT NULL,
    oznaka_serije VARCHAR(20) NOT NULL,
    pocetak_punjenja DATE NOT NULL,
    zavrsetak_punjenja DATE NOT NULL,
    kolicina INTEGER NOT NULL, 
    CONSTRAINT punjenje_proizvod_fk FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    CONSTRAINT punjenje_kolicina_ck CHECK (kolicina > 0)
);



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
    CONSTRAINT repromaterijal__dobavljac_fk FOREIGN KEY (id_dobavljac) REFERENCES dobavljac(id),
    CONSTRAINT repromaterijal_cijena_ck CHECK (jedinicna_cijena > 0)
);



----------------------------------------------- LAURA
CREATE TABLE repromaterijal_proizvod (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
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
    datum_zahtjeva DATE NOT NULL,
    ukupni_iznos DECIMAL(8, 2),
    status_narudzbe ENUM('Primljena', 'U obradi', 'Na čekanju', 'Spremna za isporuku', 'Poslana', 'Završena', 'Otkazana') NOT NULL DEFAULT 'Na čekanju',
    CONSTRAINT zahtjev_za_narudzbu__kupac_fk FOREIGN KEY (id_kupac) REFERENCES kupac(id),
    CONSTRAINT zahtjev_za_narudzbu__zaposlenik_fk FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);


CREATE TABLE stavka_narudzbe (
    id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_zahtjev_za_narudzbu INTEGER NOT NULL,
    id_proizvod INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    iznos_stavke DECIMAL(8, 2) NOT NULL,
    CONSTRAINT stavka_narudzbe__zahtjev_za_narudzbu_fk FOREIGN KEY (id_zahtjev_za_narudzbu) REFERENCES zahtjev_za_narudzbu(id),
    CONSTRAINT stavka_narudzbe__proizvod_fk FOREIGN KEY (id_proizvod) REFERENCES proizvod(id),
    CONSTRAINT stavka_narudzbe_uk UNIQUE (id_zahtjev_za_narudzbu, id_proizvod),
    CONSTRAINT stavka_narudzbe_kolicina_ck CHECK (kolicina > 0)
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
    status_nabave ENUM('u obradi', 'odobreno', 'odbijeno') NOT NULL,
    id_zaposlenik INT NOT NULL,
    FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id),
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id)
);



-- MARTA
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
	kolicina INTEGER NOT NULL,
	status_transporta ENUM('Obavljen', 'U tijeku', 'Otkazan') NOT NULL,
	FOREIGN KEY (id_prijevoznik) REFERENCES prijevoznik(id)
);

CREATE TABLE racun (
	id INTEGER AUTO_INCREMENT PRIMARY KEY,
    id_zaposlenik INTEGER NOT NULL,
	id_zahtjev_za_narudzbu INTEGER NOT NULL UNIQUE,
	datum_racuna DATE NOT NULL,
	FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenik(id),
	FOREIGN KEY (id_zahtjev_za_narudzbu) REFERENCES zahtjev_za_narudzbu(id)
);


-------------------------------------------- VID

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


-- PROCEDURA


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

SELECT broj_zaposlenika_u_odjelu(2);


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
	CALL azuriraj_broj_zaposlenika(new.id_odjel);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER ad_zaposlenik
	AFTER DELETE ON zaposlenik
    FOR EACH ROW
BEGIN
	CALL azuriraj_broj_zaposlenika(old.id_odjel);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER au_zaposlenik
	AFTER UPDATE ON zaposlenik
    FOR EACH ROW
BEGIN
	-- ako je zaposlenik promijenio odjel
	IF new.id_odjel != old.id_odjel THEN
		CALL azuriraj_broj_zaposlenika(old.id_odjel);
		CALL azuriraj_broj_zaposlenika(new.id_odjel);
	ELSE  -- ako se promijenio status zaposlenika
		IF new.status_zaposlenika != old.status_zaposlenika THEN
			CALL azuriraj_broj_zaposlenika(new.id_odjel);
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


CREATE TABLE stanje_skladista_vina (
	id_berba INTEGER PRIMARY KEY,
    kolicina DECIMAL(8,2),
    CONSTRAINT stanje_skladista_vina__berba_fk FOREIGN KEY (id_berba) REFERENCES berba(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_kolicinu_vina (IN p_id_berba INTEGER, IN p_tip_transakcije ENUM('ulaz', 'izlaz'), IN p_kolicina DECIMAL(8,2))
BEGIN
	DECLARE berba_postoji INTEGER;
    DECLARE nova_kolicina DECIMAL(8,2);
    
    SELECT COUNT(*) INTO berba_postoji
		FROM stanje_skladista_vina
		WHERE id_berba = p_id_berba;
    
    IF berba_postoji = 0 THEN
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
	CALL azuriraj_kolicinu_vina(new.id_berba, new.tip_transakcije, new.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ad_skladiste_vino_akv
	AFTER DELETE ON skladiste_vino
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_vina(old.id_berba, old.tip_transakcije, -old.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER au_skladiste_vino_akv
	AFTER UPDATE ON skladiste_vino
    FOR EACH ROW
BEGIN 
	CALL azuriraj_kolicinu_vina(old.id_berba, old.tip_transakcije, -old.kolicina);
    CALL azuriraj_kolicinu_vina(new.id_berba, new.tip_transakcije, new.kolicina);
END //
DELIMITER ;


CREATE TABLE stanje_skladista_proizvoda (
	id_proizvod INTEGER PRIMARY KEY,
    kolicina INTEGER,
    CONSTRAINT stanje_skladista_proizvoda__proizvod_fk FOREIGN KEY (id_proizvod) REFERENCES proizvod(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_kolicinu_proizvoda (IN p_id_proizvod INTEGER, IN p_tip_transakcije ENUM('ulaz', 'izlaz'), IN p_kolicina INTEGER)
BEGIN
	DECLARE proizvod_postoji, nova_kolicina INTEGER;
    
    SELECT COUNT(*) INTO proizvod_postoji
		FROM stanje_skladista_proizvoda
		WHERE id_proizvod = p_id_proizvod;
        
	IF proizvod_postoji = 0 THEN
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
	CALL azuriraj_kolicinu_proizvoda(new.id_proizvod, new.tip_transakcije, new.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ad_skladiste_proizvod
	AFTER DELETE ON skladiste_proizvod
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_proizvoda(old.id_proizvod, old.tip_transakcije, -old.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER au_skladiste_proizvod
	AFTER UPDATE ON skladiste_proizvod
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_proizvoda(old.id_proizvod, old.tip_transakcije, -old.kolicina);
    CALL azuriraj_kolicinu_proizvoda(new.id_proizvod, new.tip_transakcije, new.kolicina);
END //
DELIMITER ;


CREATE TABLE stanje_skladista_repromaterijala (
	id_repromaterijal INTEGER PRIMARY KEY,
    kolicina INTEGER,
    CONSTRAINT stanje_skladista_repromaterijala__repromaterijal FOREIGN KEY (id_repromaterijal) REFERENCES repromaterijal(id)
);


DELIMITER //
CREATE PROCEDURE azuriraj_kolicinu_repromaterijala (IN p_id_repromaterijal INTEGER, IN p_tip_transakcije ENUM('ulaz', 'izlaz'), p_kolicina INTEGER)
BEGIN
	DECLARE repromaterijal_postoji, nova_kolicina INTEGER;
    
    SELECT COUNT(*) INTO repromaterijal_postoji
		FROM stanje_skladista_repromaterijala
        WHERE id_repromaterijal = p_id_repromaterijal;
	
    IF repromaterijal_postoji = 0 THEN
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
	CALL azuriraj_kolicinu_repromaterijala(new.id_repromaterijal, new.tip_transakcije, new.kolicina);
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER ad_skladiste_repromaterijal
	AFTER DELETE ON skladiste_repromaterijal
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_repromaterijala(old.id_repromaterijal, old.tip_transakcije, -old.kolicina); 
END //
DELIMITER ;


DELIMITER //
CREATE TRIGGER au_skladiste_repromaterijal
	AFTER UPDATE ON skladiste_repromaterijal
    FOR EACH ROW
BEGIN
	CALL azuriraj_kolicinu_repromaterijala(old.id_repromaterijal, old.tip_transakcije, -old.kolicina); 
    CALL azuriraj_kolicinu_repromaterijala(new.id_repromaterijal, new.tip_transakcije, new.kolicina);
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
(1, 'Kutija', 'Karton, dimenzije za 6 standardnih boca', 0.60),
(1, 'Kutija', 'Karton, dimenzije za 12 standardnih boca', 0.90),

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


SELECT * FROM repromaterijal;
INSERT INTO repromaterijal_proizvod (id_proizvod, id_repromaterijal)
VALUES
-- Zagorska Graševina (Berbe 1 i 2)
(1, 5), -- Boca 0.5 L za bijelo vino
(1, 3), -- Pluteni čep
(1, 14), -- Naljepnica za Zagorsku Graševinu 0.5 L
(2, 6), -- Boca 0.75 L za bijelo vino
(2, 3), -- Pluteni čep
(2, 15), -- Naljepnica za Zagorsku Graševinu 0.75 L
(3, 7), -- Boca 1.00 L za bijelo vino
(3, 3), -- Pluteni čep
(3, 16), -- Naljepnica za Zagorsku Graševinu 1.00 L
(4, 5), -- Boca 0.5 L za bijelo vino
(4, 3), -- Pluteni čep
(4, 14), -- Naljepnica za Zagorsku Graševinu 0.5 L
(5, 6), -- Boca 0.75 L za bijelo vino
(5, 3), -- Pluteni čep
(5, 15), -- Naljepnica za Zagorsku Graševinu 0.75 L
(6, 7), -- Boca 1.00 L za bijelo vino
(6, 3), -- Pluteni čep
(6, 16), -- Naljepnica za Zagorsku Graševinu 1.00 L

-- Zeleni Breg (Berbe 3 i 4)
(7, 5), -- Boca 0.5 L za bijelo vino
(7, 3), -- Pluteni čep
(7, 17), -- Naljepnica za Zeleni Breg 0.5 L
(8, 6), -- Boca 0.75 L za bijelo vino
(8, 3), -- Pluteni čep
(8, 18), -- Naljepnica za Zeleni Breg 0.75 L
(9, 7), -- Boca 1.00 L za bijelo vino
(9, 3), -- Pluteni čep
(9, 19), -- Naljepnica za Zeleni Breg 1.00 L
(10, 5), -- Boca 0.5 L za bijelo vino
(10, 3), -- Pluteni čep
(10, 17), -- Naljepnica za Zeleni Breg 0.5 L
(11, 6), -- Boca 0.75 L za bijelo vino
(11, 3), -- Pluteni čep
(11, 18), -- Naljepnica za Zeleni Breg 0.75 L
(12, 7), -- Boca 1.00 L za bijelo vino
(12, 3), -- Pluteni čep
(12, 19), -- Naljepnica za Zeleni Breg 1.00 L

-- Bijela Zvijezda (Berbe 5 i 6)
(13, 5), -- Boca 0.5 L za bijelo vino
(13, 3), -- Pluteni čep
(13, 20), -- Naljepnica za Bijelu Zvijezdu 0.5 L
(14, 6), -- Boca 0.75 L za bijelo vino
(14, 3), -- Pluteni čep
(14, 21), -- Naljepnica za Bijelu Zvijezdu 0.75 L
(15, 7), -- Boca 1.00 L za bijelo vino
(15, 3), -- Pluteni čep
(15, 22), -- Naljepnica za Bijelu Zvijezdu 1.00 L
(16, 5), -- Boca 0.5 L za bijelo vino
(16, 3), -- Pluteni čep
(16, 20), -- Naljepnica za Bijelu Zvijezdu 0.5 L
(17, 6), -- Boca 0.75 L za bijelo vino
(17, 3), -- Pluteni čep
(17, 21), -- Naljepnica za Bijelu Zvijezdu 0.75 L
(18, 7), -- Boca 1.00 L za bijelo vino
(18, 3), -- Pluteni čep
(18, 22), -- Naljepnica za Bijelu Zvijezdu 1.00 L

-- Ružičasti Horizont (Berbe 7 i 8)
(19, 11), -- Boca 0.5 L za rose vino
(19, 4), -- Sintetički čep
(19, 23), -- Naljepnica za Ružičasti Horizont 0.5 L
(20, 12), -- Boca 0.75 L za rose vino
(20, 4), -- Sintetički čep
(20, 24), -- Naljepnica za Ružičasti Horizont 0.75 L
(21, 13), -- Boca 1.00 L za rose vino
(21, 4), -- Sintetički čep
(21, 25), -- Naljepnica za Ružičasti Horizont 1.00 L
(22, 11), -- Boca 0.5 L za rose vino
(22, 4), -- Sintetički čep
(22, 23), -- Naljepnica za Ružičasti Horizont 0.5 L
(23, 12), -- Boca 0.75 L za rose vino
(23, 4), -- Sintetički čep
(23, 24), -- Naljepnica za Ružičasti Horizont 0.75 L
(24, 13), -- Boca 1.00 L za rose vino
(24, 4), -- Sintetički čep
(24, 25), -- Naljepnica za Ružičasti Horizont 1.00 L

-- Lagana Rosa (Berba 9)
(25, 11), -- Boca 0.5 L za rose vino
(25, 4), -- Sintetički čep
(25, 26), -- Naljepnica za Laganu Rosu 0.5 L
(26, 12), -- Boca 0.75 L za rose vino
(26, 4), -- Sintetički čep
(26, 27), -- Naljepnica za Laganu Rosu 0.75 L
(27, 13), -- Boca 1.00 L za rose vino
(27, 4), -- Sintetički čep
(27, 28), -- Naljepnica za Laganu Rosu 1.00 L

-- Crni Biser (Berba 10)
(28, 8), -- Boca 0.5 L za crno vino
(28, 3), -- Pluteni čep
(28, 29), -- Naljepnica za Crni Biser 0.5 L
(29, 9), -- Boca 0.75 L za crno vino
(29, 3), -- Pluteni čep
(29, 30), -- Naljepnica za Crni Biser 0.75 L
(30, 10), -- Boca 1.00 L za crno vino
(30, 3), -- Pluteni čep
(30, 31), -- Naljepnica za Crni Biser 1.00 L

-- Tamni Val (Berba 11)
(31, 8), -- Boca 0.5 L za crno vino
(31, 3), -- Pluteni čep
(31, 32), -- Naljepnica za Tamni Val 0.5 L
(32, 9), -- Boca 0.75 L za crno vino
(32, 3), -- Pluteni čep
(32, 33), -- Naljepnica za Tamni Val 0.75 L
(33, 10), -- Boca 1.00 L za crno vino
(33, 3), -- Pluteni čep
(33, 34); -- Naljepnica za Tamni Val 1.00 L


INSERT INTO zahtjev_za_narudzbu (id_kupac, id_zaposlenik, datum_zahtjeva, status_narudzbe)
VALUES
(15, 5, '2024-11-02', 'Završena'),
(7, 20, '2024-11-05', 'Završena'),
(19, 9, '2024-11-08', 'Završena'),
(2, 17, '2024-11-11', 'Završena'),
(25, 20, '2024-11-15', 'Završena'),
(12, 5, '2024-11-18', 'Završena'),
(6, 9, '2024-11-22', 'Završena'),
(30, 17, '2024-11-25', 'Završena'),
(3, 5, '2024-11-28', 'Završena'),
(9, 20, '2024-12-01', 'Završena'),
(22, 9, '2024-12-04', 'Završena'),
(10, 17, '2024-12-07', 'Završena'),
(5, 20, '2024-12-10', 'Završena'),
(27, 5, '2024-12-13', 'Završena'),
(1, 9, '2024-12-16', 'Završena'),
(28, 17, '2024-12-19', 'Završena'),
(16, 20, '2024-12-22', 'Završena'),
(4, 9, '2024-12-25', 'Završena'),
(21, 5, '2024-12-28', 'Završena'),
(18, 17, '2025-01-02', 'Primljena'),
(8, 9, '2025-01-03', 'Otkazana'),
(14, 5, '2025-01-04', 'Na čekanju'),
(26, 20, '2025-01-05', 'Završena'),
(29, 17, '2025-01-06', 'Poslana'),
(11, 9, '2025-01-07', 'Primljena'),
(13, 5, '2025-01-08', 'U obradi'),
(17, 20, '2025-01-09', 'Otkazana'),
(24, 17, '2025-01-10', 'Spremna za isporuku'),
(20, 9, '2025-01-11', 'Poslana'),
(23, 5, '2025-01-12', 'Primljena'),
(30, 20, '2025-01-13', 'U obradi'),
(19, 17, '2025-01-14', 'Na čekanju'),
(6, 9, '2025-01-14', 'Spremna za isporuku'),
(15, 5, '2025-01-15', 'Poslana'),
(7, 20, '2025-01-15', 'Primljena');


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
(28, 22, 710), (28, 6, 320), (28, 12, 290),

-- Narudžba 29
(29, 15, 280), (29, 26, 690), (29, 30, 740),

-- Narudžba 30
(30, 17, 670), (30, 25, 820), (30, 10, 310),

-- Narudžba 31
(31, 23, 290), (31, 13, 370), (31, 20, 720),

-- Narudžba 32
(32, 29, 730), (32, 16, 320), (32, 28, 780),

-- Narudžba 33
(33, 1, 310), (33, 4, 710),

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

SELECT * FROM skladiste_vino;
SELECT * FROM stanje_skladista_vina;

-- UPDATE skladiste_vino SET id_berba = 2 WHERE id = 1;
-- DELETE FROM skladiste_vino WHERE id = 1;


-------------------------------------------------------- LAURA 

INSERT INTO skladiste_repromaterijal (datum, id_repromaterijal, kolicina, tip_transakcije, lokacija)
SELECT p.pocetak_punjenja AS datum, rp.id_repromaterijal, SUM(p.kolicina) AS kolicina, 'izlaz' AS tip_transakcije, 'Skladište D' AS lokacija
	FROM Punjenje p
	JOIN Repromaterijal_proizvod rp ON p.id_proizvod = rp.id_proizvod
	GROUP BY p.pocetak_punjenja, rp.id_repromaterijal
UNION ALL
SELECT DATE_SUB(p.pocetak_punjenja, INTERVAL 2 WEEK) AS datum, rp.id_repromaterijal, SUM(p.kolicina) + ROUND(RAND(123) * 100 + 50) AS kolicina, 'ulaz' AS tip_transakcije, 'Skladište D' AS lokacija
	FROM Punjenje p
	JOIN Repromaterijal_proizvod rp ON p.id_proizvod = rp.id_proizvod
	GROUP BY p.pocetak_punjenja, rp.id_repromaterijal
	ORDER BY datum, id_repromaterijal;

    
INSERT INTO skladiste_proizvod (id_proizvod, datum, tip_transakcije, kolicina, lokacija)
SELECT id_proizvod, zavrsetak_punjenja AS datum, 'ulaz' AS tip_transakcije, kolicina, 'Skladište E' AS lokacija
	FROM punjenje
UNION ALL
SELECT sn.id_proizvod, DATE_ADD(zn.datum_zahtjeva, INTERVAL 7 DAY) AS datum, 'izlaz' AS tip_transakcije, sn.kolicina, 'Skladište E' AS lokacija
	FROM stavka_narudzbe sn
	JOIN zahtjev_za_narudzbu zn ON sn.id_zahtjev_za_narudzbu = zn.id
	WHERE zn.status_narudzbe IN ('Poslana', 'Završena')
	ORDER BY datum;


INSERT INTO zahtjev_za_nabavu (id_repromaterijal, kolicina, datum_zahtjeva, status_nabave, id_zaposlenik)
SELECT id_repromaterijal, kolicina, DATE_SUB(datum, INTERVAL 14 DAY) AS datum_zahtjeva, 'odobreno' AS status_nabave,
CASE 
	WHEN id % 3 = 1 THEN 4
	WHEN id % 3 = 2 THEN 10
	ELSE 14
END AS id_zaposlenik
	FROM skladiste_repromaterijal
	WHERE tip_transakcije = 'ulaz';


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
(1, 'KA9012CC', 'Stjepan Kovaček', '2024-11-15', '2024-11-15', 2050, 'Obavljen'),
(5, 'ZG3456DD', 'Josip Kovač', '2024-11-18', '2024-11-18', 2560, 'Obavljen'),
(3, 'KA7890EE', 'Ante Vuk', '2024-11-22', '2024-11-22', 260, 'Obavljen'),
(2, 'ZG1122FF', 'Krešimir Lončar', '2024-11-25', '2024-11-25', 1900, 'Obavljen'),
(6, 'ZG5566GG', 'Tomislav Radić', '2024-11-29', '2024-11-29', 2590, 'Obavljen'),
(1, 'KA9999HH', 'Fran Jurić', '2024-12-02', '2024-12-02', 1040, 'Obavljen'),
(5, 'ZG3333II', 'Filip Zadro', '2024-12-05', '2024-12-05', 2690, 'Obavljen'),
(2, 'ZG4444JJ', 'Hrvoje Bašić', '2024-12-08', '2024-12-08', 1030, 'Obavljen'),
(4, 'KA5555KK', 'Zoran Božić', '2024-12-11', '2024-12-11', 2640, 'Obavljen'),
(3, 'ZG6666LL', 'Tihomir Pavlović', '2024-12-14', '2024-12-14', 1460, 'Obavljen'),
(6, 'KA7777MM', 'Petar Krpan', '2024-12-17', '2024-12-17', 720, 'Obavljen'),
(4, 'ZG8888NN', 'Damir Vlašić', '2024-12-20', '2024-12-20', 1820, 'Obavljen'),
(5, 'ZG9999OO', 'Zvonimir Kovačić', '2024-12-23', '2024-12-23', 2970, 'Obavljen'),
(1, 'ZG1111PP', 'Ivica Barić', '2024-12-26', '2024-12-26', 1030, 'Obavljen'),
(2, 'KA2222QQ', 'Viktor Grgić', '2024-12-29', '2024-12-29', 1960, 'Obavljen'),
(6, 'ZG3333RR', 'Marin Škaro', '2025-01-01', '2025-01-01', 280, 'Obavljen'),
(4, 'ZG4444SS', 'Filip Marković', '2025-01-04', '2025-01-04', 1800, 'Obavljen'),
(5, 'ZG6666UU', 'Franjo Jurić', '2025-01-12', '2025-01-12', 330, 'Obavljen'),
(3, 'KA7777VV', 'Ante Vuk', '2025-01-13', NULL, 2660, 'U tijeku'),
(1, 'ZG8888WW', 'Zvonimir Kovačić', '2025-01-18', NULL, 1710, 'U tijeku'),
(2, 'ZG9999XX', 'Filip Marković', '2025-01-22', NULL, 2240, 'U tijeku');


INSERT INTO racun (id_zaposlenik, id_zahtjev_za_narudzbu, datum_racuna)
SELECT 16 AS id_zaposlenik, zzn.id AS id_zahtjev_za_narudzbu, DATE_ADD(zzn.datum_zahtjeva, INTERVAL 3 DAY) AS datum_racuna
	FROM zahtjev_za_narudzbu zzn
	WHERE zzn.status_narudzbe IN ('Spremna za isporuku', 'Poslana', 'Završena');


----------------------------------------------- VID
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



----------------------------------------------- DAVOR


-- trigger koji provjerava je li godina berbe ispravna (tekuća ili neka od prethodnih godina)


DELIMITER //
CREATE TRIGGER provjera_godine_berbe 
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

SELECT *
	FROM berba;
    
-- trigger koji ažurira ukupnu dostupnu količinu repromaterijala na stanju na temelju odobrenog zahtjeva za nabavu

DELIMITER //
CREATE TRIGGER au_azuriraj_kolicinu_repromaterijala
AFTER UPDATE ON zahtjev_za_nabavu
FOR EACH ROW
BEGIN
    IF NEW.status_nabave = 'odobreno' THEN
        UPDATE repromaterijal
        SET kolicina = kolicina + NEW.kolicina
        WHERE id = NEW.id_repromaterijal;
    END IF;
END//
DELIMITER ;


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

SELECT * FROM zahtjev_za_narudzbu;

CALL azuriraj_status_narudzbe(25, 'Na čekanju');


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

SELECT * FROM racun;

CALL generiraj_racun(1, 35);


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

SELECT broj_narudzbi_kupca(15);


-- Prikaz proizvoda i njihovih povezanih repromaterijala s ukupnim troškovima repromaterijala po proizvodu
CREATE VIEW proizvodni_troskovi AS
	SELECT 
		p.id AS proizvod_id,
		v.naziv,
		b.godina_berbe,
		p.cijena AS cijena_proizvoda, 
		SUM(r.jedinicna_cijena) AS ukupni_trosak_repromaterijala
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

SELECT * FROM proizvodni_troskovi;

SELECT * FROM repromaterijal;

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
    
SELECT * FROM zahtjev_za_nabavu;



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

Ažuriranje statusa zaposlenika nakon promjene njegove adrese

DELIMITER //

CREATE TRIGGER au_azuriraj_status_zaposlenika
AFTER UPDATE ON zaposlenik
FOR EACH ROW
BEGIN
    IF OLD.adresa <> NEW.adresa THEN
        UPDATE zaposlenik
        SET status_zaposlenika = 'aktivan'
        WHERE id = NEW.id AND status_zaposlenika != 'aktivan';
    END IF;
END//

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

