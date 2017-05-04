#import "PSViewController.h"

@interface CCPBRootListController: PSViewController
{
	UITableView *mainView;
}
@property (nonatomic, retain) NSMutableArray *allAppInfo;
- (void)initSettings;
- (void)initAllAppInfo;
- (void)saveConfig:(UISwitch *)appSwitch;
@end
