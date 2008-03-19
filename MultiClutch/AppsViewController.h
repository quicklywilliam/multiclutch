//
//  AppsDictController.h
//  MultiClutch
//
//delegate for app tableview
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//  Multiclutch is made available for use under the BSD license.
//

#import <Cocoa/Cocoa.h>


@interface AppsViewController : NSObject { 
	IBOutlet NSButton *removeButton;
	IBOutlet NSDictionaryController *AppDictController;
}
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
@end
