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
	button = 'Not Sorted'
	if request.method == 'POST':
		if (request.form.get('op') == 'sampleid'):
			button = 'Sample ID'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY sampleid")
			result = cur.fetchall()
		elif (request.form.get('op') == 'deviceid'):
			button = 'Device ID'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY deviceid")
			result = cur.fetchall()
		elif (request.form.get('op') == 'added'):
			button = 'Time'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY added")
			result = cur.fetchall()
		elif (request.form.get('op') == 'latitude'):
			button = 'Latitude'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY latitude")
			result = cur.fetchall()
		elif (request.form.get('op') == 'longitude'):
			button = 'Longitude'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY longitude")
			result = cur.fetchall()
		elif (request.form.get('op') == 'humidity'):
			button = 'Humidity'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY humidity")
			result = cur.fetchall()
		elif (request.form.get('op') == 'temp'):
			button = 'Temperature'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY temp")
			result = cur.fetchall()
		elif (request.form.get('op') == 'light'):
			button = 'Light'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY light")
			result = cur.fetchall()
		elif (request.form.get('op') == 'type1'):
			button = 'First Match Species'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY type1")
			result = cur.fetchall()
		elif (request.form.get('op') == 'per1'):
			button = 'First Match Percentage'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY per1")
			result = cur.fetchall()
		elif (request.form.get('op') == 'type2'):
			button = 'Second Match Species'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY type2")
			result = cur.fetchall()
		elif (request.form.get('op') == 'per2'):
			button = 'Second Match Percentage'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY per2")
			result = cur.fetchall()
		elif (request.form.get('op') == 'type3'):
			button = 'Third Match Species'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY type3")
			result = cur.fetchall()
		elif (request.form.get('op') == 'per3'):
			button = 'Third Match Percentage'
			cur = db.cursor()
			cur.execute("SELECT * FROM sampleInfo ORDER BY per3")
			result = cur.fetchall()
	else:
		cur = db.cursor()
		cur.execute("SELECT * FROM sampleInfo")
		result = cur.fetchall()

	options = {
		"result": result,
        "button": button
	}
	return render_template("index.html", **options)