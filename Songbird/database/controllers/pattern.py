from flask import *
from extensions import connect_to_database
from flask import url_for

pattern = Blueprint('pattern', __name__, template_folder='templates')

db = connect_to_database()

@pattern.route('/pattern', methods = ['GET', 'POST'])
def pattern_route():
	options = {

	}
	return render_template("pattern.html", **options)
