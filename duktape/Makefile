include $(TOPDIR)/rules.mk

PKG_NAME:=duktape
PKG_VERSION:=1.0.1
PKG_EXTRA_VERSION:=
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)$(PKG_EXTRA_VERSION).tar.xz
PKG_SOURCE_URL:=http://duktape.org/
PKG_MD5SUM:=1986f377f341823b92d68699f4432816

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=Duktape embeddable JavaScript interpreter
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=
  URL:=http://www.duktape.org
  MAINTAINER:=AllSeen Alliance <allseen-core@lists.allseenalliance.org>
endef


define Package/$(PKG_NAME)/description
Duktape is a light-weight embeddable JavaScript interpreter.  It is provided as
a C source file that is to be compiled into other projects.  Because it is
highly configurable at compile-time, it is not suitable for being built as a
library.
endef

define Build/Configure/Default
# Override default to do nothing
endef

define Build/Compile
# Duktape does not get compiled.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr
	$(INSTALL_DIR) $(1)/usr/src
	$(INSTALL_DIR) $(1)/usr/src/duktape
	$(INSTALL_DIR) $(1)/usr/src/duktape/src
	$(CP) $(PKG_BUILD_DIR)/src/duktape.c $(1)/usr/src/duktape/src
	$(CP) $(PKG_BUILD_DIR)/src/duktape.h $(1)/usr/src/duktape/src
endef

define Package/ajtcl/install
# Nothing to directly install.
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
