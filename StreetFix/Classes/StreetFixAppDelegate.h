//
//  StreetFixAppDelegate.h
//  StreetFix
//
//  Created by Eric Liou on 7/28/10.
//  Copyright SAS 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraView.h"
#import "PhotoPicker.h"
#import "MapView.h"

@interface StreetFixAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
	UITabBarController *rootTabBarController;
	UINavigationController *tempNavController;
	UINavigationController *photoNavController;
	UINavigationController *mapNavController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

