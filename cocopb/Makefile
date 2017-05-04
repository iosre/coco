export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
export ARCHS = armv7 arm64
export TARGET = iphone:clang:10.1:9.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = cocoPB
cocoPB_FILES = CCPBRootListController.mm
cocoPB_FRAMEWORKS = UIKit
cocoPB_PRIVATE_FRAMEWORKS = Preferences
cocoPB_INSTALL_PATH = /Library/PreferenceBundles
cocoPB_LIBRARIES = applist
cocoPB_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/cocoPB.plist$(ECHO_END)
