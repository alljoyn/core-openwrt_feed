AJ_SERVICE:=codegen
AJ_SERVICE_NAME:=Code generator

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

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  TITLE:=AllJoyn $(AJ_SERVICE_NAME) library
  SECTION:=net
  CATEGORY:=Network
  URL:=http://www.allseenalliance.org
  MAINTAINER:=AllSeen Alliance <allseen-datadriven@lists.allseenalliance.org>
endef

define Package/$(PKG_NAME)/description
AllJoyn $(AJ_SERVICE_NAME) library.
endef

ifeq ($(CONFIG_DEBUG),y)
  ALLJOYN_BUILD_VARIANT:=debug
else
  ALLJOYN_BUILD_VARIANT:=release
endif


PKG_INSTALL_DIR:=$(PKG_BUILD_DIR)/dist

define Build/Configure/Default
# Override default to do nothing
endef

define Build/Compile
    cd $(PKG_BUILD_DIR)/codegen && \
	python setup.py install --home=$(PKG_INSTALL_DIR) && \
	PYTHONPATH=$(PKG_INSTALL_DIR)/lib/python $(PKG_INSTALL_DIR)/bin/ajcodegen-compile.py
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/bin
	$(CP) $(PKG_INSTALL_DIR)/bin/* $(STAGING_DIR_HOST)/bin
	mkdir -p $(STAGING_DIR_HOST)/lib/alljoyn-codegen
	$(INSTALL_DIR) $(STAGING_DIR_HOST)/lib
	$(CP) $(PKG_INSTALL_DIR)/lib/python/* $(STAGING_DIR_HOST)/lib/alljoyn-codegen
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
