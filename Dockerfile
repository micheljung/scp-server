FROM alpine:3.13
MAINTAINER Michel Jung <michel.jung89@gmail.com>

ENV DATADIR=/data AUTHORIZED_KEYS_FILE=/authorized_keys USERID=1000 GROUPID=1000 OWNER=data

RUN apk --update add shadow openssh rssh rsync \
  && rm -f /etc/ssh/ssh_host_* \
  && addgroup -g $GROUPID data \
  && adduser -D -h "$DATADIR" -G data -H -u $USERID -s /usr/bin/rssh $OWNER \
  && mkdir -p "$DATADIR" \
  && chown $OWNER "$DATADIR" \
  && echo "AuthorizedKeysFile $AUTHORIZED_KEYS_FILE" >>/etc/ssh/sshd_config \
  && echo "KexAlgorithms curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1" >>/etc/ssh/sshd_config \
  && touch $AUTHORIZED_KEYS_FILE \
  && chown $OWNER $AUTHORIZED_KEYS_FILE \
  && chmod 0600 $AUTHORIZED_KEYS_FILE \
  && mkdir /var/run/sshd && chmod 0755 /var/run/sshd \
  && echo "allowscp" >> /etc/rssh.conf \
  && echo "allowsftp" >> /etc/rssh.conf \
  && echo "allowrsync" >> /etc/rssh.conf \
  && rm -rf /var/cache/apk/*

ADD entrypoint.sh /

EXPOSE 22

CMD ["sh", "/entrypoint.sh"]
