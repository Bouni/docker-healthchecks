FROM alpine:latest

LABEL maintainer="Bouni <bouni@owee.de>"

RUN apk update && \
    apk upgrade

RUN addgroup -g 1000 -S healthchecks && \ 
    adduser -u 1000 -S healthchecks -G healthchecks \
    --home /home/healthchecks --shell /bin/bash && \
    mkdir -p /healthchecks /data && \
    chown healthchecks:healthchecks -R /healthchecks /data 

RUN set -ex && \
    apk --no-cache add sudo git postgresql-dev gcc musl-dev supervisor 

RUN apk add --no-cache python3 python3-dev && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --no-cache --upgrade pip setuptools wheel && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi

RUN pip3 install gunicorn psycopg2 && \
    sudo -u healthchecks -g healthchecks sh -c "git clone https://github.com/healthchecks/healthchecks.git /healthchecks" && \
    cd /healthchecks && \
    pip3 install -r requirements.txt && \
    pip3 install braintree  && \
    rm -rf /tmp/*

RUN apk del python3-dev gcc musl-dev postgresql-dev git

COPY entrypoint.sh /entrypoint.sh
COPY supervisord.conf /etc/supervisor/
RUN chmod +x /entrypoint.sh

RUN chown -R healthchecks:healthchecks \
    /var/log \
    /run

USER healthchecks

VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["app:run"]
