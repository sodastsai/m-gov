//
//  NetworkChecking.h
//  MGOV
//
//  Created by shou on 2010/10/4.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "PrefAccess.h"

@interface NetworkChecking : NSObject {
}

+ (BOOL)checkNetwork;

@end
