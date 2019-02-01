FROM i386/alpine:3.8
COPY traefik_linux-386 /usr/local/bin/traefik
RUN chmod +x /usr/local/bin/traefik
COPY entrypoint.sh /
EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
CMD ["traefik"]

# Metadata
LABEL org.label-schema.vendor="Containous" \
      org.label-schema.url="https://traefik.io" \
      org.label-schema.name="Traefik" \
      org.label-schema.description="A modern reverse-proxy" \
      org.label-schema.version="v1.7.7" \
      org.label-schema.docker.schema-version="1.0"
