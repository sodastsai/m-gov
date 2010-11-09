/*
 * 
 * ListViewController.m
 * 2010/11/09
 * sodas
 * 
 * Patch for Strange behavior about Memory Warning and UITableViewController
 *
 * Copyright 2010 NTU CSIE Mobile & HCI Lab
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "ListViewController.h"

@implementation ListViewController

@synthesize aDelegate;
@synthesize aDataSource;

#pragma mark -
#pragma mark Memory management

- (void)viewDidLoad {
	self.tableView.delegate = aDelegate;
	self.tableView.dataSource = aDataSource;
}

- (void)viewDidUnload {
}

- (void)dealloc {
	[aDelegate release];
	[aDataSource release];
	[super dealloc];
}

@end

