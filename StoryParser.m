//
//  StoryParser.m
//  ISD
//
//  Created by Rob Lourens on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StoryParser.h"


@implementation StoryParser
@synthesize story, curElement, curClass, text, byline, state;

#define mobileURLbase @"http://m.iowastatedaily.com/mobile"
- (void)loadDataForStory:(Story *)s {
	story = s;
	state = sOther;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSString *mobileURL = [s.url substringFromIndex:[self lastIndexOfCharacter:'/' inString:s.url]];
	mobileURL = [mobileURLbase stringByAppendingString:mobileURL];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:mobileURL]];
	[parser setDelegate:self];
	[parser parse];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString *errorString = [NSString stringWithFormat:@"Error occurred while parsing: %@. Reason: %@", [parseError description], [parseError localizedFailureReason]];
	NSLog(@"%@", errorString);
	
	//UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:@"Some content may not be able to be displayed. Sorry." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	//[errorAlert show];
	//[errorAlert release];
}


#define storyTextId @"blox-story-text"
#define inStoryAdId @"in-story"
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	curElement = [elementName copy];
	curClass = [attributeDict objectForKey:@"class"];
	
	NSString *curDivId = [attributeDict valueForKey:@"id"];
	if ([elementName isEqualToString:@"div"] && [storyTextId isEqualToString:curDivId]) { // put curDivId second in case it's nil
		text = [[NSMutableString alloc] init];
		state = sText;
	}
	else if ([elementName isEqualToString:@"img"]) {
		story.imgUrl = [attributeDict valueForKey:@"src"];
	}
	else if (state == sText) {
		[text appendFormat:@"<%@>", elementName];
	}
	else if ([curElement isEqualToString:@"p"] && curClass != nil && [curClass isEqualToString:@"byline"]) {
		byline = [[NSMutableString alloc] init];
		state = sByline;
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"div"] && state == sText) {
		// Remove random newlines
		story.text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
		story.loaded = YES;
		state = sOther;
	}  else if (state == sText) {
		// Save html that is part of the text
		[text appendFormat:@"</%@>", elementName];
	} else if (state == sByline) {
		story.byline = [[byline stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] stringByReplacingOccurrencesOfString:@" | " withString:@"\n"];
		state = sOther;
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (state == sText) {
		[text appendString:string];
	}
	else if (state == sByline)
		[byline appendString:string];
}

- (NSUInteger)lastIndexOfCharacter:(unichar)c inString:(NSString *)str {
	for (int i=[str length]-1; i>=0; i--) {
		if ([str characterAtIndex:i] == c) {
			return i;
		}
	}
	
	return -1;
}


@end
