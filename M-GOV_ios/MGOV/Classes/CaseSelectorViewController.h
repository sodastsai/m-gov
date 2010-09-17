//
//  CaseSelectorViewController.h
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

// Case Selector Mode
typedef enum {
	CaseSelectorListMode,
	CaseSelectorMapMode,
} CaseSelectorMenuMode;

// Delegate and Data Source
@protocol CaseSelectorDelegate

@required
- (void)didSelectRowAtIndexPathInList:(NSIndexPath *)indexPath;

@end

@protocol CaseSelectorDataSource

@required
- (NSInteger)numberOfSectionsInList;
- (NSInteger)numberOfRowsInListSection:(NSInteger)section;
- (CGFloat)heightForRowAtIndexPathInList:(NSIndexPath *)indexPath;
- (NSString *)titleForHeaderInSectionInList:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSArray *)setupAnnotationArrayForMapView;

@end

@interface CaseSelectorViewController : UINavigationController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate> {
	// Basic View
	UIViewController *emptyRootViewController;
	UITableViewController *listViewController;
	UIViewController *mapViewController;
	UIBarButtonItem *rightButtonItem;
	
	MKMapView *mapView;
	NSString *caseID;
	NSArray *annotationData;
	
	// Mode
	CaseSelectorMenuMode menuMode;
	
	// Data source and Delegate
	id<CaseSelectorDelegate> selectorDelegate;
	id<CaseSelectorDataSource> dataSource;
}

@property (retain, nonatomic) UITableViewController *listViewController;
@property (retain, nonatomic) UIViewController *mapViewController;
@property (retain, nonatomic) id<CaseSelectorDelegate> selectorDelegate;
@property (retain, nonatomic) id<CaseSelectorDataSource> dataSource;
@property (retain, nonatomic) UIBarButtonItem *rightButtonItem;
@property (retain, nonatomic) NSString *caseID;
@property (retain, nonatomic) NSArray *annotationData;
@property (retain, nonatomic) MKMapView *mapView;

// Initialize
- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title;
- (id)initWithMode:(CaseSelectorMenuMode)mode andTitle:(NSString *)title withRightBarButtonItem:(UIBarButtonItem *)rightButton;

- (UITableViewController *)initialListViewController;
- (UIViewController *)initialMapViewController;
- (void)changeToAnotherMode;
- (void)setRootViewController:(UIViewController *)rootViewController;
- (void)dropAnnotation:(NSArray *)data;
- (NSArray *)annotationArrayForMapView;
- (void)pushToCaseViewer;

@end
