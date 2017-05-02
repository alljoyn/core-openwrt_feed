AJ_SERVICE:=test
AJ_SERVICE_NAME:=test

include $(TOPDIR)/rules.mk

PKG_NAME:=alljoyn-$(AJ_SERVICE)
PKG_BASE_VERSION:=16.10
PKG_PATCHLEVEL:=.00
PKG_RELEASE:=1
PKG_VERSION:=$(PKG_BASE_VERSION)$(PKG_PATCHLEVEL)
PKG_SOURCE_PROTO:=git
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION)-$(PKG_SOURCE_VERSION).tar.gz
PKG_SOURCE_URL:=https://git.allseenalliance.org/gerrit/core/test.git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_VERSION:=RB16.10

# SCons supports parallel builds but does not support make's jobserver
PKG_BUILD_PARALLEL:=$(if $(CONFIG_PKG_BUILD_USE_JOBSERVER),0,1)

PKG_CONFIG_DEPENDS:= \
	CONFIG_PACKAGE_alljoyn-unit-tests \
	CONFIG_PACKAGE_alljoyn-data-marshaling-tests

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
  MENU:=1
endef

define Package/$(PKG_NAME)/description
AllJoyn $(AJ_SERVICE_NAME) binaries.
endef

define Package/alljoyn-unit-tests
$(call Package/$(PKG_NAME))
  TITLE+=- Unit Tests
  DEPENDS:=$(PKG_NAME) \
  	+alljoyn-about \
  	+libstdcpp \
  	+librt \
  	+libopenssl \
  	+libpthread \
	+libsqlite3
  MENU:=0
endef

define Package/alljoyn-unit-tests/description
Alljoyn Unit Tests
endef

define Package/alljoyn-data-marshaling-tests
$(call Package/$(PKG_NAME))
  TITLE+=- Data marshaling tests
  DEPENDS:=$(PKG_NAME)
  MENU:=0
endef

define Package/alljoyn-data-marshaling-tests/description
AllJoyn Data Marshaling Tests
endef

ifeq ($(CONFIG_DEBUG),y)
  ALLJOYN_BUILD_VARIANT:=debug
else
  ALLJOYN_BUILD_VARIANT:=release
endif


PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/$(AJ_SERVICE)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist/$(AJ_SERVICE)

ALLJOYN_SRC_DIR:=$(BUILD_DIR)/alljoyn-$(PKG_VERSION)-src
ALLJOYN_DISTDIR:=$(ALLJOYN_SRC_DIR)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/dist
ALLJOYN_TEST_DIR:=$(ALLJOYN_SRC_DIR)/build/openwrt/openwrt/$(ALLJOYN_BUILD_VARIANT)/test

GTEST_VERSION:=1.8.0
GTEST_PACKAGE_FILE:=release-$(GTEST_VERSION).tar.gz
GTEST_DIR:=$(BUILD_DIR)/googletest-release-$(GTEST_VERSION)/googletest

SQLITE_DIR:=$(BUILD_DIR)/sqlite-autoconf-3081101


TARGET_CFLAGS+=-fPIC
TARGET_CPPFLAGS+=-fPIC

define Download/gtest
  FILE:=$(GTEST_PACKAGE_FILE)
  URL:=https://github.com/google/googletest/archive/
endef
$(eval $(call Download,gtest))

define Build/Prepare
	$(Build/Prepare/Default)
	tar -zxf $(DL_DIR)/$(GTEST_PACKAGE_FILE) -C $(BUILD_DIR)
endef

define Build/Configure/Default
# Override default to do nothing
endef

define Build/Exports/Default
  $(1) : export AJ_CORE_SRC_DIR:=$(ALLJOYN_SRC_DIR)
  $(1) : export AJ_CORE_DIST_DIR=$(ALLJOYN_DISTDIR)
endef

define Build/Compile

ifdef CONFIG_PACKAGE_alljoyn-unit-tests
	scons -C $(ALLJOYN_SRC_DIR) \
		$(PKG_JOBS) \
		WS=off \
		CPU=openwrt \
		OS=openwrt \
		"BINDINGS=$(ALLJOYN_BINDINGS)" \
		"SERVICES=$(ALLJOYN_SERVICES)" \
		"BUILD_SERVICES_SAMPLES=$(ALLJOYN_BUILD_SERVICES_SAMPLES)" \
		"VARIANT=$(ALLJOYN_BUILD_VARIANT)" \
		BR=on \
		ICE=off \
		POLICYDB=on \
		SQLITE_DIR=$(SQLITE_DIR) \
		GTEST_DIR=$(GTEST_DIR) \
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
endif

ifdef CONFIG_PACKAGE_alljoyn-data-marshaling-tests
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
endif

endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/bin

ifdef CONFIG_PACKAGE_alljoyn-unit-tests
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajtest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/abouttest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajcheck $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/cmtest $(1)/usr/bin
endif

ifdef CONFIG_PACKAGE_alljoyn-data-marshaling-tests
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_client $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_service $(1)/usr/bin
endif

endef

define Package/alljoyn-unit-tests/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajtest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/abouttest $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/ajcheck $(1)/usr/bin
	$(INSTALL_BIN) $(ALLJOYN_TEST_DIR)/cpp/bin/cmtest $(1)/usr/bin
endef

define Package/alljoyn-datamarshaling-tests/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_client $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/scl/datatype_service $(1)/usr/bin
endef


$(eval $(call BuildPackage,$(PKG_NAME)))
$(eval $(call BuildPackage,alljoyn-unit-tests))
$(eval $(call BuildPackage,alljoyn-data-marshaling-tests))
