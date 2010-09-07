//
//  CaseDisplayTableCell.m
//  MGOV
//
//  Created by Shou on 2010/9/7.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseDisplayTableCell.h"


@implementation CaseDisplayTableCell

@synthesize typeLabel, addressLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 24)];
		addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 260, 24)];
		typeLabel.backgroundColor = [UIColor clearColor];
		//typeLabel.font = [UIFont boldSystemFontOfSize:14];
		typeLabel.adjustsFontSizeToFitWidth = YES;
		addressLabel.backgroundColor = [UIColor clearColor];
		addressLabel.font = [UIFont systemFontOfSize:12];
		addressLabel.textColor = [UIColor grayColor];
		//UILabel *dateLabel;
		[self.contentView addSubview:typeLabel];
		[self.contentView addSubview:addressLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[typeLabel release];
	[addressLabel release];
    [super dealloc];
}


@end
