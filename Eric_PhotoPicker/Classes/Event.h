//
//  Event.h
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//

@class Photo;

@interface Event : NSManagedObject  {
}

@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;

@property (nonatomic, retain) UIImage *thumbnail;

@property (nonatomic, retain) Photo *photo;

@end

