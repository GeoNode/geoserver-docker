# geoserver-docker

[GeoServer](http://geoserver.org) is an open source server for sharing geospatial data.
This is a docker image that eases setting up a GeoServer running specifically for [GeoNode](https://github.com/GeoNode/geoserver-geonode-ext) with an additional separated data directory.

The image is based on the official Tomcat 9 image

## Installation

This image is available as a [trusted build on the docker hub](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/), and is the recommended method of installation.
Simple pull the image from the docker hub.

```bash
$ docker pull geonode/geoserver
```

Alternatively you can build the image locally

```bash
$ git clone https://github.com/geonode/geoserver-docker.git
$ cd geoserver-docker
$ docker build -t "geonode/geoserver" .
```

## Quick start

You can quick start the image using the command line

Before run the container, dowload lastest data-2.xx.x.zip file from https://build.geo-solutions.it/geonode/geoserver/latest/  
Create folder geoserver on your host:
```bash
$ sudo mkdir /opt/geoserver/
$ sudo unzip ~/Dowmload/data-2.15.x.zip -d /opt/geoserver/
```
then run the container:  
```bash
$ docker run --name "geoserver" -v /var/run/docker.sock:/var/run/docker.sock -v /opt/geoserver/data/:/geoserver_data/data -d -p 8080:8080 geonode/geoserver
```

Point your browser to `http://localhost:8080/geoserver` and login using GeoServer's default username and password:

* Username: admin
* Password: geoserver

## How to use different versions

There are mainly two different versions of this image which are useful for running **GeoNode** with different authentication system types. These versions are released as specific tags for two authentication mechanisms:

**Cookie based authn**:
- [geonode/geoserver:2.9.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/8389cb2d-124d-4f30-a02b-f11106baa33c/)

**Oauth2 based authn**:
- [geonode/geoserver:2.9.x-oauth2](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/fd08708f-d495-4a40-8cbf-62a504e93b2c/)
- [geonode/geoserver:2.10.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/d8b90ab2-498f-4044-adad-7e3e0888fc39/)
- [geonode/geoserver:2.12.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/fb121f26-9270-4b14-9466-78e3f93f69ce/)
- [geonode/geoserver:2.13.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/6183c42d-5e11-44f1-b15c-cdcb817e94d9/)
- [geonode/geoserver:2.14.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/62de4f4f-6fe0-4dec-bed3-dc0ab1cf70d9/)
- [geonode/geoserver:2.15.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver/builds/190cee01-d9c8-4e6c-beaa-a0b5d8adffd5/)

You can declare what version to use along with the data directory tag which corresponds to the same version.  

## Configuration

### Data volume

This GeoServer container keeps its configuration data at `/geoserver_data/data` which is exposed as volume in the dockerfile.
The volume allows for stopping and starting new containers from the same image without losing all the data and custom configuration.

You may want to map this volume to a directory on the host. It will also ease the upgrade process in the future. Volumes can be mounted by passing the `-v` flag to the docker run command:

```bash
-v /your/host/data/path:/geoserver_data/data
```

### Data volume container

In case you are running Compose for automatically having GeoServer up and running then a data volume container will be mounted with a default preloaded *GEOSERVER_DATA_DIR* at the configuration data directory of the container.
Make sure that the image from the repository [data-docker](https://github.com/GeoNode/data-docker) is available from the [GeoNode Docker Hub](https://hub.docker.com/u/geonode/) or has been built locally:

```bash
docker build -t geonode/geoserver_data .
```

#### Persistance behavior

If you run:

```bash
docker-compose stop
```

Data are retained in the *GEOSERVER_DATA_DIR* and can then be mounted in a new GeoServer instance by running again:

```bash
docker-compose up
```

If you run:

```bash
docker-compose down
```

Data are completely gone but you can ever start from the base GeoServer Data Directory built for Geonode.

#### Data directory versions

There has to be a correspondence one-to-one between the data directory version and the tag of the GeoServer image used in the Docker compose file. So at the end you can consume these images below:

* **2.9.x**: [geonode/geoserver_data:2.9.x](https://hub.docker.com/r/geonode/geoserver_data/builds/bsus6alnddg4bc7icwymevp/)
* **2.9.x-oauth2**: [geonode/geoserver_data:2.9.x-oauth2](https://hub.docker.com/r/geonode/geoserver_data/builds/bwkxcupsunvuitzusi9gsnt/)
* **2.10.x**: [geonode/geoserver_data:2.10.x](https://hub.docker.com/r/geonode/geoserver_data/builds/b5jqhpzapkqxzyevjizccug/)
* **2.12.x**: [geonode/geoserver_data:2.12.x](https://hub.docker.com/r/geonode/geoserver_data/builds/byaaalw3lnasunpveyg3x4i/)
* **2.13.x**: [geonode/geoserver_data:2.13.x](https://hub.docker.com/r/geonode/geoserver_data/builds/bunuqzq7a7dk65iumjhkbtc/)
* **2.14.x**: [geonode/geoserver_data:2.14.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver_data/builds/545f08f9-75a3-4161-bcb0-895c1817dc8d/)
* **2.15.x**: [geonode/geoserver_data:2.15.x](https://cloud.docker.com/u/geonode/repository/registry-1.docker.io/geonode/geoserver_data/builds/dce29f95-b6f7-4f5e-86f1-78d5e98fd866/)

### Database

GeoServer recommends the usage of a spatial database

#### PostGIS container (PostgreSQL + GIS Extension)

If you want to use a [PostGIS](http://postgis.org/) container, you can link it to this image. You're free to use any PostGIS container.
An example with [kartooza/postgis](https://registry.hub.docker.com/u/kartoza/postgis/) image:

```bash
$ docker run -d --name="postgis" kartoza/postgis
```

For further information see [kartooza/postgis](https://registry.hub.docker.com/u/kartoza/postgis/).

Now start the GeoServer instance by adding the `--link` option to the docker run command:

```bash
--link postgis:postgis
```
