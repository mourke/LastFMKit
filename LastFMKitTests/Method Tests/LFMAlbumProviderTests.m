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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetInfoOnAlbum_ShouldPass_WithAllNoUsername {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getInfoOnAlbumNamed:_testAlbumName
                            byArtistNamed:_testArtistName
                                albumMBID:_testAlbumReleaseMBID
                              autoCorrect:YES
                              forUsername:nil
                             languageCode:@"en"
                                 callback:^(NSError * _Nullable error,
                                            LFMAlbum * _Nullable album) {
        XCTAssertNotNil(album);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetInfoOnAlbum_ShouldPass_WithAllNoLanguageCode {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getInfoOnAlbumNamed:_testAlbumName
                            byArtistNamed:_testArtistName
                                albumMBID:_testAlbumReleaseMBID
                              autoCorrect:YES
                              forUsername:self.testUsername
                             languageCode:nil
                                 callback:^(NSError * _Nullable error,
                                            LFMAlbum * _Nullable album) {
        XCTAssertNotNil(album);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetInfoOnAlbum_ShouldPass_WithNoAlbumName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getInfoOnAlbumNamed:nil
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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetInfoOnAlbum_ShouldPass_WithNoAlbumNameAndNoArtistName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getInfoOnAlbumNamed:nil
                            byArtistNamed:nil
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
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetInfoOnAlbum_ShouldPass_WithNoMBID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getInfoOnAlbumNamed:_testAlbumName
                            byArtistNamed:_testArtistName
                                albumMBID:nil
                              autoCorrect:YES
                              forUsername:self.testUsername
                             languageCode:@"en"
                                 callback:^(NSError * _Nullable error,
                                            LFMAlbum * _Nullable album) {
        XCTAssertNotNil(album);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetInfoOnAlbum_ShouldCrash_WithNoCallback {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getInfoOnAlbumNamed:_testAlbumName
                                             byArtistNamed:_testArtistName
                                                 albumMBID:_testAlbumReleaseMBID
                                               autoCorrect:YES
                                               forUsername:self.testUsername
                                              languageCode:@"en"
                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testGetInfoOnAlbum_ShouldCrash_WithNoAlbumNameAndNoArtistNameAndNoMBID {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getInfoOnAlbumNamed:nil
                                                         byArtistNamed:nil
                                                             albumMBID:nil
                                                           autoCorrect:YES
                                                           forUsername:self.testUsername
                                                          languageCode:@"en"
                                                              callback:^(NSError * _Nullable error,
                                                                         LFMAlbum * _Nullable album) {}],
                                 NSException, NSInternalInconsistencyException);
}

#pragma mark - Tags

- (void)testGetTags_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTagsForAlbumNamed:_testAlbumName
                             byArtistNamed:_testArtistName
                         withMusicBrainzId:_testAlbumReleaseMBID
                               autoCorrect:YES
                               forUsername:self.testUsername
                                  callback:^(NSError * _Nullable error,
                                             NSArray<LFMTag *> * tags) {
        XCTAssertNotNil(tags);
        XCTAssertGreaterThan(tags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetTags_ShouldPass_WithAllNoUsernameOnly {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTagsForAlbumNamed:_testAlbumName
                             byArtistNamed:_testArtistName
                         withMusicBrainzId:_testAlbumReleaseMBID
                               autoCorrect:YES
                               forUsername:nil
                                  callback:^(NSError * _Nullable error,
                                             NSArray<LFMTag *> * tags) {
        XCTAssertNotNil(tags);
        XCTAssertGreaterThan(tags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetTags_ShouldCrash_WithNoUsernameOrSessionKey {
    [[LFMAuth sharedInstance] setValue:nil forKey:@"_session"]; // clear the test session that's already there
    
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getTagsForAlbumNamed:_testAlbumName
                                                          byArtistNamed:_testArtistName
                                                      withMusicBrainzId:_testAlbumReleaseMBID
                                                            autoCorrect:YES
                                                            forUsername:nil
                                                               callback:^(NSError * _Nullable error,
                                                                          NSArray<LFMTag *> * tags) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testGetTags_ShouldPass_WithNoAlbumNameAndNoArtistName {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTagsForAlbumNamed:nil
                             byArtistNamed:nil
                         withMusicBrainzId:_testAlbumReleaseMBID
                               autoCorrect:YES
                               forUsername:self.testUsername
                                  callback:^(NSError * _Nullable error,
                                             NSArray<LFMTag *> * tags) {
        XCTAssertNotNil(tags);
        XCTAssertGreaterThan(tags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetTags_ShouldPass_WithNoMBID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTagsForAlbumNamed:_testAlbumName
                             byArtistNamed:_testArtistName
                         withMusicBrainzId:nil
                               autoCorrect:YES
                               forUsername:self.testUsername
                                  callback:^(NSError * _Nullable error,
                                             NSArray<LFMTag *> * tags) {
        XCTAssertNotNil(tags);
        XCTAssertGreaterThan(tags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetTags_ShouldCrash_WithNoCallback {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getTagsForAlbumNamed:_testAlbumName
                                                          byArtistNamed:_testArtistName
                                                      withMusicBrainzId:_testAlbumReleaseMBID
                                                            autoCorrect:YES
                                                            forUsername:self.testUsername
                                                               callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testGetTags_ShouldCrash_WithNoAlbumNameAndNoArtistNameAndNoMBID {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getTagsForAlbumNamed:nil
                                                          byArtistNamed:nil
                                                      withMusicBrainzId:nil
                                                            autoCorrect:YES
                                                            forUsername:self.testUsername
                                                               callback:^(NSError * _Nullable error, NSArray<LFMTag *> * tags) {}],
                                 NSException, NSInternalInconsistencyException);
}

#pragma mark - Top Tags

- (void)testGetTopTags_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTopTagsForAlbumNamed:_testAlbumName
                                byArtistNamed:_testArtistName
                            withMusicBrainzId:_testAlbumReleaseMBID
                                  autoCorrect:YES
                                     callback:^(NSError * _Nullable error,
                                                NSArray<LFMTopTag *> * topTags) {
        XCTAssertNotNil(topTags);
        XCTAssertGreaterThan(topTags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetTopTags_ShouldPass_WithNoMBID {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTopTagsForAlbumNamed:_testAlbumName
                                byArtistNamed:_testArtistName
                            withMusicBrainzId:nil
                                  autoCorrect:YES
                                     callback:^(NSError * _Nullable error,
                                                NSArray<LFMTopTag *> * topTags) {
        XCTAssertNotNil(topTags);
        XCTAssertGreaterThan(topTags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}


- (void)testGetTopTags_ShouldPass_WithNoAlbumNameAndNoArtistName {
    XCTSkip("This is broken on API side and will always fail");
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider getTopTagsForAlbumNamed:nil
                                byArtistNamed:nil
                            withMusicBrainzId:_testAlbumReleaseMBID
                                  autoCorrect:YES
                                     callback:^(NSError * _Nullable error,
                                                NSArray<LFMTopTag *> * topTags) {
        XCTAssertNotNil(topTags);
        XCTAssertGreaterThan(topTags.count, 0);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testGetTopTags_ShouldCrash_WithNoAlbumNameAndNoArtistNameAndNoMBID {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getTopTagsForAlbumNamed:nil
                                                             byArtistNamed:nil
                                                         withMusicBrainzId:nil
                                                               autoCorrect:YES
                                                                  callback:^(NSError * _Nullable error, NSArray<LFMTopTag *> * topTags) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testGetTopTags_ShouldCrash_WithNoCallback {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider getTopTagsForAlbumNamed:_testAlbumName
                                                             byArtistNamed:_testArtistName
                                                         withMusicBrainzId:_testAlbumReleaseMBID
                                                               autoCorrect:YES
                                                                  callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

#pragma mark - Search

- (void)testSearch_ShouldPass_WithAllInfoPresent {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                             itemsPerPage:30
                                   onPage:1
                                 callback:^(NSError * _Nullable error,
                                            NSArray<LFMAlbum *> * albums,
                                            LFMSearchQuery * _Nullable query) {
        XCTAssertNotNil(albums);
        XCTAssertGreaterThan(albums.count, 0);
        XCTAssertNotNil(query);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testSearch_ShouldPass_WithDefaultLimitAndPageBeingUsed {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                 callback:^(NSError * _Nullable error,
                                            NSArray<LFMAlbum *> * albums,
                                            LFMSearchQuery * _Nullable query) {
        XCTAssertNotNil(albums);
        XCTAssertGreaterThan(albums.count, 0);
        XCTAssertNotNil(query);
        XCTAssertEqual(query.currentPage, 1);
        XCTAssertEqual(query.itemsPerPage, 30);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testSearch_ShouldPass_WithDefaultLimitUsed {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                   onPage:2
                                 callback:^(NSError * _Nullable error,
                                            NSArray<LFMAlbum *> * albums,
                                            LFMSearchQuery * _Nullable query) {
        XCTAssertNotNil(albums);
        XCTAssertGreaterThan(albums.count, 0);
        XCTAssertNotNil(query);
        XCTAssertEqual(query.currentPage, 2);
        XCTAssertEqual(query.itemsPerPage, 30);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testSearch_ShouldPass_WithDefaultPageUsed {
    XCTestExpectation *expectation = [self expectationWithDescription:@"API should not return any errors and should return a valid LFMAlbum when all values are present."];
    
    [LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                             itemsPerPage:25
                                 callback:^(NSError * _Nullable error,
                                            NSArray<LFMAlbum *> * albums,
                                            LFMSearchQuery * _Nullable query) {
        XCTAssertNotNil(albums);
        XCTAssertGreaterThan(albums.count, 0);
        XCTAssertNotNil(query);
        XCTAssertEqual(query.currentPage, 1);
        XCTAssertEqual(query.itemsPerPage, 25);
        XCTAssertNil(error);
        [expectation fulfill];
    }];
        
    [self waitForExpectationsWithTimeout:TestRequestTimeout handler:nil];
}

- (void)testSearch_ShouldCrash_WithNoAlbumName {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider searchForAlbumNamed:nil
                                                                  callback:^(NSError * _Nullable error, NSArray<LFMAlbum *> * albums, LFMSearchQuery * _Nullable query) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testSearch_ShouldCrash_WithZeroPage {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                                                onPage:0
                                                                  callback:^(NSError * _Nullable error, NSArray<LFMAlbum *> * albums, LFMSearchQuery * _Nullable query) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testSearch_ShouldCrash_WithOutOfBoundsPage {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                                                onPage:10001
                                                                  callback:^(NSError * _Nullable error, NSArray<LFMAlbum *> * albums, LFMSearchQuery * _Nullable query) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testSearch_ShouldCrash_WithZeroLimit {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                                          itemsPerPage:0
                                                                  callback:^(NSError * _Nullable error, NSArray<LFMAlbum *> * albums, LFMSearchQuery * _Nullable query) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testSearch_ShouldCrash_WithOutOfBoundsLimit {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                                          itemsPerPage:10001
                                                                  callback:^(NSError * _Nullable error, NSArray<LFMAlbum *> * albums, LFMSearchQuery * _Nullable query) {}],
                                 NSException, NSInternalInconsistencyException);
}

- (void)testSearch_ShouldCrash_WithNoCallback {
    XCTAssertThrowsSpecificNamed([LFMAlbumProvider searchForAlbumNamed:_testAlbumName
                                                              callback:nil],
                                 NSException, NSInternalInconsistencyException);
}

@end
