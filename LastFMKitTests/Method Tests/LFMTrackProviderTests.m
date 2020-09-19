//
//  LFMTrackProviderTests.m
//  LastFMKit
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
@interface LFMTrackProviderTests : LFMTestCase

@end

@implementation LFMTrackProviderTests {
    NSArray<LFMScrobbleTrack *> *_testScrobbleTracks;
}

- (void)setUp {
    [super setUp];
    
    _testScrobbleTracks = @[[[LFMScrobbleTrack alloc] initWithName:@"Emotion"
                            artistName:@"Ella Mai"
                            albumName:@"Ella Mai"
                            albumArtist:@"Ella Mai"
                            positionInAlbum:@1
                            duration:@12
                            timestamp:[NSDate new]
                            chosenByUser:YES]];
}



- (void)testScrobbleTrack_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors when all values are present."];
    
    [[LFMTrackProvider scrobbleTracks:_testScrobbleTracks callback:^(NSArray<LFMScrobbleResult *> *results,
                                                                     NSError * _Nullable error) {
        XCTAssertNil(error);
        XCTAssertEqual(results.count, self->_testScrobbleTracks.count);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testNowPlaying_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors when all values are present."];
    
    [[LFMTrackProvider updateNowPlayingWithTrack:_testScrobbleTracks.firstObject callback:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        
        [expectation fulfill];
    }] resume];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

@end
