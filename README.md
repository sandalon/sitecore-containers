[![Solr logo](https://raw.githubusercontent.com/docker-library/docs/master/solr/logo.png "See more on the Solr homepage")](http://lucene.apache.org/solr/)
# Source

This repository is based upon the work of [kevinobee/docker-solr](https://github.com/kevinobee/docker-solr)

# Solr in Docker

This GitHub repository defines the Docker containers needed for running multiple Solr instances for use with Sitecore.

The images used in this repository are based on Windows Container technology and can only be run using Docker Engine for Windows Containers.

For Solr images that run on Linux-based containers refer to the [official Solr page](https://store.docker.com/images/solr) on the Docker Store.


## What is Apache Solr?

Solr is the popular, blazing-fast, open source enterprise search platform built on Apache Lucene™.

Learn more on the [Solr homepage](http://lucene.apache.org/solr/) and in the [Solr Reference Guide](https://www.apache.org/dyn/closer.cgi/lucene/solr/ref-guide/). For more general information refer to the [Apache Solr](wikipedia.org/wiki/Apache_Solr) wikipedia page.

## Currently Supported Sitecore Versions

Support currently exists for 9.0 Update 2.  Support for 9.1 will be added soon.

## Currently Supported Windows Versions

Running containers is quite a bit more complicated in Windows compared to linux.  It gets even more complicated when running Windows 10 vs Windows Server.  When using Windows 10 you will need to be on build 1809 so that you can use the process isolation level instead of hyperv.  Hyperv containers have a size limitation that is problematic for any larger containers.

## Building and running using the Dockerfile

Generate a self signed keystore/cert that's shared between the container and the host:
```
generate-keystore.ps1
```

Build the Dockerfile and tag the image:
```
docker build -t sandalon/sitecore-solr-90u2 -m 8G .
```

To start the Solr container and get it to listen for traffic on port _8983_ enter the following command:
```
docker run -p 8983:8983 -d --isolation=process --env SC_PREFIX=sc9 --name solr-90u2 sandalon/sitecore-solr-90u2 -m 8g
```
The SC_PREFIX environment variable should match the $prefix variable found in Sitecore's `install.ps1`.

To get the IP address of the running container:
```
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' solr-90u2
```

To stop the running container:
```
docker stop solr-90u2
```

To remove all stopped containers:
```
docker container prune
```

To cleanup your Docker environment:
```
docker system prune --volumes
```

## Installing Sitecore

The docker container has already generated the cores on disk via the Sitecore Installation Framework (SIF).  We'll need to modify the SIF configuration that our install.ps1 script runs to account for this.

1.  In `sitecore-solr.json` remove all tasks except for: `CreateCores`
2.  In `xconnect-solr.json` remove all tasks except for: `CreateCores`

Continue installing Sitecore as per Sitecore's documentation.