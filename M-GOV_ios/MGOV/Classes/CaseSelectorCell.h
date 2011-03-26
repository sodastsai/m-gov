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

#import <UIKit/UIKit.h>
#define kCaseSelectorCellHeight 76

@interface CaseSelectorCell : UITableViewCell {
	UILabel *caseKey;
	UILabel *caseType;
	UILabel *caseDate;
	UILabel *caseAddress;
	UIImageView *caseStatus;
    UIImageView *caseFacebook;
}

@property (nonatomic, retain) UILabel *caseKey;
@property (nonatomic, retain) UILabel *caseType;
@property (nonatomic, retain) UILabel *caseDate;
@property (nonatomic, retain) UILabel *caseAddress;
@property (nonatomic, retain) UIImageView *caseStatus;
@property (nonatomic, retain) UIImageView *caseFacebook;

+ (CGFloat)cellHeight;

@end
