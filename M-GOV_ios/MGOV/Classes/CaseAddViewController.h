//
//  CaseAddViewController.h
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "typesViewController.h"

@interface CaseAddViewController : UITableViewController <TypeSelectorDelegateProtocol>  {
		
}

- (BOOL)submitCase;

@end
