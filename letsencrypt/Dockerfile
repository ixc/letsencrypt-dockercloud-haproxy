FROM alpine:edge

RUN apk add --update \
		bash \
		certbot \
		tini \
	&& rm -rf /var/cache/apk/*

EXPOSE 80
VOLUME /etc/letsencrypt

ENV VIRTUAL_HOST="*/.well-known/acme-challenge/*"
ENV VIRTUAL_HOST_WEIGHT="999"
ENV PATH="/opt/letsencrypt/bin:$PATH"

COPY . /opt/letsencrypt/
RUN ln -fs /opt/letsencrypt/bin/update-certs.sh /etc/periodic/daily/

ENTRYPOINT ["tini", "--"]
CMD ["entrypoint.sh", "crond", "-f"]
