//
//  LocationSelectorTableCell.m
//  MGOV
//
//  Created by sodas on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "LocationSelectorTableCell.h"

@implementation LocationSelectorTableCell

@synthesize delegate;

- (id)initWithHeight:(CGFloat)h andCoordinate:(CLLocationCoordinate2D)coord actionTarget:(id)perfomer setAction:(SEL)action {
	mapViewHeight = h;
	mapButtonTarget = perfomer;
	mapButtonAction = action;
	mapCoordinate = coord;
	return [self init];
}

- (void)updatingCoordinate:(CLLocationCoordinate2D)coordinate {
	[mapView setCenterCoordinate:coordinate];
	casePlace.coordinate = coordinate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, mapViewHeight-1)];
		mapView.mapType = MKMapTypeStandard;
		//MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
		//[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
		[mapView setCenterCoordinate:mapCoordinate animated:YES];
		MKCoordinateRegion region;
		//region.center = shared.locationManager.location.coordinate;
		region.center = mapCoordinate;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.004;
		span.longitudeDelta = 0.004;
		region.span = span;
		mapView.layer.cornerRadius = 10.0;
		mapView.layer.masksToBounds = YES;
		[mapView setRegion:region];
		
		UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
		mapButton.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:mapButton];
		[mapButton addTarget:mapButtonTarget action:mapButtonAction forControlEvents:UIControlEventTouchUpInside];

		
		// TODO: correct the title: 現在位置or照片位置
		// TODO: correct the subtitle: 地址
		casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"Title test" andSubtitle:@""];
		[mapView addAnnotation:casePlace];
		
		self.backgroundView = mapView;
		[mapView release];
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	[casePlace release];
	[mapView release];
    [super dealloc];
}

@end
