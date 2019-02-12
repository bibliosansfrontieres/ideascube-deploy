FROM i386/alpine:latest

# Configuration variables
ENV HUGO_VERSION 0.54.0
ENV SITE_DIR '/var/www/hugo'
ENV HUGO_BASE_URL http://localhost:1313

RUN apk add --no-cache git openssl curl \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v${VERSION}/hugo_${VERSION}_Linux-32bit.tar.gz | tar -xz \
    && mv hugo /usr/bin/hugo \
    && apk del curl \
    && mkdir ${SITE_DIR}

WORKDIR ${SITE_DIR}

# Expose default hugo port
EXPOSE 1313

# Automatically build site
# ONBUILD ADD site/ ${SITE_DIR}
# ONBUILD RUN hugo -d /usr/share/nginx/html/

# Serve site
CMD hugo server -b ${HUGO_BASE_URL} --renderToDisk --bind=0.0.0.0
