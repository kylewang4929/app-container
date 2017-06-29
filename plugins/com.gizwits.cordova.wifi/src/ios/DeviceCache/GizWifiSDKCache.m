#import "GizWifiSDKCache.h"
#import "GizWifiCacheCommon.h"
#import "GizSDKClientLog.h"

static GizWifiSDKCache *sharedInstance = nil;

@interface GizWifiSDKCache()<GizWifiSDKDelegate>

@property (nonatomic, strong) NSMutableArray *mDelegates;

@end

@implementation GizWifiSDKCache

+ (instancetype)sharedInstance
{
  if (nil == sharedInstance) {
    sharedInstance = [[GizWifiSDKCache alloc] init];
    [GizWifiSDK sharedInstance].delegate = sharedInstance;
  }
  return sharedInstance;
}

+ (NSMutableArray *)sharedDelegates
{
  GizWifiSDKCache *sdkCache = [self sharedInstance];
  if (nil == sdkCache.mDelegates) {
    sdkCache.mDelegates = [NSMutableArray array];
  }
  return sdkCache.mDelegates;
}

+ (void)addDelegate:(id <GizWifiSDKDelegate>)delegate
{
  [GizWifiCacheCommon addDelegate:delegate mutableArray:[self sharedDelegates]];
}

+ (void)removeDelegate:(id <GizWifiSDKDelegate>)delegate
{
  [GizWifiCacheCommon removeDelegate:delegate mutableArray:[self sharedDelegates]];
}

#pragma mark - XPGWifiSDK delegate

#define GIZ_SDK_DELEGATE_CALLBACK_BEGIN(sel) \
for (id <GizWifiSDKDelegate>delegate in self.mDelegates) { \
    if ([delegate respondsToSelector:sel]) { \

#define GIZ_SDK_DELEGATE_CALLBACK_END() \
    } \
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didNotifyEvent:(GizEventType)eventType eventSource:(id)eventSource eventID:(GizWifiErrorCode)eventID eventMessage:(NSString *)eventMessage {
    GIZ_SDK_DELEGATE_CALLBACK_BEGIN(@selector(wifiSDK:didNotifyEvent:eventSource:eventID:eventMessage:))
    [delegate wifiSDK:wifiSDK didNotifyEvent:eventType eventSource:eventSource eventID:eventID eventMessage:eventMessage];
    GIZ_SDK_DELEGATE_CALLBACK_END()
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    GIZ_SDK_DELEGATE_CALLBACK_BEGIN(@selector(wifiSDK:didUserLogin:uid:token:))
    [delegate wifiSDK:wifiSDK didUserLogin:result uid:uid token:token];
    GIZ_SDK_DELEGATE_CALLBACK_END()
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRequestSendPhoneSMSCode:(NSError *)result token:(NSString *)token {
    GIZ_SDK_DELEGATE_CALLBACK_BEGIN(@selector(wifiSDK:didRequestSendPhoneSMSCode:token:))
    [delegate wifiSDK:wifiSDK didRequestSendPhoneSMSCode:result token:nil];
    GIZ_SDK_DELEGATE_CALLBACK_END()
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRegisterUser:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    GizSDKClient_LOG_DEBUG("YYYYYYYYYYYYYY");
    GIZ_SDK_DELEGATE_CALLBACK_BEGIN(@selector(wifiSDK:didRegisterUser:uid:token:))
    [delegate wifiSDK:wifiSDK didRegisterUser:result uid:uid token:token];
    GIZ_SDK_DELEGATE_CALLBACK_END()
}

@end
