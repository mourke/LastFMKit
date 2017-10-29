//
//  LFMUserProvider.h
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

@class LFMUser, LFMQuery, LFMTrack;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for interacting with a user's information on Last.fm.
 */
NS_SWIFT_NAME(UserProvider)
@interface LFMUserProvider : NSObject

/**
 Retrieves information about a user's profile.
 
 @param userName    The user to fetch info for.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMUser` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getInfoOnUserNamed:(NSString *)userName
                                    callback:(void(^)(NSError * _Nullable, LFMUser * _Nullable))block NS_SWIFT_NAME(getInfo(on:callback:));

/**
 Retrieves a list of a user's friends on Last.fm.
 
 @param userName        The name of the user whose friends are to be fetched.
 @param includeRecents  A boolean value indiciating whether or not to include information about a friend's recently played tracks.
 @param limit           The maximum number of friends to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page            The page of results to be fetched. Start page is 1 and is also the default value.
 @param block           The callback block containing an optional `NSError` if the request fails and an array of `LFMUser` objects and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getFriendsOfUserNamed:(NSString *)userName
                         includeRecentScrobbles:(BOOL)includeRecents
                                   itemsPerPage:(NSUInteger)limit
                                         onPage:(NSUInteger)page
                                       callback:(void(^)(NSError * _Nullable, NSArray<LFMUser *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getFriends(of:includingRecents:limit:on:callback:));

/**
 Retrieves a list of tracks by a given artist scrobbled by a user, including scrobble time. Can be limited to specific timeranges, defaults to all time.
 
 @param userName    The name of the user whose scrobbles are to be fetched.
 @param artistName  The scrobbled tracks' artist.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param startDate   The earliest date from which to fetch scrobbles.
 @param endDate     The latest date from which to fetch scrobbles.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTracksScrobbledByUserNamed:(NSString *)userName
                                          byArtistNamed:(NSString *)artistName
                                                 onPage:(NSUInteger)page
                                          fromStartDate:(nullable NSDate *)startDate
                                              toEndDate:(nullable NSDate *)endDate
                                               callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTracksScrobbled(by:artist:on:from:to:callback:));

/**
 Retrieves the last 50 tracks loved by a user.
 
 @param userName    The user for which to fetch the loved tracks.
 @param limit       The maximum number of tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTracksLovedByUserNamed:(NSString *)userName
                                       itemsPerPage:(NSUInteger)limit
                                             onPage:(NSUInteger)page
                                           callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTracksLoved(by:limit:on:callback:));

@end

NS_ASSUME_NONNULL_END
