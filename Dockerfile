FROM openwrt/sdk:aarch64_generic-v23.05.4

COPY . package/feeds/libs/quickjs/

RUN make defconfig && \
    make package/quickjs/compile V=s