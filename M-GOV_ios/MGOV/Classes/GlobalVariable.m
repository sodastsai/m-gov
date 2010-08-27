//
//  GlobalVariable.m
//  MGOV
//
//  Created by Shou on 2010/8/26.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "GlobalVariable.h"

static GlobalVariable *sharedVariable = nil;

@implementation GlobalVariable

@synthesize locationManager;

#pragma mark -
#pragma mark Singleton Methods

+ (GlobalVariable *)sharedVariable {
	@synchronized(self) {
		if(sharedVariable == nil){
			sharedVariable = [[self alloc] init];
		}
	}
	return sharedVariable;
}

@end
