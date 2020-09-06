//
//  LFMAuth.h
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

@class LFMURLOperation, LFMSession;

/**
 This class provides helper methods for authenticating users against the Last.fm
 authentication service. In order to make any calls to api methods requiring authentication (you will see a helpful: "🔒: Authentication Required" message in the function's description to remind you), this class must be used.
 
 @note If you want to use this class for storing credentials - which it will do automatically -, you must have keychain accessibilty turned on in your app's capabilities page.
 */
NS_SWIFT_NAME(Auth)
@interface LFMAuth : NSObject

/**
 The authentication result callback.
 
 @param error An `NSError` object if an error occurred, is `nil` if there is no error.
 @param session An `LFMSession` object containing information about the session and the authenticated user.
 */
typedef void (^LFMAuthCallback)(LFMSession * _Nullable session, NSError * _Nullable error);

/**
 Shared singleton instance of the `LFMAuth` class. A separate instance is not necessary and is not to be created.
 */
@property(class, strong, readonly) LFMAuth *sharedInstance NS_SWIFT_NAME(shared);

/**
 Starts a mobile service session for a user. Session keys have an infinite lifetime by default so this method need only be called once at the very start of your application, unless the user revokes privileges for your application on their Last.fm settings screen. Upon success, the `LFMSession` object passed into the `block` parameter will also be stored in the user's keychain and set as the `session` property on this class as well as the shared singleton instance on the `LFMSession` class itself. For any subsiquent app launches, this method need not be called as the session object will automatically be loaded from the user's keychain.
 
 @param username    The last.fm username or email address.
 @param password    The password in plaintext.
 @param block       The block called upon completion indicating success or failure.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
- (LFMURLOperation *)getSessionWithUsername:(NSString *)username
                                        password:(NSString *)password
                                        callback:(LFMAuthCallback)block NS_REFINED_FOR_SWIFT;

/**
 Locally removes a user's mobile session.
 
 @note: This method makes no calls to the Last.FM API. This is an on-device only sign out. In order to completely revoke the privleges for this app, the user must visit their settings page on the Last.fm website.
 
 @return   A boolean value indicating the success of the operation.
 */
- (BOOL)removeSession;

/**
 Generates an api signature string for use in the `api_sig` parameter when making authenticated requests to the API.
 
 @param queryItems  An array of every single parameter - including the method name - that is being passed to the API, excluding, obviously, the api signature parameter.
 
 @return   An `NSURLQueryItem` for the api signature (key=@"api_sig", value=the api signature).
 */
- (NSURLQueryItem *)signatureItemForQueryItems:(NSArray<NSURLQueryItem *> *)queryItems NS_SWIFT_NAME(signatureItem(for:));

/**
 Generates an api signature string for use in the `api_sig` parameter when making authenticated requests to the API.
 
 @param queryItems  An array of every single parameter - including the method name - that is being passed to the API, excluding, obviously, the api signature parameter.
 
 @return   A copy of the original array passed in with a new `NSURLQueryItem` for the api signature appended
 */
- (NSArray<NSURLQueryItem *> *)appendingSignatureItemToQueryItems:(NSArray<NSURLQueryItem *> *)queryItems NS_SWIFT_NAME(appendingSignature(to:));

/**
 Your "API key" obtained from Last.fm.
 
 @warning This property MUST be set before ANY calls are made to ANY method on this class otherwise an exception will be raised.
 */
@property(strong, nonatomic) NSString *apiKey;

/**
 Your "Shared secret" obtained from Last.fm.
 
 @warning This property MUST be set before ANY calls are made to ANY method on this class otherwise an exception will be raised.
 */
@property(strong, nonatomic) NSString *apiSecret;

/** A boolean value indicating whether the user has authenticated or not. */
@property(nonatomic, readonly) BOOL userHasAuthenticated;

/** The `LFMSession` object obtained by a successful call to `getSessionWithUsername:password:callback`. This object will automatically be set every app launch once one successful call has been made to the aformentioned method. */
@property(strong, nonatomic, readonly, nullable) LFMSession *session;

- (instancetype) __attribute__((unavailable("Please use `sharedInstance` instead."))) init;

+ (instancetype) __attribute__((unavailable("Please use `sharedInstance` instead."))) new;

@end

NS_ASSUME_NONNULL_END
