FROM python:3-alpine

COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY install-altstore.sh /install-altstore.sh

RUN apk add --no-cache jq libgcc && \
    wget -O altserver https://github.com/NyaMisty/AltServer-Linux/releases/latest/download/AltServer-$([[ $(arch) == armv7l ]] && echo armv7 || echo $(arch)) && \
    wget -O netmuxd https://github.com/jkcoxson/netmuxd/releases/download/v0.1.4/$([[ $(arch) == armv7l ]] && echo armv7 || echo $(arch))-linux-netmuxd && \
    chmod +x altserver netmuxd docker-entrypoint.sh install-altstore.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
