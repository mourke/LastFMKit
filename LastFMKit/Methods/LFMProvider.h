//
//  LFMProvider.h
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

extern NSString * const APIEndpoint;

/// Remove all the query items from the url if there isn't a value because it breaks the last.fm api otherwise
#define LFMURLComponentsPredicate [NSPredicate predicateWithFormat:@"value != nil"]

@class NSError, LFMAlbum, LFMArtist, LFMTag, LFMUser, LFMTopTag, LFMTrack, LFMWiki, LFMChart, LFMSearchQuery, LFMQuery, LFMScrobbleResult;

@interface LFMProvider : NSObject

/**
 A callback only containing an error.
 
 If the error is `nil` this means the operation was a success.
 
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMErrorCallback)(NSError * _Nullable error);

/**
 A callback containing pagination information.
 
 @param items         An array.
 @param query       Information about the pagination request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMGenericPaginatedCallback)(NSArray *items, LFMQuery * _Nullable query, NSError * _Nullable error);

#pragma mark - Albums

/**
 A callback containing an album and an error.
 
 @param album   An `LFMAlbum` object if there was no error, is `nil` if there is an error.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMAlbumCallback)(LFMAlbum * _Nullable album, NSError * _Nullable error);

/**
 A callback containing an array of albums and an error.
 
 @param albums      An array of `LFMAlbum`s.
 @param error         An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMAlbumsCallback)(NSArray<LFMAlbum *> *albums, NSError * _Nullable error);

/**
 A callback containing search information.
 
 @param albums    An array of `LFMAlbum`s.
 @param query       Information about the search request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMAlbumSearchCallback)(NSArray<LFMAlbum *> *albums, LFMSearchQuery * _Nullable query, NSError * _Nullable error);

/**
 A callback containing pagination information.
 
 @param albums    An array of `LFMAlbum`s.
 @param query       Information about the pagination request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMAlbumPaginatedCallback)(NSArray<LFMAlbum *> *albums, LFMQuery * _Nullable query, NSError * _Nullable error);

#pragma mark - Artist

/**
 A callback containing an artist and an error.
 
 @param artist   An `LFMArtist` object if there was no error, is `nil` if there is an error.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMArtistCallback)(LFMArtist * _Nullable artist, NSError * _Nullable error);

/**
 A callback containing an array of artists and an error.
 
 @param artists     An array of `LFMArtist`s.
 @param error         An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMArtistsCallback)(NSArray<LFMArtist *> *artists, NSError * _Nullable error);

/**
 A callback containing search information.
 
 @param artists    An array of `LFMArtist`s.
 @param query       Information about the search request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMArtistSearchCallback)(NSArray<LFMArtist *> *artists, LFMSearchQuery * _Nullable query, NSError * _Nullable error);

/**
 A callback containing pagination information.
 
 @param artists    An array of `LFMArtist`s.
 @param query       Information about the pagination request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMArtistPaginatedCallback)(NSArray<LFMArtist *> *artists, LFMQuery * _Nullable query, NSError * _Nullable error);

#pragma mark - Track

/**
 A callback containing a track and an error.
 
 @param track   An `LFMTrack` object if there was no error, is `nil` if there is an error.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTrackCallback)(LFMTrack * _Nullable track, NSError * _Nullable error);

/**
 A callback containing an array of tracks and an error.
 
 @param tracks     An array of `LFMTrack`s.
 @param error         An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTracksCallback)(NSArray<LFMTrack *> *tracks, NSError * _Nullable error);

/**
 A callback containing pagination information.
 
 @param tracks    An array of `LFMTrack`s.
 @param query       Information about the pagination request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTrackPaginatedCallback)(NSArray<LFMTrack *> *tracks, LFMQuery * _Nullable query, NSError * _Nullable error);

/**
 A callback containing search information.
 
 @param tracks    An array of `LFMTrack`s.
 @param query       Information about the search request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTrackSearchCallback)(NSArray<LFMTrack *> *tracks, LFMSearchQuery * _Nullable query, NSError * _Nullable error);

#pragma mark - User

/**
 A callback containing a user and an error.
 
 @param user   An `LFMUser` object if there was no error, is `nil` if there is an error.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMUserCallback)(LFMUser * _Nullable user, NSError * _Nullable error);

/**
 A callback containing an array of users and an error.
 
 @param users         An array of `LFMUser`s.
 @param error         An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMUsersCallback)(NSArray<LFMUser *> *users, NSError * _Nullable error);

/**
 A callback containing pagination information.
 
 @param users       An array of `LFMUser`s.
 @param query       Information about the pagination request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMUserPaginatedCallback)(NSArray<LFMUser *> *users, LFMQuery * _Nullable query, NSError * _Nullable error);

#pragma mark - Scrobble Result

/**
 A callback containing an array of scrobble results and an error.
 
 @param results     An array of `LFMScrobbleResult`s.
 @param error         An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMScrobbleResultsCallback)(NSArray<LFMScrobbleResult *> *results, NSError * _Nullable error);

#pragma mark - Tag


/**
 A callback containing a tag and an error.
 
 @param tag       An `LFMTag` object if there was no error, is `nil` if there is an error.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTagCallback)(LFMTag * _Nullable tag, NSError * _Nullable error);

/**
 A callback only containing an array of tags and an error.
 
 @param tags    An array of `LFMTag`s.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTagsCallback)(NSArray<LFMTag *> *tags, NSError * _Nullable error);

/**
 A callback containing pagination information.
 
 @param tags         An array of `LFMTag`s.
 @param query       Information about the pagination request (current page etc.)
 @param error       An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTagPaginatedCallback)(NSArray<LFMTag *> *tags, LFMQuery * _Nullable query, NSError * _Nullable error);

/**
 A callback containing an array of top tags and an error.
 
 @param tags    An array of `LFMTopTag`s.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMTopTagsCallback)(NSArray<LFMTopTag *> *tags, NSError * _Nullable error);

#pragma mark - Chart

/**
 A callback containing an array of charts and an error.
 
 @param charts    An array of `LFMChart`s.
 @param error   An `NSError` object if an error occurred, is `nil` if there is no error.
 */
typedef void (^LFMChartsCallback)(NSArray<LFMChart *> *charts, NSError * _Nullable error);

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
