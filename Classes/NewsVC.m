//
//  NewsVC.m
//  ISDtest
//
//  Created by Rob Lourens on 4/15/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import "NewsVC.h"


@implementation NewsVC

@synthesize sectionPicker, sectionPickerView, activeCategoryName, activeStories, imageCell, loadingView, tableView, refreshButton;

#define rowHeight 50
#define pickerHeight 25
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Iowa State Daily";

	sectionPicker.tintColor = [UIColor darkGrayColor];
	sectionPicker.frame = CGRectMake(sectionPicker.frame.origin.x, sectionPicker.frame.origin.y, sectionPicker.frame.size.width, pickerHeight);
	[sectionPicker addTarget:self action:@selector(sectionChanged) forControlEvents:UIControlEventValueChanged];
	
	activeCategoryName = [sectionPicker titleForSegmentAtIndex:0];	
	
	self.tableView.separatorColor = [UIColor darkGrayColor];
	
	// Initialize section picker
	for (int i=0; i<[[[NewsData data] categoryNames] count]; i++) {
		NSString *name = [[[NewsData data] categoryNames] objectAtIndex:i];
		[sectionPicker setTitle:name forSegmentAtIndex:i];
	}
	
	// Set up nav bar
	self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ISD_Mobile_logo.png"]];
	
	// Add reload button to nav bar
	//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	
	// Add refresh bar
	[refreshButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
	
	// Load data and whatnot
	[self sectionChanged];
}


- (void)sectionChanged {
	NSLog(@"Changed section");
	[self.view addSubview:loadingView];
	NSNumber *boolObject = [NSNumber numberWithBool:NO];
	[NSThread detachNewThreadSelector:@selector(loadSectionWithReload:) toTarget:self withObject:boolObject];
}

- (IBAction)refresh {
	NSLog(@"Refreshing");
	[self.view addSubview:loadingView];
	NSNumber *boolObject = [NSNumber numberWithBool:YES];
	[NSThread detachNewThreadSelector:@selector(loadSectionWithReload:) toTarget:self withObject:boolObject];
}

- (void)loadSectionWithReload:(NSNumber *)boolObj {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	activeCategoryName = [sectionPicker titleForSegmentAtIndex:[sectionPicker selectedSegmentIndex]];
	BOOL reload = [boolObj boolValue];
	activeStories = [[NewsData data] getStoriesForCategory:activeCategoryName withReload:reload];
	
	[self performSelectorOnMainThread:@selector(loadingComplete) withObject:nil waitUntilDone:NO];
	[pool release];
}

- (void)loadingComplete {
	[loadingView removeFromSuperview];
	[self.tableView reloadData]; // must reload data before scrolling, or changing sections from an empty section will crash
	
	// and must not scroll on an empty section
	if ([activeStories count] > 0) {
		NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
		[self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
	}
	
	// Now load all images
	for (int i=0; i<[activeStories count]; i++) {
		Story *s = [activeStories objectAtIndex:i];
		
		// Download if not downloaded
		if (s.hasPicture && !s.thumbnail) {
			[self startIconDownload:s forIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		}
	}
	
	// Load first story so the picture is loaded
	if ([activeStories count] >=1)
		[[NewsData data] getLoadedStoryForCategory:activeCategoryName index:0];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [activeStories count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Story *s = [activeStories objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier;
	if (indexPath.row == 0)
		CellIdentifier = @"image";
	else 
		CellIdentifier	= @"text";
    
    UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if (indexPath.row == 0) {
			cell = imageCell;
		}
		else  {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
			cell.textLabel.font = [UIFont systemFontOfSize:14];
			cell.textLabel.textColor = [UIColor lightGrayColor];
			cell.textLabel.numberOfLines = 0;
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	// Configure the 'normal' rows
	if (indexPath.row > 0) {
		cell.textLabel.text = s.title;
		CGRect frame = CGRectMake(10, 10, 280, 24);
		cell.textLabel.frame = frame;
		
		if (s.hasPicture) {
			if (!s.thumbnail) {
				cell.imageView.image = [self getPlaceholderImage];
			}
			else
			{
				cell.imageView.image = s.thumbnail;
			}
		}
		else 
			cell.imageView.image = nil;
	}
	// Configure the headline row (should have an image)
	else {
		UILabel *textLabel = (UILabel *)[cell viewWithTag:2];
		textLabel.text = s.title;
		
		if (s.hasPicture) {
			UIImage *croppedImg = [self putImage:s.img inFrame:cell.frame];
			cell.backgroundView = [[UIImageView alloc] initWithImage:croppedImg];
		}
		
		cell.imageView.image = nil;
	}
	
    return cell;
}

// Used to make the headline image the right size
- (UIImage *)putImage:(UIImage *)img inFrame:(CGRect)frame {
	CGImageRef imageref = CGImageCreateWithImageInRect([img CGImage], frame);
	return [UIImage imageWithCGImage:imageref];
}

- (UIImage *)getPlaceholderImage {
	CGSize itemSize = CGSizeMake(rowHeight, rowHeight);
	UIGraphicsBeginImageContext(itemSize);
	UIImage *placeholder = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return placeholder;
}

- (void)tableView:(UITableView *)callingTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: nil action: nil];
	[[self navigationItem] setBackBarButtonItem: newBackButton];
	[newBackButton release];
	
	StoryVC *storyVC = [[StoryVC alloc] initWithStory:[[NewsData data] getLoadedStoryForCategory:activeCategoryName index:indexPath.row]];
	[self.navigationController pushViewController:storyVC animated:YES];
	[storyVC release];
	
	[callingTableView deselectRowAtIndexPath:indexPath animated:NO]; // why doesn't this happen automatically?
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) return 200;
	else return rowHeight;
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(Story *)s forIndexPath:(NSIndexPath *)indexPath {
    if (!s.currentlyLoadingThumb) {
        IconDownloader *iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.s = s;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadThumbsForOnscreenRows {
	NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
	for (NSIndexPath *indexPath in visiblePaths)
	{
		Story *s = [activeStories objectAtIndex:indexPath.row];
		
		if (s.hasPicture && !s.thumbnail && indexPath.row != 0) // still don't load thumbnail for top story
		{
			[self startIconDownload:s forIndexPath:indexPath];
		}
	}
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath {
	[NSThread detachNewThreadSelector:@selector(imageLoaded:) toTarget:self withObject:indexPath];
}

- (void)imageLoaded:(NSIndexPath *)indexPath {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	Story *s = [activeStories objectAtIndex:indexPath.row];
	
	// Display the newly loaded image
	if (indexPath.row > 0)
		cell.imageView.image = s.thumbnail;
	
	// Reload it if visible
	if (!tableView.dragging && !tableView.decelerating) {
		if ([[self.tableView indexPathsForVisibleRows] containsObject:indexPath] && indexPath.row != 0) {
			NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
			[tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
		}
	}
	
	NSLog(@"Loaded image for %@", s.title);
	[pool release];
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
/*- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadThumbsForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadThumbsForOnscreenRows];
}
*/

@end