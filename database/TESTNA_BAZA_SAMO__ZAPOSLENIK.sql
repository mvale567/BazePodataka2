DROP DATABASE IF EXISTS TEST_vinarija;
CREATE DATABASE TEST_vinarija;
USE TEST_vinarija;

-- Prvo kreiraj tablicu Odjel
CREATE TABLE Odjel (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    broj_zaposlenika INT NOT NULL
);

-- Sada kreiraj tablicu Zaposlenik (nakon Odjela)
CREATE TABLE zaposlenik (
    id INT PRIMARY KEY AUTO_INCREMENT,
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

-- Unesi podatke u Odjel tablicu
INSERT INTO Odjel (naziv, broj_zaposlenika) 
VALUES 
('Prodaja', 5),
('Proizvodnja', 15),
('Marketing', 3),
('Logistika', 8),
('Kontrola kvalitete', 6), 
('IT podrška', 4), 
('Administracija', 18), 
('Nabava', 20), 
('Računovodstvo', 8);


SELECT * FROM Odjel;

-- Unesi podatke u Zaposlenik tablicu
INSERT INTO zaposlenik (id_odjel, ime, prezime, adresa, email, telefon, datum_zaposlenja, status_zaposlenika)
VALUES
(1, 'Marko', 'Kovačić', 'Široka ulica 5, Split', 'marko.kovacic@email.com', '0956781234', '2023-06-15', 'aktivan'),
(2, 'Ivana', 'Marić', 'Trg slobode 10, Rijeka', 'ivana.maric@email.com', '0991234567', '2022-03-01', 'aktivan'),
(4, 'Luka', 'Barišić', 'Zeleno polje 4, Osijek', 'luka.barisic@email.com', '0976543210', '2021-11-15', 'aktivan'),
(3, 'Maja', 'Knežević', 'Maslina 7, Karlovac', 'maja.knezevic@email.com', '0915678901', '2023-01-20', 'aktivan'),
(5, 'Tomislav', 'Kralj', 'Mirna ulica 2, Zagreb', 'tomislav.kralj@email.com', '0981122334', '2020-05-15', 'aktivan'),
(6, 'Hrvoje', 'Pavić', 'Riva 3, Split', 'hrvoje.pavic@email.com', '0915567788', '2021-10-10', 'aktivan'),
(7, 'Lidija', 'Mandić', 'Gajeva 7, Rijeka', 'lidija.mandic@email.com', '0923344556', '2019-04-20', 'aktivan'),
(8, 'Petar', 'Marković', 'Vlaška 10, Zagreb', 'petar.markovic@firma.hr', '+385915672341', '2022-02-15', 'aktivan'),
(9, 'Ana', 'Novak', 'Perivoj 8, Split', 'ana.novak@firma.hr', '+385914568123', '2023-07-10', 'aktivan');







SELECT * FROM zaposlenik
