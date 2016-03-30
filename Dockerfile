FROM shimaore/debian:2.0.6
MAINTAINER Stéphane Alnet <stephane@shimaore.net>

# Install prereqs
RUN apt-get update && apt-get --no-install-recommends -y install \
  bison \
  build-essential \
  ca-certificates \
  flex \
  git \
  libcurl4-gnutls-dev \
  libjson0-dev \
  libmicrohttpd-dev \
  libncurses5-dev \
  libsctp-dev \
  libssl-dev \
  libxml2-dev \
  m4 \
  netbase \
  pkg-config \
  && \
  useradd -m opensips && \
  mkdir -p /opt/opensips && \
  chown -R opensips.opensips /opt/opensips

USER opensips
WORKDIR /home/opensips
# RUN git clone https://github.com/OpenSIPS/opensips.git opensips.git
RUN \
  git clone -b fix-721 https://github.com/shimaore/opensips.git opensips.git && \
  cd opensips.git && \
  git checkout 72eb52ab4cbd9a74fcbe712a3989fe184ae80f2d && \
  make TLS=1 SCTP=1 prefix=/opt/opensips include_modules="b2b_logic db_http httpd json rest_client" && \
  make TLS=1 SCTP=1 prefix=/opt/opensips include_modules="b2b_logic db_http httpd json rest_client" modules && \
  make TLS=1 SCTP=1 prefix=/opt/opensips include_modules="b2b_logic db_http httpd json rest_client" install && \
  cd .. && \
  rm -rf opensips.git

# Cleanup
USER root
RUN apt-get purge -y \
  bison \
  build-essential \
  ca-certificates \
  cpp-5 \
  flex \
  gcc-5 \
  git \
  m4 \
  pkg-config \
  && apt-get autoremove -y && \
  apt-get install -y \
  libmicrohttpd10 \
  && apt-get clean
USER opensips
WORKDIR /home/opensips
