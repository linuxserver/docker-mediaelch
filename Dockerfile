# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debianbookworm

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
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mediaelch-logo.png && \
  echo "**** install packages ****" && \
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x604E3CBB4DEF35FBD9D4928220B2163BC4FD788F" | gpg --dearmor | tee /usr/share/keyrings/mediaelch.gpg >/dev/null && \
  echo "deb [aarch=amd64 signed-by=/usr/share/keyrings/mediaelch.gpg] http://ppa.launchpad.net/mediaelch/mediaelch-stable/ubuntu jammy main" > /etc/apt/sources.list.d/mediaelch.list && \
  if [ -z ${MEDIAELCH_VERSION+x} ]; then \
    MEDIAELCH="mediaelch"; \
  else \
    MEDIAELCH="mediaelch=${MEDIAELCH_VERSION}~jammy"; \
  fi && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    ${MEDIAELCH} && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
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
