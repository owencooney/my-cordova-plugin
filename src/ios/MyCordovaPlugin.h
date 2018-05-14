#import <Cordova/CDVPlugin.h>

@interface MyCordovaPlugin : CDVPlugin {
	NSMutableArray* _printerArray;
}

// The hooks for our plugin commands
- (void)echo:(CDVInvokedUrlCommand *)command;
- (void)getDate:(CDVInvokedUrlCommand *)command;

@end
