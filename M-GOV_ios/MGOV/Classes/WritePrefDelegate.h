//
//  WritePrefDelegate
//  MGOV
//
//  Created by sodas on 2010/10/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WritePrefDelegate

- (void)writeToPrefWithKey:(NSString *)key andObject:(id)value;

@end
