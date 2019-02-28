FROM i386/debian:stretch-slim

RUN apt-get update && \
    apt-get install -y build-essential python3 python3-dev libffi-dev python3-setuptools python3-pip libssl-dev libmagic1 libxml2 libxml2-dev libxslt-dev libz-dev && \
    mkdir /opt/api && \
    apt-get clean && \
    rm -Rf /var/lib/apt/lists

COPY . /opt/api/

WORKDIR /opt/api

RUN pip3 install wheel

RUN pip3 install -r requirements.txt

CMD ["python3", "run.py"]
