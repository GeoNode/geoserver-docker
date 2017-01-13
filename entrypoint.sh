#!/bin/bash
set -e

source /root/.bashrc

# backup geonodeAuthProvider config.xml
cp ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml.orig
# run the script for geonodeAuthProvider
/usr/local/tomcat/tmp/set_geoserver_auth.sh ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/ >> /usr/local/tomcat/tmp/set_geoserver_auth.log

# backup geonode REST role service config.xml
cp "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/config.xml" "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/config.xml.orig"
# run the script for geonode REST role service
/usr/local/tomcat/tmp/set_geoserver_auth.sh "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/config.xml" "${GEOSERVER_DATA_DIR}/security/role/geonode REST role service/" >> /usr/local/tomcat/tmp/set_geoserver_auth.log

# start tomcat
exec catalina.sh run
