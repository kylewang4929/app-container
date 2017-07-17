#import "GizWifiDeviceModule.h"
#import "GizWifiCordovaSDK.h"
#import "GizWifiDeviceCache.h"
#import "NSDictionaryUtils.h"
#import "GizWifiDef.h"

@interface GizWifiDeviceModule() <GizWifiDeviceDelegate> {
    NSString *_cbNotification;
    NSString *_cbSubscribe;
    NSString *_cbLogin;
    NSString *_cbDisconnect;
    NSString *_cbHardwareInfo;
    NSString *_cbProductionTesting;
    NSString *_cbCustomInfo;
}

@end

@implementation GizWifiDeviceModule

- (void)pluginInitialize
{
    GizSDKClient_LOG_DEBUG("9999999999999");
    [GizWifiDeviceCache addDelegate:self];
}

- (void)callbackDeviceError:(NSString *)cbId function:(const char *)function
{
    NSLog(@"%s error: device is invalid.", function);
    NSDictionary *errDict = [GizWifiCordovaSDK makeErrorCodeFromNumberResult:@(GizWifiError_DEVICE_IS_INVALID) withMessage:@"GizWifiError_DEVICE_IS_INVALID"];
    [self sendResultEventWithCallbackId:cbId dataDict:nil errDict:errDict doDelete:YES];
}

#pragma mark - notifications

/**
 * 清理通知回调
 */
- (void)cleanupNotification {
    if (_cbNotification != nil) {
        // [self deleteCallback:_cbNotification];
        _cbNotification = nil;
    }
}

- (void)sendNotification:(NSDictionary *)dataDict errDict:(NSDictionary *)errDict
{
    GizSDKPrintCbId("22222222cbNotification", _cbNotification);
    if (_cbNotification == nil) return;
    [self sendResultEventWithCallbackId:_cbNotification dataDict:dataDict errDict:errDict doDelete:NO];
}

/**
 * 注册事件通知
 */
- (void)registerDeviceStatusNotifications:(CDVInvokedUrlCommand*)command
{
    [self cleanupNotification];
    _cbNotification = command.callbackId;
    GizSDKPrintCbId("registerDeviceStatusNotifications cbId", _cbNotification);
}

#pragma mark - interfaces

- (void)setSubscribe:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSDictionary *deviceDict = [dict dictValueForKey:@"device" defaultValue:dict];
    NSString *mac = [deviceDict stringValueForKey:@"mac" defaultValue:@""];
    NSString *did = [deviceDict stringValueForKey:@"did" defaultValue:@""];
    GizWifiDevice *device = [GizWifiDeviceCache cachedDeviceWithMacAddress:mac did:did];
    NSString *productSecret = [dict stringValueForKey:@"productSecret" defaultValue:nil];
    BOOL subscribed = [dict boolValueForKey:@"subscribed" defaultValue:NO];
    _cbSubscribe = command.callbackId;
    GizSDKPrintCbId("cbId", _cbSubscribe);

    if (device) {
        [device setSubscribe:productSecret subscribed:subscribed];
    } else {
        [self callbackDeviceError:_cbSubscribe function:__func__];
    }
}

- (void)getDeviceStatus:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSDictionary *deviceDict = [dict dictValueForKey:@"device" defaultValue:dict];
    NSString *mac = [deviceDict stringValueForKey:@"mac" defaultValue:@""];
    NSString *did = [deviceDict stringValueForKey:@"did" defaultValue:@""];
    GizWifiDevice *device = [GizWifiDeviceCache cachedDeviceWithMacAddress:mac did:did];
    NSArray *attrs = [dict arrayValueForKey:@"attrs" defaultValue:nil];
    _cbDeviceStatus = command.callbackId;
    GizSDKPrintCbId("cbId", _cbDeviceStatus);

    if (device) {
        [device getDeviceStatus:attrs];
    } else {
        [self callbackDeviceError:_cbDeviceStatus function:__func__];
    }
}

