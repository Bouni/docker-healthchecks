import os

config = """
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/data/hc.sqlite',
        }
    }
SECRET_KEY = "9xQoNhBLywc0N++CXmI+Gfe7xrbx/PCKtbbRVfGMJ/M="
DEBUG = False
HOST = "0.0.0.0"
"""

with open("/healthchecks/hc/local_settings.py", "w") as f:
    f.write(config)
