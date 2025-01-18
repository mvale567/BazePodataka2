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
    



@app.route('/zaposlenik', methods=['GET'])
def show_zaposlenik():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM zaposlenik;")
    zaposlenik = cur.fetchall()
    cur.close()

    #return jsonify(zaposlenik)
    print(zaposlenik)

    return render_template('nav-templates/zaposlenik.html', zaposlenik=zaposlenik)

@app.route('/repromaterijal', methods=['GET'])
def show_repromaterijal():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM repromaterijal;")
    repromaterijal = cur.fetchall()
    cur.close()

    return render_template('nav-templates/repromaterijal.html', repromaterijal=repromaterijal)

@app.route('/vino', methods=['GET'])
def show_vino():
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


@app.route('/proizvod', methods=['GET'])
def show_proizvod():
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
def show_berba():
    cur = mysql.connection.cursor()
    cur.execute('SELECT v.naziv, b.godina_berbe, b.postotak_alkohola FROM berba b JOIN vino v ON v.id = b.id_vino;')
    berba_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/berba.html', berba=berba_lista)

@app.route('/berba')
def berba():
    return render_template('nav-templates/berba.html')

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

    trenutna_godina = datetime.now().year
    if godina_berbe > trenutna_godina:
        return "Godina berbe ne može biti u budućnosti.", 400
    cur = mysql.connection.cursor()
    cur.callproc('dodaj_novu_berbu', [id_vino, godina_berbe, postotak_alkohola])
    mysql.connection.commit()
    cur.close()

    return redirect(url_for('show_berba'))



@app.route('/punjenje', methods=['GET'])
def show_punjenje():
    cur = mysql.connection.cursor()
    cur.execute('SELECT * FROM punjenje_pogled;')
    punjenje_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/punjenje.html', punjenje=punjenje_lista)

@app.route('/punjenje')
def punjenje():
    return render_template('nav-templates/punjenje.html')


@app.route('/repromaterijal_proizvod', methods=['GET'])
def show_repromaterijal_proizvod():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM repromaterijal_po_proizvodu;")
    repromaterijal_proizvod_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/repromaterijal_proizvod.html', repromaterijal_proizvod=repromaterijal_proizvod_lista)

@app.route('/repromaterijal_proizvod')
def repromaterijal_proizvod():
    return render_template('nav-templates/repromaterijal_proizvod.html')


@app.route('/zahtjev_za_narudzbu', methods=['GET'])
def show_zahtjev_za_narudzbu():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM zahtjev_za_narudzbu;")
    zahtjev_za_narudzbu_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/zahtjev_za_narudzbu.html', zahtjev_za_narudzbu=zahtjev_za_narudzbu_lista)

@app.route('/zahtjev_za_narudzbu')
def zahtjev_za_narudzbu():
    return render_template('nav-templates/zahtjev_za_narudzbu.html')


@app.route('/stavka_narudzbe', methods=['GET'])
def show_stavka_narudzbe():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM stavka_narudzbe;")
    stavka_narudzbe_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stavka_narudzbe.html', stavka_narudzbe=stavka_narudzbe_lista)

@app.route('/stavka_narudzbe')
def stavka_narudzbe():
    return render_template('nav-templates/stavka_narudzbe.html')


@app.route('/stanje_skladista_vina', methods=['GET'])
def show_stanje_skladista_vina():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM vino_skladiste;")
    stanje_skladista_vina_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stanje_skladista_vina.html', stanje_skladista_vina=stanje_skladista_vina_lista)

@app.route('/stanje_skladista_vina')
def stanje_skladista_vina():
    return render_template('nav-templates/stanje_skladista_vina.html')


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






#@app.route('/stanje_skladista_proizvoda')
#def stanje_skladista_proizvoda():
    #return render_template('nav-templates/stanje_skladista_proizvoda.html')


@app.route('/stanje_skladista_repromaterijala', methods=['GET'])
def show_stanje_skladista_repromaterijala():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM repromaterijal_skladiste;")
    stanje_skladista_repromaterijala_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/stanje_skladista_repromaterijala.html', stanje_skladista_repromaterijala=stanje_skladista_repromaterijala_lista)

@app.route('/stanje_skladista_repromaterijala')
def stanje_skladista_repromaterijala():
    return render_template('nav-templates/stanje_skladista_repromaterijala.html')


@app.route('/kvartalni_pregled_prodaje', methods=['GET'])
def show_kvartalni_pregled_prodaje():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM kvartalna_prodaja;")
    kvartalni_pregled_prodaje_lista = cur.fetchall()
    cur.close()

    return render_template('nav-templates/kvartalni_pregled_prodaje.html', kvartalni_pregled_prodaje=kvartalni_pregled_prodaje_lista)

@app.route('/kvartalni_pregled_prodaje')
def kvartalni_pregled_prodaje():
    return render_template('nav-templates/kvartalni_pregled_prodaje.html')

@app.route('/vino')
def vino():
    return render_template('nav-templates/vino.html')

@app.route('/repromaterijal')
def repromaterijal():
    return render_template('nav-templates/repromaterijal.html')




@app.route('/')
def index():
    return render_template('login.html')

@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/zaposlenik')
def zaposlenik():
    return render_template('nav-templates/zaposlenik.html')

#@app.route('/dobavljac')
#def dobavljac():
    #return render_template('nav-templates/dobavljac.html')

@app.route('/kupac')
def kupac():
    return render_template('nav-templates/kupac.html')

@app.route('/prijevoznik')
def prijevoznik():
    return render_template('nav-templates/prijevoznik.html')

@app.route('/proizvod')
def proizvod():
    return render_template('nav-templates/proizvod.html')



if __name__ == "__main__":
    app.run(debug=True, port=8080)
# 