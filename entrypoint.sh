#!/bin/sh

#cd /healthchecks || { echo "/healthchecks directory not found. Exit 1"; exit 1; }
#
#DB_TYPE="sqlite3"
#DB_HOST="127.0.0.1"
#DB_PORT="3306"
#DB_NAME="healthchecks"
#DB_USER="healthchecks"
#DB_PASSWORD="healthchecks"
#    
#HC_SECRET_KEY="secret"
#
#databaseConfiguration() {
#    touch /healthchecks/hc/local_settings.py
#    cat <<EOF > /healthchecks/hc/local_settings.py
#DATABASES = {
#    'default': {
#        'ENGINE': 'django.db.backends.sqlite3',
#        'NAME': '/data/hc.sqlite',
#    }
#}
#EOF
#}
#
#settingsConfiguration() {
#    if [ -z "${HC_HOST+x}" ]; then
#        export HC_HOST="0.0.0.0"
#    fi
#    if [ ! -z "${HC_SITE_ROOT+x}" ] && [ -z "${HC_PING_ENDPOINT}" ]; then
#        export HC_PING_ENDPOINT="$HC_SITE_ROOT/ping/"
#    fi
#    given_settings=($(env | sed -n -r 's/HC_([0-9A-Za-z_]*).*/\1/p'))
#    for setting_key in "${given_settings[@]}"; do
#        key="HC_$setting_key"
#        setting_var="${!key}"
#        if [ -z "$setting_var" ]; then
#            echo "Empty var for key \"$setting_key\"."
#            continue
#        fi
#	    case "$setting_var" in
#            [Tt][Rr][Uu][Ee]|[Ff][Aa][Ll][Ss][Ee])
#                setting_type="plain"
#            ;;
#            \[*\])
#                setting_type="plain"
#            ;;
#            [0-9]*.[0-9]**)
#                setting_type="string"
#            ;;
#            [0-9]*)
#                setting_type="plain"
#            ;;
#            *)
#                setting_type="string"
#            ;;
#	    esac
#
#        if [ "$setting_key" = "SECRET_KEY" ] || [ "$setting_key" = "HOST" ] || [ "$setting_key" = "TELEGRAM_TOKEN" ] || \
#            [ "$setting_key" = "PD_VENDOR_KEY" ] || [ "$setting_key" = "TRELLO_APP_KEY" ] || [ "$setting_key" = "TWILIO_ACCOUNT" ] || \
#            [ "$setting_key" = "TWILIO_AUTH" ] || [ "$setting_key" = "TWILIO_FROM" ]; then
#            setting_type="string"
#        elif [ "$setting_key" = "ALLOWED_HOSTS" ] || [ "$setting_key" = "AUTHENTICATION_BACKENDS" ] || \
#            [ "$setting_key" = "TEMPLATES" ] || [ "$setting_key" = "STATICFILES_FINDERS" ]; then
#                setting_type="plain"
#        fi
#
#        if [ "$setting_type" = "plain" ]; then
#            echo "$setting_key = $setting_var" >> /healthchecks/hc/local_settings.py
#        else
#            echo "$setting_key = \"$setting_var\"" >> /healthchecks/hc/local_settings.py
#        fi
#        echo "Added \"$setting_key\" (type \"$setting_type\") to local_settings.py"
#    done
#}
#
#appRun() {
#    #databaseConfiguration
#    #settingsConfiguration
#    #python3 /healthchecks/manage.py compress
#    #ln -s /healthchecks/static-collected/CACHE /healthchecks/static/CACHE
#
#    #echo "Correcting config file permissions ..."
#    #chmod 755 -f /healthchecks/hc/settings.py /healthchecks/hc/local_settings.py
#
#    #echo "Migrating database ..."
#    #python3 /healthchecks/manage.py migrate --noinput
#
#    exec supervisord -c /etc/supervisor/supervisord.conf
#}
#
#appManagePy() {
#    COMMAND="$1"
#    shift 1
#    if [ -z "$COMMAND" ]; then
#        echo "No command given for manage.py. Defaulting to \"shell\"."
#        COMMAND="shell"
#    fi
#    echo "Running manage.py ..."
#    set +e
#    exec python3 /healthchecks/manage.py $COMMAND "$@"
#}
app_run() {
    python3 /config.py
    python3 /healthchecks/manage.py compress
    ln -s /healthchecks/static-collected/CACHE /healthchecks/static/CACHE
    chmod 755 -f /healthchecks/hc/settings.py /healthchecks/hc/local_settings.py
    python3 /healthchecks/manage.py migrate --noinput
    exec supervisord -c /etc/supervisor/supervisord.conf
}

app_manage() {
    echo "todo"
}

case "$1" in
    app:run)
        echo "Run app"
        app_run
    ;;
    app:manage)
        shift 1
        app_manage "$@"
    ;;
    *)
esac
