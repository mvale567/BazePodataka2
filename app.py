from flask import Flask, render_template
from flask_mysqldb import MySQL

app = Flask(__name__)

app.config['JSON_AS_ASCII'] = False
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'admin'  #root
app.config['MYSQL_PASSWORD'] = 'admin' #root
app.config['MYSQL_DB'] = 'vinarija'

mysql = MySQL(app)






# Ovdje definiramo upite i poglede!
















@app.route('/')
def index():
    return render_template('index.html')

@app.route('/home')
def home():
    return render_template('home.html')

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080, debug=True)
