#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "GizWifiSDK.h"
#import "GizUtil.h"
#import "GizSDKClientLog.h"
#import "GizWifiDefinitions.h"

#define GizWifiError_SDK_INIT_FAILED    GIZ_SDK_CLIENT_NOT_AUTHEN
#define GizWifiError_DEVICE_IS_INVALID  GIZ_SDK_DEVICE_DID_INVALID
#define GizWifiError_GROUP_IS_INVALID   GIZ_SDK_GROUP_ID_INVALID

#define GizSDKPrintCbId(varibleName, cbId) \
    GizSDKClient_LOG_DEBUG("%s: %zi", varibleName, cbId)

@interface GizWifiCordovaSDK : CDVPlugin

+ (NSDictionary *)makeErrorCodeFromError:(NSError *)error;
+ (NSDictionary *)makeErrorCodeFromError:(NSError *)error device:(NSDictionary *)device;
+ (NSDictionary *)makeErrorCodeFromNumberResult:(NSNumber *)result withMessage:(NSString *)message;
+ (NSDictionary *)makeDictFromDeviceWithProperties:(GizWifiDevice *)device;
+ (NSString *)defaultErrorMessage:(int)errorCode;

@end
