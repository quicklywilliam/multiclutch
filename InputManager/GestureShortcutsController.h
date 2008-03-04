//
//  GestureShortcutsController.h
//  AirKeysInputManager
//
//  Created by William Henderson on 2/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ExtendedGesturePoint : NSObject {
	NSString * type;//zoom,magnify
	float amount;
}
	@property (assign) NSString * type;
	@property (assign) float amount;
@end
//a simple object for storing info about a gesture point in a continuous gesture

@interface GestureShortcutsController : NSObject {
	NSDictionary *Bindings;
	NSMutableArray *extendedGesturePoints;
}
+(id)sharedGestureShortcutsController;
-(void)loadKeyBindingsFile;
-(void) reloadBindingsFile;
-(NSString *)getFrontmostAppBindingForGesture:(NSString *) gestureName;
-(BOOL)doesFrontmostAppSupportGestureOfType:(NSString *) type;
-(BOOL)executeSwipe:(NSString *) gestureName inDirection:(NSString *) direction;
-(BOOL)endExtendedGesture;
-(BOOL)addGesturePoint:(ExtendedGesturePoint *) gesturePoint;
-(void)performShortcutForBinding:(NSString *)theBinding;
@end
