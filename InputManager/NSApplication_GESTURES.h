//
//  NSApplication_GESTURES.h
//  MultiClutchInputManager
//
//  Created by William Henderson on 2/10/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <objc/runtime.h>
#import "GestureShortcutsController.h"

@interface NSApplication (GESTURES)
-(void)swizzledGestureEvent:(NSEvent *)anEvent;
@end
