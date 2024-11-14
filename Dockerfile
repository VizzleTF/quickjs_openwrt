FROM openwrt/sdk:x86_64-v23.05.5

COPY . package/feeds/lib/quickjs/

RUN make defconfig && \
    make package/quickjs/compile V=s && \
    make package/quickjs/install V=s