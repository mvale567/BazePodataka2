from flask import Flask, render_template, jsonify, request, session
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





@app.route('/')
def index():
    return render_template('login.html')

@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/zaposlenik')
def zaposlenik():
    return render_template('nav-templates/zaposlenik.html')

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
