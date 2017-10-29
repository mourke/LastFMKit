//
//  LFMTagProvider.h
//  LastFMKit
//
//  Copyright © 2017 Mark Bourke.
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

@class LFMTag, LFMAlbum, LFMQuery, LFMArtist, LFMTrack;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(TagProvider)
@interface LFMTagProvider : NSObject

/**
 Retrieves metadata for a tag.
 
 @param tagName     The name of the tag to be fetched.
 @param language    The language in which to return the wiki, expressed as an ISO 639 alpha-2 code.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMTag` object if it succeeds.
 
 @returns   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getInfoOnTagNamed:(NSString *)tagName
                                   language:(nullable NSString *)language
                                   callback:(void(^)(NSError * _Nullable, LFMTag * _Nullable))block NS_SWIFT_NAME(getInfo(on:in:callback:));

/**
 Retrieves the top global tags on Last.fm, sorted by popularity (number of times used).
 
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMTag`s if it succeeds.
 
 @returns   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopTagsWithCallback:(void(^)(NSError * _Nullable, NSArray<LFMTag *> *))block NS_SWIFT_NAME(getTopTags(callback:));

/**
 Retrieves tags similar to a specified tag. Returns tags ranked by similarity, based on listening data.
 
 @param tagName The name of the tag.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMTag` objects if the request succeeds.
 
 @returns   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTagsSimilarToTagNamed:(NSString *)tagName
                                          callback:(void (^)(NSError * _Nullable, NSArray<LFMTag *> *))block NS_SWIFT_NAME(getTagsSimilar(to:callback:));

/**
 Retrieves the top albums tagged by this tag, ordered by tag count.
 
 @param tagName The name of the tag.
 @param page    The page of results to be fetched. Start page is 1 and is also the default value.
 @param limit   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMQuery` object if it succeeds.
 
 @returns   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopAlbumsTaggedByTagNamed:(NSString *)tagName
                                          itemsPerPage:(NSUInteger)limit
                                                onPage:(NSUInteger)page
                                              callback:(void(^)(NSError * _Nullable, NSArray<LFMAlbum *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTopAlbumsTagged(by:limit:on:callback:));

/**
 Retrieves the top artists tagged by this tag, ordered by tag count.
 
 @param tagName The name of the tag.
 @param page    The page of results to be fetched. Start page is 1 and is also the default value.
 @param limit   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist`s and an `LFMQuery` object if it succeeds.
 
 @returns   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopArtistsTaggedByTagNamed:(NSString *)tagName
                                           itemsPerPage:(NSUInteger)limit
                                                 onPage:(NSUInteger)page
                                               callback:(void(^)(NSError * _Nullable, NSArray<LFMArtist *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTopArtistsTagged(by:limit:on:callback:));

/**
 Retrieves the top tracks tagged by this tag, ordered by tag count.
 
 @param tagName The name of the tag.
 @param page    The page of results to be fetched. Start page is 1 and is also the default value.
 @param limit   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack`s and an `LFMQuery` object if it succeeds.
 
 @returns   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopTracksTaggedByTagNamed:(NSString *)tagName
                                          itemsPerPage:(NSUInteger)limit
                                                onPage:(NSUInteger)page
                                              callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTopTracksTagged(by:limit:on:callback:));


@end

NS_ASSUME_NONNULL_END
