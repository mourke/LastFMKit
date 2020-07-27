//
//  LFMAlbumProviderTests.m
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

@interface LFMAlbumProviderTests : LFMTestCase

@end

@implementation LFMAlbumProviderTests {
    NSArray<LFMTag *> *_testTags;
    NSString *_testAlbumName;
    NSString *_testArtistName;
    NSString *_testAlbumReleaseMBID;
}

- (void)setUp {
    [super setUp];
    _testTags = @[[[LFMTag alloc] initWithName:@"Sweedish"],
                 [[LFMTag alloc] initWithName:@"Polish"]];
    _testAlbumName = @"My Everything";
    _testArtistName = @"Ariana Grande";
    _testAlbumReleaseMBID = @"92402a00-7be5-4c40-ac27-cf91622e2e5a";
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Add Tags

- (void)testAddTags_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors when all values are present."];
    
    [LFMAlbumProvider addTags:_testTags
                 toAlbumNamed:_testAlbumName
                byArtistNamed:_testArtistName
                     callback:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAddTags_ShouldPass_WithGiberishAlbumNameAndArtistName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors when the artist and album most certainly do not exist."];
    
    [LFMAlbumProvider addTags:_testTags
                 toAlbumNamed:@"lkasjdlkajskl"
                byArtistNamed:@"lkj9jas;d"
                     callback:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testAddTags_ShouldNotCrash_WithNoCallback {
    XCTAssertNoThrow([LFMAlbumProvider addTags:_testTags
                                  toAlbumNamed:_testAlbumName
                                 byArtistNamed:_testArtistName
                                      callback:nil]);
}

- (void)testAddTags_ShouldCrash_WithTagsLargerThan10 {
    NSArray<LFMTag *> *testTags = @[[[LFMTag alloc] initWithName:@"Sweedish"],
                                    [[LFMTag alloc] initWithName:@"Polish"],
                                    [[LFMTag alloc] initWithName:@"Sweedish"],
                                    [[LFMTag alloc] initWithName:@"Polish"],
                                    [[LFMTag alloc] initWithName:@"Sweedish"],
                                    [[LFMTag alloc] initWithName:@"Polish"],
                                    [[LFMTag alloc] initWithName:@"Sweedish"],
                                    [[LFMTag alloc] initWithName:@"Polish"],
                                    [[LFMTag alloc] initWithName:@"Sweedish"],
                                    [[LFMTag alloc] initWithName:@"Polish"],
                                    [[LFMTag alloc] initWithName:@"Sweedish"],
                                    [[LFMTag alloc] initWithName:@"Polish"]];
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider addTags:testTags
                                              toAlbumNamed:_testAlbumName
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testAddTags_ShouldCrash_WithNoSessionKey {
    [[LFMSession sharedSession] setValue:nil forKey:@"_sessionKey"];
    
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider addTags:_testTags
                                              toAlbumNamed:_testAlbumName
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

- (void)testAddTags_ShouldCrash_WithNoTags {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider addTags:nil
                                              toAlbumNamed:_testAlbumName
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testAddTags_ShouldCrash_WithNoAlbum {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider addTags:_testTags
                                              toAlbumNamed:nil
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testAddTags_ShouldCrash_WithNoArtist {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider addTags:_testTags
                                              toAlbumNamed:_testAlbumName
                                             byArtistNamed:nil
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

#pragma clang diagnostic pop

#pragma mark - Remove Tag

- (void)testRemoveTag_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors when all values are present."];
    
    [LFMAlbumProvider removeTag:_testTags.firstObject
                 fromAlbumNamed:_testAlbumName
                  byArtistNamed:_testArtistName
                       callback:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRemoveTag_ShouldPass_WhenNoTagExistsOnAlbum {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors when the tag trying to be removed never existed on the album."];
    
    [LFMAlbumProvider removeTag:[LFMTag tagWithName:@"laksjdlkasjdkl"]
                 fromAlbumNamed:_testAlbumName
                  byArtistNamed:_testArtistName
                       callback:^(NSError * _Nullable error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}

- (void)testRemoveTag_ShouldNotCrash_WithNoCallback {
    XCTAssertNoThrow([LFMAlbumProvider removeTag:_testTags.firstObject
                                  fromAlbumNamed:_testAlbumName
                                 byArtistNamed:_testArtistName
                                      callback:nil]);
}

- (void)testRemoveTag_ShouldCrash_WithNoSessionKey {
    [[LFMSession sharedSession] setValue:nil forKey:@"_sessionKey"];
    
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider removeTag:_testTags.firstObject
                                              fromAlbumNamed:_testAlbumName
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

- (void)testRemoveTag_ShouldCrash_WithNoTags {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider removeTag:nil
                                              fromAlbumNamed:_testAlbumName
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testRemoveTag_ShouldCrash_WithNoAlbum {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider removeTag:_testTags.firstObject
                                              fromAlbumNamed:nil
                                             byArtistNamed:_testArtistName
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testRemoveTag_ShouldCrash_WithNoArtist {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider removeTag:_testTags.firstObject
                                              fromAlbumNamed:_testAlbumName
                                             byArtistNamed:nil
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

#pragma mark - Album Info

- (void)testGetInfoOnAlbum_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getInfoOnAlbumNamed:_testAlbumName
                            byArtistNamed:_testArtistName
                                albumMBID:_testAlbumReleaseMBID
                              autoCorrect:YES
                              forUsername:self.testUsername
                             languageCode:@"en"
                                 callback:^(NSError * _Nullable error,
                                            LFMAlbum * _Nullable album) {
        XCTAssertNotNil(album);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0 handler:nil];
}


/*

    getTagsForAlbumNamed:(nullable NSString *)albumName
                                     byArtistNamed:(nullable NSString *)albumArtist
                                 withMusicBrainzId:(nullable NSString *)mbid
                                       autoCorrect:(BOOL)autoCorrect
                                           forUser:(nullable NSString *)username
                                          callback:(void (^)(NSError * _Nullable, NSArray <LFMTag *> *))block NS_SWIFT_NAME(getTags(forAlbum:by:mbid:autoCorrect:forUser:callback:));

    getTopTagsForAlbumNamed:(nullable NSString *)albumName
                                        byArtistNamed:(nullable NSString *)albumArtist
                                    withMusicBrainzId:(nullable NSString *)mbid
                                          autoCorrect:(BOOL)autoCorrect
                                             callback:(void (^)(NSError * _Nullable, NSArray <LFMTopTag *> *))block NS_SWIFT_NAME(getTopTags(for:by:mbid:autoCorrect:callback:));

    searchForAlbumNamed:(NSString *)albumName
                                     itemsPerPage:(NSUInteger)limit
                                           onPage:(NSUInteger)page
                                         callback:(void (^)(NSError * _Nullable, NSArray <LFMAlbum *> *, LFMSearchQuery * _Nullable))block
}
 
 */

@end