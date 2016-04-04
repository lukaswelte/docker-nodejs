FROM alpine:3.3
MAINTAINER Lukas Welte "info@lukaswelte.de"

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION v5.10.0

RUN apk upgrade --update \
 && apk add curl make gcc g++ linux-headers paxctl musl-dev \
    libgcc libstdc++ binutils-gold python openssl-dev zlib-dev \
 && mkdir -p /root/src \
 && cd /root/src \
 && curl -sSL https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.tar.gz | tar -xz \
 && cd /root/src/node-* \
 && ./configure --prefix=/usr --without-snapshot \
 && make -j$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
 && make install \
 && paxctl -cm /usr/bin/node \
 && npm cache clean \
 && apk del make gcc g++ python linux-headers \
 && rm -rf /root/src /tmp/* /usr/share/man /var/cache/apk/* \
    /root/.npm /root/.node-gyp /usr/lib/node_modules/npm/man \
    /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html \
 && apk search --update

CMD [ "node" ]
