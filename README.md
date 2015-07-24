# NSUserDefaults+Cache

[![Build Status](https://travis-ci.org/asalom/NSUserDefaults-Cache.svg)](https://travis-ci.org/asalom/NSUserDefaults-Cache)
[![codecov.io](http://codecov.io/github/asalom/NSUserDefaults-Cache/coverage.svg?branch=master)](http://codecov.io/github/asalom/NSUserDefaults-Cache?branch=master)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)
[![CocoaPods](https://img.shields.io/cocoapods/v/NSUserDefaults+Cache.svg)](https://cocoapods.org/pods/NSUserDefaults+Cache)

NSUserDefaults category one liner that also includes a memory cache so we only need to access disk once per item.

## Installation
### Manual
Just include the two files within the NSUserDefaults+Cache directory.

### Cocoapods
Add the following line to your Podfile:
```ruby
pod 'NSUserDefaults+Cache'
```

Then run the following command from the Terminal while in the same directory as your Podfile:
```ruby
pod install
```

## Usage
NSUserDefaults+Cache mimics all setting/getting methods from [NSUserDefaults](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/%22NSUserDefaults%22) and provides a few more. While retrieving information you can, for example, specify default values in case the key you requested was not found. You can also save and retrieve custom objects. Notice that for custom objects to be saved you will need to implement the NSCoding protocol, i.e.
```objective-c
@interface CustomCodingObject : CustomObject <NSCoding>
@property id customAttribute;
@end

@implementation CustomCodingObject
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.customAttribute forKey:@"CustomAttribute"];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.customAttribute = [aDecoder decodeObjectForKey:@"CustomAttribute"];
    }
    return self;
}
@end
```

Keep in mind that when saving things the [synchronize](https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSUserDefaults_Class/#//apple_ref/occ/instm/NSUserDefaults/synchronize) method will be called each time.
The full method list:
```objective-c
+ (BOOL)cache_containsKey:(NSString *)key;
+ (NSInteger)cache_integerForKey:(NSString *)key;
+ (NSInteger)cache_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
+ (void)cache_setIntegerSynchronizing:(NSInteger)value forKey:(NSString *)key;
+ (float)cache_floatForKey:(NSString *)key;
+ (float)cache_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
+ (void)cache_setFloatSynchronizing:(float)value forKey:(NSString *)key;
+ (double)cache_doubleForKey:(NSString *)key;
+ (double)cache_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
+ (void)cache_setDoubleSynchronizing:(double)value forKey:(NSString *)key;
+ (BOOL)cache_boolForKey:(NSString *)key;
+ (BOOL)cache_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
+ (void)cache_setBoolSynchronizing:(BOOL)value forKey:(NSString *)key;
+ (id)cache_objectForKey:(NSString *)key;
+ (id)cache_objectForKey:(NSString *)key defaultValue:(id)defaultValue;
+ (void)cache_setObjectSynchronizing:(id)value forKey:(NSString *)key;
+ (id)cache_customObjectForKey:(NSString *)key;
+ (id)cache_customObjectForKey:(NSString *)key defaultValue:(id)defaultValue;
+ (void)cache_setCustomObjectSynchronizing:(id)value forKey:(NSString *)key;
+ (NSURL *)cache_URLForKey:(NSString *)key;
+ (NSURL *)cache_URLForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;
+ (void)cache_setURLSynchronizing:(NSURL *)value forKey:(NSString *)key;
+ (void)cache_removeObjectSynchronizingForKey:(NSString *)key;
+ (void)cache_removeAllObjectsSynchronizing;
```

## License
NSUserDefaults+Cache is available under the MIT license. See the LICENSE file for more information.