include $(TOPDIR)/rules.mk

PKG_NAME:=quickjs
PKG_VERSION:=2024-01-13
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://bellard.org/quickjs/
PKG_HASH:=3c4bf8f895bfa54beb486c8d1218112771ecfc5ac3be1036851ef41568212e03

PKG_MAINTAINER:=YOUR_NAME <your.email@example.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/quickjs
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=QuickJS Javascript Engine
  URL:=https://bellard.org/quickjs/
  DEPENDS:=+libatomic +libpthread
endef

define Package/quickjs/description
  QuickJS is a small and embeddable Javascript engine that supports the 
  ES2020 specification including modules, asynchronous generators, 
  proxies and BigInt.
endef

MAKE_FLAGS += \
	PREFIX=/usr \
	CONFIG_PREFIX=/usr

# Remove OpenWrt's default CFLAGS for host build
HOST_CFLAGS := $(filter-out -fhonour-copts,$(HOST_CFLAGS))

define Build/Configure
	# Replace default gcc with cross compiler
	$(SED) 's|gcc|$(TARGET_CC)|g' $(PKG_BUILD_DIR)/Makefile
	# Fix paths
	$(SED) 's|prefix=/usr/local|prefix=/usr|g' $(PKG_BUILD_DIR)/Makefile
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) \
		CROSS_PREFIX="$(TARGET_CROSS)" \
		PREFIX="/usr" \
		$(MAKE_FLAGS)
endef

define Package/quickjs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qjs $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qjsc $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libquickjs.so* $(1)/usr/lib/
endef

$(eval $(call BuildPackage,quickjs))