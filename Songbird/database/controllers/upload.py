from flask import *
import MySQLdb
import MySQLdb.cursors
import extensions
import config
import os
import hashlib
from flask import Flask, request, redirect, url_for
from werkzeug import secure_filename
import datetime

upload = Blueprint('upload', __name__, template_folder='templates')

db = extensions.connect_to_database()

@upload.route('/upload', methods = ['GET','POST'])
def upload_route():
	if request.method == 'POST':
		if 'file' not in request.files:
			options = {
				"noFile": True
			}
			return render_template("upload.html", **options)

		file = request.files['file']

		if file.filename == '':
			options = {
				"emptyname": True
			}
			return render_template("upload.html", **options)

		else:
			latitude_get = request.form['latitude']
			if latitude_get != '':
				latitude = float(latitude_get)
			else:
				latitude = -1

			longitude_get = request.form['longitude']
			if longitude_get != '':
				longitude = float(longitude_get)
			else:
				longitude = -1

			humidity_get = request.form['humidity']
			if humidity_get != '':
				humidity = float(humidity_get)
			else:
				humidity = -1

			temp_get = request.form['temp']
			if temp_get != '':
				temp = float(temp_get)
			else:
				temp = -1

			light_get = request.form['light']
			if light_get != '':
				light = float(light_get)
			else:
				light = -1

			# do the identification process here

			cur = db.cursor()
			add_song = ("INSERT INTO sampleInfo (sampleid, deviceid, added, latitude, longitude, humidity, temp, light, type1, per1, type2, per2, type3, per3) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
			data_song = (1002, -1, datetime.datetime.now(), latitude, longitude, humidity, temp, light, "bird1", 0.85, "bird2", 0.35, "bird3", 0.05)
			#data_song = (1111, -1, datetime.datetime.now(), latitude, longitude, 90, 80, 70, "bird1", 0.85, "bird2", 0.35, "bird3", 0.05)
			cur.execute(add_song, data_song)

			filename = secure_filename(file.filename)
			file.save(os.path.join(config.env['UPLOAD_FOLDER'], filename))
			options = {
				"filename": filename
			}
			return render_template("upload.html", **options)

		
	return render_template("upload.html")