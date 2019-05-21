drop table oddzialy;
drop table pracownicy;
drop table lekarze;
drop table skierowania;
drop table zabiegi;
drop table pensje;
drop table godziny;
drop table pacjenci;
drop table lozka;
drop table przedmioty;
drop table zuzyte;
drop table testy;
drop table zabiegi_lekarze;
drop table wizyty;


create table pracownicy(
	id_pracownika INTEGER primary key AUTOINCREMENT, 
	imie TEXT NOT NULL, 
	nazwisko TEXT NOT NULL, 
	id_oddzialu INTEGER, 
	stanowisko TEXT, 
	id_pensji INTEGER NOT NULL,
foreign key(id_oddzialu) REFERENCES oddzialy(id_oddzialu),
foreign key(id_pensji) REFERENCES pensje(id_pensji),
CHECK(stanowisko IN ('lekarz', 'ordynator', 'oddzialowa', 'technik'))
);

create table oddzialy(
	id_oddzialu INTEGER primary key AUTOINCREMENT, 
	numer INTEGER NOT NULL,
	nazwa TEXT NOT NULL, 
	id_oddzialowej INTEGER, 
foreign key(id_oddzialowej) REFERENCES pracownicy(id_pracownika),
CHECK(nazwa IN ('chirurgiczny', 'pediatryczny','ortopedyczny', 'kardiologiczny', 'neurologiczny', 'polozniczo-ginekologiczny', 'psychiatryczny', 'dermatologiczny', 'okulistyczny', 'przychodnia'))
);

create table lekarze(
	id_lekarza INTEGER NOT NULL, 
	specjalnosc TEXT NOT NULL, 
	telefon INTEGER NOT NULL,
	id_ordynatora INTEGER NOT NULL, 
foreign key(id_lekarza) REFERENCES pracownicy(id_pracownika),
foreign key(id_ordynatora) REFERENCES pracownicy(id_pracownika),
CHECK(specjalnosc in ('chirurg', 'pediatra', 'ortopeda', 'kardiolog', 'neurolog', 'ginekolog', 'psychiatra', 'dermatolog', 'okulista', 'internista')),
CHECK(length(telefon>=10))
);

create table skierowania(
	id_pacjenta INTEGER NOT NULL, 
	id_lekarza INTEGER NOT NULL, 
foreign key(id_pacjenta) REFERENCES pacjenci(id_pacjenta),
foreign key(id_lekarza) REFERENCES pracownicy(id_pracownika)
);

create table zabiegi(
	id_zabiegu INTEGER primary key AUTOINCREMENT, 
	nazwa TEXT NOT NULL,
	id_pacjenta INTEGER NOT NULL, 
	data_leczenia INTEGER NOT NULL, 
	czas_leczenia INTEGER real NOT NULL, 
	wyniki TEXT NOT NULL,
foreign key(id_pacjenta) REFERENCES pacjenci(id_pacjenta)
);

create table zabiegi_lekarze(
	id_zabiegu INTEGER NOT NULL,
	id_lekarza INTEGER NOT NULL,
foreign key(id_zabiegu) REFERENCES zabiegi(id_zabiegu),
foreign key(id_lekarza) REFERENCES pracownicy(id_pracownika)
);

create table pensje(
	id_pensji INTEGER primary key AUTOINCREMENT,  
	wysokosc INTEGER real NOT NULL,
	rodzaj TEXT NOT NULL,
CHECK(rodzaj in ('stala', 'miesieczna', 'godzinowa'))
);

create table godziny(
	id_pracownika INTEGER NOT NULL, 
	id_oddzialu INTEGER NOT NULL, 
	liczba_godzin INTEGER real NOT NULL,
foreign key(id_pracownika) REFERENCES pracownicy(id_pracownika),
foreign key(id_oddzialu) REFERENCES oddzialy(id_oddzialu)
);

create table lozka(
	id_lozka INTEGER primary key AUTOINCREMENT,
	id_oddzialu INTEGER NOT NULL,
	nr_pokoju INTEGER real NOT NULL,
foreign key(id_oddzialu) REFERENCES oddzialy(id_oddzialu)
);

