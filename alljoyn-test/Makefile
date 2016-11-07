AJ_SERVICE:=test
AJ_SERVICE_NAME:=test

include $(TOPDIR)/rules.mk

PKG_NAME:=alljoyn-$(AJ_SERVICE)
PKG_BASE_VERSION:=16.10
PKG_PATCHLEVEL:=.00
PKG_RELEASE:=1
PKG_VERSION:=$(PKG_BASE_VERSION)$(PKG_PATCHLEVEL)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://git.allseenalliance.org/gerrit/core/test.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=5c5019db0250287f922e22f983fc1d64f7afefc5
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz

# SCons supports parallel builds but does not support make's jobserver
PKG_BUILD_PARALLEL:=$(if $(CONFIG_PKG_BUILD_USE_JOBSERVER),0,1)

PKG_CONFIG_DEPENDS:= CONFIG_PACKAGE_$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

ifneq ($(CONFIG_CCACHE),)
  TARGET_CC=$(TARGET_CC_NOCACHE)
  TARGET_CXX=$(TARGET_CXX_NOCACHE)
endif

ALLJOYN_BINDINGS:=cpp,
ALLJOYN_BUILD_SERVICES_SAMPLES:=on

define Package/$(PKG_NAME)
  TITLE:=AllJoyn services $(AJ_SERVICE_NAME) - sample applications
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=alljoyn
  URL:=http://www.allseenalliance.org
  MAINTAINER:=AllSeen Alliance <allseen-core@lists.allseenalliance.org>
endef

define Package/$(PKG_NAME)/description
AllJoyn $(AJ_SERVICE_NAME) binaries.
endef

ifeq ($(CONFIG_DEBUG),y)
  ALLJOYN_BUILD_VARIANT:=debug
else
  ALLJOYN_BUILD_VARIANT:=release
endif


ALLJOYN_SRC_DIR:=$(BUILD_DIR)/alljoyn-$(PKG_VERSION)-src
ALLJOYN_DISTDIR:=$(ALLJOYN_SRC_DIR)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist
ALLJOYN_TEST_DIR:=$(ALLJOYN_SRC_DIR)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/test
PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/$(AJ_SERVICE)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist/$(AJ_SERVICE)

TARGET_CFLAGS+=-fPIC
TARGET_CPPFLAGS+=-fPIC

define Build/Configure/Default
# Override default to do nothing
endef

define Build/Exports/Default
  $(1) : export AJ_CORE_SRC_DIR:=$(ALLJOYN_SRC_DIR)
  $(1) : export AJ_CORE_DIST_DIR=$(ALLJOYN_DISTDIR)
endef

define Build/Compile
	scons -C $(PKG_BUILD_DIR)/scl \
		$(PKG_JOBS) \
		WS=off \
		CPU=openwrt \
		OS=openwrt \
		"BINDINGS=$(ALLJOYN_BINDINGS)" \
		BR=off \
		BT=off \
		ICE=off \
		VARIANT=$(ALLJOYN_BUILD_VARIANT) \
		"TARGET_CC=$$(TARGET_CC)" \
		"TARGET_CXX=$$(TARGET_CXX)" \
		"TARGET_CFLAGS=$$(TARGET_CFLAGS)" \
		"TARGET_CPPFLAGS=$$(TARGET_CPPFLAGS)" \
		"TARGET_PATH=$$(TARGET_PATH)" \
		"TARGET_LINKFLAGS=$$(TARGET_LDFLAGS)" \
		"TARGET_LINK=$$(TARGET_CC)" \
		"TARGET_AR=$$(TARGET_AR)" \
		"TARGET_RANLIB=$$(TARGET_RANLIB)" \
		"STAGING_DIR=$$(STAGING_DIR)" \
		"ALL=1"
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajtest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/abouttest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajcheck $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/cmtest $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_client $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_service $(1)/usr/bin
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajtest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/abouttest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajcheck $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/cmtest $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_client $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_service $(1)/usr/bin
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
