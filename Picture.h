//
//  Picture.h
//  ISD
//
//  Created by Rob Lourens on 4/20/10.
//  Copyright 2010 Iowa State Daily. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Picture : NSObject {
	UIImage *image;
	UIImage *thumbnail;
	NSString *caption;
}

@end
