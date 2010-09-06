//
//  CaseDisplayView.m
//  MGOV
//
//  Created by iphone on 2010/9/3.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "CaseDisplayView.h"


@implementation CaseDisplayView

@synthesize mapView, listView;
@synthesize transitioning;

#pragma mark -
#pragma mark ViewTransition

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}

-(void)performTransition
{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 0.5 of a second
	transition.duration = 0.5;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	transition.type = kCATransitionFade;
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	[self.layer addAnimation:transition forKey:nil];
	
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	if (mapView.hidden) {
		mapView.hidden = NO;
		listView.hidden = YES;
	}
	else {
		mapView.hidden = YES;
		listView.hidden = NO;
	}	
}

-(void)loadCaseData:(NSDictionary *)dict {
	caseData = [NSDictionary dictionaryWithDictionary:dict];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
}


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


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		caseData = [[NSMutableArray alloc] init];
		mapView = [[MKMapView alloc] initWithFrame:frame];
		listView = [[UITableView alloc] initWithFrame:frame];
		[self addSubview:listView];
		[self addSubview:mapView];
		listView.hidden = YES;
		transitioning = NO;
    }
    return self;
}

- (void)dealloc {
	[mapView release];
	[listView release];
	[caseData release];
    [super dealloc];
}


@end
