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

- (void)updatingCoordinate:(CLLocationCoordinate2D)coordinate {

	[mapView setCenterCoordinate:coordinate];
	casePlace.coordinate = coordinate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, mapViewHeight-1)];
		mapView.mapType = MKMapTypeStandard;
		MGOVGeocoder *shared = [MGOVGeocoder sharedVariable];
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
		
		
		
		// Use Google API to transform Latitude & Longitude to the corresponding address  
		NSURL *url = [[NSURL alloc] initWithString:@"http://maps.google.com/maps/api/geocode/json?latlng=25.047924,121.517081&sensor=true&language=zh-TW"];
		NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
		NSDictionary *dict = [str JSONValue];
		[url release];
		[str release];
		
		// TODO: correct the title: 現在位置or照片位置
		// TODO: correct the subtitle: 地址
		casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"Title test" andSubtitle:[NSString stringWithFormat:@"%@", [[[dict objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]]];
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
