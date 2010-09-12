//
//  CaseSelectorCell.m
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseSelectorCell.h"

@implementation CaseSelectorCell

@synthesize caseID, caseType, caseDate, caseAddress;

+ (CGFloat)cellHeight {
	return kCaseSelectorCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Set cell size
		self.frame = CGRectMake(0, 0, 320, kCaseSelectorCellHeight);
		
		// Set labels
		caseID = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 180, 20)];
		caseID.font = [UIFont boldSystemFontOfSize:18.0];
		caseID.minimumFontSize = 16.0;
		caseID.numberOfLines = 1;
		caseID.adjustsFontSizeToFitWidth = YES;
		caseID.backgroundColor = [UIColor clearColor];
		
		caseType = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 290, 18)];
		caseType.font = [UIFont boldSystemFontOfSize:16.0];
		caseType.minimumFontSize = 14.0;
		caseType.numberOfLines = 1;
		caseType.adjustsFontSizeToFitWidth = YES;
		caseType.backgroundColor = [UIColor clearColor];
		
		caseDate = [[UILabel alloc] initWithFrame:CGRectMake(190, 12, 100, 16)];
		caseDate.font = [UIFont systemFontOfSize:14.0];
		caseDate.textColor = [UIColor colorWithHue:(203.94/360) saturation:1 brightness:0.73 alpha:1];
		caseDate.backgroundColor = [UIColor clearColor];
		caseDate.textAlignment = UITextAlignmentRight;
		
		caseAddress = [[UILabel alloc] initWithFrame:CGRectMake(40, 54, 250, 12)];
		caseAddress.font = [UIFont systemFontOfSize:12.0];
		caseAddress.textColor = [UIColor grayColor];
		caseAddress.backgroundColor = [UIColor clearColor];
		caseAddress.numberOfLines = 1;
		caseAddress.adjustsFontSizeToFitWidth = NO;
		
		caseStatus = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ok.png"]];
		caseStatus.frame = CGRectMake(10, 28, 20, 20);
		
		[self.contentView addSubview:caseID];
		[self.contentView addSubview:caseDate];
		[self.contentView addSubview:caseType];
		[self.contentView addSubview:caseAddress];
		[self.contentView addSubview:caseStatus];
		
		[caseID release];
		[caseType release];
		[caseDate release];
		[caseAddress release];
		[caseStatus release];
		
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
    [super dealloc];
}

@end
