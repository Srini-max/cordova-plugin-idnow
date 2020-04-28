# cordova-plugin-idnow
Cordova plugin for IDnow ID verification mobile SDKs which supportsiOS platforms. 

## Usage

To start the video identification, use the below code.
```
        var companyId = 'COMPANY_ID';
        var transactionToken = 'TND-PLMSE';
        var showErrorSuccessScreen = true;
        IDnowPlugin.startPhotoIdent(companyId, transactionToken, showErrorSuccessScreen, successCallback, failureCallback);
```

Define your successcallback and failurecallback functions

```
function successCallback(message) {

    console.log("js successCallback method");
    console.log("Success Result from native sdk :" + message);
}

function failureCallback(message) {
    console.log("js failureCallback method");
    console.log("Failure Result from native sdk :" + message);
}
```

## References
Please refer the below repositories for more information on the SDK usage.

Android SDK: https://github.com/idnow/de.idnow.android

iOS SDK: https://github.com/idnow/de.idnow.ios


