#
# Copyright (C) 2021 CTCGFW Project-OpenWrt
# <https://project-openwrt.eu.org>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=quickjs
PKG_VERSION:=2024-01-13
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://bellard.org/quickjs/
PKG_HASH:=skip

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=CN_SZTL <cnsztl@project-openwrt.eu.org>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk

define Package/quickjs
	SECTION:=lib
	CATEGORY:=Libraries
	URL:=https://bellard.org/quickjs
	TITLE:=A small and embeddable Javascript engine
	DEPENDS:=+libatomic +libpthread
endef

define Package/quickjs/description
	QuickJS is a small and embeddable Javascript engine. It supports the ES2020 specification including modules, asynchronous generators, proxies and BigInt.
	It optionally supports mathematical extensions such as big decimal floating point numbers (BigDecimal), big binary floating point numbers (BigFloat) and operator overloading.
endef

MAKE_FLAGS += \
	PREFIX=/usr \
	CONFIG_PREFIX=/usr \
	HOST_CFLAGS="$(HOST_CFLAGS)" \
	HOST_LDFLAGS="$(HOST_LDFLAGS)" \
	CROSS_PREFIX="$(TARGET_CROSS)"

define Build/Prepare
	$(call Build/Prepare/Default)
	$(SED) 's,-fhonour-copts,,g' $(PKG_BUILD_DIR)/Makefile
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/libquickjs.a $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/quickjs.h $(1)/usr/include
	$(CP) $(PKG_BUILD_DIR)/quickjs-libc.h $(1)/usr/include
endef

define Package/quickjs/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libquickjs.so* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qjs $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qjsc $(1)/usr/bin/
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,quickjs))