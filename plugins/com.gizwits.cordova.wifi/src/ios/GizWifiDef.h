#import <Foundation/Foundation.h>
#import "GizWifiDefinitions.h"

/**
 枚举数据映射关系（定义与文档一致，除了GAgentType之外）
 */
XPGConfigureMode getCompatibleConfigModeFromInteger(NSInteger integerValue);
GizWifiConfigureMode getConfigModeFromInteger(NSInteger integerValue);
GizLogPrintLevel getLogLevelFromInteger(NSInteger integerValue);
NSInteger getDeviceTypeFromEnum(GizWifiDeviceType enumValue);
NSInteger getEventTypeFromEnum(GizEventType enumValue);
GizThirdAccountType getThirdAccountTypeFromInteger(NSInteger integerValue);
GizUserGenderType getUserGenderTypeFromInteger(NSInteger integerValue);
GizUserAccountType getUserAccountTypeFromInteger(NSInteger integerValue);
GizWifiDeviceNetStatus getDeviceNetStatus(NSInteger integerValue);