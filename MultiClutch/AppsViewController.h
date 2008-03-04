//
//  AppsDictController.h
//  MultiClutch
//
//delegate for app tableview
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AppsViewController : NSObject { 
	IBOutlet NSButton *removeButton;
	IBOutlet NSDictionaryController *AppDictController;
}
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification;
@end
