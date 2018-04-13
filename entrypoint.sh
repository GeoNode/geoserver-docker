#!/bin/bash
set -e

source /root/.bashrc

# control the value of NGINX_BASE_URL variable
if [ ${NGINX_BASE_URL} ]
then
    echo "NGINX_BASE_URL is filled so I'll leave the found value '$NGINX_BASE_URL' \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log
else
    echo "NGINX_BASE_URL is empty so I'll set to localhost \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log
    echo export NGINX_BASE_URL='http://localhost/' >> /root/.override_env
    echo "The calculated value is now NGINX_BASE_URL='$NGINX_BASE_URL' \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log
fi

# set basic tagname
TAGNAME=( "baseUrl" )

# backup geonode REST role service config.xml
cp "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/config.xml" "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/config.xml.orig"
# run the setting script for geonode REST role service
/usr/local/tomcat/tmp/set_geoserver_auth.sh "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/config.xml" "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/" ${TAGNAME} >> /usr/local/tomcat/tmp/set_geoserver_auth.log

# set oauth2 filter tagname
TAGNAME=( "accessTokenUri" "userAuthorizationUri" "redirectUri" "checkTokenEndpointUrl" "logoutUri" )

# backup geonode-oauth2 config.xml
cp ${GEOSERVER_DATA_DIR}/security/filter/geonode-oauth2/config.xml ${GEOSERVER_DATA_DIR}/security/filter/geonode-oauth2/config.xml.orig
# run the setting script for geonode-oauth2
/usr/local/tomcat/tmp/set_geoserver_auth.sh ${GEOSERVER_DATA_DIR}/security/filter/geonode-oauth2/config.xml ${GEOSERVER_DATA_DIR}/security/filter/geonode-oauth2/ "${TAGNAME[@]}" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

# set global tagname
TAGNAME=( "proxyBaseUrl" )

# backup global.xml
cp ${GEOSERVER_DATA_DIR}/global.xml ${GEOSERVER_DATA_DIR}/global.xml.orig
# run the setting script for global configuration
/usr/local/tomcat/tmp/set_geoserver_auth.sh ${GEOSERVER_DATA_DIR}/global.xml ${GEOSERVER_DATA_DIR}/ ${TAGNAME} >> /usr/local/tomcat/tmp/set_geoserver_auth.log

# start tomcat
exec catalina.sh run
