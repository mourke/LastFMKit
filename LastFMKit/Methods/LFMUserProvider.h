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
#import "LFMTaggingType.h"
#import "LFMTimePeriod.h"

@class LFMUser, LFMQuery, LFMTrack, LFMAlbum, LFMArtist, LFMTopTag, LFMChart;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for interacting with a user's information on Last.fm.
 */
NS_SWIFT_NAME(UserProvider)
@interface LFMUserProvider : NSObject

/**
 Retrieves information about a user's profile.
 
 @param username    The user to fetch info for.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMUser` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getInfoOnUserNamed:(NSString *)username
                                    callback:(void(^)(NSError * _Nullable, LFMUser * _Nullable))block NS_SWIFT_NAME(getInfo(on:callback:));

/**
 Retrieves a list of a user's friends on Last.fm.
 
 @param username        The name of the user whose friends are to be fetched.
 @param includeRecents  A boolean value indiciating whether or not to include information about a friend's recently played tracks.
 @param limit           The maximum number of friends to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page            The page of results to be fetched. Start page is 1 and is also the default value.
 @param block           The callback block containing an optional `NSError` if the request fails and an array of `LFMUser` objects and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getFriendsOfUserNamed:(NSString *)username
                         includeRecentScrobbles:(BOOL)includeRecents
                                   itemsPerPage:(NSUInteger)limit
                                         onPage:(NSUInteger)page
                                       callback:(void(^)(NSError * _Nullable, NSArray<LFMUser *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getFriends(of:includingRecents:limit:on:callback:));

/**
 Retrieves a list of tracks by a given artist scrobbled by a user, including scrobble time. Can be limited to specific timeranges, defaults to all time.
 
 @param username    The name of the user whose scrobbles are to be fetched.
 @param artistName  The scrobbled tracks' artist.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param startDate   The earliest date from which to fetch scrobbles.
 @param endDate     The latest date from which to fetch scrobbles.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTracksScrobbledByUserNamed:(NSString *)username
                                          byArtistNamed:(NSString *)artistName
                                                 onPage:(NSUInteger)page
                                          fromStartDate:(nullable NSDate *)startDate
                                              toEndDate:(nullable NSDate *)endDate
                                               callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTracksScrobbled(by:artist:on:from:to:callback:));

/**
 Retrieves the last 50 tracks loved by a user.
 
 @param username    The user for whom to fetch the loved tracks.
 @param limit       The maximum number of tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTracksLovedByUserNamed:(NSString *)username
                                       itemsPerPage:(NSUInteger)limit
                                             onPage:(NSUInteger)page
                                           callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTracksLoved(by:limit:on:callback:));

/**
 Retrieves items to which the user added personal tags.
 
 @param username    The user who performed the taggings.
 @param tagName     The name of the tag to which the user applied the items.
 @param type        The type of the items to be returned.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of the specified type (`LFMAritst`s, `LFMTrack`s, `LFMAlbum`s) and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getItemsTaggedByUserNamed:(NSString *)username
                                        forTagNamed:(NSString *)tagName
                                           itemType:(LFMTaggingType)type
                                       itemsPerPage:(NSUInteger)limit
                                             onPage:(NSUInteger)page
                                           callback:(void(^)(NSError * _Nullable, NSArray *, LFMQuery * _Nullable))block NS_REFINED_FOR_SWIFT;

/**
 Retrieves a list of the recent tracks listened to by this user.
 
 @param username    The user for whom to fetch recent tracks.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param startDate   The earliest date from which to fetch tracks.
 @param endDate     The latest date from which to fetch tracks.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getRecentTracksForUsername:(NSString *)username
                                         itemsPerPage:(NSUInteger)limit
                                               onPage:(NSUInteger)page
                                        fromStartDate:(nullable NSDate *)startDate
                                            toEndDate:(nullable NSDate *)endDate
                                             callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getRecentTracks(for:limit:on:from:to:callback:));

/**
 Retrieves the top albums listened to by a user. The period can be stipulated. Sends the overall chart by default.
 
 @param username    The user for whom to fetch top albums.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param period      The time period over which to retrieve top albums.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopAlbumsForUsername:(NSString *)username
                                      itemsPerPage:(NSUInteger)limit
                                            onPage:(NSUInteger)page
                                        overPeriod:(nullable LFMTimePeriod)period
                                          callback:(void(^)(NSError * _Nullable, NSArray<LFMAlbum *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTopAlbums(for:limit:on:over:callback:));

/**
 Retrieves the top artists listened to by a user. The period can be stipulated. Sends the overall chart by default.
 
 @param username    The user for whom to fetch top artists.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param period      The time period over which to retrieve top artists.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopArtistsForUsername:(NSString *)username
                                       itemsPerPage:(NSUInteger)limit
                                             onPage:(NSUInteger)page
                                         overPeriod:(nullable LFMTimePeriod)period
                                           callback:(void(^)(NSError * _Nullable, NSArray<LFMArtist *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTopArtists(for:limit:on:over:callback:));

/**
 Retrieves the top tracks listened to by a user. The period can be stipulated. Sends the overall chart by default.
 
 @param username    The user for whom to fetch top tracks.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param period      The time period over which to retrieve top tracks.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopTracksForUsername:(NSString *)username
                                      itemsPerPage:(NSUInteger)limit
                                            onPage:(NSUInteger)page
                                        overPeriod:(nullable LFMTimePeriod)period
                                          callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMQuery * _Nullable))block NS_SWIFT_NAME(getTopTracks(for:limit:on:over:callback:));

/**
 Retrieves the top tags used by this user.
 
 @param username    The user for whom to fetch top tags.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopTagsForUsername:(NSString *)username
                                           limit:(NSUInteger)limit
                                        callback:(void(^)(NSError * _Nullable, NSArray<LFMTopTag *> *))block NS_SWIFT_NAME(getTopTags(for:limit:callback:));

/**
 Retrieves an album chart for a user profile, for a given date range. If no date range is supplied, the most recent album chart for this user will be returned.
 
 @param username    The user for whom to fetch album charts.
 @param startDate   The date from which the chart should start.
 @param endDate     The date on which the chart should end.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum` objects if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getWeeklyAlbumChartForUsername:(NSString *)username
                                            fromStartDate:(nullable NSDate *)startDate
                                                toEndDate:(nullable NSDate *)endDate
                                                 callback:(void(^)(NSError * _Nullable, NSArray<LFMAlbum *> *))block NS_SWIFT_NAME(getWeeklyAlbumChart(for:from:to:callback:));

/**
 Retrieves an artist chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent artist chart for this user.
 
 @param username    The user for whom to fetch artist charts.
 @param startDate   The date from which the chart should start.
 @param endDate     The date on which the chart should end.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist` objects if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getWeeklyArtistChartForUsername:(NSString *)username
                                             fromStartDate:(nullable NSDate *)startDate
                                                 toEndDate:(nullable NSDate *)endDate
                                                  callback:(void(^)(NSError * _Nullable, NSArray<LFMArtist *> *))block NS_SWIFT_NAME(getWeeklyArtistChart(for:from:to:callback:));

/**
 Retrieves a track chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent track chart for this user.
 
 @param username    The user for whom to fetch track charts.
 @param startDate   The date from which the chart should start.
 @param endDate     The date on which the chart should end.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getWeeklyTrackChartForUsername:(NSString *)username
                                            fromStartDate:(nullable NSDate *)startDate
                                                toEndDate:(nullable NSDate *)endDate
                                                 callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *))block NS_SWIFT_NAME(getWeeklyTrackChart(for:from:to:callback:));

/**
 Retrieves a list of available charts for this user, expressed as date ranges which can be sent to the chart services.
 
 @param username    The user for whom to fetch chart lists.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMChart` objects if it succeeds.
 
 @return    The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getWeeklyChartListForUsername:(NSString *)username
                                                callback:(void(^)(NSError * _Nullable, NSArray<LFMChart *> *))block NS_SWIFT_NAME(getWeeklyChartList(for:callback:));

@end

NS_ASSUME_NONNULL_END

