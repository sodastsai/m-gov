//
//  SubmitRootViewController.m
//  MGOV
//
//  Created by iphone on 2010/8/11.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SubmitRootViewController.h"
#import "Photo.h"

@implementation SubmitRootViewController

@synthesize eventsArray, locationManager;
@synthesize managedObjectContext;

#pragma mark -
#pragma mark View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Configure the edit button
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;
	
	// Configure the photo button
	UIBarButtonItem *photoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePhoto)];
	photoButton.enabled = YES;
	self.navigationItem.rightBarButtonItem = photoButton;
	
	
	// Start to get the user's location.
	[[self locationManager] startUpdatingLocation];	
	
	
	//Fetch the existing photo
	// Create a fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:managedObjectContext];
	[request setEntity:entity];

	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	[self setEventsArray:mutableFetchResults];
	[mutableFetchResults release];
	[request release];
	
	
	
	
	// Use Google API to transform Latitude & Longitude to the corresponding address  
	NSURL *url = [[NSURL alloc] initWithString:@"http://maps.google.com/maps/api/geocode/json?latlng=25.047924,121.517081&sensor=true&language=zh-TW"];
	NSString *str = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"%@", str);
	
	[url release];
	[str release];
}


-(void) takePhoto {
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	}
	else {
		picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	}
	[self presentModalViewController:picker animated:YES];
	[picker release];
	
}

- (void)addEvent:(UIImage *)image {
	
	Photo *tempPhoto = (Photo *)[NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:managedObjectContext];

	/*
	// Create the icon on TableView
	CGSize size = image.size;	
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 44.0 / size.width;
	}
	else {
		ratio = 44.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];
	image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	*/
	
	tempPhoto.image = image;
	
	// Get latitude & longitude
	CLLocation *location = [locationManager location];
	if (!location) {
		return;
	}
	CLLocationCoordinate2D coordinate = [location coordinate];
	[tempPhoto setLatitude:[NSNumber numberWithDouble:coordinate.latitude]];
	[tempPhoto setLongitude:[NSNumber numberWithDouble:coordinate.longitude]];
	//NSLog(@"%f, %f", coordinate.latitude, coordinate.longitude);
	
	MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc] initWithCoordinate:coordinate];
	[geocoder start];
	
	[geocoder release];
	
	// Should be timestamp, but this will be constant for simulator.
	// [event setCreationDate:[location timestamp]];
	[tempPhoto setCreationDate:[NSDate date]];
	
	
	// Commit the change.
	NSError *error = nil;
	if (![managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	
	[eventsArray insertObject:tempPhoto atIndex:0];
	
	[self.tableView reloadData];
	[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
	
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.tableView reloadData];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/



#pragma mark -
#pragma mark Photo Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	
	UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
	[picker dismissModalViewControllerAnimated:YES];
	[self addEvent:image];
	
}





#pragma mark -
#pragma mark Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [eventsArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...

    Photo *tempPhoto = [eventsArray objectAtIndex:indexPath.row];
	//UIImage *tempImage = [eventsArray objectAtIndex:indexPath.row];
	
	// Transform the NSDate to StringStyle & fill the table text.
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	cell.textLabel.text = [dateFormatter stringFromDate:tempPhoto.creationDate];
	
	
	// Transform the Latitude&Longitude to address, then fill in the table text.
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%f %f" , [tempPhoto.latitude doubleValue], [tempPhoto.longitude doubleValue]];
	
	// Fill the table icon.
	cell.imageView.image = tempPhoto.image;
	
	[dateFormatter release];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (editingStyle == UITableViewCellEditingStyleDelete) {
	
		// Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [eventsArray objectAtIndex:indexPath.row];
		[managedObjectContext deleteObject:eventToDelete];
		// Commit the change.
		NSError *error = nil;
		if (![managedObjectContext save:&error]) {
			// Handle the error.
		}
		//[eventToDelete release];
		
		// Delete the element in the array and table view.
        [eventsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		
    }  
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    } 
	
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}




#pragma mark -
#pragma mark Location manager

/**
 Return a location manager -- create one if necessary.
 */
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];
	
	return locationManager;
}






#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[locationManager release];
	[managedObjectContext release];
	[eventsArray release];
    [super dealloc];
}






@end

