//
//  LFMUserProvider.h
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
#import "LFMTaggingType.h"
#import "LFMTimePeriod.h"

@class LFMURLOperation, LFMUser, LFMQuery, LFMTrack, LFMAlbum, LFMArtist, LFMTopTag, LFMChart;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for interacting with a user's information on Last.fm.
 */
NS_SWIFT_NAME(UserProvider)
@interface LFMUserProvider : LFMProvider

/**
 Retrieves information about a user's profile.
 
 @param username    The user to fetch info for.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMUser` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getInfoOnUserNamed:(NSString *)username
                                    callback:(LFMUserCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves a list of a user's friends on Last.fm.
 
 @param username        The name of the user whose friends are to be fetched.
 @param includeRecents  A boolean value indiciating whether or not to include information about a friend's recently played tracks.
 @param limit           The maximum number of friends to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page            The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param block           The callback block containing an optional `NSError` if the request fails and an array of `LFMUser` objects and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getFriendsOfUserNamed:(NSString *)username
                         includeRecentScrobbles:(BOOL)includeRecents
                                   itemsPerPage:(nullable NSNumber *)limit
                                         onPage:(nullable NSNumber *)page
                                       callback:(LFMUserPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves a list of tracks by a given artist scrobbled by a user, including scrobble time. Can be limited to specific timeranges, defaults to all time.
 
 @param username    The name of the user whose scrobbles are to be fetched.
 @param artistName  The scrobbled tracks' artist.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param startDate   The earliest date from which to fetch scrobbles.
 @param endDate     The latest date from which to fetch scrobbles.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTracksScrobbledByUserNamed:(NSString *)username
                                          byArtistNamed:(NSString *)artistName
                                                 onPage:(nullable NSNumber *)page
                                          fromStartDate:(nullable NSDate *)startDate
                                              toEndDate:(nullable NSDate *)endDate
                                               callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the last 50 tracks loved by a user.
 
 @param username    The user for whom to fetch the loved tracks.
 @param limit       The maximum number of tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTracksLovedByUserNamed:(NSString *)username
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                           callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves items to which the user added personal tags.
 
 @param username    The user who performed the taggings.
 @param tagName     The name of the tag to which the user applied the items.
 @param type        The type of the items to be returned.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of the specified type (`LFMAritst`s, `LFMTrack`s, `LFMAlbum`s) and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getItemsTaggedByUserNamed:(NSString *)username
                                        forTagNamed:(NSString *)tagName
                                           itemType:(LFMTaggingType)type
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                           callback:(LFMGenericPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves a list of the recent tracks listened to by this user.
 
 @param username    The user for whom to fetch recent tracks.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param startDate   The earliest date from which to fetch tracks.
 @param endDate     The latest date from which to fetch tracks.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getRecentTracksForUsername:(NSString *)username
                                         itemsPerPage:(nullable NSNumber *)limit
                                               onPage:(nullable NSNumber *)page
                                        fromStartDate:(nullable NSDate *)startDate
                                            toEndDate:(nullable NSDate *)endDate
                                             callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top albums listened to by a user. The period can be stipulated. Sends the overall chart by default.
 
 @param username    The user for whom to fetch top albums.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param period      The time period over which to retrieve top albums.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopAlbumsForUsername:(NSString *)username
                                      itemsPerPage:(nullable NSNumber *)limit
                                            onPage:(nullable NSNumber *)page
                                        overPeriod:(nullable LFMTimePeriod)period
                                          callback:(LFMAlbumPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top artists listened to by a user. The period can be stipulated. Sends the overall chart by default.
 
 @param username    The user for whom to fetch top artists.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param period      The time period over which to retrieve top artists.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopArtistsForUsername:(NSString *)username
                                       itemsPerPage:(nullable NSNumber *)limit
                                             onPage:(nullable NSNumber *)page
                                         overPeriod:(nullable LFMTimePeriod)period
                                           callback:(LFMArtistPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tracks listened to by a user. The period can be stipulated. Sends the overall chart by default.
 
 @param username    The user for whom to fetch top tracks.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param period      The time period over which to retrieve top tracks.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTracksForUsername:(NSString *)username
                                      itemsPerPage:(nullable NSNumber *)limit
                                            onPage:(nullable NSNumber *)page
                                        overPeriod:(nullable LFMTimePeriod)period
                                          callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tags used by this user.
 
 @param username    The user for whom to fetch top tags.
 @param limit       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag` objects and an `LFMQuery` object if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTagsForUsername:(NSString *)username
                                           limit:(nullable NSNumber *)limit
                                        callback:(LFMTopTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves an album chart for a user profile, for a given date range. If no date range is supplied, the most recent album chart for this user will be returned.
 
 @param username    The user for whom to fetch album charts.
 @param startDate   The date from which the chart should start.
 @param endDate     The date on which the chart should end.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum` objects if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getWeeklyAlbumChartForUsername:(NSString *)username
                                            fromStartDate:(nullable NSDate *)startDate
                                                toEndDate:(nullable NSDate *)endDate
                                                 callback:(LFMAlbumsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves an artist chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent artist chart for this user.
 
 @param username    The user for whom to fetch artist charts.
 @param startDate   The date from which the chart should start.
 @param endDate     The date on which the chart should end.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist` objects if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getWeeklyArtistChartForUsername:(NSString *)username
                                             fromStartDate:(nullable NSDate *)startDate
                                                 toEndDate:(nullable NSDate *)endDate
                                                  callback:(LFMArtistsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves a track chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent track chart for this user.
 
 @param username    The user for whom to fetch track charts.
 @param startDate   The date from which the chart should start.
 @param endDate     The date on which the chart should end.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getWeeklyTrackChartForUsername:(NSString *)username
                                            fromStartDate:(nullable NSDate *)startDate
                                                toEndDate:(nullable NSDate *)endDate
                                                 callback:(LFMTracksCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves a list of available charts for this user, expressed as date ranges which can be sent to the chart services.
 
 @param username    The user for whom to fetch chart lists.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMChart` objects if it succeeds.
 
 @return    The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getWeeklyChartListForUsername:(NSString *)username
                                                callback:(LFMChartsCallback)block NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END

