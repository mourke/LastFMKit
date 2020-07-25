//
//  LFMTestCase.m
//  LastFMKitTests
//
//  Copyright (c) 2017 Mark Bourke
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
//  THE SOFTWARE.
//

#import "LFMTestCase.h"
#import <LastFMKit/LastFMKit.h>
#import <LastFMKit/LFMKit+Protected.h>

@implementation LFMTestCase

- (NSString *)testUsername {
    return @"test_lfmkit_ios";
}

- (void)setUp {
    [[LFMAuth sharedInstance] setApiKey:@"bc15dd6972bc0f7c952273b34d253a6a"];
    [[LFMAuth sharedInstance] setApiSecret:@"d46ca773c61a3907c0b19c777c5bcf20"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    LFMSession *testSession = [[LFMSession alloc] performSelector:NSSelectorFromString(@"init")]; // Initialiser is private.
#pragma clang diagnostic pop
    [testSession setValue:[NSNumber numberWithBool:NO] forKey:@"_userIsSubscriber"];
    [testSession setValue:self.testUsername forKey:@"_userName"];
    [testSession setValue:@"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO" forKey:@"_sessionKey"];
    
    [[LFMAuth sharedInstance] setValue:testSession forKey:@"_session"];
}

@end
