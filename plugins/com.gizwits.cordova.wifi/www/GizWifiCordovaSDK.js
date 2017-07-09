var exec = require('cordova/exec');

exports.startWithAppID = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "startWithAppID", [arg0]);
};

exports.registerDeviceListNotifications = function(success, error) {
    exec(success, error, "GizWifiCordovaSDK", "registerDeviceListNotifications", [null]);
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

exports.changeUserPassword = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "changeUserPassword", [arg0]);
};

exports.resetPassword = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "resetPassword", [arg0]);
};

exports.getUserInfo = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "getUserInfo", [arg0]);
};

exports.changeUserInfo = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "changeUserInfo", [arg0]);
};

exports.setDeviceOnboarding = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "setDeviceOnboarding", [arg0]);
};

exports.getBoundDevices = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "getBoundDevices", [arg0]);
};

exports.bindRemoteDevice = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "bindRemoteDevice", [arg0]);
};

exports.unbindDevice = function(arg0, success, error) {
    exec(success, error, "GizWifiCordovaSDK", "unbindDevice", [arg0]);
};

exports.getVersion = function(success, error) {
  exec(success, error, "GizWifiCordovaSDK", "getVersion", [null]);
};

exports.setSubscribe = function(arg0, success, error) {
    exec(success, error, "GizWifiDeviceModule", "setSubscribe", [arg0]);
};

exports.getDeviceStatus = function(arg0, success, error) {
    exec(success, error, "GizWifiDeviceModule", "getDeviceStatus", [arg0]);
};

exports.write = function(arg0, success, error) {
    exec(success, error, "GizWifiDeviceModule", "write", [arg0]);
};

exports.setCustomInfo = function(arg0, success, error) {
    exec(success, error, "GizWifiDeviceModule", "setCustomInfo", [arg0]);
};

exports.registerDeviceStatusNotifications = function(success, error) {
    exec(success, error, "GizWifiDeviceModule", "registerDeviceStatusNotifications", [null]);
};
