//
//  GestureShortcutsController.m
//  MultiClutchInputManager
//
//  Created by William Henderson on 2/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "GestureShortcutsController.h"
#import "KeyboardShortcut.h"

@implementation ExtendedGesturePoint
	@synthesize type;
	@synthesize amount;
@end

@implementation GestureShortcutsController
+ (id)sharedGestureShortcutsController {
    static GestureShortcutsController *sharedInstance = nil;
    if (!sharedInstance) {
        sharedInstance = [[GestureShortcutsController alloc] init];
    }
    return sharedInstance;	
}
-(id) init {
	self = [super init];
	[self loadKeyBindingsFile];
	[[NSDistributedNotificationCenter defaultCenter] addObserver: self
														selector: @selector(reloadBindingsFile)
															name: @"bindingsDidChange"
														  object: @"net.wonderboots.multiclutchinputmanager"];	
	return self;
}
- (void)dealloc {
    [super dealloc];
	[Bindings release];
}
-(void) reloadBindingsFile {
	[Bindings autorelease];
	[self loadKeyBindingsFile];
}

-(void) loadKeyBindingsFile {
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile: 
			   [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.wonderboots.MultiClutchBindings.plist"]];
	Bindings = [[prefs  valueForKey:@"bindings"] retain];
	if(Bindings == nil || ([prefs valueForKey:@"version"] == nil))
	{
		NSMutableDictionary *tempPrefs = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *tempBindings = [[NSMutableDictionary alloc] init];
		NSMutableDictionary *textEditBindings = [[NSMutableDictionary alloc] init];
		[tempBindings setObject:textEditBindings forKey:@"Global"];
		[tempPrefs setObject:@"b3" forKey:@"version"];
		[tempPrefs setObject:tempBindings forKey:@"bindings"];
		[tempPrefs writeToFile: [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.wonderboots.MultiClutchBindings.plist"] 
					   atomically: YES];
		Bindings = [tempBindings copy];
		NSLog(@"[MultiClutch] Made new Default Preferences");		
	}
	else {
//		NSLog(@"[MultiClutch] Loaded Key Bindings");

	}
	
}

-(BOOL)executeSwipe:(NSString *) gestureName inDirection:(NSString *) direction{//up,down,left,right
//	NSLog(@"[MultiClutch] Pulling a Swipe!");
	NSString* theBinding = [self getFrontmostAppBindingForGesture:[[gestureName stringByAppendingString:@" "] stringByAppendingString:direction]];
	if(theBinding != nil) {
		[self performShortcutForBinding:theBinding];
		return YES;
	}
	else {
		return NO;
	}
}

-(NSString *)getFrontmostAppBindingForGesture:(NSString *) gestureName{
	NSString * frontmostApp = [[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationName"];
	NSString * theBinding = [[Bindings objectForKey:frontmostApp] objectForKey:gestureName];
	if(theBinding == nil) {
		theBinding = [[Bindings objectForKey:@"Global"] objectForKey:gestureName];
	}
	NSLog(theBinding);
	return theBinding;
}
-(BOOL)doesFrontmostAppSupportGestureOfType:(NSString *) type {
	NSString * frontmostApp = [[[NSWorkspace sharedWorkspace] activeApplication] objectForKey:@"NSApplicationName"];
	if([[[Bindings objectForKey:frontmostApp] objectForKey:[@"Supports_" stringByAppendingString:type]] isEqualToString:@"true"]){
		return YES;
	}
	if([[[Bindings objectForKey:@"Global"] objectForKey:[@"Supports_" stringByAppendingString:type]] isEqualToString:@"true"]) {
		return YES;
	}
	return NO;
}

-(BOOL)addGesturePoint:(ExtendedGesturePoint *) gesturePoint {
	if([self doesFrontmostAppSupportGestureOfType:gesturePoint.type]) {
		if(extendedGesturePoints == nil){
			extendedGesturePoints = [[NSMutableArray alloc] init];
		}
		[extendedGesturePoints addObject:gesturePoint];
		return YES;
	}
	else {
		return NO;
	}
}
-(BOOL)endExtendedGesture {
	if((extendedGesturePoints == nil) || ([extendedGesturePoints count] == 0))
		return NO;
	
	int zoomCount = 0;
	int zoomDir1 = -1; //0 is in, 1 is out
	int zoomDir2 = -1;
	int rotateCount = 0;
	float rotateSum = 0;
	for(ExtendedGesturePoint *gesturePoint in extendedGesturePoints) {
		if([gesturePoint.type isEqualToString:@"Zoom"]) {
			zoomCount++;
			if(gesturePoint.amount >= 1) { //notice we are ignoring values in (-1,1)
				if(zoomDir1 == 0) {
					zoomDir2 = 1;
				}
				else {
					zoomDir1 = 1;
				}
			}
			else if(gesturePoint.amount <= -1) {
				if(zoomDir1 == 1) {
					zoomDir2 = 0;
				}
				else {
					zoomDir1 = 0;
				}
			}
		}
		else if([gesturePoint.type isEqualToString:@"Rotate"]) {
			rotateCount++;
			rotateSum += gesturePoint.amount;
		}
    }
	
	NSString* theGesture = [[NSMutableArray alloc] init];
	if(zoomCount > rotateCount) {
		if((zoomDir1 == 1) && (zoomDir2 == -1)){
			theGesture = @"Zoom In";

		}
		else if((zoomDir1 == 0) && (zoomDir2 == -1)) {
			theGesture = @"Zoom Out";
		}
		else if((zoomDir1 == 1) && (zoomDir2 == 0)) {
			theGesture = @"Zoom In, Zoom Out";
		}
		else if((zoomDir1 == 0) && (zoomDir2 == 1)){
			theGesture = @"Zoom Out, Zoom In";
		}

	}
	else {
		if(rotateSum <= 0)
			theGesture = @"Rotate Right";
		else
			theGesture = @"Rotate Left";
	}
	
	NSString* theBinding = [self getFrontmostAppBindingForGesture:theGesture];
	if(theBinding != nil) {
		[self performShortcutForBinding:theBinding];
	}
	
	[extendedGesturePoints release];
	extendedGesturePoints = nil;
	return YES;
}
//-(void)beginExtendedGesture{
//}	
-(void)performShortcutForBinding:(NSString *)theBinding{	
	BOOL controlKeyDidPress = NO;
	BOOL optionKeyDidPress = NO;
	BOOL shiftKeyDidPress = NO;
	BOOL commandKeyDidPress = NO;
	
	if([[theBinding substringToIndex:2] isEqualToString:@"59"]) {
		NSLog(@"control");
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)59, true );
		controlKeyDidPress = YES;
		theBinding = [theBinding substringFromIndex:3];
	}
	if([[theBinding substringToIndex:2] isEqualToString:@"58"]) {
		NSLog(@"option");
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)58, true );
		optionKeyDidPress = YES;
		theBinding = [theBinding substringFromIndex:3];
	}
	if([[theBinding substringToIndex:2] isEqualToString:@"56"]) {
		NSLog(@"shift");
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)56, true );
		shiftKeyDidPress = YES;
		theBinding = [theBinding substringFromIndex:3];
	}
	if([[theBinding substringToIndex:2] isEqualToString:@"55"]) {
		NSLog(@"apple");
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)55, true);
		commandKeyDidPress = YES;
		theBinding = [theBinding substringFromIndex:3];
	}	
	CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)[theBinding intValue], true);
	CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)[theBinding intValue], false);
	if(commandKeyDidPress) {
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)55, false);
	}
	if(shiftKeyDidPress) {
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)56, false);
	}
	if(optionKeyDidPress) {
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)58, false);
	}
	if(controlKeyDidPress) {
		CGPostKeyboardEvent((CGCharCode)0, (CGCharCode)59, false);

	}
	CGEnableEventStateCombining(TRUE);
}
@end
