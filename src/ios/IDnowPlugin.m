/********* IDnowPlugin Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
@import IDnowSDK;

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
    
    
    // Set up and customize settings
    self.settings = [IDnowSettings new];
    self.settings.showErrorSuccessScreen = true;
    self.settings.showVideoOverviewCheck = true;
    
    
    COMPANY_ID_PHOTO_IDENT = [globalCommand.arguments objectAtIndex:0];
    TRANSACTION_TOKEN_PHOTO_IDENT = [globalCommand.arguments objectAtIndex:1];
    SHOW_ERROR_SUCCESS_SCREEN = [globalCommand.arguments objectAtIndex:2];
    
    // Setting dummy dev token and company id -> will instantiate a photo identification
    self.settings.transactionToken = TRANSACTION_TOKEN_PHOTO_IDENT;
    self.settings.companyID = COMPANY_ID_PHOTO_IDENT;
    self.settings.showErrorSuccessScreen = SHOW_ERROR_SUCCESS_SCREEN;
    
    // This time we use the delegate instead of blocks (it's your choice)
    self.idnowController.delegate = self;
    
    // Initialize identification
    [self.idnowController initialize];
}

#pragma mark - IDnowControllerDelegate -

- (void) idnowController: (IDnowController *) idnowController initializationDidFailWithError: (NSError *) error
{
    // Initialization failed -> Present an alert containing localized error description
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle: @"Error" message: error.localizedDescription preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction	  *action		   = [UIAlertAction actionWithTitle: @"Ok" style: UIAlertActionStyleCancel handler: nil];
    [alertController addAction: action];
    [self.viewController presentViewController: alertController animated: true completion: nil];
}


- (void) idnowControllerDidFinishInitializing: (IDnowController *) idnowController
{
    // Initialization was successfull -> Start identification
    [self.idnowController startIdentificationFromViewController: self];
}


- (void) idnowControllerCanceledByUser: (IDnowController *) idnowController
{
    // The identification was canceled by the user.
    // For example the user tapped on the "x"-Button or simply navigates back.
    // Normally you don't have to do anything...
    [self invalidateTimer];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Identification Canceled By User"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:globalCommand.callbackId];
}


- (void) idnowController: (IDnowController *) idnowController identificationDidFailWithError: (NSError *) error
{
    // Identification failed
    // If showErrorSuccessScreen (Settings) is disabled and error.type == IDnowErrorTypeIdentificationFailed
    // you can show for example an alert to your users.
    [self invalidateTimer];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error.description];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:globalCommand.callbackId];
}


- (void) idnowControllerDidFinishIdentification: (IDnowController *) idnowController
{
    // Identification was successfull
    // If showErrorSuccessScreen (Settings) is disabled
    // you can show for example an alert to your users.
    [self invalidateTimer];
    CDVPluginResult* pluginResult = nil;
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Identification Finished"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:globalCommand.callbackId];
}

@end
