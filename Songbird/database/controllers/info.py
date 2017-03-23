from flask import *
from extensions import connect_to_database
from flask import url_for

info = Blueprint('info', __name__, template_folder='templates')

db = connect_to_database()

@info.route('/info', methods = ['GET', 'POST'])
def info_route():
	sampleid = request.args.get('sampleid')
	cur = db.cursor()
	cur.execute('SELECT * FROM sampleInfo WHERE sampleid = %s', (sampleid, ))
	results = cur.fetchone()
	options = {
		"res": results
	}
	return render_template("info.html", **options)