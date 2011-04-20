//
//  StoryVC.m
//  ISD
//
//  Created by Rob Lourens on 4/30/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import "StoryVC.h"


@implementation StoryVC
@synthesize story, headheight, scrollView;

- (id)initWithStory:(Story *)s {
    if (self = [super init]) {
		self.story = s;
		self.navigationItem.title = @"Iowa State Daily";
    }
    return self;
}

#define webViewFontSize 15
- (void)loadView {
	scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	UIView *headView = [self getHeadView];
	headheight = headView.frame.size.height;
	
	NSString *text = [NSString stringWithFormat:@"<div style=\"color:gray\">%@</div>", story.byline];
	text = [text stringByAppendingString:story.text];

	// Get article height before adding other HTML stuff
	NSString *textOnly = [self stringWithoutHTMLchars:text];
	// 300 because the webview seems to render with a ~10px offset on either side
	CGFloat articleHeight = [textOnly sizeWithFont:[UIFont systemFontOfSize:webViewFontSize] constrainedToSize:CGSizeMake(300, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height;
	NSLog(@"calculated h: %f", articleHeight);
	
	text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"];
	text = [NSString stringWithFormat:@"<html> \n"
								   "<head> \n"
								   "<style type=\"text/css\"> \n"
								   "body {font-family: \"%@\"; font-size: %@;}\n"
								   "</style> \n"
								   "</head> \n"
								   "<body>%@</body> \n"
								   "</html>", @"helvetica", [NSNumber numberWithInt:webViewFontSize], text];
	
	// Create webview from story HTML
	// init with articleHeight calculation in case something goes wrong with the javascript height query
	UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, headView.frame.size.height, 320, articleHeight)];
	[webview loadHTMLString:text baseURL:[NSURL URLWithString:@"http://www.iowastatedaily.com"]];
	webview.delegate = self;
	webview.userInteractionEnabled = NO; // To disable scrolling in the webview. Otherwise, the webview may scroll initially instead of the parent scrollview
	
	scrollView.contentSize = CGSizeMake(320, webview.frame.size.height + headView.frame.size.height);
	[scrollView addSubview:headView];
	[scrollView addSubview:webview];
	self.view = scrollView;
	
	[headView release];
	[webview release];
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

#define titleViewOp .7
#define titleLabelXOffset 8
#define titleLabelYOffset 3
#define titleFontSize 22
- (UIView *)getHeadView {
	CGFloat titleViewH = [story.title sizeWithFont:[UIFont boldSystemFontOfSize:titleFontSize] constrainedToSize:CGSizeMake(320-2*titleLabelXOffset, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap].height + 2*titleLabelYOffset;
	
	// Create stuff for image
	CGFloat titleViewY = 0;
	//UIView *imViewContainer;
	UIImageView *imView;
	if (story.hasPicture) {
		// Many pictures are 300px wide. Some are >320. Some are skinny and tall, and 
		// resizing leads to very very tall pics. 290 seems like a good cut off point.
		if (story.img.size.width > 290)
			imView = [[UIImageView alloc] initWithImage:[self resizeImage:story.img toWidth:320]];
		else {
			// Center the imView in container
			imView = [[UIImageView alloc] initWithImage:story.img];
			NSLog(@"width: %f", imView.frame.size.width);
			CGFloat offset = (320-imView.frame.size.width)/2.0;
			imView.frame = CGRectMake(offset, 0, imView.frame.size.width, imView.frame.size.height);
		}

		//imViewContainer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, imView.frame.size.height)] autorelease];
		//[imViewContainer addSubview:imView];
		titleViewY = imView.frame.size.height;
	}
	else titleViewY = 0;
	
	// Create stuff for headline
	UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, titleViewY, 320, titleViewH)];
	titleView.backgroundColor = [UIColor whiteColor];

	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleLabelXOffset, titleLabelYOffset, 320-2*titleLabelXOffset, titleViewH-2*titleLabelYOffset)];
	titleLabel.numberOfLines = 0;
	titleLabel.font = [UIFont boldSystemFontOfSize:titleFontSize];
	titleLabel.text = story.title;
	titleLabel.backgroundColor = [UIColor clearColor];
	// color is af222f
	titleLabel.textColor = [UIColor colorWithRed:175/255.0 green:34/255.0 blue:47/255.0 alpha:1.0];
	
	// Put all the views together
	[titleView addSubview:titleLabel];
	[titleLabel release];
	if (story.hasPicture) {
		CGRect topViewFrame = CGRectMake(0, 0, 320, titleViewH + titleViewY);
		UIView *topView = [[UIView alloc] initWithFrame:topViewFrame];
		titleView.alpha = .8;
		[topView addSubview:imView];
		[topView addSubview:titleView];
		return topView;
	}
	else {
		titleView.alpha = .9;
		return titleView;
	}
}

- (UIImage *)resizeImage:(UIImage *)img toWidth:(CGFloat)w {
	CGFloat scaleF = w/img.size.width;
	CGSize finalSize = CGSizeMake(w, img.size.height*scaleF);
	
	UIGraphicsBeginImageContext(finalSize);
	CGRect imageRect = CGRectMake(0.0, 0.0, finalSize.width, finalSize.height);
	[img drawInRect:imageRect];
	UIImage *final = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return final;
}

- (NSString *)stringWithoutHTMLchars:(NSString *)str {
	str = [str stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"\""];
	str = [str stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"\""];
	str = [str stringByReplacingOccurrencesOfString:@"&rsquo;" withString:@"\'"];
	str = [str stringByReplacingOccurrencesOfString:@"<strong>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"</strong>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"<a href=\"" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"<em>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"</em>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n\n"];
	str = [str stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
	str = [str stringByReplacingOccurrencesOfString:@"<li>" withString:@"\n"];
	str = [str stringByReplacingOccurrencesOfString:@"</li>" withString:@""];
	return [str stringByReplacingOccurrencesOfString:@"&mdash;" withString:@""];
}

// This is necessary for scrollsToTop to work for the UIScrollView with a UIWebView added.
// For some reason, adding a UIWebView to a UIScrollView breaks scrollsToTop unless you do this.
// http://stackoverflow.com/questions/2175281/uiscrollview-uiwebview-no-scrollstotop
- (void)webViewDidFinishLoad:(UIWebView *) wv {  
	NSLog(@"finished load");
	((UIScrollView *)[[wv subviews] objectAtIndex:0]).scrollsToTop = NO;	
	[self performSelector:@selector(calculateWebViewSize:) withObject:wv afterDelay:0.1];
}

- (void)calculateWebViewSize:(UIWebView *)webView {
	int height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] intValue];
	webView.frame = CGRectMake(0, headheight, webView.frame.size.width, height);
	scrollView.contentSize = CGSizeMake(320, webView.frame.size.height + headheight);
}

- (void)dealloc {	
    [super dealloc];
}


@end