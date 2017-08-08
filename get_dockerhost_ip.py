#!/usr/bin/env python

import docker

BOOTSTRAP_IMAGE_CHEIP = 'codenvy/che-ip:nightly'

client = docker.from_env()
print client.info()
client.containers.run(BOOTSTRAP_IMAGE_CHEIP, network_mode='host')
