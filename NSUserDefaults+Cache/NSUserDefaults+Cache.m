//
//  NSUserDefaults+Cache.m
//  NSUserDefaultsCache
//
//  Created by Alexandre Salom Fernandez on 10.07.14.
//  Copyright (c) 2014 Alex Salom © alexsalom.es All rights reserved.
//

#import "NSUserDefaults+Cache.h"

static NSCache * _cache = nil;
static NSUserDefaults * _userDefaults = nil;

@implementation NSUserDefaults (Cache)

+ (void)initialize {
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        _cache = [[NSCache alloc] init];
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
}

+ (void)cache_setCache:(NSCache *)cache {
    _cache = cache;
}

+ (void)cache_setUserDefaults:(NSUserDefaults *)userDefaults {
    _userDefaults = userDefaults;
}

+ (BOOL)cache_containsKey:(NSString *)key {
    return [self cache_objectForKey:key] != nil;
}

#pragma mark - Object
+ (id)cache_objectForKey:(NSString *)key {
    if (!key) {
        [NSException raise:@"nil key exception" format:@"A key can not be nil"];
    }
    
    if ([_cache objectForKey:key]) {
        return [_cache objectForKey:key];
    }
    
    id value = [_userDefaults objectForKey:key];
    
    if (value) {
        [_cache setObject:value forKey:key];
    }
    
    return value;
}

+ (id)cache_objectForKey:(NSString *)key
      defaultValue:(id)defaultValue {
    id value = [self cache_objectForKey:key];
    return value == nil ? defaultValue : value;
}

+ (void)cache_setObjectSynchronizing:(id)value
                        forKey:(NSString *)key {
    [_cache setObject:value forKey:key];
    [_userDefaults setObject:value forKey:key];
    [_userDefaults synchronize];
}

#pragma mark - Custom objects
+ (id)cache_customObjectForKey:(NSString *)key {
    NSData *data = [self cache_objectForKey:key];
    if (!data) {
        return nil;
    }
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (id)cache_customObjectForKey:(NSString *)key
      defaultValue:(id)defaultValue {
    id value = [self cache_customObjectForKey:key];
    return value == nil ? defaultValue : value;
}

+ (void)cache_setCustomObjectSynchronizing:(id)value
                        forKey:(NSString *)key {
    if (![value respondsToSelector:@selector(encodeWithCoder:)]) {
        return;
    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:value];
    if (data) {
        [self cache_setObjectSynchronizing:data forKey:key];
    }
}

#pragma mark - Integer
+ (NSInteger)cache_integerForKey:(NSString *)key {
    return [[self cache_objectForKey:key] integerValue];
}
+ (NSInteger)cache_integerForKey:(NSString *)key
              defaultValue:(NSInteger)defaultValue {
    id value = [self cache_objectForKey:key];
    return value == nil ? defaultValue : [value integerValue];
}

+ (void)cache_setIntegerSynchronizing:(NSInteger)value
                         forKey:(NSString *)key {
    [self cache_setObjectSynchronizing:@(value) forKey:key];
}

#pragma mark - Float
+ (float)cache_floatForKey:(NSString *)key {
    return [[self cache_objectForKey:key] floatValue];
}

+ (float)cache_floatForKey:(NSString *)key defaultValue:(float)defaultValue {
    id value = [self cache_objectForKey:key];
    return value == nil ? defaultValue : [value floatValue];
}

+ (void)cache_setFloatSynchronizing:(float)value forKey:(NSString *)key {
    [self cache_setObjectSynchronizing:@(value) forKey:key];
}

#pragma mark - Double
+ (double)cache_doubleForKey:(NSString *)key {
    return [[self cache_objectForKey:key] doubleValue];
}

+ (double)cache_doubleForKey:(NSString *)key defaultValue:(double)defaultValue {
    id value = [self cache_objectForKey:key];
    return value == nil ? defaultValue : [value doubleValue];
}

+ (void)cache_setDoubleSynchronizing:(double)value forKey:(NSString *)key {
    [self cache_setObjectSynchronizing:@(value) forKey:key];
}

#pragma mark - Bool
+ (BOOL)cache_boolForKey:(NSString *)key {
    return [[self cache_objectForKey:key] boolValue];
}

+ (BOOL)cache_boolForKey:(NSString *)key
      defaultValue:(BOOL)defaultValue {
    id value = [self cache_objectForKey:key];
    return value == nil ? defaultValue : [value boolValue];
}

+ (void)cache_setBoolSynchronizing:(BOOL)value
                      forKey:(NSString *)key {
    [self cache_setObjectSynchronizing:@(value) forKey:key];
}

#pragma mark - NSURL
/** Reason why we don't use the objectForKey method:
 1.- Any non-file URL is written by calling +[NSKeyedArchiver archivedDataWithRootObject:] using the NSURL instance as the root object.
 2.- Any file reference file: scheme URL will be treated as a non-file URL, and information which makes this URL compatible with 10.5 systems will also be written as part of the archive as well as its minimal bookmark data.
 3.- Any path-based file: scheme URL is written by first taking the absolute URL, getting the path from that and then determining if the path can be made relative to the user's home directory. If it can, the string is abbreviated by using stringByAbbreviatingWithTildeInPath and written out. This allows pre-10.6 clients to read the default and use -[NSString stringByExpandingTildeInPath] to use this information.
 */
+ (NSURL *)cache_URLForKey:(NSString *)key {
    if (!key) {
        [NSException raise:@"nil key exception" format:@"Requesting a nil key should not throw an exception"];
    }
    
    if ([_cache objectForKey:key]) {
        return [_cache objectForKey:key];
    }
    
    id value = [_userDefaults URLForKey:key];
    
    if (value) {
        [_cache setObject:value forKey:key];
    }
    
    return value;
}

+ (NSURL *)cache_URLForKey:(NSString *)key defaultValue:(NSURL *)defaultValue {
    NSURL *value = [self cache_URLForKey:key];
    return value == nil ? defaultValue : value;
}

+ (void)cache_setURLSynchronizing:(NSURL *)value forKey:(NSString *)key {
    [_cache setObject:value forKey:key];
    [_userDefaults setURL:value forKey:key];
    [_userDefaults synchronize];
}

#pragma mark - Removing Defaults
+ (void)cache_removeObjectSynchronizingForKey:(NSString *)key {
    [_cache removeObjectForKey:key];
    [_userDefaults removeObjectForKey:key];
    [_userDefaults synchronize];
}
+ (void)cache_removeAllObjectsSynchronizing {
    [_cache removeAllObjects];
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [_userDefaults removePersistentDomainForName:appDomain];
    [_userDefaults synchronize];
}

@end
