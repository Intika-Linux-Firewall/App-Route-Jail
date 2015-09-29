include $(TOPDIR)/rules.mk

PKG_NAME:=approute-utils
PKG_VERSION:=1
PKG_RELEASE:=1

#PKG_SOURCE:=systemd-$(PKG_VERSION).tar.xz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_SOURCE_SUBDIR)
#PKG_SOURCE_URL:=http://www.freedesktop.org/software/systemd/
#PKG_MD5SUM:=e0d6c9a4b4f69f66932d2230298c9a34

PKG_BUILD_DEPENDS:=

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
  that in combination allow full application - specific routing and name resolution
endef

define Build/Configure
        : Do nothing
endef

define Build/Compile
        glib-genmarshal --prefix=g_udev_marshal --header $(PKG_BUILD_DIR)/src/gudev/gudevmarshal.list >$(PKG_BUILD_DIR)/src/gudev/gudevmarshal.h
        echo '#include "gudevmarshal.h"' >$(PKG_BUILD_DIR)/src/gudev/gudevmarshal.c
        glib-genmarshal --prefix=g_udev_marshal --body $(PKG_BUILD_DIR)/src/gudev/gudevmarshal.list >>$(PKG_BUILD_DIR)/src/gudev/gudevmarshal.c
        $(TARGET_CC) -L$(INTL_PREFIX)/lib -L$(STAGING_DIR)/lib -shared -o $(SONAME) -Wl,-soname=$(SONAME) -fPIC -I$(PKG_BUILD_DIR)/src `pkg-config --cflags --libs libudev glib-2.0 gobject-2.0` -D_GUDEV_COMPILA
TION $(PKG_BUILD_DIR)/src/gudev/*.c
        sed 's,@prefix@,/usr,;s,@exec_prefix@,/usr,;s,@libdir@,/usr/lib,;s,@includedir@,/usr/include,;s,@VERSION@,$(PKG_VERSION),' $(PKG_BUILD_DIR)/src/gudev/$(GUDEV_NAME)-$(GUDEV_VERSION).pc.in >$(GUDEV_NAME)
-$(GUDEV_VERSION).pc
endef

define Build/InstallDev
        $(INSTALL_DIR) $(1)/usr/include/$(GUDEV_NAME)-$(GUDEV_VERSION)/$(GUDEV_NAME)
        $(CP) $(PKG_BUILD_DIR)/src/gudev/*.h $(1)/usr/include
        $(INSTALL_DIR) $(1)/usr/lib
        $(INSTALL_DATA) $(SONAME) $(1)/usr/lib/
        $(LN) $(SONAME) $(1)/usr/lib/lib$(GUDEV_NAME)-$(GUDEV_VERSION).so
        $(INSTALL_DIR) $(1)/usr/lib/pkgconfig
        $(INSTALL_DATA) $(GUDEV_NAME)-$(GUDEV_VERSION).pc $(1)/usr/lib/pkgconfig/
endef

define Package/gudev1/install
        $(INSTALL_DIR) $(1)/usr/lib
        $(CP) $(SONAME) $(1)/usr/lib/
endef

$(eval $(call BuildPackage,gudev1))
