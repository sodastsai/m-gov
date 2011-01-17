//
//  EGORefreshTableHeaderView.m
//  https://github.com/enormego/EGOTableViewPullRefresh
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

// Private Method
@interface EGORefreshTableHeaderView ()
- (void)setCurrentDate;
- (void)setState:(EGOPullRefreshState)aState;
@end

@implementation EGORefreshTableHeaderView

@synthesize state=_state;
@synthesize loadingState, delegate;

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	// Directly Define Appearance
	CGRect frame = CGRectMake(0.0f, -460.0f+44.0f, 320.0f, 460.0f);
	if (self = [super initWithFrame:frame]) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
		
		// Label for last update time
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		[label release];

		// Save update state
		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"])
			_lastUpdatedLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
		else
			[self setCurrentDate];
		
		// Label for updating status
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = TEXT_COLOR;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		[label release];
		
		// Arrow Image
		CALayer *layer = [[CALayer alloc] init];
		layer.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"blueArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		[layer release];
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;
		[view release];
		
		[self setState:EGOOPullRefreshNormal];
		
    }
    return self;
}

#pragma mark -
#pragma mark Set Appearance

- (void)setCurrentDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"上午"];
	[formatter setPMSymbol:@"下午"];
	[formatter setDateFormat:@"yyyy/MM/dd a hh:mm"];
	_lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新：%@", [formatter stringFromDate:[NSDate date]]];
	[[NSUserDefaults standardUserDefaults] setObject:_lastUpdatedLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

- (void)setState:(EGOPullRefreshState)aState{
	switch (aState) {
		case EGOOPullRefreshPulling:
			_statusLabel.text = @"放開以更新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
			
		case EGOOPullRefreshNormal:
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			_statusLabel.text = @"下拉以更新...";
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
			
		case EGOOPullRefreshLoading:
			_statusLabel.text = @"更新中...";
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			break;
			
		default:
			break;
	}
	_state = aState;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
	delegate = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Event

- (void)userDidScrollScrollView:(UIScrollView *)scrollView {
	if (scrollView.isDragging) {
		if (self.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !loadingState)
			[self setState:EGOOPullRefreshNormal];
		else if (self.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !loadingState)
			[self setState:EGOOPullRefreshPulling];
	}
}

- (void)userDidEndDraggingScrollView:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y <= - 65.0f && !loadingState) {
		loadingState = YES;
		[delegate reloadTableViewDataSource];
		[self setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		if ([self.superview isKindOfClass:[UIScrollView class]])
			[(UIScrollView *)self.superview setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f)];
		[UIView commitAnimations];
	}
}

- (void)dataSourceDidFinishLoadingDataWithStatus:(BOOL)status {
	
	loadingState = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	if ([self.superview isKindOfClass:[UIScrollView class]])
		[(UIScrollView *)self.superview setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
	[self setState:EGOOPullRefreshNormal];
	if (status)
		[self setCurrentDate];
}


@end
