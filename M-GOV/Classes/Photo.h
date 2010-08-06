//
//  Photo.h
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//

@class Event;

@interface Photo : NSManagedObject  
{
}

@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSNumber * pictureLatitude;
@property (nonatomic, retain) NSNumber * pictureLongitude;

@end



