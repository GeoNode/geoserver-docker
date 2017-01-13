FROM tomcat:9-jre8
MAINTAINER GeoNode Development Team

#
# Set GeoServer version and data directory
#
ENV GEOSERVER_VERSION=2.9.x-oauth2
ENV GEOSERVER_DATA_DIR="/geoserver_data/data"

#
# Download and install GeoServer
#
RUN cd /usr/local/tomcat/webapps \
    && wget --progress=bar:force:noscroll http://build.geonode.org/geoserver/latest/geoserver-${GEOSERVER_VERSION}.war \
    && unzip -q geoserver-${GEOSERVER_VERSION}.war -d geoserver \
    && rm geoserver-${GEOSERVER_VERSION}.war \
    && mkdir -p $GEOSERVER_DATA_DIR

VOLUME $GEOSERVER_DATA_DIR

# Set DOCKER_HOST address
ARG DOCKER_HOST=${DOCKER_HOST}
# for debugging
RUN echo -n DOCKER_HOST=$DOCKER_HOST
#
ENV DOCKER_HOST ${DOCKER_HOST}
# for debugging
RUN echo -n DOCKER_HOST=$DOCKER_HOST

ENV DOCKER_HOST_IP ${DOCKER_HOST_IP}
RUN echo export DOCKER_HOST_IP=${DOCKER_HOST} | sed 's/tcp:\/\/\([^:]*\).*/\1/' >> /root/.bashrc

# for debugging
RUN echo -n DOCKER_HOST_IP=${DOCKER_HOST_IP}
# ENV DOCKER_HOST_IP ${DOCKER_HOST_IP}
# Set WEBSERVER public port
ARG PUBLIC_PORT=${PUBLIC_PORT}
# for debugging
RUN echo -n PUBLIC_PORT=${PUBLIC_PORT}
#
ENV PUBLIC_PORT=${PUBLIC_PORT}
# for debugging
RUN echo -n PUBLIC_PORT=${PUBLIC_PORT}

# set nginx base url for geoserver
RUN echo export BASE_URL=http://${NGINX_HOST}:${NGINX_PORT}/ | sed 's/tcp:\/\/\([^:]*\).*/\1/' >> /root/.bashrc

# copy the script and perform the change to config.xml
RUN mkdir -p /usr/local/tomcat/tmp
WORKDIR /usr/local/tomcat/tmp
COPY set_geoserver_auth.sh /usr/local/tomcat/tmp
RUN chmod +x /usr/local/tomcat/tmp/set_geoserver_auth.sh

COPY setup_auth.sh /usr/local/tomcat/tmp
RUN chmod +x /usr/local/tomcat/tmp/setup_auth.sh
COPY entrypoint.sh /usr/local/tomcat/tmp/entrypoint.sh
RUN chmod +x /usr/local/tomcat/tmp/entrypoint.sh
CMD ["/usr/local/tomcat/tmp/entrypoint.sh"]
