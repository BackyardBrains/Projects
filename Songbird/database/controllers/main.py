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


    search = 'SELECT * FROM sampleInfo '
    where = ' WHERE '
    order = ' ORDERED BY '
    des = ' DESC'
    equal = ' = '
    less = ' < '
    great = ' > '

    if request.method == 'POST':
        button = request.form.get('sort')

        cur.execute(search)
        result = cur.fetchall()

    options = {
		"result": result
	}
    return render_template("index.html", **options)