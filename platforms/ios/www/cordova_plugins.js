cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "id": "Umeng.Umeng",
        "file": "plugins/Umeng/www/Umeng.js",
        "pluginId": "Umeng",
        "clobbers": [
            "MobclickAgent"
        ]
    },
    {
        "id": "com.gizwits.cordova.wifi.GizWifiCordovaSDK",
        "file": "plugins/com.gizwits.cordova.wifi/www/GizWifiCordovaSDK.js",
        "pluginId": "com.gizwits.cordova.wifi",
        "clobbers": [
            "cordova.plugins.GizWifiCordovaSDK",
            "cordova.plugins.GizWifiDeviceModule"
        ]
    },
    {
        "id": "com.pylonproducts.wifiwizard.WifiWizard",
        "file": "plugins/com.pylonproducts.wifiwizard/www/WifiWizard.js",
        "pluginId": "com.pylonproducts.wifiwizard",
        "clobbers": [
            "window.WifiWizard"
        ]
    },
    {
        "id": "cordova-plugin-appavailability.AppAvailability",
        "file": "plugins/cordova-plugin-appavailability/www/AppAvailability.js",
        "pluginId": "cordova-plugin-appavailability",
        "clobbers": [
            "appAvailability"
        ]
    },
    {
        "id": "cordova-plugin-device.device",
        "file": "plugins/cordova-plugin-device/www/device.js",
        "pluginId": "cordova-plugin-device",
        "clobbers": [
            "device"
        ]
    },
    {
        "id": "cordova-plugin-network-information.network",
        "file": "plugins/cordova-plugin-network-information/www/network.js",
        "pluginId": "cordova-plugin-network-information",
        "clobbers": [
            "navigator.connection",
            "navigator.network.connection"
        ]
    },
    {
        "id": "cordova-plugin-network-information.Connection",
        "file": "plugins/cordova-plugin-network-information/www/Connection.js",
        "pluginId": "cordova-plugin-network-information",
        "clobbers": [
            "Connection"
        ]
    },
    {
        "id": "cordova-plugin-splashscreen.SplashScreen",
        "file": "plugins/cordova-plugin-splashscreen/www/splashscreen.js",
        "pluginId": "cordova-plugin-splashscreen",
        "clobbers": [
            "navigator.splashscreen"
        ]
    },
    {
        "id": "cordova-plugin-statusbar.statusbar",
        "file": "plugins/cordova-plugin-statusbar/www/statusbar.js",
        "pluginId": "cordova-plugin-statusbar",
        "clobbers": [
            "window.StatusBar"
        ]
    },
    {
        "id": "cordova-plugin-vibration.notification",
        "file": "plugins/cordova-plugin-vibration/www/vibration.js",
        "pluginId": "cordova-plugin-vibration",
        "merges": [
            "navigator.notification",
            "navigator"
        ]
    },
    {
        "id": "cordova.custom.plugins.exitapp.exitApp",
        "file": "plugins/cordova.custom.plugins.exitapp/www/ExitApp.js",
        "pluginId": "cordova.custom.plugins.exitapp",
        "merges": [
            "navigator.app"
        ]
    },
    {
        "id": "ionic-plugin-keyboard.keyboard",
        "file": "plugins/ionic-plugin-keyboard/www/ios/keyboard.js",
        "pluginId": "ionic-plugin-keyboard",
        "clobbers": [
            "cordova.plugins.Keyboard"
        ],
        "runs": true
    },
    {
        "id": "phonegap-plugin-barcodescanner.BarcodeScanner",
        "file": "plugins/phonegap-plugin-barcodescanner/www/barcodescanner.js",
        "pluginId": "phonegap-plugin-barcodescanner",
        "clobbers": [
            "cordova.plugins.barcodeScanner"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "Umeng": "3.0.0",
    "com.gizwits.cordova.wifi": "0.1.0",
    "com.pylonproducts.wifiwizard": "0.2.11",
    "cordova-plugin-appavailability": "0.4.2",
    "cordova-plugin-compat": "1.1.0",
    "cordova-plugin-device": "1.1.6",
    "cordova-plugin-network-information": "1.3.3",
    "cordova-plugin-splashscreen": "4.0.3",
    "cordova-plugin-statusbar": "2.2.3",
    "cordova-plugin-vibration": "2.1.5",
    "cordova.custom.plugins.exitapp": "1.0.0",
    "ionic-plugin-keyboard": "2.2.1",
    "phonegap-plugin-barcodescanner": "6.0.6"
};
// BOTTOM OF METADATA
});