//
//  Photo.h
//  MGOV
//
//  Created by iphone on 2010/8/12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface Photo : NSManagedObject {
	
}

@property (nonatomic, retain) UIImage *image;
//@property (nonatomic, retain) UIImage *icon;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@end
