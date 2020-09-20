//
//  LFMAuthTests.m
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

#import "LFMTestCase.h"
#import <LastFMKit/LastFMKit.h>

@interface LFMAuthTests : LFMTestCase

@end

@implementation LFMAuthTests {
    LFMSession *_originalSession;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testUserAuth {
    [[LFMAuth sharedInstance] setValue:nil forKey:@"_session"]; // clear the test session that's already there
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Should not have any error."];
    
    [[[LFMAuth sharedInstance] getSessionWithUsername:@"test_lfmkit_ios"
                                             password:@"Eethu3po5wia&!"
                                             callback:^(LFMSession * _Nullable session, NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertNotNil(session);
        XCTAssertNotNil(session.sessionKey);
        XCTAssertNotNil(session.username);
        XCTAssertTrue([session.username isEqualToString:@"test_lfmkit_ios"]);
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

@end
