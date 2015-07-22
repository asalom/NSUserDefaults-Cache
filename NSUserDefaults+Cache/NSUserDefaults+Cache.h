//
//  NSUserDefaults+Cache.h
//  NSUserDefaultsCache
//
//  Created by Alexandre Salom Fernandez on 10.07.14.
//  Copyright (c) 2014 Alex Salom © alexsalom.es All rights reserved.
//

#import <Foundation/Foundation.h>

/** Category to allow saving in NSUserDefaults with one line
 This category has an NSCache object internally which stores in memory the objects too so we don't access to disk every time we want to recover something from the NSUserDefaults. Each method preforms the tasks and synchronizes the new changes with the cache and the NSUserDefaults
 */
@interface NSUserDefaults (Cache)

/**---------------------------------------------------------------------------------------
 * @name Util
 *  ---------------------------------------------------------------------------------------
 */

/** Check if a a key exists in NSUserDefaults
 @param key Key to be checked
 @return YES if the key exists in NSUserDefaults, NO otherwise
 */
+ (BOOL)cache_containsKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Integer
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves an NSInteger from either the cache or disk
 @param key Key to identify the value
 @return NSInteger found or 0 if not found
 */
+ (NSInteger)cache_integerForKey:(NSString *)key;

/** Retrieves an NSInteger from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return NSInteger found or defaultValue if not found
 */
+ (NSInteger)cache_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

/** Writes in disk and in the cache the provided NSInteger
 @param value NSInteger to be stored in the cache and disk
 @param key Key to identify the value
 */
+ (void)cache_setIntegerSynchronizing:(NSInteger)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Float
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves a float from either the cache or disk
 @param key Key to identify the value
 @return float found or 0.0 if not found
 */
+ (float)cache_floatForKey:(NSString *)key;

/** Retrieves an float from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return float found or defaultValue if not found
 */
+ (float)cache_floatForKey:(NSString *)key defaultValue:(float)defaultValue;

/** Writes in disk and in the cache the provided float
 @param value float to be stored in the cache and disk
 @param key Key to identify the value
 */
+ (void)cache_setFloatSynchronizing:(float)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Double
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves a double from either the cache or disk
 @param key Key to identify the value
 @return double found or 0.0 if not found
 */
+ (double)cache_doubleForKey:(NSString *)key;

/** Retrieves an double from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return double found or defaultValue if not found
 */
+ (double)cache_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;

/** Writes in disk and in the cache the provided double
 @param value double to be stored in the cache and disk
 @param key Key to identify the value
 */
+ (void)cache_setDoubleSynchronizing:(double)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Bool
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves a BOOL from either the cache or disk
 @param key Key to identify the value
 @return BOOL found or NO if not found
 */
+ (BOOL)cache_boolForKey:(NSString *)key;

/** Retrieves an BOOL from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return BOOL found or defaultValue if not found
 */
+ (BOOL)cache_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

/** Writes in disk and in the cache the provided BOOL
 @param value BOOL to be stored in the cache and disk
 @param key Key to identify the value
 */
+ (void)cache_setBoolSynchronizing:(BOOL)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Object
 * @discussion The value parameter can be only property list objects: NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary. For NSArray and NSDictionary objects, their contents must be property list objects.
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves an object from either the cache or disk
 @param key Key to identify the value
 @return object found or nil if not found
 */
+ (id)cache_objectForKey:(NSString *)key;

/** Retrieves a BOOL from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return BOOL found or defaultValue if not found
 */
+ (id)cache_objectForKey:(NSString *)key defaultValue:(id)defaultValue;

/** Writes in disk and in the cache the provided object
 @param value Object to be stored in the cache and disk
 @param key Key to identify the value
 @discussion The value parameter can be only property list objects: NSData, NSString, NSNumber, NSDate, NSArray, or NSDictionary. For NSArray and NSDictionary objects, their contents must be property list objects.
 */
+ (void)cache_setObjectSynchronizing:(id)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Custom object
 * @discussion The custom object needs to implement NSCoding protocol so we can transform it into NSData before storing it in NSUserDefaults
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves an Custom object from either the cache or disk
 @param key Key to identify the value
 @return Custom object found or nil if not found
 */
+ (id)cache_customObjectForKey:(NSString *)key;

/** Retrieves a Custom Object from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return Custom object found found or defaultValue if not found
 */
+ (id)cache_customObjectForKey:(NSString *)key defaultValue:(id)defaultValue;

/** Writes in disk and in the cache the provided Custom Object
 @param value Custom Object to be stored in the cache and disk
 @param key Key to identify the value
 @discussion The custom object needs to implement NSCoding protocol so we can transform it into NSData before storing it in NSUserDefaults
 */
+ (void)cache_setCustomObjectSynchronizing:(id)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name URL
 *  ---------------------------------------------------------------------------------------
 */

/** Retrieves an NSURL from either the cache or disk
 @param key Key to identify the value
 @return NSURL found or nil if not found
 */
+ (NSURL *)cache_urlForKey:(NSString *)key;

/** Retrieves a NSURL from either the cache or disk
 @param key Key to identify the value
 @param defaultValue Default value in case nothing is found given the provided key
 @return NSURL found found or defaultValue if not found
 */
+ (NSURL *)cache_urlForKey:(NSString *)key defaultValue:(NSURL *)defaultValue;

/** Writes in disk and in the cache the provided NSURL
 @param value NSURL to be stored in the cache and disk
 @param key Key to identify the value
 */
+ (void)cache_setUrlSynchronizing:(NSURL *)value forKey:(NSString *)key;


/**---------------------------------------------------------------------------------------
 * @name Deleting objects
 *  ---------------------------------------------------------------------------------------
 */

/** Removes an object by a given key
 @param key Key of the object to be deleted
 */
+ (void)cache_removeObjectSynchronizingForKey:(NSString *)key;

/** Removes all objects
 */
+ (void)cache_removeAllObjectsSynchronizing;

+ (void)cache_setCache:(NSCache *)cache;
+ (void)cache_setUserDefaults:(NSUserDefaults *)userDefaults;

@end
