
#....MARKO........
from datetime import datetime

from flask import Flask, render_template, jsonify, request, redirect, url_for, session
from flask_mysqldb import MySQL, MySQLdb


app = Flask(__name__)

app.config['JSON_AS_ASCII'] = False
app.config['MYSQL_HOST'] = 'localhost'
#app.config['MYSQL_USER'] = 'root'  
#app.config['MYSQL_PASSWORD'] = 'root' 
app.config['MYSQL_DB'] = 'vinarija'

mysql = MySQL(app)

app.config['SECRET_KEY'] = '984/%$fs8'



@app.route('/login', methods=['GET', 'POST'])
def login():
    message = ''
    if request.method == 'POST':
        db_username = request.form.get('db_username')
        db_password = request.form.get('db_password')

        if db_username and db_password:
            try:
                session['db_username'] = db_username
                session['db_password'] = db_password

                # Konfiguracija za pristup MySQL
                app.config['MYSQL_USER'] = db_username
                app.config['MYSQL_PASSWORD'] = db_password
                mysql.init_app(app)

                cur = mysql.connection.cursor()
                cur.execute('SELECT 1') 
                result = cur.fetchone()

                if result:
                    session['loggedin'] = True
                else:
                    message = 'Failed to connect to the database'
                    print("Failed to connect to the database")
                    
            except Exception as e:
                message = f"Error: {e}"

        else:
            message = 'Please provide database username and password'
            print('Please provide database username and password')

        return render_template('index.html', message=message)
    

#...........


@app.route('/zaposlenik', methods=['GET'])
def zaposlenik():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM zaposlenik;")
    zaposlenik = cur.fetchall()
    cur.close()

    #return jsonify(zaposlenik)
    print(zaposlenik)

    return render_template('nav-templates/zaposlenik.html', zaposlenik=zaposlenik)

@app.route('/dodaj_zaposlenika_forma', methods=['GET'])
def dodaj_zaposlenika_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM zaposlenik;')
    zaposlenik = cur.fetchall()
    cur.close()

    return render_template('nav-templates/dodaj_zaposlenika.html', zaposlenik=zaposlenik)

@app.route('/dodaj_zaposlenika', methods=['POST'])
def dodaj_zaposlenika():
    id_odjel = request.form['id_odjel']
    ime = request.form['ime']
    prezime = request.form['prezime']
    adresa = request.form['adresa']
    email = request.form['email']
    telefon = request.form['telefon']
    datum_zaposlenja = request.form['datum_zaposlenja']
    status_zaposlenika = request.form['status_zaposlenika']
    uloga_id = request.form['uloga_id']
    lozinka = request.form['lozinka']

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO zaposlenik (id_odjel, ime, prezime, adresa, email, telefon, datum_zaposlenja, status_zaposlenika, uloga_id, lozinka) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                 (id_odjel, ime, prezime, adresa, email, telefon, datum_zaposlenja, status_zaposlenika, uloga_id, lozinka))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('zaposlenik'))

@app.route('/edit_zaposlenika', methods=['GET'])
def edit_zaposlenika():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM zaposlenik;')
    zaposlenik = cur.fetchall()
    cur.close()

    return render_template('nav-templates/edit_zaposlenika.html', zaposlenik=zaposlenik)


@app.route('/obrisi_zaposlenika/<int:id>', methods=['POST'])
def obrisi_zaposlenika(id):
    try:
        cur = mysql.connection.cursor()
        cur.execute("DELETE FROM zaposlenik WHERE id = %s", [id])
        mysql.connection.commit()
        cur.close()

        return redirect(url_for('edit_zaposlenika'))

    except Exception as e:
        print(f"Error: {e}")
        return redirect(url_for('edit_zaposlenika'))


@app.route('/edit_zaposlenika_forma/<int:id>', methods=['GET'])
def edit_zaposlenika_forma(id):
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM zaposlenik WHERE id = %s', [id])
    zaposlenik = cur.fetchone()
    cur.close()

    return render_template('nav-templates/edit_zaposlenika_forma.html', zaposlenik=zaposlenik)
    
@app.route('/update_zaposlenika/<int:id>', methods=['POST'])
def update_zaposlenika(id):
    id_odjel = request.form['id_odjel']
    ime = request.form['ime']
    prezime = request.form['prezime']
    adresa = request.form['adresa']
    email = request.form['email']
    telefon = request.form['telefon']
    datum_zaposlenja = request.form['datum_zaposlenja']
    status_zaposlenika = request.form['status_zaposlenika']
    uloga_id = request.form['uloga_id']
    lozinka = request.form['lozinka']

    cur = mysql.connection.cursor()
    cur.execute("""
        UPDATE zaposlenik 
        SET id_odjel = %s, ime = %s, prezime = %s, adresa = %s, email = %s, telefon = %s, 
            datum_zaposlenja = %s, status_zaposlenika = %s, uloga_id = %s, lozinka = %s
        WHERE id = %s
    """, (id_odjel, ime, prezime, adresa, email, telefon, datum_zaposlenja, status_zaposlenika, uloga_id, lozinka, id))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('zaposlenik'))



