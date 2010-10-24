/*
 * 
 * LocationSelectorTableCell.h
 * 2010/8/31
 * sodas
 * 
 * Cell which will show selected location and open location selector
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

#import "LocationSelectorTableCell.h"

@implementation LocationSelectorTableCell

@synthesize delegate;

- (id)initWithHeight:(CGFloat)h andCoordinate:(CLLocationCoordinate2D)coord actionTarget:(id)perfomer setAction:(SEL)action {
	mapViewHeight = h;
	mapButtonTarget = perfomer;
	mapButtonAction = action;
	mapCoordinate = coord;
	self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationCell"];
	return self;
}

- (void)updatingCoordinate:(CLLocationCoordinate2D)coordinate {
	[mapView setCenterCoordinate:coordinate];
	casePlace.coordinate = coordinate;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 300, mapViewHeight)];
		mapView.mapType = MKMapTypeStandard;
		[mapView setCenterCoordinate:mapCoordinate animated:YES];
		MKCoordinateRegion region;
		region.center = mapCoordinate;
		MKCoordinateSpan span;
		span.latitudeDelta = 0.004;
		span.longitudeDelta = 0.004;
		region.span = span;
		mapView.layer.cornerRadius = 10.0;
		mapView.layer.masksToBounds = YES;
		mapView.scrollEnabled = NO;
		[mapView setRegion:region];
		
		UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
		mapButton.backgroundColor = [UIColor clearColor];
		[mapButton addTarget:mapButtonTarget action:mapButtonAction forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:mapButton];
		[mapButton release];

		casePlace = [[AppMKAnnotation alloc] initWithCoordinate:region.center andTitle:@"" andSubtitle:@""];
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
