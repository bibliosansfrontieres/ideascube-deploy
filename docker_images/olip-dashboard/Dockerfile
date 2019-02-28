FROM i386/node:8 as builder

RUN mkdir /opt/build

COPY . /opt/build

RUN cd /opt/build && \
    npm install && \
    npm install -g quasar quasar-cli && \
    quasar build

FROM i386/nginx:1.15

COPY --from=builder /opt/build/dist/* /usr/share/nginx/html/

COPY docker/nginx.conf /etc/nginx/nginx.conf

ENV API_URL=http://localhost:5002

ADD docker/startup.sh /startup.sh

ENTRYPOINT ["sh", "/startup.sh"]

CMD ["nginx", "-g", "daemon off;"]