- (void)write:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSDictionary *deviceDict = [dict dictValueForKey:@"device" defaultValue:dict];
    NSString *mac = [deviceDict stringValueForKey:@"mac" defaultValue:@""];
    NSString *did = [deviceDict stringValueForKey:@"did" defaultValue:@""];
    NSDictionary *data = [dict dictValueForKey:@"data" defaultValue:@{}];
    NSInteger sn = [dict integerValueForKey:@"sn" defaultValue:-1];
    GizWifiDevice *device = [GizWifiDeviceCache cachedDeviceWithMacAddress:mac did:did];
    _cbWrite = command.callbackId;
    GizSDKPrintCbId("cbId", _cbWrite);

    if (device) {
        if (sn != -1) {
            [device write:data withSN:(int)sn];
        } else {
            [device write:data];
        }
    } else {
        [self callbackDeviceError:_cbWrite function:__func__];
    }
}

- (void)setCustomInfo:(CDVInvokedUrlCommand *)command
{
    NSDictionary *dict = [command.arguments objectAtIndex:0];
    
    NSDictionary *deviceDict = [dict dictValueForKey:@"device" defaultValue:dict];
    NSString *mac = [deviceDict stringValueForKey:@"mac" defaultValue:@""];
    NSString *did = [deviceDict stringValueForKey:@"did" defaultValue:@""];
    GizWifiDevice *device = [GizWifiDeviceCache cachedDeviceWithMacAddress:mac did:did];
    NSString *remark = [dict stringValueForKey:@"remark" defaultValue:nil];
    NSString *alias = [dict stringValueForKey:@"alias" defaultValue:nil];
    _cbCustomInfo = command.callbackId;
    GizSDKPrintCbId("cbId", _cbCustomInfo);

    if (device) {
        [device setCustomInfo:remark alias:alias];
    } else {
        [self callbackDeviceError:_cbCustomInfo function:__func__];
    }
}

#pragma mark - XPGWifiDeviceDelegate

