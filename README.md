# QuickJS for OpenWrt

This package provides QuickJS JavaScript engine for OpenWrt. QuickJS is a small and embeddable Javascript engine that supports the ES2020 specification.

## Description

QuickJS is a small and embeddable Javascript engine that supports:
- ES2020 specification
- Modules
- Asynchronous generators
- Proxies
- BigInt
- Mathematical extensions (optional):
  - BigDecimal for big decimal floating point numbers
  - BigFloat for big binary floating point numbers
  - Operator overloading

## Dependencies

- libatomic
- libpthread

## Installation

You can install this package via the OpenWrt package manager:

```bash
opkg update
opkg install quickjs
```

## Building from Source

### Using OpenWrt SDK

1. Download and setup the OpenWrt SDK for your target
2. Add this feed to your `feeds.conf`:

```
src-git quickjs https://github.com/YOUR_USERNAME/openwrt-quickjs.git
```

3. Update and install the feed:
```bash
./scripts/feeds update quickjs
./scripts/feeds install quickjs
```

4. Enable the package in menuconfig:
```bash
make menuconfig
# Go to Libraries -> quickjs
```

5. Build the package:
```bash
make package/quickjs/compile V=s
```

## License

This package is licensed under MIT.