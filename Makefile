export THEOS_DEVICE_IP = localhost
export THEOS_DEVICE_PORT = 2222
export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = coco
coco_FILES = Tweak.xm
coco_LIBRARIES = applist
coco_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)cp -r PreferenceBundles $(THEOS_STAGING_DIR)/Library$(ECHO_END)
	$(ECHO_NOTHING)cp -r PreferenceLoader $(THEOS_STAGING_DIR)/Library$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
