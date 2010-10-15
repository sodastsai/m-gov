//
//  TypesAndDetailsAppDelegate.m
//  TypesAndDetails
//
//  Created by sodas on 2010/8/11.
//  Copyright NTU Mobile HCI Lab 2010. All rights reserved.
//

#import "TypesAndDetailsAppDelegate.h"

@implementation TypesAndDetailsAppDelegate

@synthesize window;
@synthesize typeAndDetails;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [window addSubview:typeAndDetails.view];	
    [window makeKeyAndVisible];
	
	return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
