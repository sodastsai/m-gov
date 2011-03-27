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

#import "FBCommentTableCell.h"


@implementation FBCommentTableCell

@synthesize likeImage, commentImage, likeNumber, commentNumber;

- (id)initWithLike:(NSString *)likeCount andComment:(NSString *)commentCount{
    
    self.likeImage = nil;
    self.commentImage = nil;
    if (![likeCount isEqualToString:@"0"]){
        self.likeImage = [UIImage imageNamed:@"like.png"];
        self.likeNumber = likeCount;
    }
    if (![commentCount isEqualToString:@"0"]){
        self.commentImage = [UIImage imageNamed:@"group.png"];
        self.commentNumber = commentCount;
    }
     
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FBCommentCell"];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        UIImageView *likeView;
        UIImageView *commentView;
        UILabel *likeLabel;
        UILabel *commentLabel;
        
        if (self.likeImage!=nil) {
            likeView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 5, 20, 20)];
            likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 5, 70, 20)];
                      
            likeView.image = self.likeImage;
            likeLabel.text = [NSString stringWithFormat:@"%@人說讚", self.likeNumber];
            likeLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
            likeLabel.font = [UIFont systemFontOfSize:14.0];
            likeLabel.backgroundColor = [UIColor clearColor];
            
            [self addSubview:likeView];
            [self addSubview:likeLabel];

            [likeView release];
            [likeLabel release];
        }
        
        if (self.likeImage!=nil && self.commentImage!=nil) {
            commentView = [[UIImageView alloc] initWithFrame:CGRectMake(132, 6, 20, 20)];
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(158, 5, 70, 20)];
            
            commentView.image = self.commentImage;
            commentLabel.text = [NSString stringWithFormat:@"%@人留言", self.commentNumber];
            commentLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
            commentLabel.font = [UIFont systemFontOfSize:14.0];
            commentLabel.backgroundColor = [UIColor clearColor];
            
            [self addSubview:commentView];
            [self addSubview:commentLabel];
            [commentView release];
            [commentLabel release];

        }
        
        if (self.likeImage==nil && self.commentImage!=nil){
            commentView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 6, 20, 20)];
            commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 5, 70, 20)];
            
            commentView.image = self.commentImage;
            commentLabel.text = [NSString stringWithFormat:@"%@人留言", self.commentNumber];
            commentLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.53 alpha:1.0];
            commentLabel.font = [UIFont systemFontOfSize:14.0];
            commentLabel.backgroundColor = [UIColor clearColor];
            
            [self addSubview:commentView];
            [self addSubview:commentLabel];
            [commentView release];
            [commentLabel release];
        }
         
    }
    
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    
    [likeImage release];
    [commentImage release];
    [likeNumber release];
    [commentNumber release];
     
    [super dealloc];
}

@end
