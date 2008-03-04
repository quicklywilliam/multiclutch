//
//  AppsDictController.m
//  MultiClutch
//
//delegate for app tableview
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//

#import "AppsViewController.h"


@implementation AppsViewController
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
	if([[[[AppDictController selectedObjects] objectAtIndex:0] key] isEqualToString:@"Global"])
		[removeButton setEnabled:NO];
	else
		[removeButton setEnabled:YES];
}
@end
