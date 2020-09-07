//
//  LFMArtistProvider.h
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

@class LFMURLOperation, LFMTag, LFMTopTag, LFMArtist, LFMAlbum, LFMQuery, LFMSearchQuery, LFMTrack;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for looking up info on Artists using Last.fm.
 */
NS_SWIFT_NAME(ArtistProvider)
@interface LFMArtistProvider : LFMProvider

/**
 Tags an artist using a list of user supplied tags.
 
 @note  🔒: Authentication Required.
 
 @param tags        An array of user supplied tags to apply to this artist. Accepts a maximum of 10 tags. An exception will be raised if more than 10 tags are passed in.
 @param artistName  The name of the artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)addTags:(NSArray<LFMTag *> *)tags
                    toArtistNamed:(NSString *)artistName
                         callback:(nullable LFMErrorCallback)block NS_SWIFT_NAME(add(tags:to:callback:));

/**
 Removes a user's tag from an artist.
 
 @note  🔒: Authentication Required.
 
 @param tag         A single user tag to remove from this artist.
 @param artistName  The name of the artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)removeTag:(LFMTag *)tag
                    fromArtistNamed:(NSString *)artistName
                           callback:(nullable LFMErrorCallback)block NS_SWIFT_NAME(remove(tag:from:callback:));

/**
 Retrieves corrections based on common misspellings of artist names.
 
 @param artistName  The misspelt/misconcatinated name of an artist.
 @param block       The callback block containing an optional `NSError` if the request fails and a matching artist if one is found.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getCorrectionForMisspelledArtistName:(NSString *)artistName
                                                 callback:(LFMArtistCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves detailed information on an artist using its name or MusicBrainzID.
 
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param username    The username for the context of the request. If supplied, the user's playcount for this artist is included in the response.
 @param code        The language to return the biography in, expressed as an ISO 639 alpha-2 code.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMArtist` object if the request succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getInfoOnArtistNamed:(nullable NSString *)artistName
                             withMusicBrainzId:(nullable NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                   forUsername:(nullable NSString *)username
                                  languageCode:(nullable NSString *)code
                                      callback:(LFMArtistCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves artists similar to a specified artist.
 
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param limit       The maximum number of similar artists to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000. Defaults to 30.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist` objects if the request succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getArtistsSimilarToArtistNamed:(nullable NSString *)artistName
                                       withMusicBrainzId:(nullable NSString *)mbid
                                             autoCorrect:(BOOL)autoCorrect
                                                   limit:(nullable NSNumber *)limit
                                                callback:(LFMArtistsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the tags applied by an individual user to an artist on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
 
 @note  🔒: Authentication Optional.
 
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param username    The name of any Last.fm user on which to obtain artist tags from. If this method is called and the user has not been signed in, this parameter @b must be set otherwise an exception will be raised.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTag`s if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTagsForArtistNamed:(nullable NSString *)artistName
                              withMusicBrainzId:(nullable NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                    forUsername:(nullable NSString *)username
                                      callback:(LFMTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top albums for an artist on Last.fm, ordered by popularity.
 
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param limit       The maximum number of albums that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopAlbumsForArtistNamed:(nullable NSString *)artistName
                                   withMusicBrainzId:(nullable NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(nullable NSNumber *)limit
                                              onPage:(nullable NSNumber *)page
                                            callback:(LFMAlbumPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tracks for an artist on Last.fm, ordered by popularity.
 
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param limit       The maximum number of albums that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTrack`s and an `LFMQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTracksForArtistNamed:(nullable NSString *)artistName
                                   withMusicBrainzId:(nullable NSString *)mbid
                                         autoCorrect:(BOOL)autoCorrect
                                        itemsPerPage:(nullable NSNumber *)limit
                                              onPage:(nullable NSNumber *)page
                                            callback:(LFMTrackPaginatedCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tags for an artist on Last.fm, ordered by popularity.
 
 @param artistName  The name of the artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag`s if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTagsForArtistNamed:(nullable NSString *)artistName
                                withMusicBrainzId:(nullable NSString *)mbid
                                      autoCorrect:(BOOL)autoCorrect
                                         callback:(LFMTopTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Searches for an artist by name. Returns artist matches sorted by relevance.
 
 @param artistName  The name of the artist.
 @param limit       The maximum number of artists that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist`s and an `LFMSearchQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)searchForArtistNamed:(NSString *)artistName
                                  itemsPerPage:(nullable NSNumber *)limit
                                        onPage:(nullable NSNumber *)page
                                      callback:(LFMArtistSearchCallback)block NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
