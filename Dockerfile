FROM certbot/certbot

RUN apk add curl jq

COPY --chmod=0755 ./scripts /tmp/scripts
