# QuickJS for OpenWrt

QuickJS is a extremly small and embeddable JavaScript engine.

## Features

- Extremly small weight

## Installation

Install the pre-built package:

```bash
wget https://github.com/VizzleTF/quickjs_openwrt/releases/download/v0.0.5/quickjs_2020-11-08-2_aarch64_cortex-a53.ipk -O quickjs.ipk
opkg install quickjs.ipk
```

## Usage

After installation, use the QuickJS interpreter:

```bash
qjs script.js     # Run JavaScript file
qjs               # Start REPL mode
```

## Building from Source

1. Clone the repository
2. Use the provided Docker-based build system
3. Find built packages in the `bin` directory

## License

MIT License

## Dependencies

- libatomic
- libpthread