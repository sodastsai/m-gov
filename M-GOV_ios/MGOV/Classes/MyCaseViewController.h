//
//  MyCaseViewController.h
//  MGOV
//
//  Created by Shou 2010/8/24.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CaseAddViewController.h"
#import "CaseDisplayView.h"

@interface MyCaseViewController : UIViewController <CaseAddViewControllerProtocol> {
	NSString *userEmail;
	CaseDisplayView *caseDisplayView;
}

- (void) addCase;
- (void) modeChange;

@end
