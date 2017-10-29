//
//  LastFMKitTests.m
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

#import <XCTest/XCTest.h>

#import <LastFMKit/LastFMKit.h>

@interface LastFMKitTests: XCTestCase

@end

@implementation LastFMKitTests

- (void)setUp {
    [super setUp];

    [[LFMAuth sharedInstance] setApiKey:@"bc15dd6972bc0f7c952273b34d253a6a"];
    [[LFMAuth sharedInstance] setApiSecret:@"d46ca773c61a3907c0b19c777c5bcf20"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAlbumSearch {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Search albums"];

    [LFMAlbumProvider searchForAlbumNamed:@"My Everything" itemsPerPage:50 onPage:1 callback:^(NSError * _Nullable error, NSArray<LFMAlbum *> * _Nonnull albums, LFMSearchQuery * _Nullable searchQuery) {
        XCTAssertNil(error, @"Failed to create session %@", error);
        XCTAssertFalse(albums.count == 0, @"Search results were empty");
        XCTAssertNotNil(searchQuery, @"Search failed.");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

@end
