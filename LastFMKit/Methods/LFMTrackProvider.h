//
//  LFMTrackProvider.h
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

@class LFMTrack, LFMSearchQuery, LFMScrobbleTrack, LFMTag, LFMTopTag;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for interacting with tracks on Last.fm.
 */
NS_SWIFT_NAME(TrackProvider)
@interface LFMTrackProvider : NSObject

/**
 Notifies Last.fm that a user has started listening to a track.
 
 @note  🔒: Authentication Required.
 
 @param trackName   The name of the track.
 @param artistName  The name of the track's artist.
 @param albumName   The name of the track's album, if any.
 @param trackNumber The position of the track on said album, if any.
 @param albumArtist The artist of the album, if different to that of the track.
 @param duration    The duration of the track, in seconds.
 @param mbid        The MusicBrainzID for the track.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)updateNowPlayingWithTrackNamed:(NSString *)trackName
                                           byArtistNamed:(NSString *)artistName
                                            onAlbumNamed:(nullable NSString *)albumName
                                         positionInAlbum:(nullable NSNumber *)trackNumber
                                    withAlbumArtistNamed:(nullable NSString *)albumArtist
                                           trackDuration:(nullable NSNumber *)duration
                                           musicBrainzId:(nullable NSString *)mbid
                                                callback:(void (^_Nullable)(NSError * _Nullable))block NS_SWIFT_NAME(updateNowPlaying(track:by:on:position:albumArtist:duration:mbid:callback:));

/**
 Adds a track-play to a user's profile.
 
 A track should only be scrobbled when both of the following conditions have been met:
 * The track must be longer than 30 seconds in length.
 * The track has been played for at least half its duration, or for 4 minutes (whichever occurs earlier).
 
 @note  🔒: Authentication Required.
 
 @param tracks  The array of tracks to be scrobbled. The maximum amount of tracks that can be scrobbled at a time is 50. An exception will be raised if this limit is passed.
 @param block   The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)scrobbleTracks:(NSArray <LFMScrobbleTrack *> *)tracks
                                callback:(void (^_Nullable)(NSError * _Nullable))block NS_SWIFT_NAME(scrobble(tracks:callback:));

/**
 Loves a track for a user profile.
 
 @note  🔒: Authentication Required.
 
 @param trackName   The name of the track.
 @param artistName  The name of the track's artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)loveTrackNamed:(NSString *)trackName
                           byArtistNamed:(NSString *)artistName
                                callback:(void (^_Nullable)(NSError * _Nullable))block NS_SWIFT_NAME(love(track:by:callback:));

/**
 Un-loves a track for a user profile.
 
 @note  🔒: Authentication Required.
 
 @param trackName   The name of the track.
 @param artistName  The name of the track's artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)unloveTrackNamed:(NSString *)trackName
                             byArtistNamed:(NSString *)artistName
                                  callback:(void (^_Nullable)(NSError * _Nullable))block NS_SWIFT_NAME(unlove(track:by:callback:));

/**
 Retrieves detailed information on a track using its name and artist or MusicBrainzID.
 
 @param trackName   The name of the track. Required, unless mbid is specified.
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the track. Required unless the trackName and artistName are specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
 @param username    The username for the context of the request. If supplied, the user's playcount for this track is included in the response.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMTrack` object if the request succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getInfoOnTrackNamed:(nullable NSString *)trackName
                                byArtistNamed:(nullable NSString *)artistName
                             withMusicBrainzId:(nullable NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                       forUser:(nullable NSString *)username
                                     callback:(void (^)(NSError * _Nullable, LFMTrack * _Nullable))block NS_SWIFT_NAME(getInfo(on:by:mbid:autoCorrect:username:callback:));

/**
 Searches for a track by name. Returns track matches sorted by relevance.
 
 @param trackName   The name of the track.
 @param artistName  The track's artist.
 @param limit       The number of search results available per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack`s and an `LFMSearchQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)searchForTrackNamed:(NSString *)trackName
                                byArtistNamed:(nullable NSString *)artistName
                                 itemsPerPage:(NSUInteger)limit
                                       onPage:(NSUInteger)page
                                     callback:(void(^)(NSError * _Nullable, NSArray<LFMTrack *> *, LFMSearchQuery * _Nullable))block NS_SWIFT_NAME(search(for:by:limit:on:callback:));

/**
 Retrieves tracks similar to a specified track.
 
 @param trackName   The name of the track. Required, unless mbid is specified.
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the track. Required unless both the trackName and artistName are specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
 @param limit       The maximum number of similar tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack` objects if the request succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTracksSimilarToTrackNamed:(nullable NSString *)trackName
                                         byArtistNamed:(nullable NSString *)artistName
                                     withMusicBrainzId:(nullable NSString *)mbid
                                           autoCorrect:(BOOL)autoCorrect
                                                 limit:(NSUInteger)limit
                                              callback:(void (^)(NSError * _Nullable, NSArray<LFMTrack *> *))block NS_SWIFT_NAME(getTracksSimilar(to:by:mbid:autoCorrect:limit:callback:));

/**
 Checks whether the supplied track has a correction to a canonical track.
 
 @param trackName   The name of the track.
 @param artistName  The name of the artist.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMTrack` object if the request succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getCorrectionForMisspelledTrackNamed:(NSString *)trackName
                                     withMisspelledArtistNamed:(NSString *)artistName
                                                      callback:(void (^)(NSError * _Nullable, LFMTrack * _Nullable))block NS_SWIFT_NAME(getCorrection(for:by:callback:));

/**
 Tags a track using a list of user supplied tags.
 
 @note  🔒: Authentication Required.
 
 @param tags        An array of user supplied tags to apply to this track. Accepts a maximum of 10 tags. An exception will be raised if more than 10 tags are passed in.
 @param trackName   The name of the track.
 @param artistName  The name of the track's artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)addTags:(NSArray <LFMTag *> *)tags
                     toTrackNamed:(NSString *)trackName
                    byArtistNamed:(NSString *)artistName
                         callback:(void (^_Nullable)(NSError * _Nullable))block NS_SWIFT_NAME(add(tags:to:by:callback:));

/**
 Removes a user's tag from a track.
 
 @note  🔒: Authentication Required.
 
 @param tag         A single user tag to remove from this track.
 @param trackName   The name of the track.
 @param artistName  The name of the track's artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)removeTag:(LFMTag *)tag
                     fromTrackNamed:(NSString *)trackName
                      byArtistNamed:(NSString *)artistName
                           callback:(void (^_Nullable)(NSError * _Nullable))block NS_SWIFT_NAME(remove(tag:from:by:callback:));

/**
 Retrieves the tags applied by an individual user to a track on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
 
 @note  🔒: Authentication Optional.
 
 @param trackName   The name of the track. Required, unless mbid is specified.
 @param artistName  The name of the track's artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the track. Required, unless both trackName and artistName are specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
 @param username    The name of any Last.fm user from which to obtain track tags. If this method is called and the user has not been signed in, this parameter MUST be set otherwise an exception will be raised.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTag`s if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTagsForTrackNamed:(nullable NSString *)trackName
                                 byArtistNamed:(nullable NSString *)artistName
                             withMusicBrainzId:(nullable NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                       forUser:(nullable NSString *)username
                                      callback:(void (^)(NSError * _Nullable, NSArray <LFMTag *> *))block NS_SWIFT_NAME(getTags(forTrack:by:mbid:autoCorrect:forUser:callback:));

/**
 Retrieves the top tags for a track on Last.fm, ordered by popularity.
 
 @param trackName   The name of the track. Required, unless mbid is specified.
 @param artistName  The name of the track's artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the track. Required, unless both trackName and artistName are specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag`s if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getTopTagsForTrackNamed:(nullable NSString *)trackName
                                    byArtistNamed:(nullable NSString *)artistName
                                withMusicBrainzId:(nullable NSString *)mbid
                                      autoCorrect:(BOOL)autoCorrect
                                         callback:(void (^)(NSError * _Nullable, NSArray <LFMTopTag *> *))block NS_SWIFT_NAME(getTopTags(for:by:mbid:autoCorrect:callback:));

@end

NS_ASSUME_NONNULL_END
