//
//  LFMAlbumProvider.h
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

@class LFMURLOperation, LFMTag, LFMTopTag, LFMAlbum, LFMSearchQuery;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for looking up info on Albums using Last.fm.
 */
NS_SWIFT_NAME(AlbumProvider)
@interface LFMAlbumProvider : LFMProvider

/**
 Tags an album using a list of user supplied tags.
 
 @note  🔒: Authentication Required.
 
 @param tags        An array of user supplied tags to apply to this album. Accepts a maximum of 10 tags. An exception will be raised if more than 10 tags are passed in.
 @param albumName   The name of the album.
 @param albumArtist The name of the album's artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)addTags:(NSArray<LFMTag *> *)tags
                toAlbumNamed:(NSString *)albumName
               byArtistNamed:(NSString *)albumArtist
                    callback:(nullable LFMErrorCallback)block NS_SWIFT_NAME(add(tags:to:by:callback:));

/**
 Removes a user's tag from an album.
 
 @note  🔒: Authentication Required.
 
 @param tag         A single user tag to remove from this album.
 @param albumName   The name of the album.
 @param albumArtist The name of the album's artist.
 @param block       The callback block containing an optional `NSError` if the request fails. Regardless of the success of the operation, this block will be called.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)removeTag:(LFMTag *)tag
                     fromAlbumNamed:(NSString *)albumName
                      byArtistNamed:(NSString *)albumArtist
                           callback:(nullable LFMErrorCallback)block NS_SWIFT_NAME(remove(tag:from:by:callback:));

/**
 Retrieves the metadata and tracklist for an album on Last.fm using the album name and album artist or album release MusicBrainzID.
 
 @note  🔒: Authentication Optional.
 
 @param albumName   The name of the album.
 @param albumArtist The name of the album's artist.
 @param mbid        The MusicBrainzID for the album @b release.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param username    The username for the context of the request. If supplied, the user's playcount for this album is included in the response. If not supplied, the playcount for the authenticated user (if any) will be returned.
 @param code        The language to return the biography in, expressed as an ISO 639 alpha-2 code.
 @param block       The callback block containing an optional `NSError` if the request fails and an `LFMAlbum` object if the request succeeds.
 
 @note  It is @b very important that you use the album release id and not the album release group id. The album release group contains information about the album release - i.e. the releases for each country, whether a delux cd was released, the digital version etc. The album release is a specific one of these group items. If you provide an album release group id you will get an error code @b 6 saying the album was not found.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getInfoOnAlbumNamed:(nullable NSString *)albumName
                                byArtistNamed:(nullable NSString *)albumArtist
                                    albumMBID:(nullable NSString *)mbid
                                  autoCorrect:(BOOL)autoCorrect
                                  forUsername:(nullable NSString *)username
                                 languageCode:(nullable NSString *)code
                                     callback:(LFMAlbumCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the tags applied by an individual user to an album on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
 
 @note  🔒: Authentication Optional.
 
 @param albumName   The name of the album. Required, unless mbid is specified.
 @param albumArtist The name of the album's artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the album. Required, unless both albumName and albumArtist are specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param username    The name of any Last.fm user from which to obtain album tags. If this method is called and the user has not been signed in, this parameter MUST be set otherwise an exception will be raised.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTag`s if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTagsForAlbumNamed:(nullable NSString *)albumName
                                 byArtistNamed:(nullable NSString *)albumArtist
                             withMusicBrainzId:(nullable NSString *)mbid
                                   autoCorrect:(BOOL)autoCorrect
                                   forUsername:(nullable NSString *)username
                                      callback:(LFMTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Retrieves the top tags for an album on Last.fm, ordered by popularity.
 
 @param albumName   The name of the album. Required, unless mbid is specified.
 @param albumArtist The name of the album's artist. Required, unless mbid is specified.
 @param mbid        The MusicBrainzID for the album. Required, unless both albumName and albumArtist are specified.
 @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag`s if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)getTopTagsForAlbumNamed:(nullable NSString *)albumName
                                    byArtistNamed:(nullable NSString *)albumArtist
                                withMusicBrainzId:(nullable NSString *)mbid
                                      autoCorrect:(BOOL)autoCorrect
                                         callback:(LFMTopTagsCallback)block NS_REFINED_FOR_SWIFT;

/**
 Searches for an album by name. Returns album matches sorted by relevance.
 
 @param albumName   The name of the album.
 @param limit       The number of search results available per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000. Defaults to 30.
 @param page        The page of results to be fetched. Page must be between 1 and 10,000. Defaults to 1.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMSearchQuery` object if it succeeds.
 
 @return   The `LFMURLOperation` object to be resumed.
 */
+ (LFMURLOperation *)searchForAlbumNamed:(NSString *)albumName
                                 itemsPerPage:(nullable NSNumber *)limit
                                       onPage:(nullable NSNumber *)page
                                     callback:(LFMAlbumSearchCallback)block NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END

