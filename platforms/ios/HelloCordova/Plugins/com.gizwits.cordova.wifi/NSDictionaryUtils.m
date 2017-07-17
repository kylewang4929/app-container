#import "NSDictionaryUtils.h"

@implementation NSDictionary (Utils)

- (NSInteger)integerValueForKey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
  if ([self objectForKey:key] != nil) {
    return [[self valueForKey:key] integerValue];
  }
  return defaultValue;
}

- (BOOL)boolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
  if ([self objectForKey:key] != nil) {
    return [[self valueForKey:key] boolValue];
  }
  return defaultValue;
}

- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
  NSString *ret = (NSString *)[self valueForKey:key];
  if (ret == nil) {
    ret = defaultValue;
  }
  return ret;
}

- (NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
  if ([self objectForKey:key] != nil) {
    return (NSArray *)[self valueForKey:key];
  }
  return defaultValue;
}

- (NSDictionary *)dictValueForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
  NSDictionary *ret = (NSDictionary *)[self valueForKey:key];
  if (ret == nil) {
    ret = defaultValue;
  }
  return ret;
}

@end
