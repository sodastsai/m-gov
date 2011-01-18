/*
 * 
 * IconCell.m
 * 2011/1/18
 * sodas
 * 
 *
 * Copyright 2011 NTU CSIE Mobile & HCI Lab
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

#import "IconCell.h"

@implementation IconCell

@synthesize imageIconView;
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        imageIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unknown.png"]];
		imageIconView.frame = CGRectMake(20, (45-imageIconView.frame.size.height)/2, imageIconView.frame.size.width, imageIconView.frame.size.height);
		[self addSubview:imageIconView];
		
		textField = [[UILabel alloc] initWithFrame:CGRectMake(30+imageIconView.frame.size.width, 7, 250, 31)];
		[self addSubview:textField];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)dealloc {
	[textField release];
	[imageIconView release];
    [super dealloc];
}


@end
