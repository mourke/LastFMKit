//
//  LFMSession.m
//  LastFMKit
//
//  Copyright © 2020 Mark Bourke.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE
//

#import "LFMSession.h"
#import "LFMKit+Protected.h"
#import "LFMAuth.h"

@implementation LFMSession {
    NSString *_username;
    BOOL _userIsSubscriber;
    NSString *_sessionKey;
}

+ (LFMSession *)sharedSession {
    return [[LFMAuth sharedInstance] session];
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        id name = [dictionary objectForKey:@"name"];
        id key = [dictionary objectForKey:@"key"];
        id subscriber = [dictionary objectForKey:@"subscriber"];
        
        if (name != nil && [name isKindOfClass:NSString.class] &&
            key != nil && [key isKindOfClass:NSString.class] &&
            subscriber != nil && [subscriber isKindOfClass:NSNumber.class]) {
            _username = name;
            _sessionKey = key;
            _userIsSubscriber = [subscriber boolValue];
            
            return self;
        }
    }
    
    return nil;
}

- (NSString *)username {
    return _username;
}

- (BOOL)userIsSubscriber {
    return _userIsSubscriber;
}

- (NSString *)sessionKey {
    return _sessionKey;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ sessionKey: %@; userIsSubscriber: %d; username: %@", [super description], _sessionKey, _userIsSubscriber, _username];
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_username forKey:NSStringFromSelector(@selector(username))];
    [aCoder encodeBool:_userIsSubscriber forKey:NSStringFromSelector(@selector(userIsSubscriber))];
    [aCoder encodeObject:_sessionKey forKey:NSStringFromSelector(@selector(sessionKey))];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _username = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(username))];
        _userIsSubscriber = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(userIsSubscriber))];
        _sessionKey = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(sessionKey))];
    }
    
    return self;
}

#pragma mark - Keychain

- (BOOL)saveInKeychain {
    NSMutableDictionary *queryDictionary = [LFMKeychainQueryDictionary() mutableCopy];
    
    NSMutableDictionary *updateDictionary = [NSMutableDictionary dictionary];
    updateDictionary[(__bridge id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:self];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wtautological-compare"
    if (&kSecAttrAccessibleWhenUnlocked != NULL) {
        updateDictionary[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleWhenUnlocked;
    }
#pragma clang diagnostic pop
    
    OSStatus status;
    BOOL exists = ([LFMSession loadFromKeychain] != nil);
    
    if (exists) {
        status = SecItemUpdate((__bridge CFDictionaryRef)queryDictionary, (__bridge CFDictionaryRef)updateDictionary);
    } else {
        [queryDictionary addEntriesFromDictionary:updateDictionary];
        status = SecItemAdd((__bridge CFDictionaryRef)queryDictionary, NULL);
    }
    
    return (status == errSecSuccess);
}

- (BOOL)removeFromKeychain {
    NSMutableDictionary *queryDictionary = [LFMKeychainQueryDictionary() mutableCopy];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)queryDictionary);
    
    return (status == errSecSuccess);
}

+ (LFMSession *)loadFromKeychain {
    NSMutableDictionary *queryDictionary = [LFMKeychainQueryDictionary() mutableCopy];
    queryDictionary[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    queryDictionary[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;
    
    CFDataRef result = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)queryDictionary, (CFTypeRef *)&result);
    
    if (status != errSecSuccess) {
        return nil;
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)result];
}

static NSDictionary* LFMKeychainQueryDictionary() {
    return @{
             (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
             (__bridge id)kSecAttrService: @"LFMCredentialService",
             (__bridge id)kSecAttrAccount: @"LFMSession"
             };
}

@end
