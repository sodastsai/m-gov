//
//  QueryViewController.h
//  MGOV
//
//  Created by Shou on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeSelectorDelegateProtocol.h"


@interface QueryViewController : UITableViewController <TypeSelectorDelegateProtocol> {
	NSString *selectedTypeTitle;
	NSInteger qid;
}

@property (retain, nonatomic) NSString *selectedTypeTitle;
@property (nonatomic) NSInteger qid;

- (BOOL)submitQuery;

@end
