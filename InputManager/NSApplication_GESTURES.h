//
//  NSApplication_GESTURES.h
//  MultiClutch InputManager
//
//  Created by William Henderson on 2/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//  Multiclutch is made available for use under the BSD license.
//

#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import "GestureShortcutsController.h"

@interface NSApplication (GESTURES)
-(void)swizzledGestureEvent:(NSEvent *)anEvent;
@end
