//
//  SubmitRootViewController.h
//  MGOV
//
//  Created by iphone on 2010/8/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SubmitRootViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{

	NSMutableArray *eventsArray;
	
}

@property (nonatomic, retain) NSMutableArray *eventsArray;


-(void) addEvent:(UIImage *)image;

@end
