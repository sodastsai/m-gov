/*
 * 
 * FacebookTableCell.h
 * 2011/3/26
 * kamebkj
 * 
 * Cell to display facebook like&comment
 *
 * Copyright 2010,2011 NTU CSIE Mobile & HCI Lab
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


@interface FBCommentTableCell : UITableViewCell {
    UIImage *likeImage;
    UIImage *commentImage;
    NSString *likeNumber;
    NSString *commentNumber;
}

@property (nonatomic, retain) UIImage *likeImage;
@property (nonatomic, retain) UIImage *commentImage;
@property (nonatomic, retain) NSString *likeNumber;
@property (nonatomic, retain) NSString *commentNumber;

- (id)initWithLike:(NSString *)likeCount andComment:(NSString *)commentCount;

@end
