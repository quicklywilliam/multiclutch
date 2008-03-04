//
//  KeyboardShortCut.m
//  AirKeysInputManager
//
//  Created by William Henderson on 2/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import "KeyboardShortcut.h"


@implementation KeyboardShortcut
+(id)initWithCharacter:(NSString *)character andModifiers:(unsigned int) modifiers {
	self = [super init];
	modifiers = modifiers;
	character = character;
	return self;
}
@end
