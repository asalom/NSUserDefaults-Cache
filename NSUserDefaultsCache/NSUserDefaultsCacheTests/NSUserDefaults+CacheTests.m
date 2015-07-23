//
//  NSUserDefaults+CacheTests.m
//  NSUserDefaultsCache
//
//  Created by Alex Salom on 5/6/15.
//  Copyright (c) 2014 Alex Salom © alexsalom.es All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "NSUserDefaults+Cache.h"

@interface CustomObject : NSObject
@property id customAttribute;
-(instancetype)initWithCustomAttribute:(id)customAttribute;
@end

@implementation CustomObject
- (instancetype)initWithCustomAttribute:(id)customAttribute {
    self = [super init];
    if (self) {
        _customAttribute = customAttribute;
    }
    return self;
}

- (BOOL)isEqual:(CustomObject *)object {
    return [self.customAttribute isEqual:object.customAttribute];
}
@end

@interface CustomCodingObject : CustomObject <NSCoding>
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

@interface NSUserDefaults_CacheTests : XCTestCase

@end

@implementation NSUserDefaults_CacheTests {
    id _mockUserDefaults;
    NSCache *_cache;
    NSString *_testObject;
    NSString *_testKey;
}

- (void)setUp {
    _mockUserDefaults = OCMClassMock([NSUserDefaults class]);
    _cache = [NSCache new];
    [NSUserDefaults cache_setUserDefaults:_mockUserDefaults];
    [NSUserDefaults cache_setCache:_cache];
    _testObject = @"test object";
    _testKey = @"test_key";
    [super setUp];
}

- (void)tearDown {
    _mockUserDefaults = nil;
    _cache = nil;
    _testObject = nil;
    _testKey = nil;
    [super tearDown];
}

- (void)testContainsKeyDoesntCrashWithNilKey {
    XCTAssertNoThrow([NSUserDefaults cache_containsKey:nil], @"Requesting a nil key should not crash");
}

- (void)testRetrievingNonExistingKeyReturnsFalse {
    XCTAssertFalse([NSUserDefaults cache_containsKey:_testKey], @"Retrieving non existing key returns NO");
}

- (void)testRetrievingExistingKeyReturnsTrue {
    [NSUserDefaults cache_setObjectSynchronizing:_testObject forKey:_testKey];
    XCTAssertTrue([NSUserDefaults cache_containsKey:_testKey], @"Retrieving existing key returns YES");
}

- (void)testAddingAnObjectAddsItToTheCache {
    [NSUserDefaults cache_setObjectSynchronizing:_testObject forKey:_testKey];
    XCTAssertEqualObjects([_cache objectForKey:_testKey], _testObject, @"First object in the cache should contain previously added object");
}

- (void)testRetrieveAnObjectPreviouslyAdded {
    [NSUserDefaults cache_setObjectSynchronizing:_testObject forKey:_testKey];
    id object = [NSUserDefaults cache_objectForKey:_testKey];
    XCTAssertEqualObjects(object, _testObject, @"Added and retrieved objects should be the same");
}

- (void)testRetrievingAnExistingObjectAddsItToTheMemoryCache {
    OCMStub([_mockUserDefaults objectForKey:_testKey]).andReturn(@23);
    [NSUserDefaults cache_objectForKey:_testKey];
    XCTAssertEqualObjects([_cache objectForKey:_testKey], @23, @"When an object is requested from NSUserDefaults it should be added to the memory cache");
}

- (void)testRequestingANonExistingKeyReturnsNil {
    XCTAssertNil([NSUserDefaults cache_objectForKey:_testKey], @"Requesting a non existing key should return nil");
}

- (void)testRemovingAnObjectFromUserDefaults {
    [NSUserDefaults cache_setObjectSynchronizing:_testObject forKey:_testKey];
    [NSUserDefaults cache_removeObjectSynchronizingForKey:_testKey];
    XCTAssertNil([NSUserDefaults cache_objectForKey:_testKey], @"After an object is removed it should return nil if we request its key");
}

- (void)testRemovingAllObjectsFromUserDefaults {
    [NSUserDefaults cache_setObjectSynchronizing:_testObject forKey:_testKey];
    [NSUserDefaults cache_removeAllObjectsSynchronizing];
    XCTAssertNil([NSUserDefaults cache_objectForKey:_testKey], @"After all objects are removed it should return nil if we request any key");
}

- (void)testAddingAnIntegerReturnsAnIntegerWhenRetrieved {
    [NSUserDefaults cache_setIntegerSynchronizing:3 forKey:_testKey];
    XCTAssertEqual([NSUserDefaults cache_integerForKey:_testKey], 3, @"Adding an integer should return an integer when requested");
}

