//
//  BindingViewsController.h
//  MultiClutch
//
//  Controller for our bindings views.  A delegate for the main window.
//  Copyright 2008 Wonderboots. Reasonable rights reserved.  
//  Multiclutch is made available for use under the BSD license.
//

#import <Cocoa/Cocoa.h>
#import "KeyShortcutsFieldEditor.h"
#import "BindingsController.h"
#import "InputManagerInstaller.h"

@interface WindowController : NSObject {
	KeyShortcutsFieldEditor *fieldEditor;
	BindingsController *bindings;
	IBOutlet NSDictionaryController *AppDictController;
	IBOutlet NSDictionaryController *BindingsDictController;
	IBOutlet NSWindow *installPromptWindow;
	IBOutlet NSButton *donateButton;
	
}
-(IBAction)dontInstallInputManager:(id) sender;
-(IBAction)installInputManager:(id) sender;
-(IBAction) chooseNewApp:(id)sender;
-(IBAction)visitDonateLink:(id) sender;

-(id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)anObject;
-(void)setSelectedApplication;
@end
