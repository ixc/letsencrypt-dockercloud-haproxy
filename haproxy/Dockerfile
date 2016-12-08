FROM dockercloud/haproxy:1.5.1

RUN apk add --update \
		bash \
		inotify-tools \
		openssl \
	&& rm -rf /var/cache/apk/*

ENV LIVE_CERT_FOLDER="/etc/letsencrypt/live"
ENV PATH="/opt/haproxy/bin:$PATH"

COPY . /opt/haproxy

CMD ["entrypoint.sh", "dockercloud-haproxy"]
