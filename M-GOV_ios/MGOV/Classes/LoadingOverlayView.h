//
//  LoadingOverlayView.h
//  MGOV
//
//  Created by sodas on 2010/9/28.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kLoadingViewHeight 80
#define kLoadingViewWidth 250
#define kIndicatorSize 30
#define kLabelHeight 20
#define kLabelWidth 90
#define kIndicatorLabelInterval 20

@interface LoadingOverlayView : UIView {
	UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator;

- (id)initAtPoint:(CGPoint)point;
- (id)initAtViewCenter:(UIView *)targetView;

- (void)startedLoad;
- (void)finishedLoad;

@end
