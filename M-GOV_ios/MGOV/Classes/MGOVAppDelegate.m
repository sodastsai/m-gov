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
	
	// Set the locationManager be a global variable, and init
	GlobalVariable *shared = [GlobalVariable sharedVariable];
	shared.locationManager = [[CLLocationManager alloc] init];
	[shared.locationManager startUpdatingLocation];
	
	// Define File Path
	NSString *userInformationPlistPathInAppBundle = [[NSBundle mainBundle] pathForResource:@"UserInformation" ofType:@"plist"];
	NSString *userInformationPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	NSString *typeSelectorStatusPlistPathInAppBundle = [[NSBundle mainBundle] pathForResource:@"TypeSelectorStatus" ofType:@"plist"];
	NSString *typeSelectorStatusPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"TypeSelectorStatus.plist"];
	
	// Copy plist file
	if (![[NSFileManager defaultManager] fileExistsAtPath:userInformationPlistPathInAppDocuments]) {
		[[NSFileManager defaultManager] copyItemAtPath:userInformationPlistPathInAppBundle toPath:userInformationPlistPathInAppDocuments error:nil];
	}
	if (![[NSFileManager defaultManager] fileExistsAtPath:typeSelectorStatusPlistPathInAppDocuments]) {
		[[NSFileManager defaultManager] copyItemAtPath:typeSelectorStatusPlistPathInAppBundle toPath:typeSelectorStatusPlistPathInAppDocuments error:nil];
	}
	
	// Read plist from App's documents folder
	NSDictionary *dictUserInformation = [NSDictionary dictionaryWithContentsOfFile:userInformationPlistPathInAppDocuments];
	
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
