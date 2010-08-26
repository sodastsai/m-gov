//
//  secondDetailViewController.h
//  MGOV
//
//  Created by sodas on 2010/8/11.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeSelectorDelegateProtocol.h"

@interface secondDetailViewController : UITableViewController {
	NSInteger finalSectionId;
	NSInteger finalTypeId;
	NSInteger finalDetailId;
	NSInteger finalSecondDetailId;
	id<TypeSelectorDelegateProtocol> delegate;
}

@property (nonatomic) NSInteger finalSectionId;
@property (nonatomic) NSInteger finalTypeId;
@property (nonatomic) NSInteger finalDetailId;
@property (nonatomic) NSInteger finalSecondDetailId;
@property (nonatomic, retain) id<TypeSelectorDelegateProtocol> delegate;

@end
