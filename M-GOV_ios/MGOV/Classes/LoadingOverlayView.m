//
//  LoadingOverlayView.m
//  MGOV
//
//  Created by sodas on 2010/9/28.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "LoadingOverlayView.h"

@implementation LoadingOverlayView

@synthesize indicator, loading;

#pragma mark -
#pragma mark Lifecycle

- (id)initAtViewCenter:(UIView *)targetView {
	float viewX = (targetView.frame.size.width- kLoadingViewWidth)/2;
	float viewY = (targetView.frame.size.height - kLoadingViewHeight)/2;
	return [self initAtPoint:CGPointMake(viewX, viewY)];
}

- (id)initAtPoint:(CGPoint)point {
	return [self initWithFrame:CGRectMake(point.x, point.y, kLoadingViewWidth, kLoadingViewHeight)];
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		int indicatorX = (kLoadingViewWidth-(kIndicatorSize+kIndicatorLabelInterval+kLabelWidth))/2;
		int labelX = indicatorX + kIndicatorSize + kIndicatorLabelInterval;
		indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		indicator.frame = CGRectMake(indicatorX, (int)((kLoadingViewHeight-kIndicatorSize)/2), kIndicatorSize, kIndicatorSize);
		
        loading = [[UILabel alloc] initWithFrame:
							CGRectMake(labelX, (int)((kLoadingViewHeight-kLabelHeight)/2), kLabelWidth, kLabelHeight)];
		loading.text = @"正在載入...";
		loading.textColor = [UIColor whiteColor];
		loading.backgroundColor = [UIColor clearColor];
		loading.font = [UIFont boldSystemFontOfSize:18.0];
		
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.67];
		self.layer.cornerRadius = 10;
		[self addSubview:loading];
		[self addSubview:indicator];
		
		[indicator stopAnimating];
    }
    return self;
}

- (void)startedLoad {
	[indicator startAnimating];
}

- (void)finishedLoad {
	[indicator stopAnimating];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[loading release];
    [super dealloc];
}


@end
