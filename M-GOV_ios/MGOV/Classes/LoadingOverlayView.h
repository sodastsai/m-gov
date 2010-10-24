/*
 * 
 * LoadingOverlayView.h
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
	UILabel *loading;
}

@property (nonatomic, retain) UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UILabel *loading;

- (id)initAtPoint:(CGPoint)point;
- (id)initAtViewCenter:(UIView *)targetView;

- (void)startedLoad;
- (void)finishedLoad;

@end
