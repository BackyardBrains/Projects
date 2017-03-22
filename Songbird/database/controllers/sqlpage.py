from flask import *
from extensions import connect_to_database
from flask import url_for

sqlpage = Blueprint('sqlpage', __name__, template_folder='templates')

db = connect_to_database()

@sqlpage.route('/', methods = ['GET', 'POST'])
def sqlpage_route():