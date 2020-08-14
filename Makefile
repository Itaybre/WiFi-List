THEOS_DEVICE_IP = 192.168.88.131

TARGET = iphone:13.3:12.0

export GO_EASY_ON_ME=1
ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = WiFiList

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = WiFiList

WiFiList_FILES = main.m IBAppDelegate.m IBRootViewController.m IBWiFiManager.m IBWiFiNetwork.m
WiFiList_FRAMEWORKS = UIKit CoreGraphics
WiFiList_PRIVATE_FRAMEWORKS = MobileWiFi
WiFiList_CFLAGS = -fobjc-arc
WiFiList_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/application.mk
