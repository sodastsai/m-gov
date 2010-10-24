/*
 * 
 * PhotoPickerTableCell.h
 * 2010/8/31
 * sodas
 * 
 * Cell which will show picked photo and trigger the menu of taking photo
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "PhotoPickerTableCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoPickerTableCell

@synthesize delegate;
@synthesize photoButton;

+ (CGFloat)cellHeight {
	return kPhotoPickerCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        photoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, kPhotoPickerCellHeight)];
		
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
