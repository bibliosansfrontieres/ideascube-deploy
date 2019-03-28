FROM i386/alpine:3.8

ENV KIWIX_VERSION=1.1.0

RUN mkdir -p /opt/kiwix-serve && \
    cd /opt/kiwix-serve && \
    wget https://download.kiwix.org/release/kiwix-tools/kiwix-tools_linux-i586-${KIWIX_VERSION}.tar.gz -O kiwix-serve.tar.gz && \
    tar -xzvf kiwix-serve.tar.gz --strip=1 && \
    rm kiwix-serve.tar.gz && \
    mkdir /data

RUN apk add --no-cache tini inotify-tools supervisor

WORKDIR /opt/kiwix-serve

EXPOSE 8080

CMD ["supervisord", "-c", "/docker/supervisord.conf"]

RUN mkdir /docker

ADD docker/* /docker/

RUN chmod +x /docker/rebuild_library.sh && \
    chmod +x /docker/wait_for_change.sh

VOLUME ["/data"]
