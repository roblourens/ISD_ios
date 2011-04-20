//
//  Story.h
//  ISD
//
//  Created by Rob Lourens on 4/20/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Story : NSObject {
	NSString *text;
	NSString *category;
	NSString *title;
	NSString *byline;
	NSString *date;
	NSString *url;
	NSString *description;
	UIImage *img;
	UIImage *thumbnail;
	UIImage *headlineImg;
	NSString *storyID;
	NSString *imgUrl;
	NSString *thumbnailImgUrl;
	
	BOOL hasPicture;
	BOOL currentlyLoadingThumb;
	BOOL loaded;
}

- (void)loadImage;

@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *byline;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic, retain) UIImage *thumbnail;
@property (nonatomic, retain) NSString *storyID;
@property (nonatomic, retain) NSString *imgUrl;
@property (nonatomic, retain) NSString *thumbnailImgUrl;

@property (nonatomic) BOOL hasPicture;
@property (nonatomic) BOOL currentlyLoadingThumb;
@property (nonatomic) BOOL loaded;

@end
