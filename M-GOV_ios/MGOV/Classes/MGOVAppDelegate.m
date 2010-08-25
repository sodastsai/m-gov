//
//  MGOVAppDelegate.m
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright NTU Mobile HCI Lab 2010. All rights reserved.
//

#import "MGOVAppDelegate.h"

@implementation MGOVAppDelegate

@synthesize window, tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	// Main tab
	tabBarController = [[UITabBarController alloc] init];
	
	// First time welcome and guide
	
	
	// Tab1
	MyCaseViewController *myCase = [[MyCaseViewController alloc] init];
	myCase.title = @"我的案件";
	UINavigationController *myCaseNavigation = [[UINavigationController alloc] initWithRootViewController:myCase];
	
	// Tab2
	QueryViewController *query = [[QueryViewController alloc] init];
	query.title = @"查詢";
	UINavigationController *queryNavigation = [[UINavigationController alloc] initWithRootViewController:query];
	
	// Add tabs and view
	tabBarController.viewControllers = [NSArray arrayWithObjects:myCaseNavigation, queryNavigation, nil];
	[window addSubview:tabBarController.view];
	
	[query release];
	[myCase release];
	[queryNavigation release];
	[myCaseNavigation release];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}

- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end
