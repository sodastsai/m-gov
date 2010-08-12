//
//  MGOVAppDelegate.h
//  MGOV
//
//  Created by iphone on 2010/8/11.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitRootViewController.h"
#import "QueryRootViewController.h"

@interface MGOVAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

