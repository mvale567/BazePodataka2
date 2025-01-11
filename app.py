from flask import Flask, render_template, jsonify
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['JSON_AS_ASCII'] = False
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'  
app.config['MYSQL_PASSWORD'] = 'root' 
app.config['MYSQL_DB'] = 'test_vinarija'

mysql = MySQL(app)


@app.route('/zaposlenik', methods=['GET'])
def show_zaposlenik():
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM zaposlenik;")
    zaposlenik = cur.fetchall()
    cur.close()

    #return jsonify(zaposlenik)
    print(zaposlenik)

    return render_template('nav-templates/zaposlenik.html', zaposlenik=zaposlenik)

# Ovdje definiramo upite i poglede!
















@app.route('/')
def index():
    return render_template('index.html')

@app.route('/home')
def home():
    return render_template('home.html')

@app.route('/zaposlenik')
def zaposlenik():
    return render_template('nav-templates/zaposlenik.html')

@app.route('/kupac')
def kupac():
    return render_template('nav-templates/kupac.html')


if __name__ == "__main__":
    app.run(debug=True, port=8080)
