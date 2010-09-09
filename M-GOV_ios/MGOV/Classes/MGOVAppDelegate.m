//
//  MGOVAppDelegate.m
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright NTU Mobile HCI Lab 2010. All rights reserved.
//

#import "MGOVAppDelegate.h"
#import "MyCaseViewController.h"
#import "QueryViewController.h"
#import "QueryGoogleAppEngine.h"

@implementation MGOVAppDelegate

@synthesize window, tabBarController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// Set the locationManager be a global variable, and init
	MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
	shared.locationManager = [[CLLocationManager alloc] init];
	[shared.locationManager startUpdatingLocation];
	
	// Define File Path
	NSString *userInformationPlistPathInAppBundle = [[NSBundle mainBundle] pathForResource:@"UserInformation" ofType:@"plist"];
	NSString *userInformationPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
	// Copy plist file
	if (![[NSFileManager defaultManager] fileExistsAtPath:userInformationPlistPathInAppDocuments]) 
		[[NSFileManager defaultManager] copyItemAtPath:userInformationPlistPathInAppBundle toPath:userInformationPlistPathInAppDocuments error:nil];
	
	// My Case
	MyCaseViewController *myCase = [[MyCaseViewController alloc] initWithMode:CaseSelectorListMode andTitle:@"我的案件"];
	myCase.dataSource = myCase;
	myCase.selectorDelegate = myCase;
		
	// Query
	QueryViewController *queryCase = [[QueryViewController alloc] initWithMode:CaseSelectorMapMode andTitle:@"查詢案件"];
	queryCase.dataSource = queryCase;
	queryCase.selectorDelegate = queryCase;
	
	// Add tabs and view
	tabBarController = [[UITabBarController alloc] init];
	tabBarController.viewControllers = [NSArray arrayWithObjects:myCase, queryCase, nil];
	
	// Set window property and show
	window.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	[window addSubview:tabBarController.view];
	[window makeKeyAndVisible];
	
	// Release
	[myCase release];
	[queryCase release];
	
	return YES;
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
