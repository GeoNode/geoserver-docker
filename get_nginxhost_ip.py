#!/usr/bin/env python

import logging
import os
import socket
import sys

import docker

try:
    socket.getaddrinfo('geonode', '80')
    logging.info("k8s service discovery enabled")
    print "http://geonode:80"
    sys.exit()
except socket.gaierror as e:
    logging.info("k8s service discovery not enabled, using docker-compose")

client = docker.from_env()
# print client.info()
# TODO avoid this script can fail and fall in the loop where the geoserver
# service is not available and consequently the nginx too which has geoserver
# as a reference link
for network in client.networks.list():
    if 'geonode' in network.name:
        geonode_network = network.name
    else:
        geonode_network = 'geonode_default'

try:
    containers = {
        c.attrs['Config']['Image']: c.attrs['NetworkSettings']['\
Networks'][geonode_network]['\
IPAddress'] for c in client.containers.list() if c.status in 'running'
    }
    for item in containers.items():
        if "geonode/nginx" in item[0]:
            ipaddr = item[1]

    try:
        os.environ["NGINX_BASE_URL"] = "http://" + ipaddr + ":" + "80"
        nginx_base_url = "http://{}:80".format(ipaddr)
    except NameError as er:
        logging.info("NGINX container is not running maybe exited! Running\
containers are:{0}".format(containers))
except KeyError as ke:
    logging.info("There has been a problem with the docker\
network which has raised the following exception: {0}".format(ke))
else:
    # nginx_base_url = None
    pass
finally:
    try:
        print nginx_base_url
    except NameError as ne:
        print "http://geonode:80"
