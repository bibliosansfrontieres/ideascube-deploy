FROM i386/debian:jessie-slim

WORKDIR /home/ideascube/

RUN \
  apt update -q; \
  apt full-upgrade --purge -q -y; \
  apt install -q -y --no-install-recommends \
    autoconf \
    automake \
    cython3 \
    gcc \
    git \
    libdbus-glib-1-dev \
    libjpeg-dev \
    libtool \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    make \
    python3 \
    python3-pip \
    python3-dev \
    python3-wheel \
    zlib1g-dev; \
  apt-get clean -y; \
  rm -fr \
    /usr/share/doc/* \
    /var/cache/debconf/*

RUN git clone https://framagit.org/ideascube/ideascube.git /home/ideascube/

EXPOSE 9000

RUN \
  pip3 install --upgrade pip setuptools uwsgi; \
  pip3 install -r /home/ideascube/requirements.txt; \
  sed -i 's|/opt/venvs/$NAME|/usr/local|' extras/bin/ideascube; \
  ln -s /home/ideascube/extras/bin/ideascube /usr/bin/ideascube; \
  ln -s /home/ideascube/ideascube/ /usr/local/lib/python3.4/dist-packages/ideascube; \
  ln -s /home/ideascube/storage /var/cache/ideascube; \
  ln -s /home/ideascube/storage /var/ideascube; \
  mkdir -p /usr/share/ideascube/static/branding; \
  cp /home/ideascube/debian/ideascube.default /etc/default/ideascube;

RUN \
  apt remove --purge -q -y \
    autoconf \
    automake \
    gcc \
    cython3 \
    git \
    make

ENTRYPOINT ["uwsgi", "--ini", "/tmp/ideascube.ini"]
