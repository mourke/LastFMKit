//
//  LFMTagProvider.h
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

#import "LFMProvider.h"

@class LFMURLOperation, LFMTag, LFMAlbum, LFMQuery, LFMArtist, LFMTrack;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for looking up tags on Last.fm.
 */
NS_SWIFT_NAME(TagProvider)
@interface LFMTagProvider : LFMProvider

/**
 Retrieves metadata for a tag.
 
 @param tagName     The name of the tag to be fetched.
 @param language    The language in which to return the wiki, expressed as an ISO 639 alpha-2 code.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMTag` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getInfoOnTagNamed:(NSString *)tagName
                                   language:(nullable NSString *)language
                                   callback:(LFMTagCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top global tags on Last.fm, sorted by popularity (number of times used).
 
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMTag`s if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTagsWithCallback:(LFMTopTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves tags similar to a specified tag. Returns tags ranked by similarity, based on listening data.
 
 @param tagName The name of the tag.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMTag` objects if the request succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTagsSimilarToTagNamed:(NSString *)tagName
                                          callback:(LFMTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top albums tagged by this tag, ordered by tag count.
 
 @param tagName The name of the tag.
 @param page    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param limit   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopAlbumsTaggedByTagNamed:(NSString *)tagName
                                          itemsPerPage:(nullable NSNumber *)limit
                                                onPage:(nullable NSNumber *)page
                                              callback:(LFMAlbumPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top artists tagged by this tag, ordered by tag count.
 
 @param tagName The name of the tag.
 @param page    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param limit   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist`s and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopArtistsTaggedByTagNamed:(NSString *)tagName
                                           itemsPerPage:(nullable NSNumber *)limit
                                                 onPage:(nullable NSNumber *)page
                                               callback:(LFMArtistPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tracks tagged by this tag, ordered by tag count.
 
 @param tagName The name of the tag.
 @param page    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param limit   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack`s and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTracksTaggedByTagNamed:(NSString *)tagName
                                          itemsPerPage:(nullable NSNumber *)limit
                                                onPage:(nullable NSNumber *)page
                                              callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;


@end

NS_ASSUME_NONNULL_END
