//
//  Event.m
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import "Event.h"
#import "Photo.h"

#import "UIImageToDataTransformer.h"

@implementation Event 

@dynamic creationDate, latitude, longitude, thumbnail, photo;

+ (void)initialize {
	if (self == [Event class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end

