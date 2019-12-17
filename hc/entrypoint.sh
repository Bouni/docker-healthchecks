#!/bin/sh

app_run() {
    python3 /config.py
    python3 /healthchecks/manage.py compress
    cp -r /healthchecks/static-collected/CACHE /healthchecks/static/CACHE
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
