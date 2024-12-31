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
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_Repromaterijal INT NOT NULL,
    kolicina INT NOT NULL,
    datum_zahtjeva DATETIME NOT NULL,
    status ENUM('u obradi', 'odobreno', 'odbijeno') NOT NULL,
    id_zaposlenik INT NOT NULL,
    FOREIGN KEY (id_Repromaterijal) REFERENCES Repromaterijal(id),
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

