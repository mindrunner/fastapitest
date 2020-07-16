#! /usr/bin/env sh
# replace docker image with the name of your docker built
docker stop fastapi
docker rm fastapi
docker run -it --name=fastapi \
    -p 8080:80 \
    -v $PWD/app:/app \
    -v $PWD/gunicorn_conf.py:/gunicorn_conf.py \
    -v $PWD/logging.conf:/logging.conf \
    -v $PWD/start.sh:/start.sh \
    -v $PWD/start-reload.sh:/start-reload.sh \
    fastapi bash -c "/start.sh"
