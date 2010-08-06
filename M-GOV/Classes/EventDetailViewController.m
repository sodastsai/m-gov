//
//  MapViewController.h
//  Locations
//
//  Created by Eric Liou on 8/2/10.
//  Copyright 2010 SAS. All rights reserved.
//


#import "EventDetailViewController.h"
#import "Event.h"
#import "Photo.h"
#import "MapViewController.h"
#import "SubmitViewController.h"

@implementation EventDetailViewController

@synthesize event, timeLabel, coordinatesLabel, deletePhotoButton, photoImageView, mapPush, controlBar;


#pragma mark -
#pragma mark Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	mapPush = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(pushMap)];
	mapPush.enabled = YES;
    self.navigationItem.rightBarButtonItem = mapPush;
	
	// A date formatter for the creation date.
    static NSDateFormatter *dateFormatter = nil;
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	}
	
	static NSNumberFormatter *numberFormatter;
	if (numberFormatter == nil) {
		numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
		[numberFormatter setMaximumFractionDigits:3];
	}
	
	timeLabel.text = [dateFormatter stringFromDate:[event creationDate]];
	
	NSString *coordinatesString = [[NSString alloc] initWithFormat:@"%@, %@",
								   [numberFormatter stringFromNumber:[event latitude]],
								   [numberFormatter stringFromNumber:[event longitude]]];
	coordinatesLabel.text = coordinatesString;
	[coordinatesString release];
		
	UIImage *image = event.photo.image;
	photoImageView.image = image;
	
	[self updatePhotoInfo];
}


- (void)viewDidUnload {
	
	self.timeLabel = nil;
	self.coordinatesLabel = nil;
	self.deletePhotoButton = nil;
	self.photoImageView = nil;
}


#pragma mark -
#pragma mark Editing the photo

- (IBAction)deletePhoto {
	
	/*
	 If the event already has a photo, delete the Photo object and dispose of the thumbnail.
	 Because the relationship was modeled in both directions, the event's relationship to the photo will automatically be set to nil.
	 */
	
	NSManagedObjectContext *context = event.managedObjectContext;
	[context deleteObject:event.photo];
	event.thumbnail = nil;
	
	// Commit the change.
	NSError *error = nil;
	if (![event.managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	// Update the user interface appropriately.
	[self updatePhotoInfo];
}


- (IBAction)choosePhoto {
	
	// Show an image picker to allow the user to choose a new photo.
	
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}



- (void)updatePhotoInfo {
	
	// Synchronize the photo image view and the text on the photo button with the event's photo.
	UIImage *image = event.photo.image;
	
	photoImageView.image = image;
	if (image) {
		deletePhotoButton.enabled = YES;
	}
	else {
		deletePhotoButton.enabled = NO;
	}
}


#pragma mark -
#pragma mark Image picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	NSManagedObjectContext *context = event.managedObjectContext;
	
	// If the event already has a photo, delete it.
	if (event.photo) {
		[context deleteObject:event.photo];
	}
	
	// Create a new photo object and set the image.
	Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
	photo.image = selectedImage;
	
	// Associate the photo object with the event.
	event.photo = photo;	
	
	// Create a thumbnail version of the image for the event object.
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 44.0 / size.width;
	}
	else {
		ratio = 44.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	event.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Commit the change.
	NSError *error = nil;
	if (![event.managedObjectContext save:&error]) {
		// Handle the error.
	}
	
	// Update the user interface appropriately.
	[self updatePhotoInfo];
	
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	// The user canceled -- simply dismiss the image picker.
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction)pushSubmit
{
	SubmitViewController *submitView = [[SubmitViewController alloc] initWithNibName:@"SubmitViewController" bundle:nil];
	[self.navigationController pushViewController:submitView animated:YES];
	[submitView release];
}

-(void)pushMap
{
	MapViewController *mapView = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
	[self.navigationController pushViewController:mapView animated:YES];
	[mapView release];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
	[event release];
	[timeLabel release];
	[coordinatesLabel release];
	[deletePhotoButton release];
	[photoImageView release];
	
    [super dealloc];
}


@end