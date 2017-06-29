/********* GizWifiCordovaSDK.m Cordova Plugin Implementation *******/

#import "GizWifiCordovaSDK.h"
#import "GizWifiSDK.h"
#import "GizWifiSDKCache.h"
#import "NSDictionaryUtils.h"
#import "GizWifiDef.h"

#define SDK_RESET_PHONEID       0
#define SDK_MODULE_VERSION      @"1.3.1"

#if SDK_RESET_PHONEID
NSString *const keychainService = @"com.gizwits.wifisdk";

@interface XPGWifiDeviceIDManager : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end

static inline NSString *GetUUIDString() {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidString;
}

#endif

#define DEFAULT_CALLBACK_OPENAPI(cbId) \
GizSDKPrintCbId(#cbId, cbId);\
if (nil == cbId) return; \
NSDictionary *dataDict = nil; \
NSDictionary *errDict = nil; \
if ([error intValue] == GIZ_SDK_SUCCESS) { \
    dataDict = @{@"errorCode": @0, \
                 @"msg": @"GIZ_SDK_SUCCESS"}; \
} else { \
    errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:error withMessage:errorMessage]; \
} \
[self sendResultEventWithCallbackId:cbId dataDict:dataDict errDict:errDict doDelete:YES]; \
cbId = nil;

#define DEFAULT_CALLBACK_OPENAPI_V2(cbId) \
GizSDKPrintCbId(#cbId, cbId);\
if (nil == cbId) return; \
NSDictionary *dataDict = nil; \
NSDictionary *errDict = nil; \
if (result.code == GIZ_SDK_SUCCESS) { \
    dataDict = @{@"errorCode": @0, \
                 @"msg": @"GIZ_SDK_SUCCESS"}; \
} else { \
    errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:@(result.code) withMessage:result.localizedDescription]; \
} \
[self sendResultEventWithCallbackId:cbId dataDict:dataDict errDict:errDict doDelete:YES]; \
cbId = nil;

#define DEFAULT_CALLBACK_OPENAPI_V2_DATADICT(cbId, dict) \
GizSDKPrintCbId(#cbId, cbId);\
if (nil == cbId) return; \
NSDictionary *errDict = nil; \
if (result.code != GIZ_SDK_SUCCESS) { \
errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:@(result.code) withMessage:result.localizedDescription]; \
} \
[self sendResultEventWithCallbackId:cbId dataDict:dict errDict:errDict doDelete:YES]; \
cbId = nil;

@interface GizWifiCordovaSDK() <GizWifiSDKDelegate> {
    // 主流程
    NSString *_cbLogin;
    
    // 新版验证码
    NSString *_cbRequestSendVerifyCode;
    
    // 图形验证码接口
    NSString *_cbGetPhoneSMSCode;
    
    // 用户注册
    NSString *_cbRegisterUser;
    
    // 通知
    NSString *_cbAppID;
    NSString *_cbNotification;
}

@end

@implementation GizWifiCordovaSDK

- (void)pluginInitialize
{
  GizSDKClient_LOG_DEBUG("XXXXXXXXXXXX");
  _cbNotification = nil;
  [GizWifiSDKCache addDelegate:self];
}

- (void)startWithAppID:(CDVInvokedUrlCommand*)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSString *appid = [dict stringValueForKey:@"appID" defaultValue:@""];
    NSString *appSecret = [dict stringValueForKey:@"appSecret" defaultValue:@""];
    NSDictionary *cloudServiceInfo = [dict dictValueForKey:@"cloudServiceInfo" defaultValue:nil];
    NSArray *specialProductKeys = [dict arrayValueForKey:@"specialProductKeys" defaultValue:nil];
    BOOL autoSetDeviceDomain = [dict boolValueForKey:@"autoSetDeviceDomain" defaultValue:NO];
    // _cbAppID = [dict integerValueForKey:@"cbId" defaultValue:-1];
    _cbAppID = command.callbackId;
    GizSDKPrintCbId("cbId", _cbAppID);
    if (appSecret.length > 0) {
      [GizWifiSDK startWithAppID:appid appSecret:appSecret specialProductKeys:specialProductKeys cloudServiceInfo:cloudServiceInfo autoSetDeviceDomain:autoSetDeviceDomain];
    } else if (dict[@"autoSetDeviceDomain"]) {
      [GizWifiSDK startWithAppID:appid specialProductKeys:specialProductKeys cloudServiceInfo:cloudServiceInfo autoSetDeviceDomain:autoSetDeviceDomain];
    } else {
      [GizWifiSDK startWithAppID:appid specialProductKeys:specialProductKeys cloudServiceInfo:cloudServiceInfo];
    }
}

