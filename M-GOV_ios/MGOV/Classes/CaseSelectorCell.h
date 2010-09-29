//
//  CaseSelectorCell.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCaseSelectorCellHeight 76

@interface CaseSelectorCell : UITableViewCell {
	UILabel *caseID;
	UILabel *caseType;
	UILabel *caseDate;
	UILabel *caseAddress;
	UIImageView *caseStatus;
}

@property (nonatomic, retain) UILabel *caseID;
@property (nonatomic, retain) UILabel *caseType;
@property (nonatomic, retain) UILabel *caseDate;
@property (nonatomic, retain) UILabel *caseAddress;
@property (nonatomic, retain) UIImageView *caseStatus;

+ (CGFloat)cellHeight;

@end
