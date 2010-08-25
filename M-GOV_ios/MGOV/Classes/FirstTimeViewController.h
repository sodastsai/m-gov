//
//  FirstTimeViewController.h
//  MGOV
//
//  Created by sodas on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTimeViewController : UIViewController <UIAlertViewDelegate> {
	UIButton *startToUse;
	UITextField *emailField;
	NSString *alertRequestEmailTitle;
}

@property (nonatomic, retain) IBOutlet UIButton *startToUse;

- (IBAction)requestEmail;

@end
