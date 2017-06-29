var exec = require('cordova/exec');

exports.startWithAppID = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "startWithAppID", [arg0]);
};

exports.userLogin = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "userLogin", [arg0]);
};

exports.requestSendVerifyCode = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "requestSendVerifyCode", [arg0]);
};

exports.registerUser = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "registerUser", [arg0]);
};

exports.getVersion = function(success, error) {
  exec(success, error, "GizWifiCordovaSDK", "getVersion", [null]);
};
