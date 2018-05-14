#import "MyCordovaPlugin.h"
#import "PrinterSDK.h"

#import <Cordova/CDVAvailability.h>

@implementation MyCordovaPlugin

- (void)pluginInitialize {
}

- (void)echo:(CDVInvokedUrlCommand *)command {
  NSString* phrase = [command.arguments objectAtIndex:0];
  NSLog(@"%@", phrase);
    
//    __block NSMutableArray *_printerArray = [[NSMutableArray alloc] init];
//
//    [[PrinterSDK defaultPrinterSDK] scanPrintersWithCompletion:^(Printer *printer) {
//                [_printerArray addObject:printer];
//                NSLog(@"%@",_printerArray);
//    }];

    [[PrinterSDK defaultPrinterSDK] scanPrintersWithCompletion:^(Printer* printer)
    {
        if (nil == _printerArray){
         _printerArray = [[NSMutableArray alloc] initWithCapacity:1];
        }
        [_printerArray addObject:printer];
        if (_printerArray != nil && [_printerArray count] > 0) {
            [[PrinterSDK defaultPrinterSDK] connectBT:printer];
            double delayInSeconds = 5.0f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[PrinterSDK defaultPrinterSDK] printTestPaper];
                NSLog(@"%@",printer.name);
                NSLog(@"%@",printer.UUIDString);
            });
        }
    }];
    NSLog(@"%@", _printerArray);
    
//    if (_printerArray != nil && [_printerArray count] > 1) {
//        for(Printer* prt in _printerArray){
//            NSLog(@"%@",prt.name);
//            NSLog(@"%@",prt.UUIDString);
//        }
//        NSLog(@"%@", @"have printers");
//        Printer* printer1 = [_printerArray objectAtIndex:1];
//        [[PrinterSDK defaultPrinterSDK] connectBT:printer1];
//        //[[PrinterSDK defaultPrinterSDK] printTestPaper];
//        //[[PrinterSDK defaultPrinterSDK] printText:@"123456789"];
//        //[[PrinterSDK defaultPrinterSDK] selfTest];
//        //[[PrinterSDK defaultPrinterSDK] beep];
//        double delayInSeconds = 1.0f;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
//       {
//           [[PrinterSDK defaultPrinterSDK] beep];
//       });
//    }
}

- (void)getDate:(CDVInvokedUrlCommand *)command {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
  [dateFormatter setLocale:enUSPOSIXLocale];
  [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];

  NSDate *now = [NSDate date];
  NSString *iso8601String = [dateFormatter stringFromDate:now];

  CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:iso8601String];
  [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

@end
