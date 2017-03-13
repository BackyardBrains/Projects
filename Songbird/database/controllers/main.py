from flask import *

from extensions import connect_to_database
from flask import url_for

main = Blueprint('main', __name__, template_folder='templates',url_prefix='/panhxxwm/p1/')

@main.route('/')
def main_route():
    db=connect_to_database()
    cur=db.cursor()


    
    
    
    return render_template("index.html",usernames=result)