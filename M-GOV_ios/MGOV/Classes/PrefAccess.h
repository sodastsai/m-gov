//
//  PrefAccess.h
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPrefPlistFileName @"UserInformation"
#define kPrefPlistFileFullName @"UserInformation.plist"

@interface PrefAccess : NSObject {
	NSMutableDictionary *prefDict;
	NSString *prefPlistPathInAppDocuments;
}

@property (nonatomic, retain) NSMutableDictionary *prefDict;
@property (nonatomic, retain) NSString *prefPlistPathInAppDocuments;

+ (void)copyEmptyPrefPlistToDocumentsByRecover:(BOOL)recover;
+ (id)readPrefByKey:(NSString *)key;
+ (void)writePrefByKey:(NSString *)key andObject:(id)object;

@end
