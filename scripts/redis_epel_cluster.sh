#!/bin/bash

#set -x
#exec 3>&1 4>&2
#trap 'exec 2>&4 1>&3' 0 1 2 3
#exec 1>/etc/tflog.out 2>&1

INIT_DNS="${name}0.${name}.${name}.oraclevcn.com"
NODE_DNS=$(hostname -f)
MASTER_PRIVATE_IP=$(host "$INIT_DNS" | awk '{ print $4 }')
PRIVATE_IP=$(host "$NODE_DNS" | awk '{ print $4 }')
PASSWORD=${password}

REDIS_PORT=6379
REDIS_CONFIG_FILE=/etc/redis.conf
SENTINEL_PORT=26379
SENTINEL_CONFIG_FILE=/etc/sentinel.conf


# Setup firewall rules
firewall-offline-cmd  --zone=public --add-port=6379/tcp
firewall-offline-cmd  --zone=public --add-port=16379/tcp
firewall-offline-cmd  --zone=public --add-port=26379/tcp
systemctl restart firewalld

yum install epel-release -y ; yum update -y ;yum install redis  -y ; systemctl start redis ; systemctl enable redis; yum install redis-trib  -y;

sed -i "s/^bind 127.0.0.1/bind $PRIVATE_IP/g" $REDIS_CONFIG_FILE
systemctl restart redis

