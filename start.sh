#! /usr/bin/env sh
set -e

if [ -f /app/app/main.py ]; then
    DEFAULT_MODULE_NAME=app.main
elif [ -f /app/main.py ]; then
    DEFAULT_MODULE_NAME=main
fi
MODULE_NAME=${MODULE_NAME:-$DEFAULT_MODULE_NAME}
VARIABLE_NAME=${VARIABLE_NAME:-app}
export APP_MODULE=${APP_MODULE:-"$MODULE_NAME:$VARIABLE_NAME"}

if [ -f /app/gunicorn_conf.py ]; then
    DEFAULT_GUNICORN_CONF=/app/gunicorn_conf.py
elif [ -f /app/app/gunicorn_conf.py ]; then
    DEFAULT_GUNICORN_CONF=/app/app/gunicorn_conf.py
else
    DEFAULT_GUNICORN_CONF=/gunicorn_conf.py
fi
export GUNICORN_CONF=${GUNICORN_CONF:-$DEFAULT_GUNICORN_CONF}

# If there's a prestart.sh script in the /app directory or other path specified, run it before starting
PRE_START_PATH=${PRE_START_PATH:-/app/prestart.sh}
echo "Checking for script in $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    . "$PRE_START_PATH"
else 
    echo "There is no script $PRE_START_PATH"
fi

# Start Gunicorn
exec gunicorn -k uvicorn.workers.UvicornWorker -c "$GUNICORN_CONF" "$APP_MODULE" --log-config "/logging.conf" 

#'{"remote_ip":"%(h)s","session_id":"%({X-Session-Id}i)s","status":"%(s)s","request_method":"%(m)s","request_path":"%(U)s","request_querystring":"%(q)s","request_timetaken":"%(D)s","response_length":"%(B)s", "remote_addr": "%(h)s"}'

#--access-logformat='{"ip":"%(h)s","session_id":"%({X-Session-Id}i)s","status":"%(s)s","method":"%(m)s","query":"%(q)s","duration":"%(D)s"}'

# message '%s - "%s %s HTTP/%s" %d'