- (void)userLogin:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSString *userName = [dict stringValueForKey:@"userName" defaultValue:@""];
    NSString *password = [dict stringValueForKey:@"password" defaultValue:@""];
    _cbLogin = command.callbackId;
    GizSDKPrintCbId("cbId", _cbLogin);

    if (userName.length == 0 || password.length == 0) {
        NSNumber *nError = @(GIZ_SDK_PARAM_INVALID);
        NSString *message = [GizWifiCordovaSDK defaultErrorMessage:GIZ_SDK_PARAM_INVALID];
        NSDictionary *errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:nError withMessage:message];
        [self sendResultEventWithCallbackId:_cbLogin dataDict:nil errDict:errDict doDelete:YES];
    } else {
        [[GizWifiSDK sharedInstance] userLogin:userName password:password];
    }
}

- (void)requestSendVerifyCode:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSString *appSecret = [dict stringValueForKey:@"appSecret" defaultValue:@""];
    NSString *phone = [dict stringValueForKey:@"phone" defaultValue:@""];
    _cbRequestSendVerifyCode = command.callbackId;
    GizSDKPrintCbId("cbId", _cbRequestSendVerifyCode);
    
    if (appSecret.length == 0 || phone.length == 0) {
      NSNumber *nError = @(GIZ_SDK_PARAM_INVALID);
      NSString *message = [GizWifiCordovaSDK defaultErrorMessage:GIZ_SDK_PARAM_INVALID];
      NSDictionary *errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:nError withMessage:message];
      [self sendResultEventWithCallbackId:_cbRequestSendVerifyCode dataDict:nil errDict:errDict doDelete:YES];
    } else {
      [[GizWifiSDK sharedInstance] requestSendPhoneSMSCode:appSecret phone:phone];
    }
}

- (void)registerUser:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSString *userName = [dict stringValueForKey:@"userName" defaultValue:@""];
    NSString *password = [dict stringValueForKey:@"password" defaultValue:@""];
    NSString *verifyCode = [dict stringValueForKey:@"verifyCode" defaultValue:@""];
    GizUserAccountType accountType = getUserAccountTypeFromInteger([dict integerValueForKey:@"accountType" defaultValue:-1]);
    _cbRegisterUser = command.callbackId;
    GizSDKPrintCbId("cbId", _cbRegisterUser);
    
    if (userName.length == 0 || password.length == 0) {
        NSNumber *nError = @(GIZ_SDK_PARAM_INVALID);
        NSString *message = [GizWifiCordovaSDK defaultErrorMessage:GIZ_SDK_PARAM_INVALID];
        NSDictionary *errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:nError withMessage:message];
        [self sendResultEventWithCallbackId:_cbRegisterUser dataDict:nil errDict:errDict doDelete:YES];
    } else {
        if ((NSInteger)accountType == -1) {
            [[GizWifiSDK sharedInstance] registerUser:userName password:password];
        } else {
            [[GizWifiSDK sharedInstance] registerUser:userName password:password verifyCode:verifyCode accountType:accountType];
        }
    }
}

