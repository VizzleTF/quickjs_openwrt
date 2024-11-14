FROM openwrt/sdk:aarch64_cortex-a53-23.05.3

WORKDIR /builder

COPY . package/feeds/utils/quickjs/

RUN echo "src-link packages /builder/package/feeds" > feeds.conf && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a

RUN make defconfig && \
    make package/quickjs/compile V=s