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
	
	// Define File Path
	NSString *plistPathInAppBundle = [[NSBundle mainBundle] pathForResource:@"UserInformation" ofType:@"plist"];
	NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	
	// Copy plist file
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPathInAppDocuments]) {
		[[NSFileManager defaultManager] copyItemAtPath:plistPathInAppBundle toPath:plistPathInAppDocuments error:nil];
	}
	
	// Read plist from App's documents folder
	NSDictionary *dictUserInformation = [NSDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
	
	if ([dictUserInformation valueForKey:@"FirstRun"]) {
		firstTimeView = [[FirstTimeViewController alloc] init];
		[window addSubview:firstTimeView.view];
	} else {
		// Main tab
		tabBarController = [[UITabBarController alloc] init];
		
		// My Case
		MyCaseViewController *myCase = [[MyCaseViewController alloc] init];
		myCase.title = @"我的案件";
		UINavigationController *myCaseNavigation = [[UINavigationController alloc] initWithRootViewController:myCase];
		
		// Query
		QueryViewController *query = [[QueryViewController alloc] initWithStyle:UITableViewStyleGrouped];
		query.title = @"查詢";
		UINavigationController *queryNavigation = [[UINavigationController alloc] initWithRootViewController:query];
		
		// Add tabs and view
		tabBarController.viewControllers = [NSArray arrayWithObjects:myCaseNavigation, queryNavigation, nil];
		[window addSubview:tabBarController.view];
		
		// Release
		[query release];
		[myCase release];
		[queryNavigation release];
		[myCaseNavigation release];
	}
	
	dictUserInformation = nil;
	[dictUserInformation release];
	
	[window makeKeyAndVisible];
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[firstTimeView release];
}

- (void)dealloc {
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end
