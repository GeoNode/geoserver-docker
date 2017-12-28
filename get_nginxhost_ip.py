#!/usr/bin/env python

import os

import docker

client = docker.from_env()
# print client.info()

for network in client.networks.list():
    # if cmp(network.containers, client.containers.list()) is 1:
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
        print "http://{}:80".format(ipaddr)
    except NameError as er:
        raise Exception("NGINX container is not running maybe exited! Running\
containers are:{0}".format(containers))
except KeyError as e:
    raise Exception("There has been a problem with the docker\
network which has raised the following exception: {0}".format(e))
else:
    print "There is no ip address for Nginx within the GeoNode network!"
finally:
    pass