create table pacjenci(
	id_pacjenta INTEGER primary key AUTOINCREMENT, 
	imie TEXT NOT NULL, 
	nazwisko TEXT NOT NULL, 
	status TEXT NOT NULL, 
	adres TEXT, 
	krewny TEXT NOT NULL, 
	id_lozka INTEGER,
	choroba TEXT,
	data_urodzenia INTEGER NOT NULL,
CHECK(status in ('ambulatoryjny', 'przyjety')),
foreign key(id_lozka) REFERENCES lozka(id_lozka)
);

create table przedmioty(
	rodzaj TEXT NOT NULL,
	id_przedmiotu INTEGER primary key AUTOINCREMENT, 
	nazwa TEXT NOT NULL,
	koszt_jednostkowy INTEGER real NOT NULL,
CHECK(rodzaj in ('srodek', 'medyczny', 'chirurgiczny', 'lek'))
);

create table zuzyte(
	id_przedmiotu INTEGER NOT NULL, 
	id_pacjenta INTEGER NOT NULL,
	ilosc INTEGER real NOT NULL,
	data INTEGER NOT NULL,
	godzina INTEGER NOT NULL,
	koszt_jednostkowy INTEGER real NOT NULL,
	koszt_calkowity INTEGER real,
foreign key(id_przedmiotu) REFERENCES przedmioty(id_przedmiotu),
foreign key(id_pacjenta) REFERENCES pacjenci(id_pacjenta)
);

create table testy(
	id_technika INTEGER NOT NULL,
	id_pacjenta INTEGER NOT NULL,
	id_testu INTEGER primary key AUTOINCREMENT,
	nazwa TEXT NOT NULL,
	numer INTEGER NOT NULL,
	data INTEGER NOT NULL,
	wynik TEXT NOT NULL,
foreign key(id_technika) REFERENCES pracownicy(id_pracownika),
foreign key(id_pacjenta) REFERENCES pacjenci(id_pacjenta)
);

create table wizyty(
	id_pacjenta INTEGER NOT NULL,
	id_lekarza INTEGER NOT NULL,
	id_wizyty INTEGER primary key AUTOINCREMENT,
	data INTEGER NOT NULL,
foreign key(id_pacjenta) REFERENCES pacjenci(id_pacjenta),
foreign key(id_lekarza) REFERENCES pracownicy(id_pracownika)
);

insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Jan', 'Kowalski', 1, 'lekarz', 1);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Józek', 'Ziutek', 1, 'ordynator', 2);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Eustacha', 'Eustachiewicz', 1, 'oddzialowa', 3);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Tomasz', 'Duda', 1, 'technik', 4);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Jon', 'Snow', 2, 'lekarz', 5);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Benedykt', 'Ogórek', 2, 'ordynator', 6);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Zofia', 'Bąbelek', 2, 'oddzialowa', 7);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Mariusz', 'Miś', 2, 'technik', 8);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Teresa', 'Guzik', 3, 'lekarz', 9);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Gucio', 'Gucio', 3, 'ordynator', 10);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Gustaw', 'Guściński', 3, 'oddzialowa', 11);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Placek', 'Naleśnik', 3, 'technik', 12);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Teofilia', 'Telefon', 4, 'lekarz', 13);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Eugenia', 'Łazanki', 4, 'ordynator', 14);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Brutus', 'Zdrada', 4, 'oddzialowa', 15);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Florek', 'Akwarium', 4, 'technik', 16);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Dżesika', 'Janusz', 5, 'lekarz', 17);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Jacek', 'Wróbel', 5, 'ordynator', 18);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Brygida', 'Dzida', 5, 'oddzialowa', 19);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Zenobia', 'Kasza', 5, 'technik', 20);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Chińczyk', 'Bateryjka', 6, 'lekarz', 21);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Franklin', 'Żółwik', 6, 'ordynator', 22);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Stefan', 'Odkurzacz', 6, 'oddzialowa', 23);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Pony', 'Jednorożec', 6, 'technik', 24);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Tadek', 'Tadeusz', 7, 'lekarz', 25);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Arnold', 'Boczek', 7, 'ordynator', 26);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Felicja', 'Felga', 7, 'oddzialowa', 27);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Rudolf', 'Renifer', 7, 'technik', 28);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Cecylia', 'Bulwa', 8, 'lekarz', 29);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Maniek', 'Kangur', 8, 'ordynator', 30);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Cezary', 'Bułka', 8, 'oddzialowa', 31);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Kleopatra', 'Winogrono', 8, 'technik', 32);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Karina', 'Żuchwa', 9, 'lekarz', 33);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Bronisława', 'Rzepa', 9, 'ordynator', 34);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Wacław', 'Szuflada', 9, 'oddzialowa', 35);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Makaron', 'Spaghetti', 9, 'technik', 36);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Edward', 'Nożycoręki', 1, 'lekarz', 37);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Tekla', 'Pająk', 10, 'lekarz', 38);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Sam', 'Samuel', 10, 'lekarz', 39);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Gąska', 'Gąska', 10, 'lekarz', 40);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Ekler', 'Ciastko', 10, 'oddzialowa', 41);
insert into pracownicy(imie, nazwisko, id_oddzialu, stanowisko, id_pensji) VALUES ('Gregory', 'House', 10, 'ordynator', 42);

insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (1, 'chirurgiczny', 3);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (2, 'pediatryczny', 7);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (3, 'ortopedyczny', 11);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (4, 'kardiologiczny', 15);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (5, 'neurologiczny', 19);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (6, 'polozniczo-ginekologiczny', 23);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (7, 'psychiatryczny', 27);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (8, 'dermatologiczny', 31);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (9, 'okulistyczny', 35);
insert into oddzialy(numer, nazwa, id_oddzialowej) VALUES (10, 'przychodnia', 41);

insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (1, 'chirurg', 1234567890, 2);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (37, 'chirurg', 9012345678, 2);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (5, 'pediatra', 0987654321, 6 );
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (9, 'ortopeda', 2345678901, 10);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (13, 'kardiolog', 3456789012, 14);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (17, 'neurolog', 4567890123, 18);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (21, 'ginekolog', 5678901234, 22);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (25, 'psychiatra', 6789012345, 26);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (29, 'dermatolog', 7890123456, 30);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (33, 'okulista', 8901234567, 31);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (38, 'internista', 7363525241, 42);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (39, 'internista', 7890873456, 42);
insert into lekarze(id_lekarza, specjalnosc, telefon, id_ordynatora) VALUES (40, 'internista', 0401234567, 42);

insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Fenek', 'Lis', 'przyjety', 'Suchy Las, Leśna 12', 'Uszatek Miś', 4, 'cukrzyca',  date('1991-12-21'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Brukselka', 'Zielonka', 'ambulatoryjny', 'Zupa, Warzywna 8', 'Por Pietruszewski', NULL, NULL, date('1996-02-01'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Kubuś', 'Puchatek', 'przyjety', 'Stumilowy Las, 100', 'Prosiaczek', 35, 'schizofrenia', date('1975-10-20'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Sherlock', 'Holmes', 'przyjety', 'Baker Street 221B', 'Watson', 34, 'socjopatia', date('1854-01-01'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Jack', 'Sparrow', 'ambulatoryjny', 'Czarna Perła', 'Davy Jones', NULL, 'szkorbut', date('1961-10-21'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Rachel', 'Green', 'ambulatoryjny', 'Central Perk', 'Monica Geller', NULL, 'zakupoholizm', date('1984-08-15'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Monitor', 'Ledowy', 'przyjety', 'Biurko, Biurowa', 'Muszka Bezprzewodowa', 41, 'zaćma', date('2013-12-21'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Pinky', 'Pinky', 'przyjety', 'Klatka 4', 'Mózg', 25, 'guz mózgu', date('1995-03-13'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Harry', 'Potter', 'ambulatoryjny', 'Privet Drive 4', 'Ron Weasley', NULL, NULL, date('1980-07-31'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Kevin', 'McCallister', 'przyjety', 'Sam w domu', 'Harry', 6, 'cukrzyca', date('2010-09-31'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Brad', 'Pitt', 'przyjety', 'Troja', 'Achilles', 19, 'niedomukalność zastawek', date('1963-12-18'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Smerfetka', 'Smerf', 'przyjety', 'Wioska Smerfów', 'Papa Smerf', 26, 'kiłą', date('1972-09-11'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Bójka', 'Bajka', 'przyjety', 'Labolatorium', 'Brawurka', 39, 'AZS', date('2000-07-31'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Kiła', 'Mogiła', 'przyjety', 'Cmentarz', 'Syfilis', 29, NULL, date('2004-02-03'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Daphne', 'Blake', 'przyjety', 'Nawiedzony dom', 'Scooby Doo', 45, 'uszkodzenie siatkówki', date('1988-05-22'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Marchewka', 'Warzywo', 'ambulatoryjny', 'Lodówka', 'Brukselka Zielonka', NULL, 'hiperwitaminoza', date('2001-03-11'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Święty', 'Mikołaj', 'przyjety', 'Laponia', 'Rudolf', 19, 'zawał', date('1841-12-06'));
insert into pacjenci(imie, nazwisko, status, adres, krewny, id_lozka, choroba, data_urodzenia) VALUES ('Tomek', 'Sawyer', 'przyjety', 'St.Petersburg', 'Huckleberry Finn', 7, 'cukrzyca', date('1807-01-07'));

insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (1, 38, date('2014-10-12'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (2, 38, date('2015-11-15'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (3, 39, date('2014-04-09'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (4, 40, date('2013-12-03'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (5, 40, date('2015-01-02'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (1, 39, date('2014-11-15'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (5, 40, date('2015-06-19'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (7, 38, date('2013-03-16'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (7, 38, date('2015-04-24'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (12, 39, date('2014-06-30'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (12, 39, date('2015-09-24'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (5, 40, date('2014-01-04'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (10, 5, date('2015-09-08'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (10, 5, date('2013-08-20'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (10, 5, date('2015-10-11'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (18, 5, date('2013-08-20'));
insert into wizyty(id_pacjenta, id_lekarza, data) VALUES (18, 5, date('2015-10-11'));

insert into skierowania(id_pacjenta, id_lekarza) VALUES (1, 1);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (3, 25);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (4, 25);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (7, 33);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (8, 17);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (10, 5);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (11, 13);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (12, 21);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (13, 29);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (14, 21);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (15, 33);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (17, 13);
insert into skierowania(id_pacjenta, id_lekarza) VALUES (18, 5);

insert into zabiegi(nazwa, id_pacjenta, data_leczenia, czas_leczenia, wyniki) VALUES ('amputacja', 1, date('2012-12-21'), 5, 'udana, nie ma ręki ani nogi');
insert into zabiegi(nazwa, id_pacjenta, data_leczenia, czas_leczenia, wyniki) VALUES ('kraniektomia', 8, date('2017-12-24'), 37, 'stwierdzenie braku mózgu w czaszce');
insert into zabiegi(nazwa, id_pacjenta, data_leczenia, czas_leczenia, wyniki) VALUES ('lobotomia', 4, date('1976-06-17'), 25, 'pacjent stał się warzywem');
insert into zabiegi(nazwa, id_pacjenta, data_leczenia, czas_leczenia, wyniki) VALUES ('wazektomia', 12, date('2001-09-09'), 1, 'coś poszło nie tak');
insert into zabiegi(nazwa, id_pacjenta, data_leczenia, czas_leczenia, wyniki) VALUES ('irydektomia', 15, date('1989-01-18'), 8, 'udrożnienie kąta przesączania poprzez przypodstawne wycięcie tęczówki oka');

insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (1, 37);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (1, 33);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (2, 17);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (3, 5);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (3, 21);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (4, 13);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (5, 13);
insert into zabiegi_lekarze(id_zabiegu, id_lekarza) VALUES (5, 1);

insert into pensje(wysokosc, rodzaj) VALUES (123, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (12, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (654, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (5432, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (2323, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (4321, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (1234, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (9987, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (1234, 'stala');
insert into pensje(wysokosc, rodzaj) VALUES (1231, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (321, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (5432, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (8746, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (1234, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (7654, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (1234, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (5432, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (12344, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (4231, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (9124, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (5421, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (2111, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (12234, 'miesieczna');
insert into pensje(wysokosc, rodzaj) VALUES (12, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (91, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (32, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (1, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (875, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (65, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (43, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (43, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (65, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (43, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (12, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (85, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (45, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (96, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (10, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (11, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (82, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (13, 'godzinowa');
insert into pensje(wysokosc, rodzaj) VALUES (90, 'godzinowa');

insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (1, 1, 123);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (2, 1, 54);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (3, 1, 7);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (4, 1, 54);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (5, 2, 45);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (6, 2, 1);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (7, 2, 54);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (8, 2, 64);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (9, 3, 57);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (10, 3, 123);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (11, 3, 97);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (12, 3, 34);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (13, 4, 22);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (14, 4, 45);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (15, 4, 33);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (16, 4, 33);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (17, 5, 67);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (18, 5, 56);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (19, 5, 29);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (20, 5, 80);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (21, 6, 75);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (22, 6, 33);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (23, 6, 66);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (24, 6, 77);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (25, 7, 77);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (26, 7, 44);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (27, 7, 44);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (28, 7, 12);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (29, 8, 21);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (30, 8, 44);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (31, 8, 1);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (32, 8, 22);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (33, 9, 21);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (34, 9, 98);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (35, 9, 33);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (36, 9, 22);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (37, 1, 13);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (38, 10, 21);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (39, 10, 98);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (40, 10, 33);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (41, 10, 22);
insert into godziny(id_pracownika, id_oddzialu, liczba_godzin) VALUES (42, 10, 1);

insert into lozka(id_oddzialu, nr_pokoju) VALUES (1,1);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (1,1);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (1,2);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (1,2);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (1,2);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (2,3);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (2,3);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (2,4);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (2,4);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (2,4);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (3,5);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (3,5);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (3,6);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (3,6);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (3,6);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (4,7);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (4,7);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (4,8);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (4,8);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (4,8);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (5,9);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (5,9);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (5,10);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (5,10);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (5,10);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (6,11);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (6,11);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (6,12);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (6,12);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (6,12);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (7,13);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (7,13);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (7,14);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (7,14);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (7,14);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (8,15);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (8,15);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (8,16);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (8,16);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (8,16);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (9,17);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (9,17);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (9,18);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (9,18);
insert into lozka(id_oddzialu, nr_pokoju) VALUES (9,18);

insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('lek', 'Cetol-2', 100);
insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('lek', 'Aspiryna', 8);
insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('medyczny', 'termometr', 25);
insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('chirurgiczny', 'skalpel', 5);
insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('srodek', 'octenisept', 20);
insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('medyczny', 'plaster', 2);
insert into przedmioty(rodzaj, nazwa, koszt_jednostkowy) VALUES ('chirurgiczny', 'igła', 1);

insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (1, 10, 1, date('2015-02-19'), 10.10, 100, 100);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (1, 18, 2, date('2015-02-19'), 11.10, 100, 200);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (2, 3, 3, date('2014-12-19'), 12.10, 8, 24);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (3, 16, 1, date('2014-03-19'), 13.10, 25, 25);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (4, 11, 2, date('2015-01-19'), 14.10, 5, 10);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (5, 16, 1, date('2015-11-19'), 15.10, 20, 20);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (6, 9, 30, date('2014-02-19'), 16.10, 2, 60);
insert into zuzyte(id_przedmiotu, id_pacjenta, ilosc, data, godzina, koszt_jednostkowy, koszt_calkowity) VALUES (7, 7, 12, date('2015-09-19'), 17.10, 1, 12);

insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (4, 6, 'morfologia', 1, date('2014-09-19'), 'w normie');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (8, 9, 'badanie moczu', 2, date('2015-08-19'), 'białko w moczu');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (12, 10, 'test na płaskostopie', 3, date('2014-07-16'), 'podytywny');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (16, 13, 'ciśnienie krwi', 4, date('2015-03-01'), '90/180');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (20, 16, 'EEG', 5, date('2015-04-10'), 'w normie');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (24, 18, 'ciążowy', 6, date('2014-03-09'), 'pozytywny');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (28, 17, 'test na inteligencję', 7, date('2015-07-17'), 'IQ 50');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (32, 3, 'alergologiczny', 8, date('2015-11-02'), 'alergia na wodę');
insert into testy(id_technika, id_pacjenta, nazwa, numer, data, wynik) VALUES (36, 5, 'ostrosc widzenia', 9, date('2014-08-27'), 'wymaga okularów 2+');
