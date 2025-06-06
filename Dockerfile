FROM python:3-alpine

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --no-cache libgcc && \
    wget -O altserver https://github.com/NyaMisty/AltServer-Linux/releases/latest/download/AltServer-$([[ $(arch) == armv7l ]] && echo armv7 || echo $(arch)) && \
    wget -O netmuxd https://github.com/jkcoxson/netmuxd/releases/latest/download/$([[ $(arch) == armv7l ]] && echo armv7 || echo $(arch))-linux-netmuxd && \
    chmod +x altserver netmuxd docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