@app.route('/dodaj_dobavljaca_forma', methods=['GET'])
def dodaj_dobavljaca_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM dobavljac;')
    dobavljac = cur.fetchall()
    cur.close()

    return render_template('nav-templates/dodaj_dobavljaca.html', dobavljac=dobavljac)



@app.route('/dodaj_dobavljaca', methods=['POST'])
def dodaj_dobavljaca():
    naziv = request.form['naziv']
    adresa = request.form['adresa']
    email = request.form['email']
    telefon = request.form['telefon']
    oib = request.form['oib']

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO dobavljac (naziv, adresa, email, telefon, oib) VALUES(%s, %s, %s, %s, %s)",
                 (naziv, adresa, email, telefon, oib,))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('dobavljac'))
    


@app.route('/repromaterijal', methods=['GET'])
def repromaterijal():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM repromaterijal;")
    repromaterijal = cur.fetchall()
    cur.close()

    return render_template('nav-templates/repromaterijal.html', repromaterijal=repromaterijal)

@app.route('/vino', methods=['GET'])
def vino():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM vino;")
    vino = cur.fetchall()
    cur.close()

    #return jsonify(vino)
    print(vino)

    return render_template('nav-templates/vino.html', vino=vino)


@app.route('/kupac', methods=['GET'])
def show_kupac():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM kupac;")
    kupac = cur.fetchall()
    cur.close()

    #return jsonify(zaposlenik)
    print(kupac)

    return render_template('nav-templates/kupac.html', kupac=kupac)


@app.route('/prijevoznik', methods=['GET'])
def show_prijevoznik():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM prijevoznik;")
    prijevoznik = cur.fetchall()
    cur.close()

    return render_template('nav-templates/prijevoznik.html', prijevoznik=prijevoznik)

@app.route('/dodaj_prijevoznika_forma', methods=['GET'])
def dodaj_prijevoznika_forma():
    return render_template('nav-templates/dodaj_prijevoznika.html')  # Render the form for adding a transporter.

@app.route('/dodaj_prijevoznika', methods=['POST'])
def dodaj_prijevoznika():
    naziv = request.form['naziv']
    adresa = request.form['adresa']
    email = request.form['email']
    telefon = request.form['telefon']
    oib = request.form['oib']

    cur = mysql.connection.cursor()
    cur.execute("""
        INSERT INTO prijevoznik (naziv, adresa, email, telefon, oib)
        VALUES (%s, %s, %s, %s, %s)
    """, (naziv, adresa, email, telefon, oib))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('show_prijevoznik'))




@app.route('/izbrisi_prijevoznika_forma', methods=['GET'])
def izbrisi_prijevoznika_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM prijevoznik;')
    prijevoznik = cur.fetchall()
    cur.close()

    return render_template('nav-templates/obrisi_prijevoznika.html', prijevoznik=prijevoznik)


@app.route('/izbrisi_prijevoznika', methods=['POST'])
def izbrisi_prijevoznik():
    id_prijevoznik = request.form['id_prijevoznika']

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM prijevoznik WHERE id = %s", (id_prijevoznik,))
    mysql.connection.commit()
    cur.close()




@app.route('/proizvod', methods=['GET'])
def proizvod():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM proizvod;")
    proizvod = cur.fetchall()
    cur.close()

    return render_template('nav-templates/proizvod.html', proizvod=proizvod)


#Vid-dobavljac
@app.route('/dobavljac', methods=['GET'])
def dobavljac():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM dobavljac;')
    dobavljac = cur.fetchall()
    cur.close()
    
    print(dobavljac)

    return render_template('nav-templates/dobavljac.html', dobavljac=dobavljac)

@app.route('/zahtjev_za_nabavu', methods=['GET'])
def zahtjev_za_nabavu():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM zahtjev_za_nabavu;')
    zahtjev_za_nabavu = cur.fetchall()
    cur.close()
    
    print(zahtjev_za_nabavu)

    return render_template('nav-templates/zahtjev_za_nabavu.html', zahtjev_za_nabavu=zahtjev_za_nabavu)


