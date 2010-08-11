//
//  TypesAndDetailsAppDelegate.h
//  TypesAndDetails
//
//  Created by sodas on 2010/8/11.
//  Copyright NTU Mobile HCI Lab 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypesAndDetailsAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *typeAndDetails;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *typeAndDetails;

@end

