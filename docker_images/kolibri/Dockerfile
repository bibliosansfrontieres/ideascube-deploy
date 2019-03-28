FROM i386/python:3.6-alpine3.8

ENV KOLIBRI_VERSION 0.12.1

RUN mkdir -p /opt/kolibri && \
    cd /opt/kolibri && \
    wget http://pantry.learningequality.org/downloads/kolibri/v${KOLIBRI_VERSION}/kolibri-${KOLIBRI_VERSION}.pex -O /opt/kolibri/kolibri.pex && \
    chmod +x /opt/kolibri/kolibri.pex && \
    mkdir /data

EXPOSE 8080

WORKDIR /data

RUN apk add --no-cache tini && \
    adduser -S -h /data kolibri && \
    chown kolibri /data

USER kolibri

ENTRYPOINT [ "tini", "-s", "--" ]

CMD ["python", "/opt/kolibri/kolibri.pex", "start", "--foreground"]
