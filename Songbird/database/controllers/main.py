from flask import *

from extensions import connect_to_database
from flask import url_for

main = Blueprint('main', __name__, template_folder='templates')

db = connect_to_database()

@main.route('/', methods = ['GET', 'POST'])
def main_route():
    db = connect_to_database()
    cur = db.cursor()
    
    result = ''
    button = ''
    if request.method == 'POST':
        if (request.form.get('op') == 'sampleid'):
            button = 'sampleid'
        elif (request.form.get('op') == 'deviceid'):
            button = 'deviceid'
        elif (request.form.get('op') == 'added'):
            button = 'added'
        elif (request.form.get('op') == 'latitude'):
            button = 'latitude'
        elif (request.form.get('op') == 'longitude'):
            button = 'longitude'
        elif (request.form.get('op') == 'humidity'):
            button = 'humidity'
        elif (request.form.get('op') == 'temp'):
            button = 'temp'
        elif (request.form.get('op') == 'light'):
            button = 'light'
        elif (request.form.get('op') == 'type1'):
            button = 'type1'
        elif (request.form.get('op') == 'per1'):
            button = 'per1'
        elif (request.form.get('op') == 'type2'):
            button = 'type2'
        elif (request.form.get('op') == 'per2'):
            button = 'per2'
        elif (request.form.get('op') == 'type3'):
            button = 'type3'
        elif (request.form.get('op') == 'per3'):
            button = 'per3'

        print("button: ", button)

        cur = db.cursor()
        cur.execute("SELECT * FROM sampleInfo ORDER BY %s", %(button))
        result = cur.fetchall()

    options = {
        "result": result
    }
    return render_template("index.html", **options)