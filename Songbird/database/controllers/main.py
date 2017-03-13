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
    if request.method == 'POST':
        button = request.form.get('op')
        print("button: ", button)

        cur = db.cursor()
        cur.execute("SELECT * FROM sampleInfo ORDER BY %s", (button, ))
        result = cur.fetchall()

    options = {
        "result": result
    }
    return render_template("index.html", **options)