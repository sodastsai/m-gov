/*
 * 
 * LoadingOverlayView.m
 * 2010/9/28
 * sodas
 * 
 * A hint of loading for user
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
		
        loading = [[UILabel alloc] initWithFrame:CGRectMake(labelX, (int)((kLoadingViewHeight-kLabelHeight)/2), kLabelWidth, kLabelHeight)];
		loading.text = @"正在載入...";
		loading.textColor = [UIColor whiteColor];
		loading.backgroundColor = [UIColor clearColor];
		loading.font = [UIFont boldSystemFontOfSize:18.0];
		
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.67];
		self.layer.cornerRadius = 10;
		[self addSubview:loading];
		[self addSubview:indicator];
		
		[indicator stopAnimating];
		[indicator release];
		[loading release];
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
    [super dealloc];
}


@end
