//
//  AppsDictController.m
//  MultiClutch
//
//delegate for app tableview
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//  Multiclutch is made available for use under the BSD license.
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