@app.route('/berba', methods=['GET'])
def berba():
    cur = mysql.connection.cursor()
    cur.execute('SELECT v.naziv, b.godina_berbe, b.postotak_alkohola FROM berba b JOIN vino v ON v.id = b.id_vino;')
    berba_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/berba.html', berba=berba_lista)


@app.route('/dodaj_berbu_forma', methods=['GET'])
def dodaj_berbu_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id, naziv FROM vino;')
    vino_izbor = cur.fetchall()
    cur.close()

    return render_template('nav-templates/dodaj_berbu_forma.html', vina=vino_izbor)


@app.route('/dodaj_berbu', methods=['POST'])
def dodaj_berbu():
    id_vino = request.form['id_vino']
    godina_berbe = int(request.form['godina_berbe'])
    postotak_alkohola = request.form['postotak_alkohola']

    cur = mysql.connection.cursor()
    cur.callproc('dodaj_novu_berbu', [id_vino, godina_berbe, postotak_alkohola])
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('berba'))

@app.route('/dodaj_repromaterijal_forma', methods=['GET'])
def dodaj_repromaterijal_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM repromaterijal;')
    repromaterijal = cur.fetchall()
    cur.close()

    return render_template('nav-templates/insert_repromaterijal.html', repromaterijal=repromaterijal)

@app.route('/dodaj_repromaterijal', methods=['POST'])
def dodaj_repromaterijal():
    id_dobavljac = request.form['id_dobavljac']
    vrsta = request.form['vrsta']
    opis = request.form['opis']
    jedinicna_cijena = request.form['jedinicna_cijena']

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO repromaterijal (id_dobavljac, vrsta, opis, jedinicna_cijena) VALUES(%s, %s, %s, %s)",
            (id_dobavljac, vrsta, opis, jedinicna_cijena))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('repromaterijal'))

@app.route('/izbrisi_repromaterijal_forma', methods=['GET'])
def izbrisi_repromaterijal_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM repromaterijal;')
    repromaterijal = cur.fetchall()
    cur.close()

    return render_template('nav-templates/obrisi_repromaterijal.html', repromaterijal=repromaterijal)

@app.route('/izbrisi_repromaterijal', methods=['POST'])
def izbrisi_repromaterijal():
    id_repromaterijal = request.form['id_repromaterijal']

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM repromaterijal WHERE id = %s", (id_repromaterijal,))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('repromaterijal'))

@app.route('/dodaj_proizvod_forma', methods=['GET'])
def dodaj_proizvod_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM proizvod;')
    proizvod = cur.fetchall()
    cur.close()

    return render_template('nav-templates/dodaj_proizvod.html', proizvod=proizvod)

@app.route('/dodaj_proizvod', methods=['POST'])
def dodaj_proizvod():
    id_berba = request.form['id_berba']
    volumen = request.form['volumen']
    cijena = request.form['cijena']

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO proizvod (id_berba, volumen, cijena) VALUES(%s, %s, %s)",
            (id_berba, volumen, cijena))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('proizvod'))

@app.route('/izbrisi_proizvod_forma', methods=['GET'])
def izbrisi_proizvod_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM proizvod;')
    proizvod = cur.fetchall()
    cur.close()

    return render_template('nav-templates/obrisi_proizvod.html', proizvod=proizvod)

@app.route('/izbrisi_proizvod', methods=['POST'])
def izbrisi_proizvod():
    id_proizvod = request.form['id_proizvod']

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM proizvod WHERE id = %s", (id_proizvod,))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('proizvod'))

@app.route('/update_proizvod_forma', methods=['GET'])
def update_proizvod_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM proizvod;')
    proizvod = cur.fetchall()
    cur.close()

    return render_template('nav-templates/update_proizvod.html', proizvod=proizvod)

@app.route('/azuriraj_proizvod', methods=['POST'])
def azuriraj_proizvod():
    id_proizvod = request.form['id_proizvod']
    id_berba = request.form['id_berba']
    cijena = request.form['cijena']
    volumen = request.form['volumen']

    cur = mysql.connection.cursor()
    cur.execute("""
            UPDATE proizvod
            SET id_berba = %s, cijena = %s, volumen = %s
            WHERE id = %s
        """, (id_berba, cijena, volumen, id_proizvod))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('proizvod'))  

@app.route('/dodaj_vino_forma', methods=['GET'])
def dodaj_vino_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM vino;')
    vino = cur.fetchall()
    cur.close()

    return render_template('nav-templates/dodaj_vino.html', vino=vino)

