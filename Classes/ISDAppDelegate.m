//
//  ISDAppDelegate.m
//  ISD
//
//  Created by Rob Lourens on 4/19/10.
//  Copyright Iowa State Daily 2010. All rights reserved.
//

#import "ISDAppDelegate.h"


@implementation ISDAppDelegate

@synthesize window;
@synthesize tabBarController, navController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:navController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

