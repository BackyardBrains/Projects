from flask import *
from extensions import connect_to_database
from flask import url_for

upload = Blueprint('upload', __name__, template_folder='templates')

db = connect_to_database()

@upload.route('/upload', methods = ['GET', 'POST'])
def upload_route():
	options = {

	}
	return render_template("upload.html", **options)