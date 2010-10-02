//
//  PrefViewController.h
//  MGOV
//
//  Created by sodas on 2010/10/2.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDevelopPreview YES
#define kBetaRelease NO
#define kStableRelease NO

// Use NSString
#define kDevelopPreviewVersion @"2"
#define kBetaReleaseVersion @"0"
#define kStableReleaseVersion @"1.0"

@interface PrefViewController : UITableViewController {
	NSMutableDictionary *dictUserInformation;
}

@property (nonatomic, retain) NSMutableDictionary *dictUserInformation;

@end
