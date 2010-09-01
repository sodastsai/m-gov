//
//  AppMKAnnotationView.m
//  MGOV
//
//  Created by iphone on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "AppMKAnnotationView.h"

@implementation AppMKAnnotationView

@synthesize hasBuiltInDraggingSupport;
@synthesize AmapView;

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
	
    self.hasBuiltInDraggingSupport = [[MKPinAnnotationView class] instancesRespondToSelector:NSSelectorFromString(@"isDraggable")];
	
	if (self.hasBuiltInDraggingSupport) {
		if ((self = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
			[self performSelector:NSSelectorFromString(@"setDraggable:") withObject:[NSNumber numberWithBool:YES]];
		}
	}
	self.canShowCallout = YES;
	
	return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
