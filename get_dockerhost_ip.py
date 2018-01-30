#!/usr/bin/env python

import docker

BOOTSTRAP_IMAGE_CHEIP = 'codenvy/che-ip:nightly'


def _docker_host_ip():
    client = docker.from_env()
    ip_list = client.containers.run(BOOTSTRAP_IMAGE_CHEIP,
                                    network_mode='host'
                                    ).split("\n")
    if len(ip_list) > 1:
        print("Docker daemon is running on more than one \
address {0}".format(ip_list))
        print("Only the first address:{0} will be returned!".format(
            ip_list[0]
        ))
    else:
        print("Docker daemon is running at the following \
address {0}".format(ip_list[0]))
    return ip_list[0]


print _docker_host_ip()
