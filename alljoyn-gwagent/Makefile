AJ_SERVICE:=gwagent
AJ_SERVICE_NAME:=Gateway Management

include $(TOPDIR)/rules.mk

PKG_NAME:=alljoyn-$(AJ_SERVICE)
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-src
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-src.tar.gz
PKG_SOURCE_URL:=https://allseenalliance.org/releases/alljoyn/$(PKG_VERSION)/
PKG_MD5SUM:=

# SCons supports parallel builds but does not support make's jobserver
PKG_BUILD_PARALLEL:=$(if $(CONFIG_PKG_BUILD_USE_JOBSERVER),0,1)

include $(INCLUDE_DIR)/package.mk

ifneq ($(CONFIG_CCACHE),)
  TARGET_CC=$(TARGET_CC_NOCACHE)
  TARGET_CXX=$(TARGET_CXX_NOCACHE)
endif

ALLJOYN_BINDINGS:=cpp,

define Package/$(PKG_NAME)
  TITLE:=AllJoyn $(AJ_SERVICE_NAME)
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=alljoyn \
    +alljoyn-about \
    +alljoyn-config \
    +alljoyn-services_common \
    +alljoyn-notification \
    +libxml2 \
    +shadow-useradd \
    +shadow-userdel
  URL:=http://www.allseenalliance.org
  MAINTAINER:=AllSeen Alliance <allseen-core@lists.allseenalliance.org>
  MENU:=1
 endef

define Package/$(PKG_NAME)/description
AllJoyn $(AJ_SERVICE_NAME)
endef


ifeq ($(CONFIG_DEBUG),y)
  ALLJOYN_BUILD_VARIANT:=debug
else
  ALLJOYN_BUILD_VARIANT:=release
endif


PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/gateway/$(AJ_SERVICE)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist/gatewayMgmtApp
SAMPLE_PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/gateway/$(AJ_SERVICE)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist/gatewayConnector

TARGET_CFLAGS+=-fPIC
TARGET_CPPFLAGS+=-fPIC

define Build/Configure/Default
# Override default to do nothing
endef

define Build/Compile
	scons -C $(PKG_BUILD_DIR)/gateway/$(AJ_SERVICE) \
		$(PKG_JOBS) \
		WS=off \
		CPU=openwrt \
		OS=openwrt \
		"BINDINGS=$(ALLJOYN_BINDINGS)" \
		"BUILD_SERVICES_SAMPLES=off" \
		"LIBXML2_BASE=$$(STAGING_DIR)/usr/include/libxml2" \
		"VARIANT=$(ALLJOYN_BUILD_VARIANT)" \
		BR=off \
		BT=off \
		ICE=off \
		"TARGET_CC=$$(TARGET_CC)" \
		"TARGET_CXX=$$(TARGET_CXX)" \
		"TARGET_CFLAGS=$$(TARGET_CFLAGS)" \
		"TARGET_CPPFLAGS=$$(TARGET_CPPFLAGS)" \
		"TARGET_PATH=$$(TARGET_PATH)" \
		"TARGET_LINKFLAGS=$$(TARGET_LDFLAGS)" \
		"TARGET_LINK=$$(TARGET_CC)" \
		"TARGET_AR=$$(TARGET_AR)" \
		"TARGET_RANLIB=$$(TARGET_RANLIB)" \
		"STAGING_DIR=$$(STAGING_DIR)"
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/alljoyn/gateway
	$(CP) $(PKG_INSTALL_DIR)/inc/alljoyn/gateway/*.h $(1)/usr/include/alljoyn/gateway
	$(CP) $(PKG_INSTALL_DIR)/../gatewayConnector/inc/alljoyn/gateway/*.h $(1)/usr/include/alljoyn/gateway
	$(CP) $(PKG_INSTALL_DIR)/../gatewayController/inc/alljoyn/gateway/*.h $(1)/usr/include/alljoyn/gateway
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/../gatewayController/lib/liballjoyn_gateway.a $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/../gatewayController/lib/liballjoyn_gateway.so $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/../gatewayConnector/lib/liballjoyn_gwConnector.a $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/../gatewayConnector/lib/liballjoyn_gwConnector.so $(1)/usr/lib/
endef


define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/opt
	$(INSTALL_DIR) $(1)/opt/alljoyn
	$(INSTALL_DIR) $(1)/opt/alljoyn/alljoyn-daemon.d
	$(INSTALL_DIR) $(1)/opt/alljoyn/alljoyn-daemon.d/apps
	$(INSTALL_DIR) $(1)/opt/alljoyn/app-manager
	$(INSTALL_DIR) $(1)/opt/alljoyn/apps
	$(INSTALL_DIR) $(1)/opt/alljoyn/gwagent
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/alljoyn
	$(INSTALL_DIR) $(1)/etc/alljoyn/gwagent
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/GatewayMgmtApp $(1)/usr/bin/alljoyn-gwagent
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/bin/manifest.xsd $(1)/opt/alljoyn/gwagent
	$(INSTALL_DATA) $(PKG_INSTALL_DIR)/bin/defaultConfig.xml $(1)/etc/alljoyn/gwagent/gwagent.conf
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/gatewayMgmt.init $(1)/etc/init.d/alljoyn-gwagent
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/gatewayMgmt.defaults $(1)/etc/uci-defaults/alljoyn-gwagent
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/../gatewayController/lib/liballjoyn_gateway.so $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/../gatewayConnector/lib/liballjoyn_gwConnector.so $(1)/usr/lib/
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
    . /etc/uci-defaults/alljoyn-gwagent
    rm -f /etc/uci-defaults/alljoyn-gwagent
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
    /etc/init.d/alljoyn-gwagent stop
    /etc/init.d/alljoyn-gwagent disable
fi
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))

