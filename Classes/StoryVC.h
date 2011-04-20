//
//  StoryVC.h
//  ISD
//
//  Created by Rob Lourens on 4/30/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Story.h"


@interface StoryVC : UIViewController <UIWebViewDelegate> {
	Story *story;
	CGFloat headheight;
	UIScrollView *scrollView;
}

@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic) CGFloat headheight;

- (id)initWithStory:(Story *)s;
- (UIView *)getHeadView;
- (NSString *)stringWithoutHTMLchars:(NSString *)str;
- (UIImage *)resizeImage:(UIImage *)img toWidth:(CGFloat)w;

@end
