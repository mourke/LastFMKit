//
//  LFMSessionTests.m
//  LastFMKitTests
//
//  Copyright (c) 2020 Mark Bourke
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

#import <XCTest/XCTest.h>
#import <LastFMKit/LastFMKit.h>
#import <LastFMKit/LFMKit+Protected.h>

@interface LFMSessionTests : XCTestCase

@end

@implementation LFMSessionTests


- (void)testInitValidJSON_ShouldSucceed {
    NSString *json =
    @"{ \
        \"name\": \"test_lfmkit_ios\", \
        \"key\": \"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO\", \
        \"subscriber\": 1 \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    LFMSession *session = [[LFMSession alloc] initFromDictionary:dictionary];
    
    XCTAssertNotNil(session);
    
    XCTAssertTrue([session.username isEqualToString:@"test_lfmkit_ios"]);
    XCTAssertTrue([session.sessionKey isEqualToString:@"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO"]);
    XCTAssertEqual(session.userIsSubscriber, YES);
}

- (void)testInitServerError_ShouldFail {
    NSString *json =
    @"{ \
        \"error\": 13, \
        \"message\": \"Invalid method signature supplied\" \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

- (void)testInitNoName_ShouldFail {
    NSString *json =
    @"{ \
        \"key\": \"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO\", \
        \"subscriber\": 0 \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

- (void)testInitNullName_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": null, \
        \"key\": \"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO\", \
        \"subscriber\": 0 \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

- (void)testInitNoKey_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"test_lfmkit_ios\", \
        \"subscriber\": 0 \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

- (void)testInitNullKey_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"test_lfmkit_ios\", \
        \"key\": null, \
        \"subscriber\": 0 \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

- (void)testInitNoSubscriber_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"test_lfmkit_ios\", \
        \"key\": \"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO\", \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

- (void)testInitNullSubscriber_ShouldFail {
    NSString *json =
    @"{ \
        \"name\": \"test_lfmkit_ios\", \
        \"key\": \"1irfXzHD5BaqXja0y-k5WeeFxWiRvLrO\", \
        \"subscriber\": null \
      }";
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    XCTAssertNotNil(dictionary);
    XCTAssertNil(error);
    
    XCTAssertNil([[LFMSession alloc] initFromDictionary:dictionary]);
}

@end
