//
//  CaseSelectorCell.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCaseSelectorCellHeight 56

@interface CaseSelectorCell : UITableViewCell {
	UILabel *caseType;
	UILabel *caseDate;
	UILabel *caseAddress;
	UIImageView *caseStatus;
}

@property (nonatomic, retain) UILabel *caseType;
@property (nonatomic, retain) UILabel *caseDate;
@property (nonatomic, retain) UILabel *caseAddress;

+ (CGFloat)cellHeight;

@end
