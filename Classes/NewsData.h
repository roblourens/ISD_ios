//
//  NewsData.h
//  ISDtest
//
//  Created by Rob Lourens on 4/15/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RssParser.h"
#import "StoryParser.h"


@interface NewsData : NSObject {
	NSArray *categoryNames;
	NSDictionary *categories;
	RssParser *parser;
	StoryParser *sparser;
}

@property (nonatomic, retain) NSArray *categoryNames;
@property (nonatomic, retain) NSDictionary *categories;
@property (nonatomic, retain) RssParser *parser;
@property (nonatomic, retain) StoryParser *sparser;

+ (NewsData *)data;
- (NSArray *)loadCategory:(NSString *)category;
- (NSArray *)getStoriesForCategory:(NSString *)category withReload:(BOOL)reload;
- (Story *)getLoadedStoryForCategory:(NSString *)category index:(NSUInteger)index;
- (void)loadStory:(Story *)s;

@end
