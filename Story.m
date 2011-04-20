//
//  Story.m
//  ISD
//
//  Created by Rob Lourens on 4/20/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import "Story.h"


@implementation Story
@synthesize text, category, byline, title, date, url, description, storyID, img, imgUrl, thumbnail, thumbnailImgUrl, hasPicture, currentlyLoadingThumb, loaded;

- (UIImage *)thumbnail {
	return thumbnail;
}

- (void)loadImage {
	img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
}

- (void)setText:(NSString *)newText {
	text = nil;
	text = [[newText stringByAppendingString:@"\n\n"] retain]; // Some extra \n to ensure that the calculated text size is large enough
}

- (void)dealloc {
	[text release];
	[category release];
	[byline release];
	[title release];
	[date release];
	[url release];
	[description release];
	[storyID release];
	[img release];
	[imgUrl release];
	[thumbnail release];
	[thumbnailImgUrl release];
	[super dealloc];
}

@end
