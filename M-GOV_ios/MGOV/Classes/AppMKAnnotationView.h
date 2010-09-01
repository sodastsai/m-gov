//
//  AppMKAnnotationView.h
//  MGOV
//
//  Created by Shou on 2010/8/31.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "AppMKAnnotation.h"

@interface AppMKAnnotationView : MKPinAnnotationView {

}

@property (nonatomic, assign) MKMapView *AmapView;
@property (nonatomic, assign) BOOL hasBuiltInDraggingSupport;

@end
