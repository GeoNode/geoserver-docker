#!/usr/bin/env python

import json
import os

import docker

client = docker.from_env()
# print client.info()

for c in client.containers.list():
    # print json.loads(c.attrs)
    image = c.attrs['Config']['Image']
    if 'geonode/nginx' in image:
        ipaddr = c.attrs['NetworkSettings']['IPAddress']
        os.environ["NGINX_BASE_URL"] = "http://" + ipaddr + ":" + "80"
    else:
        print "NGINX container is not running maybe exited!"
