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

    update = 'update'
    delete = 'delete'
    insert = 'insert'
    create = 'create'
    alter = 'alter'
    drop = 'drop'
    select = 'select'

    if request.method == 'POST':
        search = request.form.get('command')

        if update in search.lower() or delete in search.lower() or insert in search.lower():
            error = 'Command not allowed, please only use the SELECT command.'
        elif create in search.lower() or alter in search.lower() or drop in search.lower():
            error = 'Command not allowed, please only use the SELECT command.'
        elif select not in search.lower():
            error = 'Command not allowed, please only use the SELECT command.'

        if not error:
            try:
                cur.execute(search)
                result = cur.fetchall()
            except:
                error = 'The SQL command returned an error.'

        if not result and not error:
            error = 'Search did not return any results.'

    options = {
		"result": result,
        "search": search,
        "error": error
	}
    return render_template("sqlpage.html", **options)