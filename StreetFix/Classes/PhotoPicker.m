//
//  PhotoPicker.m
//  StreetFix
//
//  Created by Eric Liou on 7/29/10.
//  Copyright 2010 SAS. All rights reserved.
//

#import "PhotoPicker.h"


@implementation PhotoPicker

@synthesize pick;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	
	//cell.detailTextLabel.text = [[picture pictureOwner] personName];
	//cell.textLabel.text = [picture pictureTitle];
	//cell.imageView.image = [UIImage imageWithData:[picture pictureThumbData]];
	
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	Picture *picture = (Picture *)[frc objectAtIndexPath:indexPath];
	
	// create a new PhotoDetailViewController, set some properties and add it to the stack
	PhotoDetailViewController *photoDetailViewController = [[PhotoDetailViewController alloc] init];
	photoDetailViewController.selectedPhoto = [UIImage imageWithData:[picture pictureImageData]];
	photoDetailViewController.selectedTitle = picture.pictureTitle;
	
	// the nav controller will manage the retain count of PhotoListViewController so we can release it
	[self.navigationController pushViewController:photoDetailViewController animated:YES];
	[photoDetailViewController release];
	
}*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	UIImagePickerController * picker2 = [[UIImagePickerController alloc] init];
	[self presentModalViewController:picker2 animated:YES ];
	[picker2 release];
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
    
}


- (void)dealloc {
    [super dealloc];
}


@end
