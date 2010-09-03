//
//  PhotoPickerTableCell.h
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppClassExtension.h"

#define kPhotoViewHeight 200.0

@protocol PhotoPickerTableCellDelegate

@required
-(void)openPhotoDialogAction;

@end


@interface PhotoPickerTableCell : UITableViewCell {
	UIButton *photoButton;
	id<PhotoPickerTableCellDelegate> delegate;
}

@property (retain, nonatomic) id<PhotoPickerTableCellDelegate> delegate;
@property (retain, nonatomic) UIButton *photoButton;

@end
