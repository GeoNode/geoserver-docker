FROM tomcat:9-jre8
MAINTAINER GeoNode Development Team

#
# Set GeoServer version and data directory
#
ENV GEOSERVER_DATA_DIR="/geoserver_data"

#
# Download and install GeoServer
#
RUN cd /usr/local/tomcat/webapps \
    && wget --progress=bar:force:noscroll http://build.geonode.org/geoserver/latest/geoserver-2.9.x.war \
    && unzip -q geoserver-2.9.x.war -d geoserver \
    && rm geoserver-2.9.x.war \
    && mkdir $GEOSERVER_DATA_DIR

VOLUME $GEOSERVER_DATA_DIR
