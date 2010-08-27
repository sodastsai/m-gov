//
//  GlobalVariable.h
//  MGOV
//
//  Created by Shou on 2010/8/26.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GlobalVariable : NSObject {
	
	CLLocationManager *locationManager;

}

@property (nonatomic, retain) CLLocationManager *locationManager;

+ (GlobalVariable *)sharedVariable;

@end
