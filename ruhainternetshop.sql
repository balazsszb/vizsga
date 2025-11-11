CREATE DATABASE IF NOT EXISTS `ruha_webshop`
  DEFAULT CHARACTER SET utf8
  COLLATE utf8_hungarian_ci;

USE `ruha_webshop`;

CREATE TABLE `felhasznalok` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nev` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `jelszo` VARCHAR(255) NOT NULL,
  `cim` VARCHAR(255) DEFAULT NULL,
  `telefon` VARCHAR(20) DEFAULT NULL,
  `regisztracio_datuma` DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

CREATE TABLE `kategoriak` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nev` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;


CREATE TABLE `termekek` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `nev` VARCHAR(150) NOT NULL,
  `leiras` TEXT,
  `ar` INT(11) NOT NULL,
  `marka` VARCHAR(100) DEFAULT NULL,
  `meret` VARCHAR(10) DEFAULT NULL,
  `szin` VARCHAR(50) DEFAULT NULL,
  `keszlet` INT(11) DEFAULT 0,
  `kategori_id` INT(11) DEFAULT NULL,
  `kep` VARCHAR(255) DEFAULT NULL,
  `akcios_ar` INT(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kategori_id` (`kategori_id`),
  CONSTRAINT `termekek_ibfk_1` FOREIGN KEY (`kategori_id`) REFERENCES `kategoriak` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;


CREATE TABLE `kivansaglista` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `felhasznalo_id` INT(11) NOT NULL,
  `termek_id` INT(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `felhasznalo_id` (`felhasznalo_id`),
  KEY `termek_id` (`termek_id`),
  CONSTRAINT `kivansaglista_ibfk_1` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`id`) ON DELETE CASCADE,
  CONSTRAINT `kivansaglista_ibfk_2` FOREIGN KEY (`termek_id`) REFERENCES `termekek` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;


CREATE TABLE `rendelesek` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `felhasznalo_id` INT(11) DEFAULT NULL,
  `datum` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `allapot` ENUM('Folyamatban','Kiszállítva','Törölve') DEFAULT 'Folyamatban',
  `osszeg` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `felhasznalo_id` (`felhasznalo_id`),
  CONSTRAINT `rendelesek_ibfk_1` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;


CREATE TABLE `rendeles_tetelek` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `rendeles_id` INT(11) NOT NULL,
  `termek_id` INT(11) NOT NULL,
  `mennyiseg` INT(11) DEFAULT 1,
  `ar` INT(11) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `rendeles_id` (`rendeles_id`),
  KEY `termek_id` (`termek_id`),
  CONSTRAINT `rendeles_tetelek_ibfk_1` FOREIGN KEY (`rendeles_id`) REFERENCES `rendelesek` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rendeles_tetelek_ibfk_2` FOREIGN KEY (`termek_id`) REFERENCES `termekek` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;


CREATE TABLE `adminok` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `felhasznalo_id` INT(11) NOT NULL,
  `jogosultsag_szint` ENUM('Termékkezelés','Rendeléskezelés','Teljes hozzáférés') DEFAULT 'Termékkezelés',
  PRIMARY KEY (`id`),
  KEY `felhasznalo_id` (`felhasznalo_id`),
  CONSTRAINT `adminok_ibfk_1` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_hungarian_ci;

INSERT INTO `kategoriak` (`nev`) VALUES
('Férfi Ruházat'),
('Női Ruházat'),
('Cipők'),
('Kiegészítők');

INSERT INTO `felhasznalok` (`nev`, `email`, `jelszo`, `cim`, `telefon`) VALUES
('Kovács Dániel', 'kovacs.daniel@example.com', 'titkos123', 'Budapest, Andrássy út 15.', '06201234567'),
('Szabó Eszter', 'szabo.eszter@example.com', 'jelszo456', 'Debrecen, Piac utca 8.', '06301234567');

INSERT INTO `termekek` (`nev`, `leiras`, `ar`, `marka`, `meret`, `szin`, `keszlet`, `kategori_id`, `kep`, `akcios_ar`) VALUES
('Nike Air Max 270', 'Kényelmes sportcipő modern dizájnnal', 39990, 'Nike', '42', 'Fekete', 10, 3, 'nike_airmax270.jpg', 34990),
('Adidas Hoodie', 'Puha pamut pulóver kapucnival', 19990, 'Adidas', 'M', 'Szürke', 15, 1, 'adidas_hoodie.jpg', NULL),
('Tommy Hilfiger Póló', 'Márkás rövidujjú póló logóval', 14990, 'Tommy Hilfiger', 'L', 'Fehér', 20, 1, 'tommy_polo.jpg', 12990),
('Guess Női Táska', 'Stílusos női táska arany díszítéssel', 29990, 'Guess', NULL, 'Piros', 8, 4, 'guess_taska.jpg', 24990);

INSERT INTO `rendelesek` (`felhasznalo_id`, `osszeg`) VALUES
(1, 54980);

INSERT INTO `rendeles_tetelek` (`rendeles_id`, `termek_id`, `mennyiseg`, `ar`) VALUES
(1, 1, 1, 34990),
(1, 3, 1, 19990);
