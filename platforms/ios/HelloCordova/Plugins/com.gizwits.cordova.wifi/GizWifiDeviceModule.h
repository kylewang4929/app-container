#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

@interface GizWifiDeviceModule : CDVPlugin
{
    @protected
    NSString *_cbWrite;
    NSString *_cbDeviceStatus;
}

// 遇到传入的 device 参数错误，则回调此接口
- (void)callbackDeviceError:(NSString *)cbId function:(const char *)function;

// 主动上报通知
- (void)sendNotification:(NSDictionary *)dataDict errDict:(NSDictionary *)errDict;

@end
