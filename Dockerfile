# https://github.com/tiangolo/uvicorn-gunicorn-docker

FROM python:3.7.7-slim-buster

LABEL maintainer="Klaus-Christian <wfskmoney@gmail.com>"

# pip updates
COPY requirements.txt /requirements.txt
RUN pip install --upgrade pip --no-cache-dir
RUN pip install -r requirements.txt --no-cache-dir

# fastapi files
COPY ./start.sh /start.sh
RUN chmod +x /start.sh
COPY ./start-reload.sh /start-reload.sh
RUN chmod +x /start-reload.sh

# logging
COPY ./gunicorn_conf.py /gunicorn_conf.py
COPY ./logging.conf /logging.conf

COPY ./app /app

WORKDIR /app/

ENV PYTHONPATH=/app

EXPOSE 80

# Run the start script, it will check for an /app/prestart.sh script (e.g. for migrations)
# And then will start Gunicorn with Uvicorn
CMD ["/start.sh"]