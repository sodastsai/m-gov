//
//  CaseDisplayTableCell.h
//  MGOV
//
//  Created by Shou on 2010/9/7.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CaseDisplayTableCell : UITableViewCell {
	UILabel *typeLabel;
	UILabel *addressLabel;
}

@property (nonatomic, retain) UILabel *typeLabel;
@property (nonatomic ,retain) UILabel *addressLabel;

@end
