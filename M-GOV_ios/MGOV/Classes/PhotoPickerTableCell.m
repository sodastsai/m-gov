//
//  PhotoPickerTableCell.m
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "PhotoPickerTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoPickerTableCell

@synthesize delegate;
@synthesize photoButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
		
		[photoButton setTitle:@"按一下以加入照片..." forState:UIControlStateNormal];
		photoButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
		[photoButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
		
		photoButton.showsTouchWhenHighlighted = YES;
		[photoButton addTarget:delegate action:@selector(openPhotoDialogAction) forControlEvents:UIControlEventTouchUpInside];
		photoButton.layer.cornerRadius = 10.0;
		photoButton.layer.masksToBounds = YES;
		[self.contentView addSubview:photoButton];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[photoButton release];
    [super dealloc];
}

@end
