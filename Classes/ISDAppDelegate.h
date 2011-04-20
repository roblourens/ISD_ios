//
//  ISDAppDelegate.h
//  ISD
//
//  Created by Rob Lourens on 4/19/10.
//  Copyright Iowa State Daily 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsData.h"

@interface ISDAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UINavigationController *navController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;

@end