- (void)getVersion:(CDVInvokedUrlCommand*)command
{
  CDVPluginResult* pluginResult = nil;
  NSString *version = [NSString stringWithFormat:@"%@-%@", [GizWifiSDK getVersion], SDK_MODULE_VERSION];
  
  if (version != nil && [version length] > 0) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
  }
  
  [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Class methods

+ (NSDictionary *)makeErrorCodeFromNumberResult:(NSNumber *)result withMessage:(NSString *)message {
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    [mdict setValue:result forKey:@"errorCode"];
    [mdict setValue:message forKey:@"msg"];
    return [mdict copy];
}

+ (NSString *)defaultErrorMessage:(int)errorCode {
    switch (errorCode) {
        case GIZ_SDK_SUCCESS:
            return @"GIZ_SDK_SUCCESS";
        case GIZ_PUSHAPI_BODY_JSON_INVALID:
            return @"GIZ_PUSHAPI_BODY_JSON_INVALID";
        case GIZ_PUSHAPI_DATA_NOT_EXIST:
            return @"GIZ_PUSHAPI_DATA_NOT_EXIST";
        case GIZ_PUSHAPI_NO_CLIENT_CONFIG:
            return @"GIZ_PUSHAPI_NO_CLIENT_CONFIG";
        case GIZ_PUSHAPI_NO_SERVER_DATA:
            return @"GIZ_PUSHAPI_NO_SERVER_DATA";
        case GIZ_PUSHAPI_GIZWITS_APPID_EXIST:
            return @"GIZ_PUSHAPI_GIZWITS_APPID_EXIST";
        case GIZ_PUSHAPI_PARAM_ERROR:
            return @"GIZ_PUSHAPI_PARAM_ERROR";
        case GIZ_PUSHAPI_AUTH_KEY_INVALID:
            return @"GIZ_PUSHAPI_AUTH_KEY_INVALID";
        case GIZ_PUSHAPI_APPID_OR_TOKEN_ERROR:
            return @"GIZ_PUSHAPI_APPID_OR_TOKEN_ERROR";
        case GIZ_PUSHAPI_TYPE_PARAM_ERROR:
            return @"GIZ_PUSHAPI_TYPE_PARAM_ERROR";
        case GIZ_PUSHAPI_ID_PARAM_ERROR:
            return @"GIZ_PUSHAPI_ID_PARAM_ERROR";
        case GIZ_PUSHAPI_APPKEY_SECRETKEY_INVALID:
            return @"GIZ_PUSHAPI_APPKEY_SECRETKEY_INVALID";
        case GIZ_PUSHAPI_CHANNELID_ERROR_INVALID:
            return @"GIZ_PUSHAPI_CHANNELID_ERROR_INVALID";
        case GIZ_PUSHAPI_PUSH_ERROR:
            return @"GIZ_PUSHAPI_PUSH_ERROR";
        case GIZ_SDK_PARAM_FORM_INVALID:
            return @"GIZ_SDK_PARAM_FORM_INVALID";
        case GIZ_SDK_CLIENT_NOT_AUTHEN:
            return @"GIZ_SDK_CLIENT_NOT_AUTHEN";
        case GIZ_SDK_CLIENT_VERSION_INVALID:
            return @"GIZ_SDK_CLIENT_VERSION_INVALID";
        case GIZ_SDK_UDP_PORT_BIND_FAILED:
            return @"GIZ_SDK_UDP_PORT_BIND_FAILED";
        case GIZ_SDK_DAEMON_EXCEPTION:
            return @"GIZ_SDK_DAEMON_EXCEPTION";
        case GIZ_SDK_PARAM_INVALID:
            return @"GIZ_SDK_PARAM_INVALID";
        case GIZ_SDK_APPID_LENGTH_ERROR:
            return @"GIZ_SDK_APPID_LENGTH_ERROR";
        case GIZ_SDK_LOG_PATH_INVALID:
            return @"GIZ_SDK_LOG_PATH_INVALID";
        case GIZ_SDK_LOG_LEVEL_INVALID:
            return @"GIZ_SDK_LOG_LEVEL_INVALID";
        case GIZ_SDK_DEVICE_CONFIG_SEND_FAILED:
            return @"GIZ_SDK_DEVICE_CONFIG_SEND_FAILED";
        case GIZ_SDK_DEVICE_CONFIG_IS_RUNNING:
            return @"GIZ_SDK_DEVICE_CONFIG_IS_RUNNING";
        case GIZ_SDK_DEVICE_CONFIG_TIMEOUT:
            return @"GIZ_SDK_DEVICE_CONFIG_TIMEOUT";
        case GIZ_SDK_DEVICE_DID_INVALID:
            return @"GIZ_SDK_DEVICE_DID_INVALID";
        case GIZ_SDK_DEVICE_MAC_INVALID:
            return @"GIZ_SDK_DEVICE_MAC_INVALID";
        case GIZ_SDK_SUBDEVICE_DID_INVALID:
            return @"GIZ_SDK_SUBDEVICE_DID_INVALID";
        case GIZ_SDK_DEVICE_PASSCODE_INVALID:
            return @"GIZ_SDK_DEVICE_PASSCODE_INVALID";
        case GIZ_SDK_DEVICE_NOT_CENTERCONTROL:
            return @"GIZ_SDK_DEVICE_NOT_CENTERCONTROL";
        case GIZ_SDK_DEVICE_NOT_SUBSCRIBED:
            return @"GIZ_SDK_DEVICE_NOT_SUBSCRIBED";
        case GIZ_SDK_DEVICE_NO_RESPONSE:
            return @"GIZ_SDK_DEVICE_NO_RESPONSE";
        case GIZ_SDK_DEVICE_NOT_READY:
            return @"GIZ_SDK_DEVICE_NOT_READY";
        case GIZ_SDK_DEVICE_NOT_BINDED:
            return @"GIZ_SDK_DEVICE_NOT_BINDED";
        case GIZ_SDK_DEVICE_CONTROL_WITH_INVALID_COMMAND:
            return @"GIZ_SDK_DEVICE_CONTROL_WITH_INVALID_COMMAND";
        case GIZ_SDK_DEVICE_CONTROL_FAILED:
            return @"GIZ_SDK_DEVICE_CONTROL_FAILED";
        case GIZ_SDK_DEVICE_GET_STATUS_FAILED:
            return @"GIZ_SDK_DEVICE_GET_STATUS_FAILED";
        case GIZ_SDK_DEVICE_CONTROL_VALUE_TYPE_ERROR:
            return @"GIZ_SDK_DEVICE_CONTROL_VALUE_TYPE_ERROR";
        case GIZ_SDK_DEVICE_CONTROL_VALUE_OUT_OF_RANGE:
            return @"GIZ_SDK_DEVICE_CONTROL_VALUE_OUT_OF_RANGE";
        case GIZ_SDK_DEVICE_CONTROL_NOT_WRITABLE_COMMAND:
            return @"GIZ_SDK_DEVICE_CONTROL_NOT_WRITABLE_COMMAND";
        case GIZ_SDK_BIND_DEVICE_FAILED:
            return @"GIZ_SDK_BIND_DEVICE_FAILED";
        case GIZ_SDK_UNBIND_DEVICE_FAILED:
            return @"GIZ_SDK_UNBIND_DEVICE_FAILED";
        case GIZ_SDK_DNS_FAILED:
            return @"GIZ_SDK_DNS_FAILED";
        case GIZ_SDK_M2M_CONNECTION_SUCCESS:
            return @"GIZ_SDK_M2M_CONNECTION_SUCCESS";
        case GIZ_SDK_SET_SOCKET_NON_BLOCK_FAILED:
            return @"GIZ_SDK_SET_SOCKET_NON_BLOCK_FAILED";
        case GIZ_SDK_CONNECTION_TIMEOUT:
            return @"GIZ_SDK_CONNECTION_TIMEOUT";
        case GIZ_SDK_CONNECTION_REFUSED:
            return @"GIZ_SDK_CONNECTION_REFUSED";
        case GIZ_SDK_CONNECTION_ERROR:
            return @"GIZ_SDK_CONNECTION_ERROR";
        case GIZ_SDK_CONNECTION_CLOSED:
            return @"GIZ_SDK_CONNECTION_CLOSED";
        case GIZ_SDK_SSL_HANDSHAKE_FAILED:
            return @"GIZ_SDK_SSL_HANDSHAKE_FAILED";
        case GIZ_SDK_DEVICE_LOGIN_VERIFY_FAILED:
            return @"GIZ_SDK_DEVICE_LOGIN_VERIFY_FAILED";
        case GIZ_SDK_INTERNET_NOT_REACHABLE:
            return @"GIZ_SDK_INTERNET_NOT_REACHABLE";
        case GIZ_SDK_HTTP_ANSWER_FORMAT_ERROR:
            return @"GIZ_SDK_HTTP_ANSWER_FORMAT_ERROR";
        case GIZ_SDK_HTTP_ANSWER_PARAM_ERROR:
            return @"GIZ_SDK_HTTP_ANSWER_PARAM_ERROR";
        case GIZ_SDK_HTTP_SERVER_NO_ANSWER:
            return @"GIZ_SDK_HTTP_SERVER_NO_ANSWER";
        case GIZ_SDK_HTTP_REQUEST_FAILED:
            return @"GIZ_SDK_HTTP_REQUEST_FAILED";
        case GIZ_SDK_OTHERWISE:
            return @"GIZ_SDK_OTHERWISE";
        case GIZ_SDK_MEMORY_MALLOC_FAILED:
            return @"GIZ_SDK_MEMORY_MALLOC_FAILED";
        case GIZ_SDK_THREAD_CREATE_FAILED:
            return @"GIZ_SDK_THREAD_CREATE_FAILED";
        // case GIZ_SDK_USER_ID_INVALID:
            // return @"GIZ_SDK_USER_ID_INVALID";
        // case GIZ_SDK_TOKEN_INVALID:
            // return @"GIZ_SDK_TOKEN_INVALID";
        case GIZ_SDK_GROUP_ID_INVALID:
            return @"GIZ_SDK_GROUP_ID_INVALID";
        // case GIZ_SDK_GROUPNAME_INVALID:
            // return @"GIZ_SDK_GROUPNAME_INVALID";
        case GIZ_SDK_GROUP_PRODUCTKEY_INVALID:
            return @"GIZ_SDK_GROUP_PRODUCTKEY_INVALID";
        case GIZ_SDK_GROUP_FAILED_DELETE_DEVICE:
            return @"GIZ_SDK_GROUP_FAILED_DELETE_DEVICE";
        case GIZ_SDK_GROUP_FAILED_ADD_DEVICE:
            return @"GIZ_SDK_GROUP_FAILED_ADD_DEVICE";
        case GIZ_SDK_GROUP_GET_DEVICE_FAILED:
            return @"GIZ_SDK_GROUP_GET_DEVICE_FAILED";
        case GIZ_SDK_DATAPOINT_NOT_DOWNLOAD:
            return @"GIZ_SDK_DATAPOINT_NOT_DOWNLOAD";
        case GIZ_SDK_DATAPOINT_SERVICE_UNAVAILABLE:
            return @"GIZ_SDK_DATAPOINT_SERVICE_UNAVAILABLE";
        case GIZ_SDK_DATAPOINT_PARSE_FAILED:
            return @"GIZ_SDK_DATAPOINT_PARSE_FAILED";
        case GIZ_SDK_NOT_INITIALIZED:
            return @"GIZ_SDK_NOT_INITIALIZED";
        case GIZ_SDK_EXEC_DAEMON_FAILED:
            return @"GIZ_SDK_EXEC_DAEMON_FAILED";
        case GIZ_SDK_EXEC_CATCH_EXCEPTION:
            return @"GIZ_SDK_EXEC_CATCH_EXCEPTION";
        case GIZ_SDK_APPID_IS_EMPTY:
            return @"GIZ_SDK_APPID_IS_EMPTY";
        case GIZ_SDK_UNSUPPORTED_API:
            return @"GIZ_SDK_UNSUPPORTED_API";
        case GIZ_SDK_REQUEST_TIMEOUT:
            return @"GIZ_SDK_REQUEST_TIMEOUT";
        case GIZ_SDK_DAEMON_VERSION_INVALID:
            return @"GIZ_SDK_DAEMON_VERSION_INVALID";
        case GIZ_SDK_PHONE_NOT_CONNECT_TO_SOFTAP_SSID:
            return @"GIZ_SDK_PHONE_NOT_CONNECT_TO_SOFTAP_SSID";
        case GIZ_SDK_DEVICE_CONFIG_SSID_NOT_MATCHED:
            return @"GIZ_SDK_DEVICE_CONFIG_SSID_NOT_MATCHED";
        case GIZ_SDK_NOT_IN_SOFTAPMODE:
            return @"GIZ_SDK_NOT_IN_SOFTAPMODE";
        case GIZ_SDK_PHONE_WIFI_IS_UNAVAILABLE:
            return @"GIZ_SDK_PHONE_WIFI_IS_UNAVAILABLE";
        case GIZ_SDK_RAW_DATA_TRANSMIT:
            return @"GIZ_SDK_RAW_DATA_TRANSMIT";
        case GIZ_SDK_PRODUCT_IS_DOWNLOADING:
            return @"GIZ_SDK_PRODUCT_IS_DOWNLOADING";
        case GIZ_SDK_START_SUCCESS:
            return @"GIZ_SDK_START_SUCCESS";
            
            //OPEN-API
        case GIZ_OPENAPI_MAC_ALREADY_REGISTERED:
            return @"GIZ_OPENAPI_MAC_ALREADY_REGISTERED";
        case GIZ_OPENAPI_PRODUCT_KEY_INVALID:
            return @"GIZ_OPENAPI_PRODUCT_KEY_INVALID";
        case GIZ_OPENAPI_APPID_INVALID:
            return @"GIZ_OPENAPI_APPID_INVALID";
        case GIZ_OPENAPI_TOKEN_INVALID:
            return @"GIZ_OPENAPI_TOKEN_INVALID";
        case GIZ_OPENAPI_USER_NOT_EXIST:
            return @"GIZ_OPENAPI_USER_NOT_EXIST";
        case GIZ_OPENAPI_TOKEN_EXPIRED:
            return @"GIZ_OPENAPI_TOKEN_EXPIRED";
        case GIZ_OPENAPI_M2M_ID_INVALID:
            return @"GIZ_OPENAPI_M2M_ID_INVALID";
        case GIZ_OPENAPI_SERVER_ERROR:
            return @"GIZ_OPENAPI_SERVER_ERROR";
        case GIZ_OPENAPI_CODE_EXPIRED:
            return @"GIZ_OPENAPI_CODE_EXPIRED";
        case GIZ_OPENAPI_CODE_INVALID:
            return @"GIZ_OPENAPI_CODE_INVALID";
        case GIZ_OPENAPI_SANDBOX_SCALE_QUOTA_EXHAUSTED:
            return @"GIZ_OPENAPI_SANDBOX_SCALE_QUOTA_EXHAUSTED";
        case GIZ_OPENAPI_PRODUCTION_SCALE_QUOTA_EXHAUSTED:
            return @"GIZ_OPENAPI_PRODUCTION_SCALE_QUOTA_EXHAUSTED";
        case GIZ_OPENAPI_PRODUCT_HAS_NO_REQUEST_SCALE:
            return @"GIZ_OPENAPI_PRODUCT_HAS_NO_REQUEST_SCALE";
        case GIZ_OPENAPI_DEVICE_NOT_FOUND:
            return @"GIZ_OPENAPI_DEVICE_NOT_FOUND";
        case GIZ_OPENAPI_FORM_INVALID:
            return @"GIZ_OPENAPI_FORM_INVALID";
        case GIZ_OPENAPI_DID_PASSCODE_INVALID:
            return @"GIZ_OPENAPI_DID_PASSCODE_INVALID";
        case GIZ_OPENAPI_DEVICE_NOT_BOUND:
            return @"GIZ_OPENAPI_DEVICE_NOT_BOUND";
        case GIZ_OPENAPI_PHONE_UNAVALIABLE:
            return @"GIZ_OPENAPI_PHONE_UNAVALIABLE";
        case GIZ_OPENAPI_USERNAME_UNAVALIABLE:
            return @"GIZ_OPENAPI_USERNAME_UNAVALIABLE";
        case GIZ_OPENAPI_USERNAME_PASSWORD_ERROR:
            return @"GIZ_OPENAPI_USERNAME_PASSWORD_ERROR";
        case GIZ_OPENAPI_SEND_COMMAND_FAILED:
            return @"GIZ_OPENAPI_SEND_COMMAND_FAILED";
        case GIZ_OPENAPI_EMAIL_UNAVALIABLE:
            return @"GIZ_OPENAPI_EMAIL_UNAVALIABLE";
        case GIZ_OPENAPI_DEVICE_DISABLED:
            return @"GIZ_OPENAPI_DEVICE_DISABLED";
        case GIZ_OPENAPI_FAILED_NOTIFY_M2M:
            return @"GIZ_OPENAPI_FAILED_NOTIFY_M2M";
        case GIZ_OPENAPI_ATTR_INVALID:
            return @"GIZ_OPENAPI_ATTR_INVALID";
        case GIZ_OPENAPI_USER_INVALID:
            return @"GIZ_OPENAPI_USER_INVALID";
        case GIZ_OPENAPI_FIRMWARE_NOT_FOUND:
            return @"GIZ_OPENAPI_FIRMWARE_NOT_FOUND";
        case GIZ_OPENAPI_JD_PRODUCT_NOT_FOUND:
            return @"GIZ_OPENAPI_JD_PRODUCT_NOT_FOUND";
        case GIZ_OPENAPI_DATAPOINT_DATA_NOT_FOUND:
            return @"GIZ_OPENAPI_DATAPOINT_DATA_NOT_FOUND";
        case GIZ_OPENAPI_SCHEDULER_NOT_FOUND:
            return @"GIZ_OPENAPI_SCHEDULER_NOT_FOUND";
        case GIZ_OPENAPI_QQ_OAUTH_KEY_INVALID:
            return @"GIZ_OPENAPI_QQ_OAUTH_KEY_INVALID";
        case GIZ_OPENAPI_OTA_SERVICE_OK_BUT_IN_IDLE:
            return @"GIZ_OPENAPI_OTA_SERVICE_OK_BUT_IN_IDLE";
        case GIZ_OPENAPI_BT_FIRMWARE_UNVERIFIED:
            return @"GIZ_OPENAPI_BT_FIRMWARE_UNVERIFIED";
        case GIZ_OPENAPI_BT_FIRMWARE_NOTHING_TO_UPGRADE:
            return @"GIZ_OPENAPI_BT_FIRMWARE_NOTHING_TO_UPGRADE";
        case GIZ_OPENAPI_SAVE_KAIROSDB_ERROR:
            return @"GIZ_OPENAPI_SAVE_KAIROSDB_ERROR";
        case GIZ_OPENAPI_EVENT_NOT_DEFINED:
            return @"GIZ_OPENAPI_EVENT_NOT_DEFINED";
        case GIZ_OPENAPI_SEND_SMS_FAILED:
            return @"GIZ_OPENAPI_SEND_SMS_FAILED";
        case GIZ_OPENAPI_APPLICATION_AUTH_INVALID:
            return @"GIZ_OPENAPI_APPLICATION_AUTH_INVALID";
        case GIZ_OPENAPI_NOT_ALLOWED_CALL_API:
            return @"GIZ_OPENAPI_NOT_ALLOWED_CALL_API";
        case GIZ_OPENAPI_BAD_QRCODE_CONTENT:
            return @"GIZ_OPENAPI_BAD_QRCODE_CONTENT";
        case GIZ_OPENAPI_REQUEST_THROTTLED:
            return @"GIZ_OPENAPI_REQUEST_THROTTLED";
        case GIZ_OPENAPI_DEVICE_OFFLINE:
            return @"GIZ_OPENAPI_DEVICE_OFFLINE";
        case GIZ_OPENAPI_TIMESTAMP_INVALID:
            return @"GIZ_OPENAPI_DEVICE_OFFLINE";
        case GIZ_OPENAPI_SIGNATURE_INVALID:
            return @"GIZ_OPENAPI_SIGNATURE_INVALID";
        case GIZ_OPENAPI_DEPRECATED_API:
            return @"GIZ_OPENAPI_DEPRECATED_API";
        case GIZ_OPENAPI_RESERVED:
            return @"GIZ_OPENAPI_RESERVED";
            
            //10000+
        case GIZ_SITE_PRODUCTKEY_INVALID:
            return @"GIZ_SITE_PRODUCTKEY_INVALID";
        case GIZ_SITE_DATAPOINTS_NOT_DEFINED:
            return @"GIZ_SITE_DATAPOINTS_NOT_DEFINED";
        case GIZ_SITE_DATAPOINTS_NOT_MALFORME:
            return @"GIZ_SITE_DATAPOINTS_NOT_MALFORME";
            
        default:
            break;
    }
    return @"Unknown error";
}

#pragma mark - XPGWifiSDKDelegate

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didNotifyEvent:(GizEventType)eventType eventSource:(id)eventSource eventID:(GizWifiErrorCode)eventID eventMessage:(NSString *)eventMessage {
    GizSDKClient_LOG_DEBUG("ZZZZZZZZZZZZ");
    GizSDKPrintCbId("cbNotification", _cbNotification);
    GizSDKPrintCbId("cbAppID", _cbAppID);

    //只有这些类型可以回调，其它不回调
    NSString *strEventType = nil;
    switch (eventType) {
        case GizEventSDK:
            strEventType = @"GizEventSDK";
            break;
        case GizEventDevice:
            strEventType = @"GizEventDevice";
            break;
        case GizEventM2MService:
            strEventType = @"GizEventM2MService";
            break;
        case GizEventToken:
            strEventType = @"GizEventToken";
            break;
            
        default:
            return;
    }
    
    NSDictionary *errorDict = nil;
    NSNumber *nError = @(eventID);
    NSString *message = [GizWifiCordovaSDK defaultErrorMessage:eventID];
    errorDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:nError withMessage:message];

    if (_cbNotification != nil) {
        [self sendResultEventWithCallbackId:_cbNotification dataDict:@{strEventType: errorDict} errDict:nil doDelete:NO];
    }
    
    if (_cbAppID != nil) {
        if (eventID == GIZ_SDK_START_SUCCESS) {
            [self sendResultEventWithCallbackId:_cbAppID dataDict:errorDict errDict:nil doDelete:YES];
        } else {
            [self sendResultEventWithCallbackId:_cbAppID dataDict:nil errDict:errorDict doDelete:YES];
        }
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    NSDictionary *dataDict = nil;
    
    if (result.code == GIZ_SDK_SUCCESS) {
        //｛“uid”: xxx, "token": xxx｝
        dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:uid forKey:@"uid"];
        [dataDict setValue:token forKey:@"token"];
    }
    
    DEFAULT_CALLBACK_OPENAPI_V2_DATADICT(_cbLogin, dataDict);
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRequestSendPhoneSMSCode:(NSError *)result token:(NSString *)token {
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
    [dataDict setValue:token forKey:@"token"];
    
    if (nil != _cbRequestSendVerifyCode) {
        DEFAULT_CALLBACK_OPENAPI_V2_DATADICT(_cbRequestSendVerifyCode, dataDict)
    } else {
        DEFAULT_CALLBACK_OPENAPI_V2_DATADICT(_cbGetPhoneSMSCode, dataDict)
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRegisterUser:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    NSDictionary *dataDict = nil;
    
    if (result.code == GIZ_SDK_SUCCESS) {
        //｛“uid”: xxx, "token": xxx｝
        dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:uid forKey:@"uid"];
        [dataDict setValue:token forKey:@"token"];
    }
    
    DEFAULT_CALLBACK_OPENAPI_V2_DATADICT(_cbRegisterUser, dataDict);
}

#pragma mark - private methods

- (void)sendResultEventWithCallbackId:(NSString *)cbId
                             dataDict:(NSDictionary *)dataDict
                              errDict:(NSDictionary *)errDict
                             doDelete:(BOOL)doDelete
{
  CDVPluginResult* pluginResult = nil;
  
  if (errDict == nil || [errDict count] == 0) {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dataDict];
  } else {
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsDictionary:errDict];
  }
  
  [self.commandDelegate sendPluginResult:pluginResult callbackId:cbId];
}

@end
