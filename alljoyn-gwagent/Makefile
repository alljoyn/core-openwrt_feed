# Copyright (c) 2015, AllSeen Alliance. All rights reserved.
#
#    Permission to use, copy, modify, and/or distribute this software for any
#    purpose with or without fee is hereby granted, provided that the above
#    copyright notice and this permission notice appear in all copies.
#
#    THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#    WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#    MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#    ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#    WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#    ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#    OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#

AJ_SERVICE:=gwagent
AJ_SERVICE_NAME:=Gateway Management

include $(TOPDIR)/rules.mk

PKG_NAME:=alljoyn-$(AJ_SERVICE)
PKG_VERSION:=14.06.00
PKG_RELEASE:=1
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-src
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-src.tar.gz
PKG_SOURCE_URL:=
PKG_MD5SUM:=

# SCons supports parallel builds but does not support make's jobserver
PKG_BUILD_PARALLEL:=$(if $(CONFIG_PKG_BUILD_USE_JOBSERVER),0,1)

PKG_CONFIG_DEPENDS:= CONFIG_PACKAGE_$(PKG_NAME)-samples

include $(INCLUDE_DIR)/package.mk

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


define Package/$(PKG_NAME)-samples
$(call Package/$(PKG_NAME))
  TITLE+=- Gateway Connector App testing sample
  DEPENDS:=$(PKG_NAME)
  MENU:=0
endef

define Package/$(PKG_NAME)-samples/description
Alljoyn $(AJ_SERVICE_NAME) Connector App testing sample. 
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
	$(INSTALL_DIR) $(1)/opt
	$(INSTALL_DIR) $(1)/opt/alljoyn
	$(INSTALL_DIR) $(1)/opt/alljoyn/alljoyn-daemon.d
	$(INSTALL_DIR) $(1)/opt/alljoyn/alljoyn-daemon.d/apps
	$(INSTALL_DIR) $(1)/opt/alljoyn/app-manager
	$(INSTALL_DIR) $(1)/opt/alljoyn/apps
	$(INSTALL_DIR) $(1)/opt/alljoyn/gw-mgmt
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/GatewayMgmtApp $(1)/opt/alljoyn/gw-mgmt
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/manifest.xsd $(1)/opt/alljoyn/gw-mgmt
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/installPackage.sh $(1)/opt/alljoyn/app-manager
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/defaultConfig.xml $(1)/opt/alljoyn/alljoyn-daemon.d
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/gatewayMgmt.init $(1)/etc/init.d/gatewayMgmt
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/gatewayMgmt.defaults $(1)/etc/uci-defaults/gatewayMgmt
endef


define Package/$(PKG_NAME)-samples/install
	tar czf $(SAMPLE_PKG_INSTALL_DIR)/dummyApp1.tar.gz -C $(SAMPLE_PKG_INSTALL_DIR)/tar .
	$(INSTALL_DIR) $(1)/opt
	$(INSTALL_DIR) $(1)/opt/alljoyn
	$(INSTALL_DIR) $(1)/opt/alljoyn/app-manager
	$(INSTALL_BIN) $(SAMPLE_PKG_INSTALL_DIR)/dummyApp1.tar.gz $(1)/opt/alljoyn/app-manager/dummyApp1.tar.gz
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
    . /etc/uci-defaults/gatewayMgmt
    rm -f /etc/uci-defaults/gatewayMgmt
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
    /etc/init.d/gatewayMgmt stop
    /etc/init.d/gatewayMgmt disable
fi
exit 0
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-samples))

