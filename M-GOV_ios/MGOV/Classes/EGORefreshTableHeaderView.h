//
//  EGORefreshTableHeaderView.h
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

/*
 *  Modified to sodas to fit some object specification
 *
 *  Just alloc and init. You should not add a CGRectFrame.
 *  You can direct add this view to a UITableView,
 *  and the view will directly fit the size.
 *
 *  Make your UITableViewController confirm to the protocol.
 *  The view will call the protocol method to reload.
 *
 *  And Make your UITableViewDelegate which confirms to UIScrollViewDelegate call
 *  the three scroll method in Scroll Event.
 *  (UserDidScroll, DidEndScroll, DidFinishLoaging)
 *
 *  ====
 *  
 *  - (void)reloadTableViewDataSource;
 *		Reload the datasource triggered by the dragging view.
 *
 *  - (void)scrollViewDidScroll:(UIScrollView *)scrollView;
 *		This is a method in UIScrollViewDelegate.
 *		Remember to call -userDidScrollScrollView:
 *
 *  - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
 *		This is a method in UIScrollViewDelegate.
 *		Remember to call -userDidEndDraggingScrollView:
 *
 *  Finally, remember to call -dataSourceDidFinishLoadingDataWithStatus: after loading datasource
 *  The status means reloading is success or failed.
 *
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol EGORefreshTableHeaderViewDelegate
- (void)reloadTableViewDataSource;
@end

typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

@interface EGORefreshTableHeaderView : UIView {
	
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	EGOPullRefreshState _state;
	BOOL loadingState;
	
	id<EGORefreshTableHeaderViewDelegate> delegate;
}

@property (nonatomic,assign) EGOPullRefreshState state;
@property (nonatomic,assign) BOOL loadingState;
@property (nonatomic, retain) id<EGORefreshTableHeaderViewDelegate> delegate;

- (void)userDidScrollScrollView:(UIScrollView *)scrollView;
- (void)userDidEndDraggingScrollView:(UIScrollView *)scrollView;
- (void)dataSourceDidFinishLoadingDataWithStatus:(BOOL)status;

@end
