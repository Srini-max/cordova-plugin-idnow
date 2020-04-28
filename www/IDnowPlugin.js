var exec = require('cordova/exec');

var idnow = {};
var pluginName = "IDnowPlugin";

idnow.startPhotoIdent = function(companyId, transactionToken, showErrorSuccessScreen, success, error) {
    exec(success, error, pluginName, "startPhotoIdent", [companyId, transactionToken, showErrorSuccessScreen]);
};

module.exports = idnow;
