//
//  NewsData.m
//  ISDtest
//
//  Created by Rob Lourens on 4/15/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import "NewsData.h"


@implementation NewsData
@synthesize categoryNames, categories, parser, sparser;

static NewsData *data;

+ (NewsData *)data {
	if (data == nil) {
		data = [[NewsData alloc] init];
	}
	
	return data;
}

- (id)init {
	if (self = [super init]) {
		parser = [[RssParser alloc] init];
		sparser = [[StoryParser alloc] init];

		categoryNames = [[NSArray alloc] initWithObjects:@"News", @"Opinion", @"Sports", @"Business", nil];
		categories = [[NSMutableDictionary alloc] initWithCapacity:[categoryNames count]];
	}
	
	return self;
}

- (NSArray *)loadCategory:(NSString *)category {
	NSMutableArray *stories = [parser rssStoriesForCategory:category];
	
	// Make the first story with a picture first
	for (Story *s in stories) {
		if (s.hasPicture) {
			[stories removeObject:s];
			[stories insertObject:s atIndex:0];
			break;
		}
	}
	
	return stories;
}

- (void)loadStory:(Story *)s {
	[sparser loadDataForStory:s];
	[s loadImage];
}

- (NSArray *)getStoriesForCategory:(NSString *)category withReload:(BOOL)reload {
	NSArray *stories = [categories valueForKey:category];
	if (stories == nil || reload) {
		stories = [self loadCategory:category];
		[categories setValue:stories forKey:category];
	}
	
	return stories;
}

- (Story *)getLoadedStoryForCategory:(NSString *)category index:(NSUInteger)index {
	Story *s = [[self getStoriesForCategory:category withReload:NO] objectAtIndex:index];
	if (!s.loaded)
		[self loadStory:s];
	
	return s;
}


@end
