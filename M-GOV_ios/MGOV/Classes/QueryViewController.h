//
//  QueryViewController.h
//  MGOV
//
//  Created by iphone on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeSelectorDelegateProtocol.h"


@interface QueryViewController : UITableViewController <TypeSelectorDelegateProtocol> {

}

- (BOOL)submitQuery;

@end
