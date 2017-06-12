include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = classicprefs
classicprefs_FILES = CLARootListController.m
classicprefs_INSTALL_PATH = /Library/PreferenceBundles
classicprefs_FRAMEWORKS = UIKit
classicprefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/classicprefs.plist$(ECHO_END)
