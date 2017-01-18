#!/bin/sh
sed -i 's@http://localhost:8000/@'"$SITEURL"'@g' /geoserver_data/data/security/filter/geonode-oauth2/config.xml
sed -i 's@http://localhost:8080/geoserver@'"$GEOSERVER_PUBLIC_LOCATION"'@g' /geoserver_data/data/security/filter/geonode-oauth2/config.xml
sed -i.bak 's@<baseUrl>\([^<][^<]*\)</baseUrl>@<baseUrl>'"$SITEURL"'</baseUrl>@'\
           /geoserver_data/data/security/role/geonode\ REST\ role\ service/config.xml