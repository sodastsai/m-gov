//
//  CaseAddViewController.m
//  MGOV
//
//  Created by iphone on 2010/8/24.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseAddViewController.h"


@implementation CaseAddViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:@"送出" style:UIBarButtonItemStylePlain target:self action:@selector(submitCase)];
	self.navigationItem.rightBarButtonItem = submitButton;
	[submitButton release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL) submitCase {
	
	NSLog(@"True");
	return TRUE;
	
}


- (void)dealloc {
    [super dealloc];
}


@end
