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
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/quickjs
	SECTION:=lib
	CATEGORY:=Libraries
	URL:=https://bellard.org/quickjs
	TITLE:=A small and embeddable Javascript engine.
	DEPENDS:=+libatomic +libpthread
endef

define Package/quickjs/description
	QuickJS is a small and embeddable Javascript engine. It supports the ES2020 specification including modules, asynchronous generators, proxies and BigInt.
	It optionally supports mathematical extensions such as big decimal floating point numbers (BigDecimal), big binary floating point numbers (BigFloat) and operator overloading.
endef

MAKE_FLAGS += \
	QJSC_CC="$(HOSTCC_NOCACHE)" \
	CROSS_PREFIX="$(TARGET_CROSS)"

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/local/lib/quickjs $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/local/include/quickjs $(1)/usr/include
endef

$(eval $(call BuildPackage,quickjs))