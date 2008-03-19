//
//  BindingViewsController.m
//  MultiClutch
//
//  Controller for our bindings views.  A delegate for the main window.
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//  Multiclutch is made available for use under the BSD license.
//

#import "WindowController.h"


@implementation WindowController
#define SelectionContext @"SelectionContext"


-(void) awakeFromNib {
	[[NSApp mainWindow] setDelegate:self]; //set the system prefs window delegate, not the prefpane window! (needed for custom field editor)
	//init the bindings, load in the prefs
	bindings = [[BindingsController alloc] init];

	//first check to see if we need to do an install prompt.
	if(![NSApp respondsToSelector:@selector(swizzledGestureEvent:)] || !([bindings.version isEqualToString:@"b4"])) {//indicates whether the input manager was loaded or not
		
		//display a dialog prompting the user to install the input manager
		[NSApp beginSheet:installPromptWindow modalForWindow:[NSApp mainWindow]
			modalDelegate:self didEndSelector:NULL contextInfo:nil];
		
	}	
	
	if([bindings.donateHidden isEqualToString:@"YES"]) {
		[donateButton setHidden:YES];
	}
	
	//setup our model controler and bind the dictionarycontrollers
	//we want to handle changes to the selected application manually, so observe them
	[AppDictController bind:NSContentDictionaryBinding toObject:self withKeyPath:@"bindings.theBindings" options:nil];
	[AppDictController addObserver:self forKeyPath:@"selection"
						   options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
						   context:SelectionContext];
	[BindingsDictController setInitialKey:@"Swipe Left"];
	[BindingsDictController setInitialValue:@"55,4"];
	[self setSelectedApplication];
	
	//make sure the model controller saves before closing the pref pane
	[[NSNotificationCenter defaultCenter] addObserver: bindings
											 selector: @selector(saveBindings)
												 name: @"paneWillUnselect" object:NSApp];
	[[NSNotificationCenter defaultCenter] addObserver: bindings
											 selector: @selector(saveBindings)
												 name: @"paneWillUnselect" object:NSApp];
	
	//initialize our custom field editor
	fieldEditor = [[KeyShortcutsFieldEditor alloc] init];
    [fieldEditor setEditable:YES];
    [fieldEditor setFieldEditor:YES];
	[fieldEditor setSelectable:YES];
}
-(IBAction)visitDonateLink:(id) sender{
	[donateButton setHidden:YES];
	[bindings setDonateHidden:@"YES"];
	[[NSWorkspace sharedWorkspace] openURL: [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=william%2ec%2ehenderson%40gmail%2ecom&item_name=MultiClutch&no_shipping=1&cn=Message%20to%20Developer&tax=0&currency_code=USD&lc=US&bn=PP%2dDonationsBF&charset=UTF%2d8"]];
}

-(IBAction)dontInstallInputManager:(id) sender {
	[installPromptWindow orderOut:nil];
	[NSApp endSheet:installPromptWindow];
	[NSApp terminate:self];
}
-(IBAction)installInputManager:(id) sender {
	[installPromptWindow orderOut:nil];
	[NSApp endSheet:installPromptWindow];
	InputManagerInstaller *imInstaller = [[InputManagerInstaller alloc] init];
	[imInstaller installInputManager];
}

-(void) dealloc {
	[fieldEditor release];
	[bindings release];
	[super dealloc];
}

-(void)setSelectedApplication {
	NSString * applicationName = [[[AppDictController selectedObjects] objectAtIndex:0] key];
	[BindingsDictController bind:NSContentDictionaryBinding toObject:bindings 
					 withKeyPath:[@"theBindings." stringByAppendingString:applicationName] options:nil];
	[bindings setSelectedApplication:applicationName];

	//now that we've selected the new app and bound it, watch it for changes by the nsdictionarycontroller.
	[bindings addObserver:bindings forKeyPath:[@"theBindings." stringByAppendingString:applicationName]
								options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
								context:nil];
}

-(IBAction) chooseNewApp:(id)sender{
	NSOpenPanel* appChooseDialog = [NSOpenPanel openPanel];
	
	[appChooseDialog setCanChooseFiles:YES];
	[appChooseDialog setAllowsMultipleSelection:NO];
	if ([appChooseDialog runModalForDirectory:@"/Applications" file:nil types:[NSArray arrayWithObject:@"app"]] == NSOKButton )
	{
		NSString *theAppPath = [[appChooseDialog filenames] objectAtIndex:0];
		[bindings addNewAppBindings:[[theAppPath lastPathComponent] stringByDeletingPathExtension]];
	}
}


-(id)windowWillReturnFieldEditor:(NSWindow *)sender toObject:(id)anObject //use our custom field editor for binding shortcuts
{
    if ([anObject isKindOfClass:[NSTableView class]])
    {
		if([anObject editedColumn] == 1) {//only use it for the rightmost column
				return fieldEditor;
		}
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	if (context == SelectionContext){
		//tell bindings to stop watching the old dictionary before we start watching the new one.
		[bindings removeObserver:bindings forKeyPath:[@"theBindings." stringByAppendingString:[bindings selectedApplication]]];
		[self setSelectedApplication];
	}
}

@end