@app.route('/dodaj_vino', methods=['POST'])
def dodaj_vino():
    naziv = request.form['naziv']
    vrsta = request.form['vrsta']
    sorta = request.form['sorta']

    cur = mysql.connection.cursor()
    cur.execute("INSERT INTO vino (naziv, vrsta, sorta) VALUES(%s, %s, %s)",
            (naziv, vrsta, sorta))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('vino'))

@app.route('/obrisi_vino_forma', methods=['GET'])
def obrisi_vino_forma():
    cur = mysql.connection.cursor()
    cur.execute('SELECT id FROM vino;')
    vino = cur.fetchall()
    cur.close()

    return render_template('nav-templates/obrisi_vino.html', vino=vino)

@app.route('/izbrisi_vino', methods=['POST'])
def izbrisi_vino():
    id_proizvod = request.form['id_proizvod']

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM vino WHERE id = %s", (id_proizvod,))
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('vino'))


@app.route('/punjenje', methods=['GET'])
def punjenje():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM punjenje_pogled;')
    punjenje_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/punjenje.html', punjenje=punjenje_lista)


@app.route('/repromaterijal_proizvod', methods=['GET'])
def repromaterijal_proizvod():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM repromaterijal_po_proizvodu;")
    repromaterijal_proizvod_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/repromaterijal_proizvod.html', repromaterijal_proizvod=repromaterijal_proizvod_lista)


@app.route('/zahtjev_za_narudzbu', methods=['GET'])
def zahtjev_za_narudzbu():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM narudzbe;")
    zahtjev_za_narudzbu_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/zahtjev_za_narudzbu.html', zahtjev_za_narudzbu=zahtjev_za_narudzbu_lista)


@app.route('/stavka_narudzbe', methods=['GET'])
def stavka_narudzbe():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM stavke;")
    stavka_narudzbe_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stavka_narudzbe.html', stavka_narudzbe=stavka_narudzbe_lista)


@app.route('/stanje_skladista_vina', methods=['GET'])
def stanje_skladista_vina():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM vino_skladiste;")
    stanje_skladista_vina_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stanje_skladista_vina.html', stanje_skladista_vina=stanje_skladista_vina_lista)


@app.route('/stanje_skladista_proizvoda', methods=['GET'])
def stanje_skladista_proizvoda():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM proizvod_skladiste;')
    stanje_skladista_proizvoda_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stanje_skladista_proizvoda.html', stanje_skladista_proizvoda=stanje_skladista_proizvoda_lista)

@app.route('/skladiste_proizvod', methods=['GET'])
def skladiste_proizvod():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM skladiste_proizvod;')
    skladiste_proizvod = cur.fetchall()
    cur.close()

    return render_template('nav-templates/skladiste_proizvod.html', skladiste_proizvod=skladiste_proizvod)


@app.route('/stanje_skladista_repromaterijala', methods=['GET'])
def stanje_skladista_repromaterijala():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM repromaterijal_skladiste;")
    stanje_skladista_repromaterijala_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stanje_skladista_repromaterijala.html', stanje_skladista_repromaterijala=stanje_skladista_repromaterijala_lista)


@app.route('/kvartalni_pregled_prodaje', methods=['GET'])
def kvartalni_pregled_prodaje():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM kvartalna_prodaja;")
    kvartalni_pregled_prodaje_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/kvartalni_pregled_prodaje.html', kvartalni_pregled_prodaje=kvartalni_pregled_prodaje_lista)



@app.route('/transport', methods=['GET'])
def transport():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM transport;')
    transport = cur.fetchall()
    cur.close()
    
    return render_template('nav-templates/transport.html', transport=transport)

@app.route('/racun', methods=['GET'])
def racun():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM racun;')
    racun = cur.fetchall()
    cur.close()
    
    return render_template('nav-templates/racun.html', racun=racun)

@app.route('/plan_proizvodnje', methods=['GET'])
def plan_proizvodnje():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM plan_proizvodnje;')
    plan_proizvodnje = cur.fetchall()
    cur.close()

    return render_template('nav-templates/plan_proizvodnje.html', plan_proizvodnje=plan_proizvodnje)


@app.route('/')
def index():
    return render_template('login.html')

@app.route('/home')
def home():
    return render_template('home.html')

# @app.route('/zaposlenik')
# def zaposlenik():
#     return render_template('nav-templates/zaposlenik.html')

#@app.route('/dobavljac')
#def dobavljac():
    #return render_template('nav-templates/dobavljac.html')

@app.route('/kupac')
def kupac():
    return render_template('nav-templates/kupac.html')

@app.route('/prijevoznik')
def prijevoznik():
    return render_template('nav-templates/prijevoznik.html')


if __name__ == "__main__":
    app.run(debug=True, port=8080)

