//
//  FirstTimeViewController.m
//  MGOV
//
//  Created by sodas on 2010/8/25.
//  Copyright 2010 NTU Mobile HCI Lab. All rights reserved.
//

#import "FirstTimeViewController.h"
#import "MyCaseViewController.h"
#import "QueryViewController.h"

@implementation FirstTimeViewController

@synthesize startToUse;

#pragma mark -
#pragma mark Main function

- (IBAction)requestEmail {
	// Alert
	alertEmailInput = [[UIAlertView alloc] initWithTitle:alertRequestEmailTitle message:alertRequestEmailPlaceholder delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
	// Email Text Field
	emailField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
	emailField.delegate = self;
	emailField.borderStyle = UITextBorderStyleRoundedRect;
	emailField.keyboardType = UIKeyboardTypeEmailAddress;
	emailField.returnKeyType = UIReturnKeyDone;
	emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	emailField.placeholder = alertRequestEmailPlaceholder;
	[emailField becomeFirstResponder];
	// Show view
	[alertEmailInput addSubview:emailField];
	[alertEmailInput show];
	// TODO: check if textfield is empty
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	// Call pre-close method
	[self alertView:alertEmailInput clickedButtonAtIndex:1];
	// close the alert
	[alertEmailInput dismissWithClickedButtonIndex:0 animated:YES];
	return NO;
}

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	// Maintain the responder chain
	[emailField removeFromSuperview];
	
	if ([alertView.title isEqualToString:alertRequestEmailTitle]) {
		if (buttonIndex) {
			// Write email to plist
			NSString *plistPathInAppDocuments = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"UserInformation.plist"];
			NSMutableDictionary *dictUserInformation = [NSMutableDictionary dictionaryWithContentsOfFile:plistPathInAppDocuments];
			[dictUserInformation setValue:emailField.text forKey:@"User Email"];
			// Set FirstRun to zero
			[dictUserInformation setValue:0 forKey:@"FirstRun"];
			// Write to File
			[dictUserInformation writeToFile:plistPathInAppDocuments atomically:YES];
			// Change the view
				
				// Main tab
				UITabBarController *tabBarController = [[UITabBarController alloc] init];
				// My Case
				MyCaseViewController *myCase = [[MyCaseViewController alloc] init];
				myCase.title = @"我的案件";
				UINavigationController *myCaseNavigation = [[UINavigationController alloc] initWithRootViewController:myCase];
				// Query
				QueryViewController *query = [[QueryViewController alloc] initWithStyle:UITableViewStyleGrouped];
				query.title = @"查詢";
				UINavigationController *queryNavigation = [[UINavigationController alloc] initWithRootViewController:query];
				// Add tabs and view
				tabBarController.viewControllers = [NSArray arrayWithObjects:myCaseNavigation, queryNavigation, nil];
			//
			[self.view.superview addSubview:tabBarController.view];
			[self.view removeFromSuperview];
			
		} else {
			// User does not enter his email. Close the Alert
		}

	}
}

#pragma mark -
#pragma mark View Lifecycle

- (void)viewDidLoad {
	// TODO: change the fake name to real one.
	alertRequestEmailTitle = @"歡迎使用烏賊車";
	alertRequestEmailPlaceholder = @"請輸入您的E-Mail";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[emailField release];
	[alertEmailInput release];
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}

@end
