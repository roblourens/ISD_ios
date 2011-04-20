//
//  NewsVC.h
//  ISDtest
//
//  Created by Rob Lourens on 4/15/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"
#import "NewsData.h"
#import "StoryVC.h"
#import "IconDownloader.h"

@interface NewsVC : UIViewController<IconDownloaderDelegate> {
	IBOutlet UIView *sectionPickerView;
	IBOutlet UISegmentedControl *sectionPicker;
	IBOutlet UITableViewCell *imageCell;
	IBOutlet UIView *loadingView;
	IBOutlet UITableView *tableView;
	IBOutlet UIButton *refreshButton;
	
	NSString *activeCategoryName;
	NSArray *activeStories;
}

@property (nonatomic, retain) IBOutlet UIView *sectionPickerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *sectionPicker;
@property (nonatomic, retain) IBOutlet UITableViewCell *imageCell;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIButton *refreshButton;

@property (nonatomic, retain) NSString *activeCategoryName;
@property (nonatomic, retain) NSArray *activeStories;

- (IBAction)refresh;
- (void)loadingComplete;
- (void)loadSectionWithReload:(NSNumber *)boolObj;
- (void)startIconDownload:(Story *)s forIndexPath:(NSIndexPath *)indexPath;
- (UIImage *)getPlaceholderImage;
- (void)sectionChanged;
- (UIImage *)putImage:(UIImage *)img inFrame:(CGRect)frame;

@end
