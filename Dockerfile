FROM alpine:3.13
MAINTAINER Michel Jung <michel.jung89@gmail.com>

ENV DATADIR=/data USERID=1000 GROUPID=1000 OWNER=data AUTHORIZED_KEYS_FILE=/authorized_keys

RUN apk --update add shadow openssh rssh rsync \
  && rm -f /etc/ssh/ssh_host_* \
  && addgroup -g $GROUPID data \
  && adduser -D -h "$DATADIR" -G data -H -u $USERID -s /usr/bin/rssh $OWNER \
  && usermod -p '*' data \
  && mkdir -p "$DATADIR" \
  && chown $OWNER "$DATADIR" \
  && touch $AUTHORIZED_KEYS_FILE \
  && chown $OWNER $AUTHORIZED_KEYS_FILE \
  && chmod 0600 $AUTHORIZED_KEYS_FILE \
  && mkdir /var/run/sshd && chmod 0755 /var/run/sshd \
  && echo "allowscp" >> /etc/rssh.conf \
  && echo "allowsftp" >> /etc/rssh.conf \
  && echo "allowrsync" >> /etc/rssh.conf \
  && rm -rf /var/cache/apk/*

COPY entrypoint.sh /
COPY sshd_config /etc/ssh/sshd_config

EXPOSE 22

CMD ["sh", "/entrypoint.sh"]
