include $(TOPDIR)/rules.mk

PKG_NAME:=approute-utils
PKG_VERSION:=1
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/nls.mk

define Package/approute-utils
  SECTION:=net
  CATEGORY:=Network
  TITLE:=LD_PRELOAD mark.so and newns program to force specific route for an app
  URL:=https://github.com/grandrew/approute_utils
endef

define Package/approute-utils/description
  This package contains the LD_PRELOAD library mark.so and newns program
  that in combination allow full application - specific routing and name resolution.
endef

define Build/Configure
        : Do nothing
endef

define Build/Compile
	$(TARGET_CC) -fPIC -c -D_GNU_SOURCE -o mark.o mark.c
	$(TARGET_CC) -shared -o mark.so mark.o -ldl
	$(TARGET_CC) -D_GNU_SOURCE -o newns newns.c
endef

define Package/approute-utils/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) mark.so $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(CP) newns $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,approute-utils))
