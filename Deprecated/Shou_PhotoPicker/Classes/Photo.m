//
//  Photo.m
//  MGOV
//
//  Created by iphone on 2010/8/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Photo.h"
#import "UIImageToDataTransformer.h"

@implementation Photo

@dynamic image, creationDate;
@dynamic longitude, latitude;


+ (void)initialize {
	if (self == [Photo class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
