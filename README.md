SCP server
==========

Restricted SSH server which allows SCP/SFTP/RSYNC access only. This image is meant to provide an ability to update content in data containers. You would normally make a constellation of your service, a data container, and the scp-server container.

The scp-server container is configured at runtime with environment variables to match the configuration of the main service. The environment variables are:

* AUTHORIZED_KEYS - contains the public SSH keys for the users who will be allowed to upload.
* DATADIR - The location where relative paths start from.
* USERID - The numeric id of the `data` account. Defaults to 1000.
* GROUPID - The numeric id of the `data` group. Defaults to 1000.

Running
-------

It is easiest if you use docker-compose. Then you can specify the authorized SSH keys in a block declaration:

docker-compose.yml file:
```
version: '3.9'

scpserver:
  image: eeacms/scp-server
  ports:
    - <PORT>:22
  environment:
    AUTHORIZED_KEYS: |
      ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEA4FhFro3H....vg0hrC3s0= First key
      ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAteQ38qb7....uC839w== Another key 
    DATADIR: /data
    USERID: 1000
    GROUPID: 1000
  volumes:
    - data
  
volumes:
  data:
```

When started, you can upload data into the container (e.g. via scp) as the `data` user:

    scp -P <PORT> <FILE> data@<DOCKER-HOST>:
    sftp -P <PORT> data@<DOCKER-HOST>
    rsync --rsh="ssh -p <PORT>" <FILE> data@localhost:

