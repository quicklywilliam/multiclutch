//
//  KeyboardShortCut.h
//  AirKeysInputManager
//
//  Created by William Henderson on 2/11/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface KeyboardShortcut : NSObject {
	NSString * character;
	unsigned int modifiers;
}
+(id)initWithCharacter:(NSString *)character andModifiers:(unsigned int) modifiers;
@end
//a simple object for storing keyboard shortcuts
