#import "NSDictionaryUtils.h"

@implementation NSDictionary (Utils)

- (NSInteger)integerValueForKey:(NSString*)key defaultValue:(NSInteger)defaultValue
{
  NSInteger ret = (NSInteger)[self valueForKey:key];
  if (ret == nil) {
    ret = defaultValue;
  }
  return ret;
}

- (BOOL)boolValueForKey:(NSString*)key defaultValue:(BOOL)defaultValue
{
  BOOL ret = (BOOL)[self valueForKey:key];
  if (ret == nil) {
    ret = defaultValue;
  }
  return ret;
}

- (NSString*)stringValueForKey:(NSString*)key defaultValue:(NSString*)defaultValue
{
  NSString *ret = (NSString *)[self valueForKey:key];
  if (ret == nil) {
    ret = defaultValue;
  }
  return ret;
}

- (NSArray *)arrayValueForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
  NSArray *ret = (NSArray *)[self valueForKey:key];
  if (ret == nil) {
    ret = defaultValue;
  }
  return ret;
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
