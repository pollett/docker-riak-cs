#FROM ubuntu:14.04
FROM phusion/baseimage:0.9.18

MAINTAINER Hector Castro hectcastro@gmail.com

# Environmental variables
ENV DEBIAN_FRONTEND noninteractive
ENV RIAK_VERSION 1.4.10
ENV RIAK_SHORT_VERSION 1.4
ENV RIAK_CS_VERSION 1.5.2
ENV RIAK_CS_SHORT_VERSION 1.5
ENV STANCHION_VERSION 1.5.0
ENV STANCHION_SHORT_VERSION 1.5
ENV SERF_VERSION 0.6.3

# Install dependencies
RUN apt-get update -qq && apt-get install curl unzip -y

# Install Riak
RUN curl -s https://packagecloud.io/install/repositories/basho/riak/script.deb.sh | bash \
    && apt-get install riak -y
# Setup the Riak service
RUN mkdir -p /etc/service/riak
ADD bin/riak.sh /etc/service/riak/run

# Install Riak CS
RUN curl -s https://packagecloud.io/install/repositories/basho/riak-cs/script.deb.sh | bash \
    && apt-get install riak-cs -y

# Setup the Riak CS service
RUN mkdir -p /etc/service/riak-cs
ADD bin/riak-cs.sh /etc/service/riak-cs/run

# Install Stanchion
RUN curl -s https://packagecloud.io/install/repositories/basho/stanchion/script.deb.sh | bash \
    && apt-get install stanchion -y

# Setup the Stanchion service
RUN mkdir -p /etc/service/stanchion
ADD bin/stanchion.sh /etc/service/stanchion/run

# Setup automatic clustering for Riak
ADD bin/automatic_clustering.sh /etc/my_init.d/99_automatic_clustering.sh

# Install Serf
ADD https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_linux_amd64.zip /
RUN (cd / && unzip serf_${SERF_VERSION}_linux_amd64.zip -d /usr/bin/)

# Setup the Serf service
RUN mkdir -p /etc/service/serf /etc/sudoers.d && \
    adduser --system --disabled-password --no-create-home \
            --quiet --force-badname --shell /bin/bash --group serf && \
    echo "serf ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/99_serf && \
    chmod 0440 /etc/sudoers.d/99_serf
ADD bin/serf.sh /etc/service/serf/run
ADD bin/peer-member-join.sh /etc/service/serf/
ADD bin/seed-member-join.sh /etc/service/serf/

RUN sed -i.bak 's/^storage_backend =/#storage_backend =/' /etc/riak/riak.conf && \
    echo "buckets.default.allow_mult = true" >> /etc/riak/riak.conf

# Make the Riak, Riak CS, and Stanchion log directories into volumes
VOLUME /var/lib/riak
VOLUME /var/log/riak
VOLUME /var/log/riak-cs
VOLUME /var/log/stanchion

# Open the HTTP port for Riak and Riak CS (S3)
EXPOSE 8098 8080 22

# Cleanup
RUN  rm "/serf_${SERF_VERSION}_linux_amd64.zip"
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Leverage the baseimage-docker init system
CMD ["/sbin/my_init", "--quiet"]
