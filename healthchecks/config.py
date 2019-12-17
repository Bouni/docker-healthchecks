import os

config = """
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': '/data/healthchecks.sqlite',
        }
    }
SECRET_KEY = "9xQoNhBLywc0N++CXmI+Gfe7xrbx/PCKtbbRVfGMJ/M="
HOST = "0.0.0.0"

"""

ENVVARS = [
    {"var": "SECRET_KEY", "type": "string"},
    {"var": "DEBUG", "type": "bool"},
    {"var": "ALLOWED_HOSTS", "type": "array"},
    {"var": "DEFAULT_FROM_EMAIL", "type": "string"},
    {"var": "USE_PAYMENTS", "type": "bool"},
    {"var": "REGISTRATION_OPEN", "type": "bool"},
    {"var": "DB", "type": "string"},
    {"var": "DB_HOST", "type": "string"},
    {"var": "DB_PORT", "type": "string"},
    {"var": "DB_NAME", "type": "string"},
    {"var": "DB_USER", "type": "string"},
    {"var": "DB_PASSWORD", "type": "string"},
    {"var": "DB_CONN_MAX_AGE", "type": "int"},
    {"var": "DB_SSLMODE", "type": "string"},
    {"var": "DB_TARGET_SESSION_ATTRS", "type": "string"},
    {"var": "EMAIL_HOST", "type": "string"},
    {"var": "EMAIL_PORT", "type": "int"},
    {"var": "EMAIL_HOST_USER", "type": "string"},
    {"var": "EMAIL_HOST_PASSWORD", "type": "string"},
    {"var": "EMAIL_USE_TLS", "type": "bool"},
    {"var": "EMAIL_USE_VERIFICATION", "type": "bool"},
    {"var": "SITE_ROOT", "type": "string"},
    {"var": "SITE_NAME", "type": "string"},
    {"var": "MASTER_BADGE_LABEL", "type": "string"},
    {"var": "PING_ENDPOINT", "type": "string"},
    {"var": "PING_EMAIL_DOMAIN", "type": "string"},
    {"var": "DISCORD_CLIENT_ID", "type": "string"},
    {"var": "DISCORD_CLIENT_SECRET", "type": "string"},
    {"var": "SLACK_CLIENT_ID", "type": "string"},
    {"var": "SLACK_CLIENT_SECRET", "type": "string"},
    {"var": "PUSHOVER_API_TOKEN", "type": "string"},
    {"var": "PUSHOVER_SUBSCRIPTION_URL", "type": "string"},
    {"var": "PUSHOVER_EMERGENCY_RETRY_DELAY", "type": "string"},
    {"var": "PUSHOVER_EMERGENCY_EXPIRATION", "type": "string"},
    {"var": "PUSHBULLET_CLIENT_ID", "type": "string"},
    {"var": "PUSHBULLET_CLIENT_SECRET", "type": "string"},
    {"var": "TELEGRAM_BOT_NAME", "type": "string"},
    {"var": "TELEGRAM_TOKEN", "type": "string"},
    {"var": "TWILIO_ACCOUNT", "type": "string"},
    {"var": "TWILIO_AUTH", "type": "string"},
    {"var": "TWILIO_FROM", "type": "string"},
    {"var": "TWILIO_USE_WHATSAPP", "type": "bool"},
    {"var": "PD_VENDOR_KEY", "type": "string"},
    {"var": "TRELLO_APP_KEY", "type": "string"},
    {"var": "MATRIX_HOMESERVER", "type": "string"},
    {"var": "MATRIX_USER_ID", "type": "string"},
    {"var": "MATRIX_ACCESS_TOKEN", "type": "string"},
    {"var": "APPRISE_ENABLED", "type": "bool"},
    {"var": "SHELL_ENABLED", "type": "bool"},
]

with open("/healthchecks/hc/local_settings.py", "w") as f:
    f.write(config)
    for var in ENVVARS:
        v = os.getenv(f"HC_{var['var']}")
        if not v:
            print(f"ENV var HC_{var['var']} not found.")
            continue
        if var['type'] == "string":
            f.write(f"{var['var']} = \"{v}\"\n")
        elif var['type'] == "bool" or var['type'] == "int" or  var['type'] == "array":
            f.write(f"{var['var']} = {v}\n")
