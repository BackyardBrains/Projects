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
			cur = db.cursor()
			add_song = ("INSERT INTO sampleInfo (sampleid, deviceid, added, latitude, longitude, humidity, temp, light, type1, per1, type2, per2, type3, per3) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)")
			data_song = (400, -1, datetime.datetime.now(), 111.11, 112.12, 50, 50.45, 15.15, "bird1", 0.85, "bird2", 0.35, "bird3", 0.05)
			cur.execute(add_song, data_song)

			filename = secure_filename(file.filename)
			file.save(os.path.join(config.env['UPLOAD_FOLDER'], filename))
			options = {
				"filename": filename
			}
			return render_template("upload.html", **options)

		
	return render_template("upload.html")