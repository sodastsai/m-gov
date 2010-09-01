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

- (id)initWithHeight:(CGFloat)h {
	mapViewHeight = h;
	return [self init];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        MKMapView *mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, mapViewHeight-1)];
		mapView.mapType = MKMapTypeStandard;
		GlobalVariable *shared = [GlobalVariable sharedVariable];
		[mapView setCenterCoordinate:shared.locationManager.location.coordinate animated:YES];
		MKCoordinateRegion region;
		region.center = shared.locationManager.location.coordinate;
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
		[mapButton addTarget:delegate action:@selector(openLocationSelector) forControlEvents:UIControlEventTouchUpInside];
		
		// TODO: correct the title: 現在位置or照片位置
		// TODO: correct the subtitle: 地址
		AppMKAnnotation *casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"Title test" andSubtitle:@"科科"];
		[mapView addAnnotation:casePlace];
		[casePlace release];
		
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
    [super dealloc];
}

@end
