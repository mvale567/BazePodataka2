DROP DATABASE IF EXISTS vinarija;
CREATE DATABASE vinarija;
USE vinarija;

CREATE TABLE Skladiste_proizvod (
    id INT PRIMARY KEY,
    id_proizvod INT,
    datum DATETIME,
    tip_transakcije ENUM('ulaz', 'izlaz') NOT NULL,
    kolicina INT NOT NULL,
    lokacija VARCHAR(50),
    FOREIGN KEY (id_proizvod) REFERENCES Proizvod(id)
);

CREATE TABLE Zahtjev_za_nabavu (
    id INT PRIMARY KEY,
    id_kupac INT,
    id_zaposlenik INT,
    datum_zahtjeva DATETIME,
    ukupni_iznos DECIMAL(10, 2),
    status_zahtjeva VARCHAR(30),
    FOREIGN KEY (id_kupac) REFERENCES Kupac(id),
    FOREIGN KEY (id_zaposlenik) REFERENCES Zaposlenik(id)
);

CREATE TABLE Dobavljac (
    id INT PRIMARY KEY,
    naziv VARCHAR(50),
    adresa VARCHAR(50),
    email VARCHAR(50),
    telefon VARCHAR(20),
    oib CHAR(11) UNIQUE
);