#define DEFAULT_DEVICE_CALLBACK_V2_BEGIN(cbId) \
GizSDKPrintCbId(#cbId, cbId); \
if (cbId == nil) return; \
 \
NSMutableDictionary *dataDict = [NSMutableDictionary dictionary]; \
NSDictionary *errDict = nil; \
NSDictionary *deviceDict = [GizWifiCordovaSDK makeDictFromDeviceWithProperties:device]; \
 \
if (result.code == GIZ_SDK_SUCCESS) {

#define DEFAULT_DEVICE_CALLBACK_V2_END(cbId) \
} else { \
    errDict = [GizWifiCordovaSDK makeErrorCodeFromError:result device:deviceDict]; \
} \
 \
[self sendResultEventWithCallbackId:cbId dataDict:dataDict errDict:errDict doDelete:YES]; \
cbId = nil;

- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed {
    DEFAULT_DEVICE_CALLBACK_V2_BEGIN(_cbSubscribe)
    //｛“device”: xxx, "isSubscribed": YES/NO｝
    [dataDict setValue:deviceDict forKey:@"device"];
    [dataDict setValue:@(isSubscribed) forKey:@"isSubscribed"];
    DEFAULT_DEVICE_CALLBACK_V2_END(_cbSubscribe)
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary *)dataMap withSN:(NSNumber *)sn
{
    GizSDKClient_LOG_DEBUG("3333333333");
    GizSDKPrintCbId("cbWrite", _cbWrite);
    GizSDKPrintCbId("cbDeviceStatus", _cbDeviceStatus);

    NSMutableDictionary *dataDict = nil;
    NSDictionary *errDict = nil;
    NSDictionary *deviceDict = [GizWifiCordovaSDK makeDictFromDeviceWithProperties:device];
    
    if (result.code == GIZ_SDK_SUCCESS) {
        //｛“data”: {"attrName": xxx, "attrValue": xxx, ...}｝
        NSMutableDictionary *tmpDataDict = [[dataMap dictValueForKey:@"data" defaultValue:nil] mutableCopy];
        NSDictionary *alerts = [dataMap dictValueForKey:@"alerts" defaultValue:nil];
        NSDictionary *faults = [dataMap dictValueForKey:@"faults" defaultValue:nil];
        NSData *binary = [dataMap valueForKey:@"binary"];
        NSString *strBinary = nil;
        if (binary) {
            strBinary = [GizWifiBinary encode:binary];
        }
        
        // 转换tmpDataDict的二进制
        for (NSString *key in tmpDataDict.allKeys) {
            id value = tmpDataDict[key];
            if ([value isKindOfClass:[NSData class]]) {
                NSString *str = [GizWifiBinary encode:value];
                [tmpDataDict setValue:str forKey:key];
            }
        }

        dataDict = [NSMutableDictionary dictionary];
        [dataDict setValue:deviceDict forKey:@"device"];
        [dataDict setValue:sn forKey:@"sn"];
        [dataDict setValue:tmpDataDict forKey:@"data"];
        [dataDict setValue:alerts forKey:@"alerts"];
        [dataDict setValue:faults forKey:@"faults"];
        [dataDict setValue:strBinary forKey:@"binary"];

        NSMutableDictionary *statusDict = [NSMutableDictionary dictionary];
        NSMutableArray *alertsArray = [NSMutableArray array];
        NSMutableArray *faultsArray = [NSMutableArray array];
        for (NSString *key in alerts.allKeys) {
            [alertsArray addObject:@{key: alerts[key]}];
        }
        for (NSString *key in faults.allKeys) {
            [faultsArray addObject:@{key: faults[key]}];
        }
        [statusDict setValue:@{@"cmd": @4, @"entity0": tmpDataDict, @"version": @4} forKey:@"data"];
        [statusDict setValue:alertsArray forKey:@"alerts"];
        [statusDict setValue:faultsArray forKey:@"faults"];
        [statusDict setValue:strBinary forKey:@"binary"];

        [dataDict setValue:statusDict forKey:@"status"];
    } else {
        errDict = [GizWifiCordovaSDK makeErrorCodeFromError:result device:deviceDict];
    }
    
    if (nil != _cbWrite) {
        [self sendResultEventWithCallbackId:_cbWrite dataDict:dataDict errDict:errDict doDelete:YES];
    }
    if (nil != _cbDeviceStatus) {
        [self sendResultEventWithCallbackId:_cbDeviceStatus dataDict:dataDict errDict:errDict doDelete:YES];
    }
    // 只有通知才需要 netStatus 字段
    NSInteger netStatus = getDeviceNetStatus(device.netStatus);
    [dataDict setValue:@(netStatus) forKey:@"netStatus"];
    [self sendNotification:dataDict errDict:errDict];
}

- (void)device:(GizWifiDevice *)device didSetCustomInfo:(NSError *)result {
    DEFAULT_DEVICE_CALLBACK_V2_BEGIN(_cbCustomInfo)
    //｛“device”: xxx｝
    [dataDict setValue:deviceDict forKey:@"device"];
    DEFAULT_DEVICE_CALLBACK_V2_END(_cbCustomInfo)
}

- (void)device:(GizWifiDevice *)device didUpdateNetStatus:(GizWifiDeviceNetStatus)netStatus {
    //｛“device”: xxx, "isOnline": xxx｝
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    NSDictionary *deviceDict = [GizWifiCordovaSDK makeDictFromDeviceWithProperties:device];
    [mdict setValue:deviceDict forKey:@"device"];
    [mdict setValue:@(device.isOnline) forKey:@"isOnline"];
    [mdict setValue:@(netStatus) forKey:@"netStatus"];
    [self sendNotification:mdict errDict:nil];
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
    
    if (doDelete == false) {
      [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    }
  
    [self.commandDelegate sendPluginResult:pluginResult callbackId:cbId];
}

#pragma mark - 销毁

- (void)dispose {
    [self cleanupNotification];
    [GizWifiDeviceCache removeDelegate:self];
    
    // FIXME: Do we need to care about this?
    // [self deleteCallback:_cbSubscribe];
    // [self deleteCallback:_cbLogin];
    // [self deleteCallback:_cbDisconnect];
    // [self deleteCallback:_cbWrite];
    // [self deleteCallback:_cbHardwareInfo];
    // [self deleteCallback:_cbProductionTesting];
    // [self deleteCallback:_cbCustomInfo];
    // [self deleteCallback:_cbDeviceStatus];
}

@end
