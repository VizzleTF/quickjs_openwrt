include $(TOPDIR)/rules.mk

PKG_NAME:=quickjs
PKG_VERSION:=2020-11-08
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=https://bellard.org/quickjs/
PKG_HASH:=skip

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Ivan K <vizzlef@gmail.com>

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/quickjs
	SECTION:=utils
	CATEGORY:=Utilities
	URL:=https://bellard.org/quickjs
	TITLE:=QuickJS JavaScript interpreter
	DEPENDS:=+libatomic +libpthread
endef

define Package/quickjs/description
	QuickJS is a small and embeddable Javascript engine.
endef

MAKE_FLAGS += \
	QJSC_CC="$(HOSTCC_NOCACHE)" \
	CROSS_PREFIX="$(TARGET_CROSS)"

define Package/quickjs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/local/bin/qjs $(1)/usr/bin
endef

$(eval $(call BuildPackage,quickjs))