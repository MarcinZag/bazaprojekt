-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 04 Gru 2020, 22:34
-- Wersja serwera: 10.4.11-MariaDB
-- Wersja PHP: 7.4.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `baza_projekt`
--
CREATE DATABASE IF NOT EXISTS `baza_projekt` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `baza_projekt`;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `adres`
--

CREATE TABLE `adres` (
  `idadres` int(11) NOT NULL,
  `wojewodztwo` varchar(45) NOT NULL,
  `miasto` varchar(45) NOT NULL,
  `ulica` varchar(45) DEFAULT NULL,
  `kod-pocztowy` varchar(6) NOT NULL,
  `nr_domu` int(11) NOT NULL,
  `nr_mieszkania` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Zrzut danych tabeli `adres`
--

INSERT INTO `adres` (`idadres`, `wojewodztwo`, `miasto`, `ulica`, `kod-pocztowy`, `nr_domu`, `nr_mieszkania`) VALUES
(1, 'podkarpackie', 'leżajsk', 'długa', '37-300', 20, 0),
(2, 'podkarpackie', 'rzeszów', 'wincentego pola', '36-852', 10, 5),
(3, 'lubelskie', 'lublin', 'szara', '21-485', 4, 0),
(4, 'świetokrzyskie', 'kielce', 'główna', '12-845', 60, 4),
(5, 'malopolskie', 'kraków', 'powiśle', '32-951', 15, 0),
(6, 'lódzkie', 'lódź', 'centralna', '12-974', 20, 1),
(7, 'śląskie', 'katowice', 'targowa', '23-852', 35, 6),
(8, 'lubelskie', 'zamość', 'zamkowa', '21-951', 12, 0),
(9, 'malopolskie', 'tarnów', 'piękna', '56-912', 60, 0),
(10, 'śląskie', 'bytom', 'węglowa', '65-348', 3, 1),
(11, 'lódzkie', 'skierniewice', 'długa', '48-153', 45, 0),
(12, 'śląskie', 'mysłowice', 'warszawska', '12-347', 10, 6),
(13, 'świetokrzyskie', 'opatów', 'klasztorna', '40-001', 31, 0),
(14, 'lubelskie', 'kraśnik', 'targowa', '32-348', 2, 0),
(15, 'podkarpackie', 'nisko', 'szeroka', '34-300', 20, 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `do_doreczenia`
--

CREATE TABLE `do_doreczenia` (
  `iddo_doreczenia` int(11) NOT NULL,
  `nr` int(11) NOT NULL,
  `data` date NOT NULL,
  `czy_gotowa` varchar(1) COLLATE utf8_polish_ci NOT NULL,
  `opis` varchar(100) COLLATE utf8_polish_ci DEFAULT NULL,
  `idinformacjeoprzesylce` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci COMMENT='przesyłki przygotowywane i w trakcie doreczenie, jesli parametr ''czy_gotowa'' jest rowny ''t'' przesylka moze zostac odebrana przez kuriera do  dostarczenia';

--
-- Zrzut danych tabeli `do_doreczenia`
--

INSERT INTO `do_doreczenia` (`iddo_doreczenia`, `nr`, `data`, `czy_gotowa`, `opis`, `idinformacjeoprzesylce`) VALUES
(1, 10, '2020-11-15', 't', NULL, 1),
(2, 21, '2020-11-07', 't', NULL, 2),
(3, 22, '2020-11-08', 'n', NULL, 3),
(4, 23, '2020-10-29', 't', 'prosze w godzinach wieczornych', 4),
(5, 40, '2020-11-18', 'n', NULL, 5),
(6, 47, '2020-10-16', 't', 'prosze zostawic u sąsiada', 6),
(7, 50, '2020-11-20', 'n', NULL, 7);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `informacje_o_przesylce`
--

CREATE TABLE `informacje_o_przesylce` (
  `idinformacje_o_przesylce` int(11) NOT NULL,
  `idtowar` int(11) NOT NULL,
  `idnadawca` int(11) NOT NULL,
  `idodbiorca` int(11) NOT NULL,
  `idtypprzesylki` int(11) NOT NULL,
  `idkurier` int(11) NOT NULL,
  `czy_dostarczona` varchar(1) COLLATE utf8_polish_ci NOT NULL COMMENT 'jesli ''t'' to przesylka zostala dostarczona',
  `data_doreczenia` date DEFAULT NULL,
  `cena_przesylki` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `informacje_o_przesylce`
--

INSERT INTO `informacje_o_przesylce` (`idinformacje_o_przesylce`, `idtowar`, `idnadawca`, `idodbiorca`, `idtypprzesylki`, `idkurier`, `czy_dostarczona`, `data_doreczenia`, `cena_przesylki`) VALUES
(1, 1, 1, 9, 1, 3, 't', '0000-00-00', 25),
(2, 3, 2, 8, 3, 3, 't', '0000-00-00', 40),
(3, 4, 3, 7, 3, 2, 't', '2020-12-04', 40),
(4, 2, 4, 6, 2, 6, 't', '2020-11-03', 20),
(5, 5, 5, 4, 1, 3, 't', '0000-00-00', 25),
(6, 9, 1, 8, 4, 4, 't', '2020-10-20', 10),
(7, 7, 4, 9, 4, 2, 't', '2020-12-04', 10);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `klient`
--

CREATE TABLE `klient` (
  `idklient` int(11) NOT NULL,
  `imie` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `nazwisko` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `idadres` int(11) NOT NULL,
  `telefon` varchar(12) COLLATE utf8_polish_ci NOT NULL,
  `email` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `ilosc_nadanych_przesylek` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `klient`
--

INSERT INTO `klient` (`idklient`, `imie`, `nazwisko`, `idadres`, `telefon`, `email`, `ilosc_nadanych_przesylek`) VALUES
(1, 'Marcin', 'Zagaja', 1, '258963147', 'mail@gmail.com', 15),
(2, 'Jan', 'Nnowak', 4, '654123985', 'jann@o2.pl', 3),
(3, 'Piotr', 'Nowacki', 5, '123674597', 'pnowacki@wp.pl', 0),
(4, 'Artur', 'Kowalski', 7, '963258741', 'kowalski@gmail.com', 1),
(5, 'Aneta', 'Malec', 8, '456321789', 'malec@o2.pl', 1),
(6, 'Dominik', 'Polak', 9, '789645123', 'dompol@wp.pl', 10),
(7, 'Jan', 'Bąk', 13, '123456789', 'janb@wp.pl', 20),
(8, 'Marek', 'Nowak', 14, '954123137', 'nowak@gmail.com', 1),
(9, 'Krzysztof', 'Kowalczyk', 15, '123645789', 'krzysztof@o2.pl', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `kurier`
--

CREATE TABLE `kurier` (
  `idkurier` int(11) NOT NULL,
  `imie` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `nazwisko` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `idadres` int(11) NOT NULL,
  `telefon` varchar(12) COLLATE utf8_polish_ci NOT NULL,
  `email` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `czy_wolny` varchar(1) COLLATE utf8_polish_ci NOT NULL COMMENT 'jesli ''n'' to kurier dostarcza przesyłke, jeśli ''t'' kurier jest wolny',
  `ilosc_dostarczonych_przesylek` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `kurier`
--

INSERT INTO `kurier` (`idkurier`, `imie`, `nazwisko`, `idadres`, `telefon`, `email`, `czy_wolny`, `ilosc_dostarczonych_przesylek`) VALUES
(1, 'Adam', 'Pelc', 2, '456789331', 'adamkurier@o2.pl', 't', 2),
(2, 'Jeży', 'Wielki', 3, '123456987', 'wielkij@gmail.com', 't', 30),
(3, 'Jan', 'Nowakowski', 6, '987456312', 'jan@wp.pl', 'n', 13),
(4, 'Artur', 'Broniarz', 10, '123456654', 'arturb@wp.pl', 'n', 2),
(5, 'Krystian', 'Kowal', 11, '645312789', 'kowal@o2.pl', 'n', 1),
(6, 'Janusz', 'Milewicz', 12, '157412369', 'januszm@gmail.com', 'n', 6);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `towar`
--

CREATE TABLE `towar` (
  `idtowar` int(11) NOT NULL,
  `nazwa` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `ilosc` int(11) NOT NULL,
  `waga_jednej_szt` double NOT NULL COMMENT 'waga w kg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `towar`
--

INSERT INTO `towar` (`idtowar`, `nazwa`, `ilosc`, `waga_jednej_szt`) VALUES
(1, 'iphone x', 2, 1),
(2, 'jabłka', 2, 5),
(3, 'rower', 2, 20),
(4, 'opoy', 3, 10),
(5, 'telefon', 1, 1),
(6, 'laptop', 1, 3),
(7, 'koło samochodowe', 2, 10),
(8, 'elektronika', 2, 2),
(9, 'dokumenty', 1, 3),
(10, 'ubrania', 1, 8),
(12, 'japko', 10, 1),
(13, 'Telefon', 2, 2);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `typ_przesylki`
--

CREATE TABLE `typ_przesylki` (
  `idtyp_przesylki` int(11) NOT NULL,
  `nazwa` varchar(45) COLLATE utf8_polish_ci NOT NULL,
  `cena` double NOT NULL,
  `przewidywany_czas_dostawy` int(11) NOT NULL COMMENT 'czas w dniach',
  `waga_max` int(11) NOT NULL COMMENT 'waga w kg'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `typ_przesylki`
--

INSERT INTO `typ_przesylki` (`idtyp_przesylki`, `nazwa`, `cena`, `przewidywany_czas_dostawy`, `waga_max`) VALUES
(1, 'szybka', 25, 2, 5),
(2, 'duza', 20, 5, 15),
(3, 'mega', 80, 10, 300),
(4, 'ekonomiczna', 10, 5, 20);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `adres`
--
ALTER TABLE `adres`
  ADD PRIMARY KEY (`idadres`);

--
-- Indeksy dla tabeli `do_doreczenia`
--
ALTER TABLE `do_doreczenia`
  ADD PRIMARY KEY (`iddo_doreczenia`,`idinformacjeoprzesylce`),
  ADD KEY `idinformacjeoprzesylce` (`idinformacjeoprzesylce`);

--
-- Indeksy dla tabeli `informacje_o_przesylce`
--
ALTER TABLE `informacje_o_przesylce`
  ADD PRIMARY KEY (`idinformacje_o_przesylce`,`idtowar`,`idnadawca`,`idodbiorca`,`idtypprzesylki`,`idkurier`),
  ADD KEY `idnadawca` (`idnadawca`),
  ADD KEY `idtypprzesylki` (`idtypprzesylki`),
  ADD KEY `idtowar` (`idtowar`),
  ADD KEY `informacje_o_przesylce_ibfk_1` (`idkurier`);

--
-- Indeksy dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD PRIMARY KEY (`idklient`,`idadres`),
  ADD KEY `idadres` (`idadres`);

--
-- Indeksy dla tabeli `kurier`
--
ALTER TABLE `kurier`
  ADD PRIMARY KEY (`idkurier`,`idadres`),
  ADD KEY `idadres` (`idadres`);

--
-- Indeksy dla tabeli `towar`
--
ALTER TABLE `towar`
  ADD PRIMARY KEY (`idtowar`);

--
-- Indeksy dla tabeli `typ_przesylki`
--
ALTER TABLE `typ_przesylki`
  ADD PRIMARY KEY (`idtyp_przesylki`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT dla tabeli `adres`
--
ALTER TABLE `adres`
  MODIFY `idadres` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT dla tabeli `do_doreczenia`
--
ALTER TABLE `do_doreczenia`
  MODIFY `iddo_doreczenia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT dla tabeli `informacje_o_przesylce`
--
ALTER TABLE `informacje_o_przesylce`
  MODIFY `idinformacje_o_przesylce` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT dla tabeli `klient`
--
ALTER TABLE `klient`
  MODIFY `idklient` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT dla tabeli `kurier`
--
ALTER TABLE `kurier`
  MODIFY `idkurier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT dla tabeli `towar`
--
ALTER TABLE `towar`
  MODIFY `idtowar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT dla tabeli `typ_przesylki`
--
ALTER TABLE `typ_przesylki`
  MODIFY `idtyp_przesylki` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `do_doreczenia`
--
ALTER TABLE `do_doreczenia`
  ADD CONSTRAINT `do_doreczenia_ibfk_1` FOREIGN KEY (`idinformacjeoprzesylce`) REFERENCES `informacje_o_przesylce` (`idinformacje_o_przesylce`);

--
-- Ograniczenia dla tabeli `informacje_o_przesylce`
--
ALTER TABLE `informacje_o_przesylce`
  ADD CONSTRAINT `informacje_o_przesylce_ibfk_2` FOREIGN KEY (`idnadawca`) REFERENCES `klient` (`idklient`),
  ADD CONSTRAINT `informacje_o_przesylce_ibfk_3` FOREIGN KEY (`idtypprzesylki`) REFERENCES `typ_przesylki` (`idtyp_przesylki`),
  ADD CONSTRAINT `informacje_o_przesylce_ibfk_4` FOREIGN KEY (`idtowar`) REFERENCES `towar` (`idtowar`);

--
-- Ograniczenia dla tabeli `klient`
--
ALTER TABLE `klient`
  ADD CONSTRAINT `klient_ibfk_1` FOREIGN KEY (`idadres`) REFERENCES `adres` (`idadres`);

--
-- Ograniczenia dla tabeli `kurier`
--
ALTER TABLE `kurier`
  ADD CONSTRAINT `kurier_ibfk_1` FOREIGN KEY (`idadres`) REFERENCES `adres` (`idadres`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
