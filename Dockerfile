FROM openwrt/sdk:x86_64-v23.05.5

RUN mkdir -p /builder/package/feeds/lib/quickjs

COPY . /builder/package/feeds/lib/quickjs/

RUN make defconfig && \
    make package/quickjs/compile V=s && \
    mkdir -p bin/packages/x86_64/lib