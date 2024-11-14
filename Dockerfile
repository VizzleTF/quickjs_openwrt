FROM openwrt/sdk:x86_64-v23.05.5

RUN ./scripts/feeds update -a && \
    ./scripts/feeds install luci-base && \
    mkdir -p package/feeds/libs/quickjs

COPY . package/feeds/libs/quickjs/

RUN make defconfig && \
    make package/quickjs/compile V=s && \
    mkdir -p bin/packages/x86_64/libs && \
    cp bin/packages/x86_64/base/quickjs_*.ipk bin/packages/x86_64/libs/