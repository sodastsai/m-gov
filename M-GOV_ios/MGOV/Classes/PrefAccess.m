//
//  PrefAccess.m
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "PrefAccess.h"

@implementation PrefAccess

@synthesize prefDict, prefPlistPathInAppDocuments;

#pragma mark -
#pragma mark Method

+ (void)copyEmptyPrefPlistToDocumentsByRecover:(BOOL)recover {
	// Define File Path
	NSString *userInformationPlistPathInAppBundle = [[NSBundle mainBundle] pathForResource:kPrefPlistFileName ofType:@"plist"];
	NSString *userInformationPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", kPrefPlistFileName]];
	// Copy plist file
	if (recover) {
		[[NSFileManager defaultManager] removeItemAtPath:userInformationPlistPathInAppDocuments error:nil];
		[[NSFileManager defaultManager] copyItemAtPath:userInformationPlistPathInAppBundle toPath:userInformationPlistPathInAppDocuments error:nil];
	} else if (![[NSFileManager defaultManager] fileExistsAtPath:userInformationPlistPathInAppDocuments]) {
		[[NSFileManager defaultManager] copyItemAtPath:userInformationPlistPathInAppBundle toPath:userInformationPlistPathInAppDocuments error:nil];
	}
}

+ (id)readPrefByKey:(NSString *)key {
	PrefAccess *tmp = [[[PrefAccess alloc] init] autorelease];
	return [tmp.prefDict objectForKey:key];
}

+ (void)writePrefByKey:(NSString *)key andObject:(id)object {
	PrefAccess *tmp = [[[PrefAccess alloc] init] autorelease];
	[tmp.prefDict setObject:object forKey:key];
	[tmp.prefDict writeToFile:tmp.prefPlistPathInAppDocuments atomically:NO];
}

#pragma mark -
#pragma mark Lifecycle

- (id)init {
	if (self = [super init]) {
		prefPlistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", kPrefPlistFileName]];
		prefDict = [[NSMutableDictionary alloc] initWithContentsOfFile:prefPlistPathInAppDocuments];
	}
	return self;
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	[super dealloc];
	[prefDict release];
}

@end
