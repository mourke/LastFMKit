//
//  LFMGeoProvider.h
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

@class LFMArtist, LFMQuery, LFMTrack;

NS_ASSUME_NONNULL_BEGIN

/*
 This class provides helper methods for looking up geographical info using Last.fm.
 */
NS_SWIFT_NAME(GeoProvider)
@interface LFMGeoProvider : LFMProvider

/**
 Retrieves the top artists in a specific country.
 
 @param country A country name, as defined by the ISO 3166-1 country names standard.
 @param page    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 30.
 @param limit   The maximum number of artists to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param block   The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist`s and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopArtistsInCountry:(NSString *)country
                                    itemsPerPage:(nullable NSNumber *)limit
                                          onPage:(nullable NSNumber *)page
                                        callback:(LFMArtistPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tracks in a specific country.
 
 @param country     A country name, as defined by the ISO 3166-1 country names standard.
 @param province    A metropoiltan name, to narrow down the geographical search result (must be within the country specified).
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 30.
 @param limit       The maximum number of tracks to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack`s and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopTracksInCountry:(NSString *)country
                                 withinProvince:(nullable NSString *)province
                                   itemsPerPage:(nullable NSNumber *)limit
                                         onPage:(nullable NSNumber *)page
                                       callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
