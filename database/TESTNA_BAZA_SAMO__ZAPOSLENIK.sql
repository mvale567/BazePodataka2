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
(9, 'Ana', 'Novak', 'Perivoj 8, Split', 'ana.novak@firma.hr', '+385914568123', '2023-07-10', 'aktivan'),
(1, 'Luka', 'Vuković', 'Kneza Branimira 5, Rijeka', 'luka.vukovic@firma.hr', '+385913456789', '2020-09-05', 'aktivan'),
(2, 'Katarina', 'Horvat', 'Dubravska 3, Dubrovnik', 'katarina.horvat@firma.hr', '+385912345678', '2021-05-30', 'aktivan'),
(4, 'Dino', 'Petrović', 'Sjenjak 2, Osijek', 'dino.petrovic@firma.hr', '+385918901234', '2022-10-12', 'aktivan'),
(3, 'Ema', 'Jurić', 'Vukovarska 7, Zagreb', 'ema.juric@firma.hr', '+385919876543', '2023-03-08', 'aktivan'),
(5, 'Filip', 'Knežević', 'Palmotićeva 4, Split', 'filip.knezevic@firma.hr', '+385916754321', '2020-12-25', 'aktivan'),
(6, 'Maja', 'Tomić', 'Frankopanska 6, Rijeka', 'maja.tomic@firma.hr', '+385914567890', '2021-04-15', 'aktivan'),
(7, 'Nikola', 'Grgić', 'Put Sv. Roka 9, Dubrovnik', 'nikola.grgic@firma.hr', '+385912346789', '2019-11-03', 'aktivan'),
(8, 'Tina', 'Šarić', 'Trg Ivana Pavla 1, Osijek', 'tina.saric@firma.hr', '+385918234567', '2022-06-20', 'aktivan'),
(9, 'Karlo', 'Lovrić', 'Savska 11, Zagreb', 'karlo.lovric@firma.hr', '+385919123876', '2021-02-17', 'aktivan'),
(1, 'Marin', 'Vidović', 'Šetalište Bačvice 15, Split', 'marin.vidovic@firma.hr', '+385915673219', '2023-08-11', 'aktivan'),
(2, 'Iva', 'Babić', 'Križanićeva 8, Rijeka', 'iva.babic@firma.hr', '+385913421678', '2020-10-05', 'aktivan'),
(4, 'Lucija', 'Pavlović', 'Pera Čingrije 14, Dubrovnik', 'lucija.pavlovic@firma.hr', '+385912437658', '2021-07-29', 'aktivan'),
(3, 'Petra', 'Matković', 'Rokova 12, Osijek', 'petra.matkovic@firma.hr', '+385918234987', '2019-09-15', 'aktivan'),
(5, 'Ante', 'Božić', 'Jankomir 13, Zagreb', 'ante.bozic@firma.hr', '+385919654123', '2020-03-21', 'aktivan'),
(6, 'Andrija', 'Krpan', 'Istarska 10, Split', 'andrija.krpan@firma.hr', '+385916321789', '2021-12-11', 'aktivan'),
(7, 'Marina', 'Mikulić', 'Adamićeva 17, Rijeka', 'marina.mikulic@firma.hr', '+385914567312', '2022-01-25', 'aktivan'),
(8, 'Filip', 'Blažević', 'Ante Topića 18, Dubrovnik', 'filip.blazevic@firma.hr', '+385912348765', '2023-05-03', 'aktivan'),
(9, 'Katarina', 'Perić', 'Radnička 19, Osijek', 'katarina.peric@firma.hr', '+385918320456', '2021-08-14', 'aktivan'),
(1, 'Marta', 'Klarić', 'Novaka Radonića 20, Zagreb', 'marta.klaric@firma.hr', '+385919123754', '2022-11-09', 'aktivan'),
(2, 'Dora', 'Barbir', 'Kralja Zvonimira 22, Split', 'dora.barbir@firma.hr', '+385915789012', '2023-04-07', 'aktivan'),
(4, 'Tina', 'Jakšić', 'Svačićeva 25, Rijeka', 'tina.jaksic@firma.hr', '+385913476590', '2020-06-18', 'aktivan');






SELECT * FROM 
