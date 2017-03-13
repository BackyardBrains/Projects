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
			#button = 'sampleid'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY sampleid")
			result = cur.fetchall()
		elif (request.form.get('op') == 'deviceid'):
			#button = 'deviceid'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY deviceid")
			result = cur.fetchall()
		elif (request.form.get('op') == 'added'):
			#button = 'added'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY added")
			result = cur.fetchall()
		elif (request.form.get('op') == 'latitude'):
			#button = 'latitude'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY latitude")
			result = cur.fetchall()
		elif (request.form.get('op') == 'longitude'):
			#button = 'longitude'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY longitude")
			result = cur.fetchall()
		elif (request.form.get('op') == 'humidity'):
			#button = 'humidity'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY humidity")
			result = cur.fetchall()
		elif (request.form.get('op') == 'temp'):
			#button = 'temp'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY temp")
			result = cur.fetchall()
		elif (request.form.get('op') == 'light'):
			#button = 'light'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY light")
			result = cur.fetchall()
		elif (request.form.get('op') == 'type1'):
			#button = 'type1'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY type1")
			result = cur.fetchall()
		elif (request.form.get('op') == 'per1'):
			#button = 'per1'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY per1")
			result = cur.fetchall()
		elif (request.form.get('op') == 'type2'):
			#button = 'type2'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY type2")
			result = cur.fetchall()
		elif (request.form.get('op') == 'per2'):
			#button = 'per2'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY per2")
			result = cur.fetchall()
		elif (request.form.get('op') == 'type3'):
			#button = 'type3'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY type3")
			result = cur.fetchall()
		elif (request.form.get('op') == 'per3'):
			#button = 'per3'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY per3")
			result = cur.fetchall()

		#print("button: ", button)

	options = {
		"result": result
	}
	return render_template("index.html", **options)