//
//  AtomParser.m
//  ISD
//
//  Created by Rob Lourens on 4/20/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import "AtomParser.h"


@implementation AtomParser
@synthesize title, date, description, url, story, curElement, stories, storyID;

#define atomBase @"http://www.iowastatedaily.com/search/?q=&t=article&l=100&d=&d1=&d2=&s=start_time&sd=desc&c[]=%@&f=atom"
- (NSMutableArray *)rssStoriesForCategory:(NSString *)category {
	NSLog(@"Beginning to parse %@", category);
	// must be all lowercase for URL
	NSString *urlStr = [NSString stringWithFormat:atomBase, category];
	NSURL *rssurl = [NSURL URLWithString:urlStr];
	stories = [[NSMutableArray alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:rssurl];
	[parser setDelegate:self];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[parser parse];
	
	return stories;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString *errorString = [NSString stringWithFormat:@"Error occurred while parsing: %@", [parseError description]];
	NSLog(@"%@", errorString);
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:@"Some content may not be able to be displayed. Sorry." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
	[errorAlert release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	//NSLog(@"started %@", elementName);
	curElement = [elementName copy];
	// Starting a new news item
	if ([elementName isEqualToString:@"entry"]) {
		story = [[Story alloc] init];
		title = [[NSMutableString alloc] init];
		date = [[NSMutableString alloc] init];
		//		description = [[NSMutableString alloc] init];
		url = [[NSMutableString alloc] init];
		//		storyID = [[NSMutableString alloc] init];
	}
	else if ([elementName isEqualToString:@"enclosure"]) {
		if (story != nil)
			if ([[attributeDict valueForKey:@"type"] rangeOfString:@"image"].location != NSNotFound) {
				story.thumbnailImgUrl = [attributeDict valueForKey:@"url"];
				story.hasPicture = YES;
			}
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	//NSLog(@"ended %@", elementName);
	if ([elementName isEqualToString:@"item"]) {
		story.title = [self removeCrap:title];
		story.date = date;
		//		story.description = description;
		story.url = [self removeCrap:url];
		//		story.storyID = storyID;
		
		[stories addObject:story];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if ([curElement isEqualToString:@"title"]) {
		[title appendString:string];
	} else if ([curElement isEqualToString:@"link"]) {
		[url appendString:string];
	} /*else if ([curElement isEqualToString:@"description"]) {
	   [description appendString:string];
	   } */ else if ([curElement isEqualToString:@"pubDate"]) {
		   [date appendString:string];
	   } /*else if ([curElement isEqualToString:@"guid"]) {
		  [storyID appendString:string];
		  } */
}

- (NSString *)removeCrap:(NSString *)crappyStr {
	NSString *craplessStr = [crappyStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	craplessStr = [craplessStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	craplessStr = [craplessStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	
	return craplessStr;
}


@end
