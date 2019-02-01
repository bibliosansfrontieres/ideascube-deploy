FROM i386/alpine:latest

ADD http://filer.bsf-intranet.org/kiwix-serve-i386.v2.0 /kiwix-serve
RUN chmod +x /kiwix-serve

EXPOSE 3000

CMD /kiwix-serve --library --port=3000 /var/ideascube/kiwix/library.xml
