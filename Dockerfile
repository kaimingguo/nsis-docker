# syntax=docker/dockerfile:1
FROM python:3-slim AS builder

ARG NSIS_VERSION=3.08.1 \
    NSIS_NUM=7336-1

# To enable logging
ENV PYTHONUNBUFFERED=1

RUN apt-get update && \
    apt-get --no-install-recommends install -y \
        binutils-mingw-w64 g++-mingw-w64-i686 gcc-mingw-w64-i686 \
        libz-mingw-w64 libz-mingw-w64-dev mingw-w64-i686-dev \
        wget unzip build-essential zlib1g zlib1g-dev && \
    rm -rf /var/lib/apt/lists/* && \
    pip3 install scons

WORKDIR /app
RUN wget -O trunk.zip https://sourceforge.net/projects/nsisbi/files/nsisbi${NSIS_VERSION}/nsis-code-${NSIS_NUM}-NSIS-trunk.zip/download && \
    unzip trunk.zip

WORKDIR /app/nsis-code-${NSIS_NUM}-NSIS-trunk
RUN XGCC_W32_PREFIX=i686-w64-mingw32- scons PREFIX=/opt ZLIB_W32=/usr/i686-w64-mingw32 install

COPY Plugins/amd64-unicode /opt/share/nsis/Plugins/
COPY Plugins/x86-ansi/*.dll /opt/share/nsis/Plugins/x86-ansi/
COPY Plugins/x86-unicode/*.dll /opt/share/nsis/Plugins/x86-unicode/

FROM debian:bookworm-slim
COPY --from=builder /opt /opt
WORKDIR /app
ENTRYPOINT ["/opt/bin/makensis", "-V4"]
