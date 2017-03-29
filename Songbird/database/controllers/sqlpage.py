from flask import *
from extensions import connect_to_database
from flask import url_for

sqlpage = Blueprint('sqlpage', __name__, template_folder='templates')

db = connect_to_database()

@sqlpage.route('/sqlpage', methods = ['GET', 'POST'])
def sqlpage_route():
    db = connect_to_database()
    cur = db.cursor()

    result = ''
    search = ''
    error = ''

    if request.method == 'POST':
        search = request.form.get('command')

        try:
            cur.execute(search)
            result = cur.fetchall()
        except:
            error = True

    options = {
		"result": result,
        "search": search,
        "error": error
	}
    return render_template("sqlpage.html", **options)