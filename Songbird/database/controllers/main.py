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
    where = 'WHERE '
    order = ' ORDER BY '
    des = ' DESC'
    equal = ' = '
    notequal = ' = '
    greater = ' > '
    lesser = ' < '
    greaterand = ' >= '
    lesserand = ' <= '

    if request.method == 'POST':
        button = request.form.get('sort')
        direction = request.form.get('dir')
        column = request.form.get('col')
        equation = request.form.get('equ')
        match = request.form.get('crit')

        if column != '' and equation != '' and match != '':
            search = search + where + column
            if equation == 'equal': search += equal
            elif equation == 'notequal': search += notequal
            elif equation == 'greater': search += greater
            elif equation == 'lesser': search += lesser
            elif equation == 'greaterand': search += greaterand
            elif equation == 'lesserand': search += lesserand
            if column == 'type1': search += " '"
            search += match
            if column == 'type1': search += "' "

        if button != '':
            search = search + order + button
        else:
            search = search + order + "sampleid"
        print(search)

        if direction == 'descending':
            search += des

        print(search)

        cur.execute(search)
        result = cur.fetchall()

    options = {
		"result": result,
        "button": button,
        "direction": direction,
        "column": column,
        "equation": equation,
        "match": match
	}
    return render_template("index.html", **options)