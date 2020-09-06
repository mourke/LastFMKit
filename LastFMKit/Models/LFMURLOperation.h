//
//  LFMURLOperation.h
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
 A class that allows managing and retrying an NSURLSessionDataTask object.
 
 @note  Pass your `NSURLRequest`  and `NSURLSession` into the objects constructor as well as the callback block to be used to process the API's response. If an error occurs, it will be passed back through the call back which should, in turn be filtered back up to the user and presented using the `localizedRecoverySuggestion`, `localizedRecoveryOptions` and `recoveryAttempter` properties of `NSError`. This class conforms to the NSErrorRecoveryAttempting protocol and the request will be retried upon a successful call.
*/
@interface LFMURLOperation : NSObject

/**
 The callback block to handle the JSON data.
 
 @param responseDictionary  The JSON response converted to a dictionary, if there were no errors.
 @param error                               The error object. This object's userInfo dictionary contains all NSLocalizedRecovery options. To handle an error thrown by the API, use the `localizedRecoverySuggestion`, `localizedRecoveryOptions` and `recoveryAttempter` to show the user information about the error and recover from the error. Calling the `recoveryAttempter` will retry the request with the same callback instance.
*/
typedef void (^OperationCallback)(NSDictionary * _Nullable responseDictionary, NSError * _Nullable error);

- (instancetype)initWithSession:(NSURLSession *)session
                        request:(NSURLRequest *)request
                       callback:(OperationCallback)callback NS_DESIGNATED_INITIALIZER;

+ (instancetype)operationWithSession:(NSURLSession *)session
                             request:(NSURLRequest *)request
                            callback:(OperationCallback)callback;

/** A Boolean value indicating whether the operation is currently cancelling. */
@property (readonly, getter=isCancelled) BOOL cancelled;

/** A Boolean value indicating whether the operation is currently executing. */
@property (readonly, getter=isExecuting) BOOL executing;

/** A Boolean value indicating whether the operation is finished. */
@property (readonly, getter=isFinished) BOOL finished;

/** A Boolean value indicating whether the operation is finished and has failed. */
@property (readonly, getter=isFailed) BOOL failed;

/** Resume the underlying  NSURLSessionDataTask. */
- (void)resume;

/** Cancel the underlying  NSURLSessionDataTask. */
- (void)cancel;

/**
 Restart the  NSURLSessionDataTask. If the task has not yet completed, it will be cancelled and destroyed. If the task doesn't exist, this is identical to calling `resume`
 
 @note  This will work even when the NSURLSessionDataTask has finished (either completed, cancelled or failed).
 */
- (void)restart;

/** Temporarily suspend the underlying  NSURLSessionDataTask. */
- (void)suspend;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
