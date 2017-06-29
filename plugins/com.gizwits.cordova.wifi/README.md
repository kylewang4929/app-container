# What's this?

A Cordova wrapper of Gizwits Wi-Fi SDK.

# How to integrate with project?

1. Checkout the code in parallel to your project

If you have a project in folder '~/workspace/MyApp', checkout this project at '~/workspace/GizWifiCordovaSDK'.

2. Run the following command to add the plugin

```
cd ~/workspace/MyApp
cordova plugin add ../GizWifiCordovaSDK
```

# How to call API?

A typical usage would be:

```
  cordova.plugins.GizWifiCordovaSDK.getVersion(function(version) {
    alert("Version: " + JSON.stringify(version));
  }, function(error) {
    alert("Error getting version: " + JSON.stringify(error));
  });
```

# Caveats

1. You need to remove the plugin and add it back again every time you change the plugin itself. Let me know if you have any better idea!
