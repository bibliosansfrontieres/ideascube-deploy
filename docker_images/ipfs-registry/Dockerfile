FROM i386/debian:stretch-slim

EXPOSE 5000
ENV IPFS_GATEWAY https://localhost:8080
ENTRYPOINT ["/start.sh"]


RUN \
  apt update -q; \
  apt full-upgrade --purge -q -y; \
  apt install -q -y --no-install-recommends \
    python-pip \
    nginx \
    uwsgi \
    uwsgi-plugin-python \
    supervisor; \
  apt-get clean -y; \
  rm -fr \
    /usr/share/doc/* \
    /var/cache/debconf/*


RUN pip install base58 flask

COPY dumb-init  /usr/local/bin/

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
        ln -sf /dev/stderr /var/log/nginx/error.log && \
        ln -sf /dev/stdout /var/log/uwsgi.log

COPY wsgi.conf /
COPY proxy.conf /
COPY locations.conf /
COPY https.conf /

COPY start.sh /
COPY nginx.conf /
COPY app.py /

COPY supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord"]
