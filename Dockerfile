# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MEDIAELCH_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Mediaelch \
    PIXELFLUX_WAYLAND=true

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/mediaelch-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libqt6multimedia6 \
    libqt6sql6-sqlite \
    libqt6svg6 \
    qt6-image-formats-plugins && \
  echo "**** install mediaelch ****" && \
  mkdir -p /opt/mediaelch && \
  DOWNLOAD_URL=$(curl -sX GET "https://api.github.com/repos/Komet/MediaElch/releases/latest" \
    | awk -F '(": "|")' '/https.*MediaElch_linux.*AppImage/ {print $3}') && \
  curl -o \
    /tmp/mediaelch.app -L \
    "${DOWNLOAD_URL}" && \
  chmod +x /tmp/mediaelch.app && \
  cd /tmp && \
  ./mediaelch.app --appimage-extract && \
  mv squashfs-root/* /opt/mediaelch && \
  cp \
    /opt/mediaelch/usr/share/pixmaps/MediaElch.png \
    /usr/share/pixmaps/MediaElch.png && \
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
EXPOSE 3001

VOLUME /config
