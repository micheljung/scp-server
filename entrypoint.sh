#!/bin/sh

ssh-keygen -A

echo "$AUTHORIZED_KEYS" >$AUTHORIZED_KEYS_FILE

sed -i -e '/chrootpath/d' /etc/rssh.conf
echo "chrootpath = $DATADIR" >> /etc/rssh.conf

groupmod --gid $GROUPID data
usermod --non-unique --home "$DATADIR" --shell /usr/bin/rssh --uid "$USERID" --gid "$GROUPID" "$OWNER"

chown "${OWNER}:data" "$DATADIR"
chown "${OWNER}:data" $AUTHORIZED_KEYS_FILE

exec /usr/sbin/sshd -D -e
