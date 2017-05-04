#import "CCPBRootListController.h"
#import <notify.h>
#import <AppList/AppList.h>

#define SETTINGS @"/var/mobile/Library/Preferences/com.naken.coco.plist"
#define BUNDLE [NSBundle bundleWithPath:@"/Library/PreferenceBundles/cocoPB.bundle"]
#define BLACKLIST @[@"com.apple.Diagnostics.Mitosis", @"com.apple.Diagnostics", @"com.apple.managedconfiguration.MDMRemoteAlertService", @"com.apple.SafariViewService", @"com.apple.CloudKit.ShareBear", @"com.apple.social.SLGoogleAuth", @"com.apple.social.SLYahooAuth", @"com.apple.StoreDemoViewService", @"com.apple.Home.HomeUIService", @"com.apple.ServerDocuments", @"com.apple.Fitness", @"com.apple.appleseed.FeedbackAssistant"]

@implementation CCPBRootListController

@synthesize allAppInfo;

- (instancetype)init
{
	if ( (self = [super init]) )
	{
		self.title = @"coco";
		mainView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
		mainView.delegate = self;
		mainView.dataSource = self;
		self.view = mainView;

		[self initAllAppInfo];
		[self initSettings];
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if ([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.allAppInfo count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return NSLocalizedStringFromTableInBundle(@"Toggle to Disturb", @"Localizable", BUNDLE, nil);
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
	return NSLocalizedStringFromTableInBundle(@"By snakeninny", @"Localizable", BUNDLE, nil);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"any-cell"];
	if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"any-cell"];

	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSString *appIdentifier = ((NSDictionary *)(self.allAppInfo[indexPath.row])).allKeys[0];
	NSString *appName = ((NSDictionary *)(self.allAppInfo[indexPath.row])).allValues[0];
	cell.imageView.image = [[ALApplicationList sharedApplicationList] iconOfSize:ALApplicationIconSizeSmall forDisplayIdentifier:appIdentifier];
	cell.textLabel.text = appName;
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGS];
	UISwitch *appSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
	appSwitch.tag = indexPath.row + 1;
	appSwitch.on = ((NSNumber *)settings[appIdentifier]).boolValue;
	[appSwitch addTarget:self action:@selector(saveConfig:) forControlEvents:UIControlEventValueChanged];	
	cell.accessoryView = appSwitch;

	return cell;
}

- (void)initSettings
{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSMutableDictionary *settings;
	if ([fileManager fileExistsAtPath:SETTINGS])
	{
		settings = [[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGS];
		for (NSDictionary *applicationInfo in self.allAppInfo)
		{
			NSString *appIdentifier = applicationInfo.allKeys[0];
			if (settings[appIdentifier] == nil) settings[appIdentifier] = @NO;
		}
	}
	else
	{
		settings = [@{} mutableCopy];
		for (NSDictionary *applicationInfo in self.allAppInfo) settings[applicationInfo.allKeys[0]] = @NO;
	}
	[settings writeToFile:SETTINGS atomically:YES];

	notify_post("com.naken.coco.loadsettings");	
}

- (void)initAllAppInfo
{
	allAppInfo = [@[] mutableCopy];
	NSArray *sortedDisplayIdentifiers;
	ALApplicationList *applicationList = [ALApplicationList sharedApplicationList];
	NSDictionary *applications = [applicationList applicationsFilteredUsingPredicate:nil onlyVisible:YES titleSortedIdentifiers:&sortedDisplayIdentifiers];
	for (NSString *displayIdentifier in sortedDisplayIdentifiers)
	{
		if (![applicationList applicationWithDisplayIdentifierIsHidden:displayIdentifier] && ![BLACKLIST containsObject:displayIdentifier])
		{
			NSString *appName = applications[displayIdentifier];
			[allAppInfo addObject:@{displayIdentifier : appName}];
		}
	}
}

- (void)saveConfig:(UISwitch *)appSwitch
{
	NSInteger row = appSwitch.tag - 1;
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGS];
	settings[((NSDictionary *)(self.allAppInfo[row])).allKeys[0]] = [NSNumber numberWithBool:appSwitch.on];
	[settings writeToFile:SETTINGS atomically:YES];

	notify_post("com.naken.coco.loadsettings");
}

@end
