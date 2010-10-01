//
//  HybridViewController.h
//  MGOV
//
//  Created by sodas on 2010/9/9.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppMKAnnotation.h"
#import "CaseViewerViewController.h"

// Hybrid View Mode
typedef enum {
	HybridViewListMode,
	HybridViewMapMode,
} HybridViewMenuMode;

// Delegate and Data Source
@protocol HybridViewDelegate

@required
- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath;
- (void)didSelectAnnotationViewInMap:(MKAnnotationView *)annotationView;
// Child in Navigation Hierachy
@property (nonatomic, retain) UIViewController *childViewController;

@end

@protocol HybridViewDataSource

@required
- (NSInteger)numberOfSectionsInList;
- (NSInteger)numberOfRowsInListSection:(NSInteger)section;
- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSectionInList:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)setupAnnotationArrayForMapView;

@end

@interface HybridViewController : UINavigationController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate> {
	// Basic View
	UIViewController *emptyRootViewController;
	UITableViewController *listViewController;
	UIViewController *mapViewController;
	UIBarButtonItem *rightButtonItem;

	MKMapView *mapView;
	// Mode
	HybridViewMenuMode menuMode;
	
	// Data source and Delegate
	id<HybridViewDelegate> selectorDelegate;
	id<HybridViewDataSource> dataSource;
}

@property (retain, nonatomic) UITableViewController *listViewController;
@property (retain, nonatomic) UIViewController *mapViewController;
@property (retain, nonatomic) id<HybridViewDelegate> selectorDelegate;
@property (retain, nonatomic) id<HybridViewDataSource> dataSource;
@property (retain, nonatomic) UIBarButtonItem *rightButtonItem;
@property (retain, nonatomic) NSString *caseID;
@property (retain, nonatomic) MKMapView *mapView;

// Initialize
- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)title;
- (id)initWithMode:(HybridViewMenuMode)mode andTitle:(NSString *)title withRightBarButtonItem:(UIBarButtonItem *)rightButton;

- (UITableViewController *)initialListViewController;
- (UIViewController *)initialMapViewController;
- (void)changeToAnotherMode;
- (void)setRootViewController:(UIViewController *)rootViewController;
- (void)dropAnnotation:(NSArray *)data;
- (NSArray *)annotationArrayForMapView;
- (void)refreshViews;
- (void)pushToChildViewControllerInMap;

@end
