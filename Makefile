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

include $(INCLUDE_DIR)/host-build.mk
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
  ES2020 specification.
endef

# Host build for qjsc compiler
define Host/Configure
	# Fix paths for host build
	$(SED) 's|prefix=/usr/local|prefix=$(STAGING_DIR_HOST)|g' $(HOST_BUILD_DIR)/Makefile
endef

define Host/Compile
	$(MAKE) -C $(HOST_BUILD_DIR) \
		PREFIX="$(STAGING_DIR_HOST)" \
		qjsc
endef

define Host/Install
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(INSTALL_BIN) $(HOST_BUILD_DIR)/qjsc $(STAGING_DIR_HOST)/bin/
endef

MAKE_FLAGS += \
	PREFIX=/usr \
	CONFIG_PREFIX=/usr \
	CROSS_PREFIX="$(TARGET_CROSS)"

# Remove OpenWrt's default CFLAGS that might conflict
TARGET_CFLAGS := $(filter-out -fhonour-copts,$(TARGET_CFLAGS))

define Build/Configure
	# Replace default gcc with cross compiler
	$(SED) 's|gcc|$(TARGET_CC)|g' $(PKG_BUILD_DIR)/Makefile
	# Fix paths
	$(SED) 's|prefix=/usr/local|prefix=/usr|g' $(PKG_BUILD_DIR)/Makefile
endef

define Build/Compile
	+$(MAKE_VARS) $(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		$(MAKE_FLAGS) \
		PREFIX="/usr" \
		CROSS_PREFIX="$(TARGET_CROSS)" \
		qjs libquickjs.so
endef

define Package/quickjs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qjs $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_BUILD_DIR)/libquickjs.so* $(1)/usr/lib/
endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,quickjs))