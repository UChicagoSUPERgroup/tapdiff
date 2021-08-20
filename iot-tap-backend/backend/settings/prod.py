from .base import *


def __get_secrets(secret_name):
    try:
        with open('/run/secrets/{}'.format(secret_name), 'r') as secret_file:
            return secret_file.read().strip(' \n')
    except IOError:
        return None


# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = __get_secrets('backend_django_secret')

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = False


ALLOWED_HOSTS = [
    'localhost:4200', 
    __get_secrets('host_domain')
]

# Database
# https://docs.djangoproject.com/en/2.0/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'ifttt',
        'USER': __get_secrets('db_username'),
        'PASSWORD': __get_secrets('db_password'),
        'HOST': 'postgres'
        }
}

# CORS settings
# https://github.com/ottoyiu/django-cors-headers
# CORS whitelist
CORS_ORIGIN_WHITELIST = (
    'localhost:4200', 
    __get_secrets('host_domain')
)
