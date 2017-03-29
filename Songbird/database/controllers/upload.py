from flask import *
from extensions import connect_to_database
from flask import Flask, request, redirect, url_for
from werkzeug.utils import secure_filename
import os
import config

upload = Blueprint('upload', __name__, template_folder='templates')

db = connect_to_database()

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
			filename = secure_filename(file.filename)
			#file.save(os.path.join(config.env['UPLOAD_FOLDER'], filename))
			options = {
				"filename": filename
			}
			return render_template("upload.html", **options)

		
	return render_template("upload.html")