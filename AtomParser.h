//
//  AtomParser.h
//  ISD
//
//  Created by Rob Lourens on 4/20/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"


@interface AtomParser : NSObject<NSXMLParserDelegate> {
	NSMutableString *title;
	NSMutableString *url;
	NSMutableString *description;
	NSMutableString *date;
	NSMutableString *storyID;
	NSString *curElement;
	Story *story;
	NSMutableArray *stories;
}

- (NSMutableArray *)rssStoriesForCategory:(NSString *)category;
- (NSString *)removeCrap:(NSString *)crappyStr;

@property (nonatomic, retain) NSMutableString *title;
@property (nonatomic, retain) NSMutableString *url;
@property (nonatomic, retain) NSMutableString *description;
@property (nonatomic, retain) NSMutableString *date;
@property (nonatomic, retain) NSMutableString *storyID;
@property (nonatomic, retain) NSString *curElement;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) NSMutableArray *stories;

@end
