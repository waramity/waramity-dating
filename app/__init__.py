from flask import Flask, g, request, redirect, url_for
from flask_babel import Babel
from flask_login import LoginManager
from flask_sqlalchemy import SQLAlchemy
from flask_session import Session
from oauthlib.oauth2 import WebApplicationClient
import os
from flask_socketio import SocketIO

from config import Config
from dotenv import load_dotenv
from pymongo import MongoClient
from flask_login import UserMixin
from bson import ObjectId



load_dotenv()

os.environ['OAUTHLIB_INSECURE_TRANSPORT'] = '1'

app = Flask(__name__)

app.debug = True  # Enable debug mode
app.config.from_object(Config)

app.config['SESSION_TYPE'] = 'filesystem'

babel = Babel(app)
db = SQLAlchemy()
client = WebApplicationClient(app.config['GOOGLE_CLIENT_ID'])
google_client = WebApplicationClient(app.config['GOOGLE_CLIENT_ID'])
sess = Session()

login_manager = LoginManager()
login_manager.login_view = 'auth.login'
login_manager.init_app(app)

from app.features.dating import dating as dating_blueprint, socketio as dating_socket
app.register_blueprint(dating_blueprint)

from app.features.auth import auth as auth_blueprint
app.register_blueprint(auth_blueprint)

dating_socket.init_app(app, manage_session=False)
db.init_app(app)
sess.init_app(app)

@babel.localeselector
def get_locale():
    if not g.get('lang_code', None):
        g.lang_code = request.accept_languages.best_match(
            app.config['LANGUAGES']) or app.config['LANGUAGES'][0]
    return g.lang_code

@app.route('/')
def index():
    if not g.get('lang_code', None):
        get_locale()
    return redirect(url_for('dating.index'))

from .models import Social, User as DatingUser, Gender, Passion

@login_manager.user_loader
def load_user(user_id):
    return DatingUser.query.get(user_id)

with app.app_context():
    from app.features.dating.utils import social_generator, gender_generator, passion_generator
    # db.drop_all()
    db.create_all()
    social_generator()
    gender_generator()
    passion_generator()

    # Check the connection status
