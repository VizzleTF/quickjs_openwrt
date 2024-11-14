FROM openwrt/sdk:x86_64-v23.05.5

# Create feed directory
RUN mkdir -p /builder/package/feeds/libs/quickjs

# Copy package files
COPY . /builder/package/feeds/libs/quickjs/

# Build package
RUN make defconfig && \
    make package/quickjs/compile V=s