#!/usr/bin/env python

import os

import docker

client = docker.from_env()
# print client.info()

# Assuming default network for geonode 'geonode_default'
containers = {
    c.attrs['Config']['Image']: c.attrs['NetworkSettings']['\
Networks']['geonode_default']['\
IPAddress'] for c in client.containers.list() if c.status in 'running'
}

for item in containers.items():
    if "geonode/nginx" in item[0]:
        ipaddr = item[1]

if ipaddr:
    os.environ["NGINX_BASE_URL"] = "http://" + ipaddr + ":" + "80"
else:
    print "NGINX container is not running maybe exited!"
