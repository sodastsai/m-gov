/*
 * 
 * CaseSelectorCell.h
 * 2010/9/9
 * sodas
 * 
 * Define Layout of cell in Case Selector
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

#import "CaseSelectorCell.h"

@implementation CaseSelectorCell

@synthesize caseKey, caseType, caseDate, caseAddress, caseStatus, caseFacebook;

+ (CGFloat)cellHeight {
	return kCaseSelectorCellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Set cell size
		self.frame = CGRectMake(0, 0, 320, kCaseSelectorCellHeight);
		
		// Set labels
		caseKey = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 180, 20)];
		caseKey.font = [UIFont boldSystemFontOfSize:18.0];
		caseKey.minimumFontSize = 16.0;
		caseKey.numberOfLines = 1;
		caseKey.adjustsFontSizeToFitWidth = YES;
		caseKey.backgroundColor = [UIColor clearColor];
		
		caseType = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 290, 18)];
		caseType.font = [UIFont boldSystemFontOfSize:16.0];
		caseType.minimumFontSize = 14.0;
		caseType.numberOfLines = 1;
		caseType.adjustsFontSizeToFitWidth = YES;
		caseType.backgroundColor = [UIColor clearColor];
		
		caseDate = [[UILabel alloc] initWithFrame:CGRectMake(190, 12, 100, 16)]; //(190, 12, 100, 16)
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
		
		caseStatus = [[UIImageView alloc] init];
		caseStatus.frame = CGRectMake(10, 28, 20, 20); //(10,28,20,20)
        
        caseFacebook = [[UIImageView alloc] init];
        caseFacebook.frame = CGRectMake(210, 12, 15, 15);
		
		[self.contentView addSubview:caseKey];
		[self.contentView addSubview:caseDate];
		[self.contentView addSubview:caseType];
		[self.contentView addSubview:caseAddress];
		[self.contentView addSubview:caseStatus];
        [self.contentView addSubview:caseFacebook];
		
		[caseKey release];
		[caseType release];
		[caseDate release];
		[caseAddress release];
		[caseStatus release];
        [caseFacebook release];
		
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
