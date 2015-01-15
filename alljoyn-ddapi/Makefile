AJ_SERVICE:=ddapi
AJ_SERVICE_NAME:=Data Driven API

include $(TOPDIR)/rules.mk

PKG_NAME:=alljoyn-$(AJ_SERVICE)
PKG_VERSION:=0.0.1
PKG_RELEASE:=1
PKG_MD5SUM:=
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)-src
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-src.tar.gz
PKG_SOURCE_URL:=https://allseenalliance.org/releases/alljoyn/$(PKG_VERSION)/

# SCons supports parallel builds but does not support make's jobserver
PKG_BUILD_PARALLEL:=$(if $(CONFIG_PKG_BUILD_USE_JOBSERVER),0,1)

PKG_CONFIG_DEPENDS:= \
	CONFIG_DEBUG \
	CONFIG_PACKAGE_alljoyn-ddapi-samples

include $(INCLUDE_DIR)/package.mk

ALLJOYN_BINDINGS:=cpp,
ALLJOYN_DDAPI_BUILD_SAMPLES:=off

define Package/ddapi/Default
  SECTION:=net
  CATEGORY:=Network
  URL:=http://www.allseenalliance.org
  MAINTAINER:=AllSeen Alliance <allseen-datadriven@lists.allseenalliance.org>
endef

define Package/$(PKG_NAME)
  $(call Package/ddapi/Default)
  TITLE:=AllJoyn $(AJ_SERVICE_NAME) library
  DEPENDS:=alljoyn \
	+alljoyn-about
  MENU:=1
endef

define Package/$(PKG_NAME)/description
AllJoyn $(AJ_SERVICE_NAME) service library.
endef

define Package/$(PKG_NAME)-samples
  $(call Package/ddapi/Default)
  TITLE:=AllJoyn ddapi samples
  DEPENDS:=alljoyn-ddapi
endef

define Package/$(PKG_NAME)-samples/description
Alljoyn Data Driven API samples.
endef

ifeq ($(CONFIG_DEBUG),y)
  ALLJOYN_BUILD_VARIANT:=debug
else
  ALLJOYN_BUILD_VARIANT:=release
endif

PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/data/datadriven_api/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist

TARGET_CFLAGS+=-fPIC
TARGET_CPPFLAGS+=-fPIC

ifdef CONFIG_PACKAGE_$(PKG_NAME)-samples
	ALLJOYN_DDAPI_BUILD_SAMPLES:=on
endif

define Build/Compile
	scons -C $(PKG_BUILD_DIR)/data/datadriven_api \
		$(PKG_JOBS) \
		WS=off \
		CPU=openwrt \
		OS=openwrt \
		"BINDINGS=$(ALLJOYN_BINDINGS)" \
		"BUILD_SAMPLES=$(ALLJOYN_DDAPI_BUILD_SAMPLES)" \
		"BUILD_TESTS=on" \
		"VARIANT=$(ALLJOYN_BUILD_VARIANT)" \
		"V=1" \
		BR=off \
		BT=off \
		ICE=off \
		"TARGET_CC=$$(TARGET_CC)" \
		"TARGET_CXX=$$(TARGET_CXX)" \
		"TARGET_CFLAGS=$$(TARGET_CFLAGS)" \
		"TARGET_CPPFLAGS=$$(TARGET_CPPFLAGS)" \
		"TARGET_PATH=$$(TARGET_PATH)" \
		"TARGET_LINKFLAGS=$$(TARGET_LDFLAGS) -lalljoyn -lstdc++ -lpthread" \
		"TARGET_LINK=$$(TARGET_CC)" \
		"TARGET_AR=$$(TARGET_AR)" \
		"TARGET_RANLIB=$$(TARGET_RANLIB)" \
		"STAGING_DIR=$$(STAGING_DIR)"
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include/alljoyn/datadriven
	$(CP) $(PKG_INSTALL_DIR)/datadriven_cpp/inc/datadriven/* $(1)/usr/include/alljoyn/datadriven
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/datadriven_cpp/lib/liballjoyn_ddapi.a $(1)/usr/lib/
	$(CP) $(PKG_INSTALL_DIR)/datadriven_cpp/lib/liballjoyn_ddapi.so $(1)/usr/lib/
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/datadriven_cpp/lib/liballjoyn_ddapi.so $(1)/usr/lib/
endef

define Package/$(PKG_NAME)-samples/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/datadriven_cpp/bin/samples/ddchat $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/datadriven_cpp/bin/samples/door_provider $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/datadriven_cpp/bin/samples/door_consumer $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)-samples))
