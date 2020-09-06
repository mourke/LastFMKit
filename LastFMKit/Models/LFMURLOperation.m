//
//  LFMURLOperation.m
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

#import "LFMURLOperation.h"
#import "LFMError.h"

@implementation LFMURLOperation {
    OperationCallback _callback;
    NSURLRequest *_request;
    NSURLSession *_session;
    NSURLSessionDataTask *_task;
}

- (instancetype)initWithSession:(NSURLSession *)session
                        request:(NSURLRequest *)request
                       callback:(OperationCallback)callback {
    self = [super init];
    
    if (self) {
        _request = request;
        _callback = callback;
        _session = session;
    }
    
    return self;
}

+ (instancetype)operationWithSession:(NSURLSession *)session request:(NSURLRequest *)request callback:(OperationCallback)callback {
    return [[self alloc] initWithSession:session request:request callback:callback];
}

- (void)resume {
    if (_task == nil) {
        __weak __typeof__(self) weakSelf = self;
        _task = [[NSURLSession sharedSession] dataTaskWithRequest:_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSDictionary *responseDictionary;
            if (error == nil && lfm_error_validate(data, &error) && http_error_validate(response, &error)) {
                responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            }
            
            if (error != nil) {
                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                userInfo[NSLocalizedRecoverySuggestionErrorKey] = @"Click 'Retry' to try again.";
                userInfo[NSLocalizedRecoveryOptionsErrorKey] = @[@"Retry"];
                userInfo[NSRecoveryAttempterErrorKey] = weakSelf; // we only want our operation to last as long as it's being retained, not for as long as this error object is retained.
                error = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            }
            
            self->_callback(responseDictionary, error); // we can use captured self here because we are the only people who have access to the NSURLSessionDataTask reference.
        }];
    }
    
    [_task resume];
}

- (void)cancel {
    [_task cancel];
}

- (BOOL)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex {
    [self restart];
    return YES;
}

- (void)attemptRecoveryFromError:(NSError *)error optionIndex:(NSUInteger)recoveryOptionIndex delegate:(id)delegate didRecoverSelector:(SEL)didRecoverSelector contextInfo:(void *)contextInfo {
    BOOL didRecover = [self attemptRecoveryFromError:error optionIndex:recoveryOptionIndex];
    
    if ([delegate respondsToSelector:didRecoverSelector]) {
        NSMethodSignature *signature = [[delegate class] instanceMethodSignatureForSelector:didRecoverSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:delegate];
        [invocation setSelector:didRecoverSelector];
        [invocation setArgument:&didRecover atIndex:2];
        [invocation setArgument:&contextInfo atIndex:3];
        [invocation invoke];
    }
}

- (void)restart {
    [_task cancel];
    _task = nil;
    [self resume];
}

- (void)suspend {
    [_task suspend];
}

- (BOOL)isCancelled {
    return _task == nil ? NO : _task.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    return _task == nil ? NO : _task.state == NSURLSessionTaskStateRunning;
}

- (BOOL)isFinished {
    return _task == nil ? NO : _task.state == NSURLSessionTaskStateCompleted;
}

- (BOOL)isFailed {
    return _task == nil ? NO : ([self isFinished] && (_task.error != nil));
}


@end
