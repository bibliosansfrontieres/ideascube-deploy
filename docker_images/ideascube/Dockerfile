FROM i386/debian:jessie-slim

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /home/ideascube/

RUN \
  apt update -q; \
  apt full-upgrade --purge -q -y; \
  apt install -q -y --no-install-recommends \
    locales \
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

## Set LOCALE to UTF8
#
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

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
