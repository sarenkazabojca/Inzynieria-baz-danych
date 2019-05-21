import sqlite3
import io
from flask import Flask, render_template, request


class Baza:
    def __init__(self):
        self.connection = sqlite3.connect("baza.db")
        self.cursor = self.connection.cursor()
        self.connection.commit()

    def __del__(self):
        self.connection.close()

    def wykonaj(self, instrukcje):
        self.cursor.executescript(instrukcje)
        self.connection.commit()

    def zapytanie1(self):
        self.cursor.execute("""select distinct P.nazwisko, P.data_urodzenia
                    from pacjenci as P, zuzyte as Z, wizyty as W, lekarze as L, przedmioty as T
                    where T.nazwa='Cetol-2' and P.id_pacjenta=Z.id_pacjenta and P.choroba='cukrzyca' and P.id_pacjenta=W.id_pacjenta
                    and L.specjalnosc='pediatra' and T.id_przedmiotu=Z.id_przedmiotu and L.id_lekarza=W.id_lekarza;""")
        return list(map(lambda wiersz: dict({
            "nazwisko":        wiersz[0],
            "data_urodzenia":  wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie2(self):
        self.cursor.execute("""select distinct(P.nazwisko)
                    from pacjenci as P, pracownicy as R, wizyty as W, lekarze as L
                    where L.specjalnosc='internista' and R.nazwisko in('Gąska', 'Pająk', 'Samuel') and P.id_pacjenta=W.id_pacjenta and L.id_lekarza=R.id_pracownika
                    and L.id_lekarza=W.id_lekarza;""")
        return list(map(lambda wiersz: dict({
            "nazwisko":        wiersz[0],
        }), self.cursor.fetchall()))


    def zapytanie3(self):
        self.cursor.execute("""select count(P.nazwisko) from pacjenci as P,
                    (select id_pacjenta, count(id_pacjenta) ilosc from wizyty where id_lekarza in
                    (select id_lekarza from lekarze where specjalnosc='internista') group by id_pacjenta) as W
                    where P.id_pacjenta=W.id_pacjenta and W.ilosc >= 2 and P.nazwisko like 'S%';""")
        return list(map(lambda wiersz: dict({
            "liczba":          wiersz[0],
        }), self.cursor.fetchall()))

    def zapytanie4(self):
        self.cursor.execute("""SELECT R.imie, R.nazwisko FROM (
                    SELECT id_lekarza, MIN(ilosc_wizyt) FROM (
                        SELECT id_lekarza, COUNT(id_wizyty) ilosc_wizyt FROM wizyty
                        WHERE data BETWEEN DATE('2015-01-01') AND DATE('2015-12-31')
                        GROUP BY id_lekarza
                    )
                    ) AS W, pracownicy AS R
                    WHERE R.id_pracownika=W.id_lekarza;""")
        return list(map(lambda wiersz: dict({
            "nazwisko":        wiersz[0],
            "imie":            wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie5(self):
        self.cursor.execute("""select R.nazwisko, round(J.wysokosc*1.15) from pracownicy as R, pensje as J
                    where R.id_pensji=J.id_pensji and J.rodzaj='godzinowa';""")
        return list(map(lambda wiersz: dict({
            "nazwisko":        wiersz[0],
            "stawka":          wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie6(self):
        self.cursor.execute("""select R.nazwisko, J.wysokosc from pracownicy as R, pensje as J
                    where R.id_pensji=J.id_pensji and J.rodzaj='stala' and R.stanowisko!='ordynator'
                    union
                    select R.nazwisko, '-' wysokosc from pracownicy as R, pensje as J
                    where R.id_pensji=J.id_pensji and J.rodzaj='stala' and R.stanowisko='ordynator';""")
        return list(map(lambda wiersz: dict({
            "nazwisko":        wiersz[0],
            "placa":           wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie7(self):
        self.cursor.execute("""select O.nazwa, count(R.id_pracownika) ilosc
                    from pracownicy as R, oddzialy as O
                    where O.id_oddzialu=R.id_oddzialu
                    group by O.id_oddzialu
                    order by O.id_oddzialu;""")
        return list(map(lambda wiersz: dict({
            "oddzial":         wiersz[0],
            "liczba":          wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie8(self):
        self.cursor.execute("""with pensje_pracownikow as (
                    select R.id_pracownika, J.wysokosc*G.liczba_godzin*4 wysokosc FROM pracownicy as R, pensje as J, godziny as G
                    where R.id_pensji=J.id_pensji and R.id_pracownika=G.id_pracownika and J.rodzaj='godzinowa'
                    union
                    select R.id_pracownika, J.wysokosc FROM pracownicy as R, pensje as J
                    where R.id_pensji=J.id_pensji and J.rodzaj!='godzinowa'
                    )
                    select R.nazwisko, R.stanowisko FROM pracownicy as R, pracownicy as S, lekarze as L, pensje_pracownikow as Jp, pensje_pracownikow as Js --Jp.wysokosc pensja_pracownika, Js.wysokosc pensja_szefa
                    where R.id_pracownika=L.id_lekarza and R.id_pracownika=Jp.id_pracownika and L.id_ordynatora=S.id_pracownika and S.id_pracownika=Js.id_pracownika
                    and Jp.wysokosc<Js.wysokosc/2;""")
        return list(map(lambda wiersz: dict({
            "nazwisko":        wiersz[0],
            "etat":            wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie9(self):
        self.cursor.execute("""with pacjenci_na_oddzialach as (
                    select O.nazwa, count(P.id_pacjenta) ilosc
                    from oddzialy as O, pacjenci as P, lozka as L
                    where L.id_lozka=P.id_lozka and L.id_oddzialu=O.id_oddzialu
                    group by O.id_oddzialu
                    )
                    select PO.nazwa, PO.ilosc from pacjenci_na_oddzialach as PO
                    where PO.ilosc>(select AVG(ilosc) FROM pacjenci_na_oddzialach);""")
        return list(map(lambda wiersz: dict({
            "oddzial":         wiersz[0],
            "liczba":          wiersz[1]
        }), self.cursor.fetchall()))


    def zapytanie10(self):
        self.cursor.execute("""select nazwa from (
                    select nazwa, max(place_oddzial) from (
                        select O.nazwa, sum(J.wysokosc) place_oddzial from oddzialy as O, pracownicy as R, pensje as J
                        where R.id_pensji=J.id_pensji and O.id_oddzialu=R.id_oddzialu and J.rodzaj='stala'
                        group by O.id_oddzialu
                    ));""")
        return list(map(lambda wiersz: dict({
            "oddzial":         wiersz[0],
        }), self.cursor.fetchall()))


    def pobierzOddzialy(self):
        self.cursor.execute("select * from oddzialy")
        return list(map(lambda wiersz: dict({
            "id":               wiersz[0],
            "numer":            wiersz[1],
            "nazwa":            wiersz[2],
            "id_oddzialowej":   wiersz[3]
        }), self.cursor.fetchall()))

    def dodajPracownika(self, f):
        self.cursor.execute("insert into pensje values (NULL, ?, ?)", (f['wysokosc'], f['rodzaj']))
        id_pensji = self.cursor.lastrowid
        self.cursor.execute("insert into pracownicy values (NULL, ?, ?, ?, ?, ?)",
                            (f['imie'], f['nazwisko'], f['id_oddzialu'], f['stanowisko'], id_pensji))
        id_pracownika = self.cursor.lastrowid
        self.connection.commit()
        self.cursor.execute("select * from pracownicy where id_pracownika=?", (id_pracownika,))
        pracownik = self.cursor.fetchone()
        return dict({
            "id":           pracownik[0],
            "imie":         pracownik[1],
            "nazwisko":     pracownik[2],
            "id_oddzialu":  pracownik[3],
            "stanowisko":   pracownik[4],
            "id_pensji":    pracownik[5]
        })


    def edytujPracownika(self, f):
        self.cursor.execute("update pensje set rodzaj=?, wysokosc=? where id_pensji=?", (f['rodzaj'], f['wysokosc'], f['id_pensji']))
        self.cursor.execute("update pracownicy set imie=?, nazwisko=?, id_oddzialu=?, stanowisko=? where id_pracownika=?",
                            (f['imie'], f['nazwisko'], f['id_oddzialu'], f['stanowisko'], f['id']))
        self.connection.commit()
        self.cursor.execute("select * from pracownicy where id_pracownika=?", (f['id'],))
        pracownik = self.cursor.fetchone()
        return dict({
            "id":           pracownik[0],
            "imie":         pracownik[1],
            "nazwisko":     pracownik[2],
            "id_oddzialu":  pracownik[3],
            "stanowisko":   pracownik[4],
            "id_pensji":    pracownik[5]
        })


    def pobierzPracownika(self, id):
        self.cursor.execute("select * from pracownicy where id_pracownika=?", (id,))
        pracownik = self.cursor.fetchone()
        return dict({
            "id":           pracownik[0],
            "imie":         pracownik[1],
            "nazwisko":     pracownik[2],
            "id_oddzialu":  pracownik[3],
            "stanowisko":   pracownik[4],
            "id_pensji":    pracownik[5]
        })


    def pobierzPensje(self, id):
        self.cursor.execute("select * from pensje where id_pensji=?", (id,))
        pensja = self.cursor.fetchone()
        return dict({
            "id": pensja[0],
            "rodzaj": pensja[2],
            "wysokosc": pensja[1]
        })


    def pobierzWszystkichPracownikow(self):
        self.cursor.execute("select * from pracownicy")
        return list(map(lambda wiersz: dict({
            "id":           wiersz[0],
            "imie":         wiersz[1],
            "nazwisko":     wiersz[2],
            "id_oddzialu":  wiersz[3],
            "stanowisko":   wiersz[4],
            "id_pensji":    wiersz[5]
        }), self.cursor.fetchall()))

    def usunPracownika(self, id_pracownika):
        self.cursor.execute("select * from pracownicy where id_pracownika=?", (id_pracownika,))
        pracownik = self.cursor.fetchone()
        self.cursor.execute("delete from pracownicy where id_pracownika=?", (id_pracownika,))
        self.connection.commit()
        return dict({
            "id":           pracownik[0],
            "imie":         pracownik[1],
            "nazwisko":     pracownik[2],
            "id_oddzialu":  pracownik[3],
            "stanowisko":   pracownik[4],
            "id_pensji":    pracownik[5]
        })


serwer = Flask(__name__)
with io.open('baza.sql', mode='r', encoding='utf-8') as sql:
    baza = Baza()
    baza.wykonaj(sql.read())  # zakomentować żeby nie znikało


@serwer.route("/")
def main():
    return render_template('index.html')


@serwer.route("/1")
def zapytanie1():
    baza = Baza()
    return render_template('zapytanie1.html', wiersze=baza.zapytanie1())


@serwer.route("/2")
def zapytanie2():
    baza = Baza()
    return render_template('zapytanie2.html', wiersze=baza.zapytanie2())


@serwer.route("/3")
def zapytanie3():
    baza = Baza()
    return render_template('zapytanie3.html', wiersze=baza.zapytanie3())


@serwer.route("/4")
def zapytanie4():
    baza = Baza()
    return render_template('zapytanie4.html', wiersze=baza.zapytanie4())


@serwer.route("/5")
def zapytanie5():
    baza = Baza()
    return render_template('zapytanie5.html', wiersze=baza.zapytanie5())


@serwer.route("/6")
def zapytanie6():
    baza = Baza()
    return render_template('zapytanie6.html', wiersze=baza.zapytanie6())


@serwer.route("/7")
def zapytanie7():
    baza = Baza()
    return render_template('zapytanie7.html', wiersze=baza.zapytanie7())


@serwer.route("/8")
def zapytanie8():
    baza = Baza()
    return render_template('zapytanie8.html', wiersze=baza.zapytanie8())


@serwer.route("/9")
def zapytanie9():
    baza = Baza()
    return render_template('zapytanie9.html', wiersze=baza.zapytanie9())


@serwer.route("/10")
def zapytanie10():
    baza = Baza()
    return render_template('zapytanie10.html', wiersze=baza.zapytanie10())

@serwer.route("/pracownik/dodaj")
def wyswietlDodawaniePracownika():
    baza = Baza()
    return render_template('dodawaniePracownika.html', oddzialy=baza.pobierzOddzialy())


@serwer.route("/pracownik/dodany", methods=['POST'])
def dodajPracownika():
    baza = Baza()
    return render_template('dodanyPracownik.html', pracownik=baza.dodajPracownika(request.form))


@serwer.route("/pracownik/wyswietl/<id>")
def wyswietlPracownika(id):
    baza = Baza()
    return render_template('pracownik.html', pracownik=baza.pobierzPracownika(id))


@serwer.route("/pracownik/wyswietl")
def wyswietlWszystkichPracownikow():
    baza = Baza()
    return render_template('wyswietlWszystkichPracownikow.html', wiersze=baza.pobierzWszystkichPracownikow())


@serwer.route("/pracownik/edytuj/<id>")
def edytujPracownika(id):
    baza = Baza()
    pracownik = baza.pobierzPracownika(id)
    pensja = baza.pobierzPensje(pracownik['id_pensji'])
    oddzialy = baza.pobierzOddzialy()
    print(pensja, pracownik)
    return render_template('edytowaniePracownika.html', pracownik=pracownik, pensja=pensja, oddzialy=oddzialy)


@serwer.route("/pracownik/edytowany", methods=['POST'])
def wyswietlEdytowanegoPracownika():
    baza = Baza()
    return render_template('edytowanyPracownik.html', pracownik=baza.edytujPracownika(request.form))


@serwer.route("/pracownik/usun", defaults={'id': ''})
@serwer.route("/pracownik/usun/<id>")
def wyswietlUsuwaniePracownika(id):
    baza = Baza()
    return render_template('usuwaniePracownika.html', id=id)


@serwer.route("/pracownik/usuniety", methods=['POST'])
def usuwaniePracownika():
    baza = Baza()
    try:
        return render_template('usunietyPracownik.html', pracownik=baza.usunPracownika(request.form['id']))
    except:
        return render_template('bladUsuwania.html')


if __name__ == "__main__":
    serwer.run()
