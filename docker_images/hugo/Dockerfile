FROM i386/alpine:latest

# Configuration variables
ENV SITE_DIR '/hugo'
ENV HUGO_BASE_URL http://localhost:1313

RUN apk add --no-cache git openssl curl \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-32bit.tar.gz | tar -xz \
    && mv hugo /usr/bin/hugo \
    && apk del curl \
    && mkdir ${SITE_DIR}

WORKDIR ${SITE_DIR}

# Expose default hugo port
EXPOSE 1313

# Serve site
ENTRYPOINT hugo server -b ${HUGO_BASE_URL} --renderToDisk --bind=0.0.0.0
