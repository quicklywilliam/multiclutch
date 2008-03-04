//
//  WCHFieldEditor.m
//  AirKeys
//
//  Custom Field Editor for handling keyboard shortcut input
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//

#import "KeyShortcutsFieldEditor.h"


@implementation KeyShortcutsFieldEditor
-(BOOL)performKeyEquivalent:(NSEvent *)theEvent {
	NSString * theKeyCodes = [NSString stringWithFormat:@"%i",[theEvent keyCode]];

	if([theEvent modifierFlags] & NSCommandKeyMask) {//note reverse order from when they are unpacked by the IM
		theKeyCodes = [@"55," stringByAppendingString:theKeyCodes];
	}
	if([theEvent modifierFlags] & NSShiftKeyMask) {
		theKeyCodes = [@"56," stringByAppendingString:theKeyCodes];
	}
	if([theEvent modifierFlags] & NSAlternateKeyMask) {
		theKeyCodes = [@"58," stringByAppendingString:theKeyCodes];
	}
	if([theEvent modifierFlags] & NSControlKeyMask) {
		theKeyCodes = [@"59," stringByAppendingString:theKeyCodes];
	}
	[self selectAll:self]; //just incase, so we don't get wierd things like ⌘⌘mh if they try to insert in the middle.
	[self insertText:theKeyCodes];
	[[NSApp mainWindow] endEditingFor:self];
	return YES;
}
- (void)keyDown:(NSEvent *)theEvent{
	NSBeep();
}
@end
