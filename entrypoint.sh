#!/bin/bash
set -e

source /root/.bashrc

# control the value of DOCKER_HOST_IP variable
if ! [ -z ${DOCKER_HOST_IP} ]
then

    echo "DOCKER_HOST_IP is empty so I'll run the python utility \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log
    DOCKER_HOST_IP=`python /usr/local/tomcat/tmp/get_dockerhost_ip.py`
    echo "The calculated value is now DOCKER_HOST_IP='$DOCKER_HOST_IP' \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

else

    echo "DOCKER_HOST_IP is filled so I'll leave the found value '$DOCKER_HOST_IP' \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

fi

# control the value of NGINX_BASE_URL variable
if ! [ -z ${NGINX_BASE_URL} ]
then

    echo "NGINX_BASE_URL is empty so I'll run the python utility \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log
    NGINX_BASE_URL=`python /usr/local/tomcat/tmp/get_nginxhost_ip.py`
    echo "The calculated value is now NGINX_BASE_URL='$NGINX_BASE_URL' \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

else

    echo "NGINX_BASE_URL is filled so I'll leave the found value '$NGINX_BASE_URL' \n" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

fi

# set basic tagname
TAGNAME=( "baseUrl" )

# backup geonodeAuthProvider config.xml
cp ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml.orig
# run the setting script for geonodeAuthProvider
/usr/local/tomcat/tmp/set_geoserver_auth.sh ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/ ${TAGNAME} >> /usr/local/tomcat/tmp/set_geoserver_auth.log

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
