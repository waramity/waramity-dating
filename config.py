import os
from dotenv import dotenv_values

config = dotenv_values(".env")


class Config:
    DEBUG = False
    TESTING = False
    SESSION_TYPE = 'filesystem'
    SQLALCHEMY_DATABASE_URI = config['SQLALCHEMY_DATABASE_URI']
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = config['SECRET_KEY']
    LANGUAGES = ['th', 'en']
    GOOGLE_CLIENT_ID = config["GOOGLE_CLIENT_ID"]
    GOOGLE_CLIENT_SECRET = config["GOOGLE_CLIENT_SECRET"]
    GOOGLE_DISCOVERY_URL = (
        "https://accounts.google.com/.well-known/openid-configuration"
    )

class DevelopmentConfig(Config):
    DEBUG = True

class TestingConfig(Config):
    TESTING = True
    SQLALCHEMY_DATABASE_URI = os.environ.get('TEST_DATABASE_URL')

class ProductionConfig(Config):
    pass

config_by_name = dict(
    dev=DevelopmentConfig,
    test=TestingConfig,
    prod=ProductionConfig
)