- (void)testAddingABoolReturnsABoolWhenRetrieved {
    [NSUserDefaults cache_setBoolSynchronizing:YES forKey:_testKey];
    XCTAssertEqual([NSUserDefaults cache_boolForKey:_testKey], YES, @"Adding a bool should return a bool when requested");
}

- (void)testAddingADoubleReturnsADoubleWhenRetrieved {
    [NSUserDefaults cache_setDoubleSynchronizing:2.5 forKey:_testKey];
    XCTAssertEqual([NSUserDefaults cache_doubleForKey:_testKey], 2.5, @"Adding a double should return a double when requested");
}

- (void)testAddingAFloatReturnsAFloatWhenRetrieved {
    [NSUserDefaults cache_setFloatSynchronizing:2.5f forKey:_testKey];
    XCTAssertEqual([NSUserDefaults cache_floatForKey:_testKey], 2.5f, @"Adding a float should return a float when requested");
}

- (void)testAddingAUrlReturnsAUrlWhenRetrieved {
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    [NSUserDefaults cache_setURLSynchronizing:url forKey:_testKey];
    XCTAssertEqualObjects([NSUserDefaults cache_URLForKey:_testKey].absoluteString, url.absoluteString, @"Adding a URL should return a URL when requested");
}

- (void)testCustomObjectsThatDoNotImplementNSCodingProtocolAreNotAdded {
    CustomObject *object = [[CustomObject alloc] initWithCustomAttribute:@23];
    [NSUserDefaults cache_setCustomObjectSynchronizing:object forKey:_testKey];
    XCTAssertNil([NSUserDefaults cache_customObjectForKey:_testKey], @"Adding a custom object that does not implement NSCoding protocol results in the object not being really added");
}

- (void)testAddingACustomObjectReturnsACustomObjectWhenRetrieved {
    CustomCodingObject *object = [[CustomCodingObject alloc] initWithCustomAttribute:@23];
    [NSUserDefaults cache_setCustomObjectSynchronizing:object forKey:_testKey];
    XCTAssertEqualObjects([NSUserDefaults cache_customObjectForKey:_testKey], object, @"Adding a custom object should return a custom object when requested");
}

- (void)testRetrievingNonexistingObjectReturnsDefaultValue {
    XCTAssertEqualObjects([NSUserDefaults cache_objectForKey:_testKey defaultValue:_testObject], _testObject, @"Retrieving non existing object returns default value");
}

- (void)testRetrievingNonexistingBoolReturnsDefaultValue {
    XCTAssertEqual([NSUserDefaults cache_boolForKey:_testKey defaultValue:YES], YES, @"Retrieving non existing BOOL returns default value");
}

- (void)testRetrievingNonexistingIntegerReturnsDefaultValue {
    XCTAssertEqual([NSUserDefaults cache_integerForKey:_testKey defaultValue:23], 23, @"Retrieving non existing Integer returns default value");
}

- (void)testRetrievingNonexistingDoubleReturnsDefaultValue {
    XCTAssertEqual([NSUserDefaults cache_doubleForKey:_testKey defaultValue:23.3], 23.3, @"Retrieving non existing double returns default value");
}

- (void)testRetrievingNonexistingFloatReturnsDefaultValue {
    XCTAssertEqual([NSUserDefaults cache_floatForKey:_testKey defaultValue:23.3f], 23.3f, @"Retrieving non existing float returns default value");
}

- (void)testRetrievingNonExistingCustomObjectReturnsDefaultValue {
    CustomCodingObject *object = [[CustomCodingObject alloc] initWithCustomAttribute:@23];
    XCTAssertEqualObjects([NSUserDefaults cache_customObjectForKey:_testKey defaultValue:object], object, @"Retrieving non existing custom object returns default value");
}

- (void)testRetrievingNonExistingUrlReturnsDefaultValue {
    NSURL *url = [NSURL URLWithString:@"http://example.com"];
    XCTAssertEqualObjects([NSUserDefaults cache_URLForKey:_testKey defaultValue:url], url, @"Retrieving non existing URL returns default value");
}

- (void)testRetrievingAnExistingUrlAddsItToTheMemoryCache {
    NSURL *testUrl = [NSURL URLWithString:@"https://example.com/"];
    OCMStub([_mockUserDefaults URLForKey:_testKey]).andReturn(testUrl);
    [NSUserDefaults cache_URLForKey:_testKey];
    XCTAssertEqualObjects([_cache objectForKey:_testKey], testUrl, @"When a URL is requested from NSUserDefaults it should be added to the memory cache");
}

@end
