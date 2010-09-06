//
//  CaseDisplayView.h
//  MGOV
//
//  Created by iphone on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CaseDisplayView : UIView {
	MKMapView *mapView;
	UITableView *listView;
	NSMutableArray *caseData;
	BOOL transitioning;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UITableView *listView;
@property BOOL transitioning;

-(void)performTransition;

@end
