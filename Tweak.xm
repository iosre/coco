#import "coco.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_10_0
#define kCFCoreFoundationVersionNumber_iOS_10_0 1300.0
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_9_0
#define kCFCoreFoundationVersionNumber_iOS_9_0 1240.10
#endif

static NSDictionary *settings;

static void LoadSettings(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	settings = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.naken.coco.plist"];
}

%hook BBBulletin

- (BOOL)bulletinAlertShouldOverrideQuietMode
{
	if (((NSNumber *)settings[self.section]).boolValue) return YES;
	return %orig;
}

%end

%ctor
{
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0 && kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_10_0)
	{
		%init;
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, LoadSettings, CFSTR("com.naken.coco.loadsettings"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		LoadSettings(NULL, NULL, NULL, NULL, NULL);
	}
}
