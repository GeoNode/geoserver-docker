#!/usr/bin/env python

import os

import docker

client = docker.from_env()
# print client.info()

for network in client.networks.list():
    if cmp(network.containers, client.containers.list()) is 1:
        geonode_network = network.name

if geonode_network:
    containers = {
        c.attrs['Config']['Image']: c.attrs['NetworkSettings']['\
Networks'][geonode_network]['\
IPAddress'] for c in client.containers.list() if c.status in 'running'
    }
else:
    pass

for item in containers.items():
    if "geonode/nginx" in item[0]:
        ipaddr = item[1]

if ipaddr:
    os.environ["NGINX_BASE_URL"] = "http://" + ipaddr + ":" + "80"
    print "http://{}:80".format(ipaddr)
else:
    print "NGINX container is not running maybe exited!"
