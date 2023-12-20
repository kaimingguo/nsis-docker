# syntax=docker/dockerfile:1
FROM python:3-slim

ARG NSIS_VERSION=3.08.1
ARG NSIS_NUM=7336-1

# To enable logging
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get --no-install-recommends install -y \
        binutils-mingw-w64 g++-mingw-w64-i686 gcc-mingw-w64-i686 \
        libz-mingw-w64 libz-mingw-w64-dev mingw-w64-i686-dev \
        wget unzip build-essential zlib1g zlib1g-dev

RUN pip3 install scons

WORKDIR /app

RUN wget -O trunk.zip https://sourceforge.net/projects/nsisbi/files/nsisbi${NSIS_VERSION}/nsis-code-${NSIS_NUM}-NSIS-trunk.zip/download
RUN unzip trunk.zip
WORKDIR /app/nsis-code-${NSIS_NUM}-NSIS-trunk

RUN XGCC_W32_PREFIX=i686-w64-mingw32- scons PREFIX=/opt/nsis ZLIB_W32=/usr/i686-w64-mingw32 install
CMD ["/opt/nsis/bin/makensis"]
