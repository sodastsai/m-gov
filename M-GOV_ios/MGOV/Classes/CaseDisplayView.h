//
//  CaseDisplayView.h
//  MGOV
//
//  Created by iphone on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CaseDisplayView : UIView {
	MKMapView *mapView;
	UITableView *listView;
	NSMutableArray *caseData;
}

@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) UITableView *listView;

@end
