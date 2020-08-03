//
//  LFMSession.h
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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents a user's session authenticated through the Last.fm authentication service. For persisting the session, you may use `NSKeyedArchiver` to obtain an `NSData` instance, which can
 be stored securely using Keychain Services.
 
 @note This is done automatically using `LFMAuth` and it is recommended that you use said class.
 */
NS_SWIFT_NAME(Session)
@interface LFMSession : NSObject <NSSecureCoding>

/** The authenticated user's username. */
@property(strong, nonatomic, readonly) NSString *username;

/** Boolean value indicating whether or not the user is a subscriber. */
@property(nonatomic, readonly) BOOL userIsSubscriber;

/** The user's session key used for authenticating all requests that require you to do so. This key is encrypted on-device using Apple's built in Keychain framework. */
@property(strong, nonatomic, readonly) NSString *sessionKey;

/**
 Shared singleton instance. This can only be set using `LFMAuth` class's `getSessionWithUsername:password:callback` method.
 */
@property(class, strong, readonly, nullable) LFMSession *sharedSession NS_SWIFT_NAME(shared);

- (instancetype) __attribute__((unavailable("Please use `sharedSession` instead."))) init;

+ (instancetype) __attribute__((unavailable("Please use `sharedSession` instead."))) new;

@end

NS_ASSUME_NONNULL_END
