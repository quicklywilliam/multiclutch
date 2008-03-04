//
//  BindingsController.h
//  AirKeys
//
//  Model controller for the bindings dictionary (of app binding dictionaries).
//  Copyright 2008 Wonderboots. Reasonable rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BindingsController : NSObject {
	NSMutableDictionary *theBindings;
	NSString *selectedApplication;
	NSString *version;
	NSString *donateHidden;
}
-(void)validateBindingsAndSaveForCurrentApplication;
-(void)loadKeyBindingsFile;
-(void)saveBindings;
-(NSString *) donateHidden;
-(void) setDonateHidden:(NSString *)value;	
-(void) addNewAppBindings:(NSString *) appName;

@property(assign) NSMutableDictionary *theBindings;
@property (assign) 	NSString *selectedApplication;
@property (assign) 	NSString * donateHidden;
@property (readonly) 	NSString *version;
@end
