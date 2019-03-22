FROM i386/debian:stretch-slim as build

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

RUN apt-get update && \
    apt-get install -y python3-venv build-essential python3 python3-dev libffi-dev python3-setuptools python3-pip libssl-dev libmagic1 libxml2 libxml2-dev libxslt-dev libz-dev && \
    mkdir /opt/api && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists

COPY . /opt/api/

WORKDIR /opt/api

RUN python3 -m venv /opt/api/venv

RUN . /opt/api/venv/bin/activate && pip3 install wheel

RUN . /opt/api/venv/bin/activate && pip3 install -r requirements.txt

FROM i386/debian:stretch-slim

RUN apt-get update && \
    apt-get install -y python3 libmagic1 libxml2 && \
    mkdir /opt/api && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists

COPY --from=build /opt/api/ /opt/api/

WORKDIR /opt/api

RUN chmod +x /opt/api/docker/entrypoint.sh

ENTRYPOINT ["/opt/api/docker/entrypoint.sh"]

CMD ["python3", "run.py"]
