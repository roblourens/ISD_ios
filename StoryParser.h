//
//  StoryParser.h
//  ISD
//
//  Created by Rob Lourens on 11/1/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Story.h"

typedef enum {
	sText,
	sByline,
	sOther	
} ParseState;

@interface StoryParser : NSObject<NSXMLParserDelegate> {
	NSString *curElement;
	NSString *curClass;
	Story *story;
	NSMutableString *text;
	NSMutableString *byline;
	ParseState state;
}

@property (nonatomic, retain) NSString *curElement;
@property (nonatomic, retain) NSString *curClass;
@property (nonatomic, retain) Story *story;
@property (nonatomic, retain) NSMutableString *text;
@property (nonatomic, retain) NSMutableString *byline;
@property (nonatomic) ParseState state;

- (void)loadDataForStory:(Story *)s;
- (NSUInteger)lastIndexOfCharacter:(unichar)c inString:(NSString *)str;

@end
