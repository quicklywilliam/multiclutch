//
//  BindingsController.m
//  MultiClutch
//
//  Created by William Henderson on 2/10/08.
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//  Multiclutch is made available for use under the BSD license.
//

#import "BindingsController.h"


@implementation BindingsController

@synthesize theBindings;
@synthesize selectedApplication;
@synthesize version;

-(id) init{
	self = [super init];
	
	NSDictionary * prefs = [NSDictionary dictionaryWithContentsOfFile: 
							[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.wonderboots.MultiClutchBindings.plist"]];
	NSDictionary * bindings = [prefs valueForKey:@"bindings"];
	if(bindings == nil)
	{
		NSLog(@"[MultiClutch] Default Bindings Not Found!");		
	}
	else {
	}
	version = [[prefs valueForKey:@"version"] retain];
	if(([prefs valueForKey:@"donateHidden"] == nil) || [[prefs valueForKey:@"donateHidden"] isEqualToString:@"NO"]) {
		donateHidden = @"NO";
	}
	else {
		donateHidden = @"YES";
	}
	theBindings = [bindings mutableCopy];
	return self;
}
- (void) dealloc
{
	[theBindings release];
	[selectedApplication release];
	[super dealloc];
}
-(NSString *) donateHidden {
	return donateHidden;
}
-(void) setDonateHidden:(NSString *)value {
	[donateHidden autorelease];
	donateHidden = [value retain];
	[self saveBindings];
}
-(void) addNewAppBindings:(NSString *) appName {
	NSMutableDictionary *theAppBindings = [[NSMutableDictionary alloc] init];	
	//we need to send notifications manually so the view updates
	[self willChangeValueForKey:@"theBindings"];
	[[self valueForKey:@"theBindings"] setValue:theAppBindings forKey:appName];
	[self didChangeValueForKey:@"theBindings"];
	[theAppBindings release];
}

-(void)saveBindings {
//	NSLog(@"[MultiClutch] Saving prefs...");
	[[NSDictionary dictionaryWithObjectsAndKeys:theBindings, @"bindings", version, @"version", donateHidden, @"donateHidden",nil] 
	 writeToFile: [NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/com.wonderboots.MultiClutchBindings.plist"] 
				  atomically: YES];
	
	//send notice for the input manager
	[[NSDistributedNotificationCenter defaultCenter] postNotificationName: @"bindingsDidChange"
						  object: @"net.wonderboots.multiclutchinputmanager"
						userInfo: nil
			  deliverImmediately: YES];
	
}

-(void)validateBindingsAndSaveForCurrentApplication {
	//**sigh**.  we have to suspend KVO to prevent an infinite loop here
	[self removeObserver:self forKeyPath:[@"theBindings." stringByAppendingString:selectedApplication]];
	
	NSMutableDictionary *appBindings = [[theBindings objectForKey:selectedApplication] mutableCopy];
	NSString* rotateEnabled = @"false";
	NSString* zoomEnabled = @"false";
	
	for (id key in appBindings) {
		if([key hasPrefix:@"Zoom"])
			zoomEnabled = @"true";
		else if([key hasPrefix:@"Rotate"])
			rotateEnabled = @"true";
	}
	[appBindings setObject:zoomEnabled forKey:@"Supports_Zoom"];
	[appBindings setObject:rotateEnabled forKey:@"Supports_Rotate"];
	
	[theBindings setObject:appBindings forKey:selectedApplication];
	[self saveBindings];
	
	[self addObserver:self forKeyPath:[@"theBindings." stringByAppendingString:selectedApplication]
				  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
				  context:nil];	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	[self validateBindingsAndSaveForCurrentApplication];
}


@end
