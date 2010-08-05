//
//  TempView.m
//  StreetFix
//
//  Created by Eric Liou on 7/28/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import "CameraView.h"

@implementation CameraView

@synthesize doneButtonPressed, photos, arr1;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void)viewDidLoad {
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	[super viewDidLoad];
	
	/*
	 Update UI by inserting 2 new buttons on the nav bar
	 */
	UIBarButtonItem *camera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
																			target:self
																			action:@selector(takePhoto)];
	UIBarButtonItem *add = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
																		 target:self 
																		 action:@selector(temp)];	
	self.navigationItem.rightBarButtonItem = camera;
	self.navigationItem.leftBarButtonItem = add;
	[camera release];
	[add release];
	
	
}

-(void)takePhoto
{
	NSLog(@"hi");
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"];
	UIImage *image = picker.image; // imageView is my image from camera
	NSData *imageData = UIImagePNGRepresentation(image);
	[imageData writeToFile:savedImagePath atomically:NO]; 
	//[self presentModalViewController:picker animated:YES];
}

-(void)temp{
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


- (void)dealloc {
    [super dealloc];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSMutableDictionary *)info
{
	arr1 = [NSArray arrayWithObjects:@"1", nil];
	photos = [[NSMutableDictionary alloc] initWithObjectsAndKeys:arr1, @"temp", nil];
	
	NSLog(@"%@",[info keyEnumerator]);
	[picker dismissModalViewControllerAnimated:YES];
	UIImageView *image = [info objectForKey:[info keyEnumerator]];
	[photos setObject:image forKey:@"PhotoLibrary"];
}

	
@end
