/********* IDnowPlugin Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
@import IDNowSDKCore;

/********* IDnowPlugin.h Intefrace *******/

// The transaction token that should be used for a photo identification
static NSString *TRANSACTION_TOKEN_PHOTO_IDENT = nil;

// Your company id provided by IDnow
static NSString *COMPANY_ID_PHOTO_IDENT = nil;

BOOL SHOW_ERROR_SUCCESS_SCREEN = true;

NSTimer *keepAliveTimer;

@interface IDnowPlugin : CDVPlugin {
    // Member variables go here.
}

@property (strong, nonatomic) IDnowController *idnowController;

//- (void)initIDNow:(CDVInvokedUrlCommand*)command;

- (void)startPhotoIdent:(CDVInvokedUrlCommand*)command;

@end
/********* IDnowPlugin.m Implementation *******/
@implementation IDnowPlugin



- (void)startPhotoIdent:(CDVInvokedUrlCommand*)command {
    
    globalCommand = command;
    [IDNowSDK.shared startWithToken:@"TND-PLMSE" preferredLanguage:@"en" fromViewController:self listener:idnowResultListener];

}
void (^idnowResultListener)(enum IdentResult identResult, NSString * _Nonnull) = ^(enum IdentResult result, NSString* message) {
      NSLog( @"SDK finished");

      if (result == IdentResultERROR) {
          // show result in debug log
          CDVPluginResult* pluginResult = nil;
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Some error occured"];
          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      }

      if( result == IdentResultFINISHED ) {
          // show result in debug log
          CDVPluginResult* pluginResult = nil;
          pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Identification Finished"];
          [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
      }
  };

@end
