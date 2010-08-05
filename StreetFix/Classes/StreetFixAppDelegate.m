//
//  StreetFixAppDelegate.m
//  StreetFix
//
//  Created by Eric Liou on 7/28/10.
//  Copyright SAS 2010. All rights reserved.
//

#import "StreetFixAppDelegate.h"

@implementation StreetFixAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    CameraView *temp = [[CameraView alloc] initWithNibName:@"CameraView" bundle:[NSBundle mainBundle]];
	
	temp.title = @"Welcome";
	
	UITabBarItem *tempTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:0];
	temp.tabBarItem = tempTabBarItem;
	[tempTabBarItem release];
	
	tempNavController = [[UINavigationController alloc] init];
	
	[tempNavController pushViewController:temp animated:NO];
	[temp release];
	
	//Creating new tab for photoPicker
	
	PhotoPicker *photopicker = [[PhotoPicker alloc] initWithNibName:@"PhotoPicker" bundle:[NSBundle mainBundle]];
	
	photopicker.title=@"Choose a Photo";
	
	UITabBarItem *photoTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:0];
	photopicker.tabBarItem = photoTabBarItem;
	[photoTabBarItem release];
	
	photoNavController=[[UINavigationController alloc] init];
	
	[photoNavController pushViewController:photopicker animated:NO];
	
	[photopicker release];
	
	//create new temporary tab for map
	
	MapView *map = [[MapView alloc] initWithNibName:@"MapView" bundle:[NSBundle mainBundle]];
	
	map.title = @"title";
	
	UITabBarItem *mapTabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
	map.tabBarItem = mapTabBarItem;
	[mapTabBarItem release];
	
	mapNavController = [[UINavigationController alloc] init];
	
	[mapNavController pushViewController:map animated:NO];
	
	[map release];
	
	
	// instantiate the tab bar controller
	rootTabBarController = [[UITabBarController alloc] init];
	
	// add the viewControllers to the tab bar controller and release the navControllers
	// because the tab bar controller will manage their retain count
	rootTabBarController.viewControllers = [NSArray arrayWithObjects:tempNavController, photoNavController, mapNavController, nil];
	
	[tempNavController release];
	[photoNavController release];
	[mapNavController release];
	
	[window addSubview:rootTabBarController.view];
	[window makeKeyAndVisible];
	
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
