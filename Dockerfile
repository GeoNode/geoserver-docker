FROM tomcat:9-jre8
MAINTAINER GeoNode Development Team

#
# Set GeoServer version and data directory
#
ENV GEOSERVER_VERSION=2.12.x
ENV GEOSERVER_DATA_DIR="/geoserver_data/data"

#
# Download and install GeoServer
#
RUN cd /usr/local/tomcat/webapps \
    && wget --progress=bar:force:noscroll \
    http://build.geonode.org/geoserver/latest/geoserver-${GEOSERVER_VERSION}.war \
    && unzip -q geoserver-${GEOSERVER_VERSION}.war -d geoserver \
    && rm geoserver-${GEOSERVER_VERSION}.war \
    && mkdir -p $GEOSERVER_DATA_DIR

VOLUME $GEOSERVER_DATA_DIR

###########docker host###############
# Set DOCKERHOST variable if DOCKER_HOST exists
ARG DOCKERHOST=${DOCKERHOST}
# for debugging
RUN echo -n #1===>DOCKERHOST=${DOCKERHOST}
#
ENV DOCKERHOST ${DOCKERHOST}
# for debugging
RUN echo -n #2===>DOCKERHOST=${DOCKERHOST}

###########docker host ip#############
# Set GEONODE_HOST_IP address if it exists
ARG GEONODE_HOST_IP=${GEONODE_HOST_IP}
# for debugging
RUN echo -n #1===>GEONODE_HOST_IP=${GEONODE_HOST_IP}
#
ENV GEONODE_HOST_IP ${GEONODE_HOST_IP}
# for debugging
RUN echo -n #2===>GEONODE_HOST_IP=${GEONODE_HOST_IP}
# If empty set DOCKER_HOST_IP to GEONODE_HOST_IP
ENV DOCKER_HOST_IP=${DOCKER_HOST_IP:-${GEONODE_HOST_IP}}
# for debugging
RUN echo -n #1===>DOCKER_HOST_IP=${DOCKER_HOST_IP}
# Trying to set the value of DOCKER_HOST_IP from DOCKER_HOST
RUN if ! [ -z ${DOCKER_HOST_IP} ]; \
    then echo export DOCKER_HOST_IP=${DOCKERHOST} | \
    sed 's/tcp:\/\/\([^:]*\).*/\1/' >> /root/.bashrc; \
    else echo "DOCKER_HOST_IP is already set!"; fi
# for debugging
RUN echo -n #2===>DOCKER_HOST_IP=${DOCKER_HOST_IP}

# Set WEBSERVER public port
ARG PUBLIC_PORT=${PUBLIC_PORT}
# for debugging
RUN echo -n #1===>PUBLIC_PORT=${PUBLIC_PORT}
#
ENV PUBLIC_PORT=${PUBLIC_PORT}
# for debugging
RUN echo -n #2===>PUBLIC_PORT=${PUBLIC_PORT}

# set nginx base url for geoserver
RUN echo export NGINX_BASE_URL=http://${NGINX_HOST}:${NGINX_PORT}/ | \
    sed 's/tcp:\/\/\([^:]*\).*/\1/' >> /root/.bashrc

# copy the script and perform the run of scripts from entrypoint.sh
RUN mkdir -p /usr/local/tomcat/tmp
WORKDIR /usr/local/tomcat/tmp
COPY set_geoserver_auth.sh /usr/local/tomcat/tmp
COPY setup_auth.sh /usr/local/tomcat/tmp
COPY requirements.txt /usr/local/tomcat/tmp
COPY get_dockerhost_ip.py /usr/local/tomcat/tmp
COPY get_nginxhost_ip.py /usr/local/tomcat/tmp
COPY entrypoint.sh /usr/local/tomcat/tmp

RUN apt-get update \
    && apt-get -y upgrade \
    && apt-get install -y python python-pip python-dev \
    && chmod +x /usr/local/tomcat/tmp/set_geoserver_auth.sh \
    && chmod +x /usr/local/tomcat/tmp/setup_auth.sh \
    && chmod +x /usr/local/tomcat/tmp/entrypoint.sh \
    && pip install --upgrade pip \
    && pip install -r requirements.txt \
    && chmod +x /usr/local/tomcat/tmp/get_dockerhost_ip.py \
    && chmod +x /usr/local/tomcat/tmp/get_nginxhost_ip.py

CMD ["/usr/local/tomcat/tmp/entrypoint.sh"]
