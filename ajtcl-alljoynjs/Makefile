include $(TOPDIR)/rules.mk

PKG_NAME:=ajtcl-alljoynjs
SRC_NAME:=alljoyn-js
PKG_VERSION:=15.09.00dev
PKG_RELEASE:=1
PKG_MD5SUM:=
PKG_BUILD_DIR:=$(BUILD_DIR)/$(SRC_NAME)-$(PKG_VERSION)-src
PKG_SOURCE:=$(SRC_NAME)-$(PKG_VERSION)-src.tar.gz
PKG_SOURCE_URL:=https://build.allseenalliance.org/ci/job/master-source-extraction/lastSuccessfulBuild/artifact/depot/

# SCons supports parallel builds but does not support make's jobserver
PKG_BUILD_PARALLEL:=$(if $(CONFIG_PKG_BUILD_USE_JOBSERVER),0,1)

PKG_CONFIG_DEPENDS:= \
	CONFIG_DEBUG

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=AllJoyn Thin Client - AllJoyn JS
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+ajtcl +ajtcl-services
  URL:=http://www.allseenalliance.org
  MAINTAINER:=AllSeen Alliance <allseen-core@lists.allseenalliance.org>
endef

define Package/$(PKG_NAME)/description
AllJoyn Thin Client AllJoynJS binding is a basic, low-level JavaScript
interpreter that uses the Duktape embeddable JavaScript engine for developing
ad hoc peer-to-peer applications that use the AllJoyn protocol.
endef

define Package/$(PKG_NAME)-samples
$(call Package/$(PKG_NAME))
  TITLE+=- testing samples
  DEPENDS:=@(PACKAGE_$(PKG_NAME))
endef

define Package/$(PKG_NAME)-samples/description
Sample JavaScript programs that use AllJoyn via alljoyn.js.
endef

ifeq ($(CONFIG_DEBUG),y)
  ALLJOYN_BUILD_VARIANT:=debug
else
  ALLJOYN_BUILD_VARIANT:=release
endif

TARGET_CFLAGS+=-D_POSIX_C_SOURCE

define Build/Configure/Default
# Override default to do nothing
endef

define Build/Compile
	CROSS_CFLAGS="$(TARGET_CFLAGS) $(EXTRA_CFLAGS) $(TARGET_CPPFLAGS)" \
	CROSS_LINKFLAGS="$(TARGET_LINKFLAGS) $(TARGET_LDFLAGS)" \
	CROSS_PATH=$(TARGET_PATH) \
	CROSS_PREFIX=$(TARGET_CC:gcc=) \
	scons -C $(PKG_BUILD_DIR) \
		$(PKG_JOBS) \
		WS=off \
		TARG=linux \
		V=1 \
		"VARIANT=$(ALLJOYN_BUILD_VARIANT)"
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/dist/bin/alljoynjs $(1)/usr/bin/
endef

define Package/$(PKG_NAME)-samples/install
	$(INSTALL_DIR) $(1)/usr
	$(INSTALL_DIR) $(1)/usr/share
	$(INSTALL_DIR) $(1)/usr/share/alljoyn.js
	$(CP) $(PKG_BUILD_DIR)/js/*.js $(1)/usr/share/alljoyn.js/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-samples))
