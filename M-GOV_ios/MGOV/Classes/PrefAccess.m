/*
 * 
 * PrefAccess.m
 * 2010/10/3
 * sodas
 * 
 * Access Preference plist with simpler method
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

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
	userInformationPlistPathInAppBundle = nil;
	userInformationPlistPathInAppDocuments = nil;
}

+ (id)readPrefByKey:(NSString *)key {
	PrefAccess *tmp = [[[PrefAccess alloc] init] autorelease];
	return [tmp.prefDict objectForKey:key];
}

+ (void)writePrefByKey:(NSString *)key andObject:(id)object {
	PrefAccess *tmp = [[PrefAccess alloc] init];
	[tmp.prefDict setObject:object forKey:key];
	[tmp.prefDict writeToFile:tmp.prefPlistPathInAppDocuments atomically:NO];
	[tmp release];
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
	prefPlistPathInAppDocuments = nil;
	[prefDict release];
	[super dealloc];
}

@end
