#
# Copyright (C) 2007-2018 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=tinc-pre
PKG_VERSION:=1.1pre15
PKG_RELEASE:=1

PKG_SOURCE:=tinc-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://www.tinc-vpn.org/packages
PKG_HASH:=64fb5847ccc7a1b35975af3eb981f727

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/tinc-pre
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=tinc vpn daemon pre-release
  URL:=https://www.tinc-vpn.org/
  DEPENDS:=+kmod-tun +liblzo +libopenssl +zlib
endef

define Package/tinc-pre/description
  tinc is a Virtual Private Network (VPN) daemon that uses tunnelling and
  encryption to create a secure private network between hosts on the Internet.
endef

TARGET_CFLAGS += -std=gnu99

CONFIGURE_ARGS += \
	--with-kernel="$(LINUX_DIR)" \
	--with-lzo-include="$(STAGING_DIR)/usr/include/lzo" \
	--with-zlib="$(STAGING_DIR)/usr"

MAKE_PATH:=src

define Build/Compile
	$(call Build/Compile/Default)
endef

define Package/tinc-pre/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tinc $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/sbin/tincd $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d/
	$(INSTALL_BIN) files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) files/$(PKG_NAME).config $(1)/etc/config/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/tinc
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DATA) files/tinc.upgrade $(1)/lib/upgrade/keep.d/tinc
endef

define Package/tinc/conffiles
/etc/config/tinc
endef

$(eval $(call BuildPackage,tinc-pre))
