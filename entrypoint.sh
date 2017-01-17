#!/bin/bash
set -e

source /root/.bashrc

# control the value of DOCKER_HOST_IP variable
if ! [ -z "$DOCKER_HOST_IP" ]
then

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

else
    echo "DOCKER_HOST_IP is empty so I'll leave the original files" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

fi

# start tomcat
exec catalina.sh run
