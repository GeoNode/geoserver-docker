#!/bin/bash
set -e

source /root/.bashrc

# Those environment variables can be set to be an ip address with a port or a hostname / dns.
# For development you should either set them to be the docker container ip address or
# the container name that holds nginx. For example:

# SITEURL=http://nginx/
# GEOSERVER_PUBLIC_LOCATION=http://nginx/geoserver/


# Set django url from environment variables.
sed -i 's@http://localhost:8000/@'"$SITEURL"'@g' /geoserver_data/data/security/filter/geonode-oauth2/config.xml
# Set geoserver url from environment variables.
sed -i 's@http://localhost:8080/geoserver@'"$GEOSERVER_PUBLIC_LOCATION"'@g' /geoserver_data/data/security/filter/geonode-oauth2/config.xml
# Set django url from environment variables.
sed -i.bak 's@<baseUrl>\([^<][^<]*\)</baseUrl>@<baseUrl>'"$SITEURL"'</baseUrl>@'\
           /geoserver_data/data/security/role/geonode\ REST\ role\ service/config.xml

# start tomcat
exec catalina.sh run