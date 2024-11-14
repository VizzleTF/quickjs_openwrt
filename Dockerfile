FROM openwrt/sdk:aarch64_cortex-a53-23.05.3

COPY . package/feeds/libs/quickjs/

RUN make defconfig && \
    make package/quickjs/compile V=s