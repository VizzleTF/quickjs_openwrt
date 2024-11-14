include $(TOPDIR)/rules.mk

PKG_NAME:=quickjs
PKG_VERSION:=2024-01-13
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://bellard.org/quickjs/
PKG_HASH:=3c4bf8f895bfa54beb486c8d1218112771ecfc5ac3be1036851ef41568212e03

PKG_MAINTAINER:=Ivan K <vizzlef@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

define Package/quickjs
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=QuickJS Javascript Engine
  URL:=https://bellard.org/quickjs/
  DEPENDS:=+libatomic +libpthread
endef

define Package/quickjs/description
  QuickJS is a small and embeddable Javascript engine
endef

# Remove problematic flags
TARGET_CFLAGS := $(filter-out -fhonour-copts,$(TARGET_CFLAGS))

define Build/Prepare
	$(call Build/Prepare/Default)
	# Create an empty repl.c to avoid host-qjsc dependency
	touch $(PKG_BUILD_DIR)/repl.c
	# Fix version string in qjs.c
	$(PATCH) $(PKG_BUILD_DIR) ./patches
endef

define Build/Compile
	+$(MAKE_VARS) $(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		PREFIX="/usr" \
		CONFIG_PREFIX="/usr" \
		CC="$(TARGET_CC)" \
		CROSS_PREFIX="$(TARGET_CROSS)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		qjs libquickjs.a
endef

define Package/quickjs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qjs $(1)/usr/bin/
endef

$(eval $(call BuildPackage,quickjs))