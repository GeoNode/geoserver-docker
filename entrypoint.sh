#!/bin/bash
set -e

source /root/.bashrc

# backup config.xml
cp ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml.orig
# run the script
/usr/local/tomcat/tmp/set_geoserver_auth.sh ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/config.xml ${GEOSERVER_DATA_DIR}/security/auth/geonodeAuthProvider/ > /usr/local/tomcat/tmp/set_geoserver_auth.log

# start tomcat
exec catalina.sh run
