FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MEDIAELCH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Mediaelch

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /kclient/public/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mediaelch-logo.png && \
  echo "**** install packages ****" && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 604E3CBB4DEF35FBD9D4928220B2163BC4FD788F && \
  echo "deb http://ppa.launchpad.net/mediaelch/mediaelch-stable/ubuntu jammy main" >> /etc/apt/sources.list.d/mediaelch.list && \
  if [ -z ${MEDIAELCH_VERSION+x} ]; then \
    MEDIAELCH="mediaelch"; \
  else \
    MEDIAELCH="mediaelch=${MEDIAELCH_VERSION}~jammy"; \
  fi && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ${MEDIAELCH} && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /config/.launchpadlib \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
