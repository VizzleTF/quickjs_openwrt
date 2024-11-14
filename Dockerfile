FROM openwrt/sdk:aarch64_cortex-a53-23.05.3

WORKDIR /builder

# Копируем исходники пакета
COPY . package/feeds/utils/quickjs/

# Настраиваем и собираем
RUN echo "src-link packages /builder/package/feeds" > feeds.conf && \
    ./scripts/feeds update -a && \
    ./scripts/feeds install -a && \
    make defconfig && \
    make package/quickjs/compile V=s