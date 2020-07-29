//
//  AlbumProvider+Swift.swift
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

import Foundation
import LastFMKit.LFMAlbumProvider

public extension AlbumProvider {
    
    /**
     Retrieves the metadata and tracklist for an album on Last.fm using the album name and album artist.
     
     - Parameter album:         The name of the album.
     - Parameter artist:        The name of the album's artist.
     - Parameter autoCorrect:   A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter username:      The username for the context of the request. If supplied, the user's playcount for this album is included in the response. If not supplied, the playcount for the authenticated user (if any) will be returned.
     - Parameter language:      The language to return the biography in, expressed as an ISO 639 alpha-2 code.
     - Parameter callback :      The callback block containing an optional `Error` if the request fails and an `Album` object if the request succeeds.
    
     - Returns:   The `URLSessionDataTask` object from the web request.
    */
    @discardableResult
    class func getInfo(on album: String,
                       by artist: String,
                       autoCorrectArtist autoCorrect: Bool = true,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Album, Error>) -> Void) -> URLSessionDataTask {
        return __getInfoOnAlbumNamed(album,
                                     byArtistNamed: artist,
                                     albumMBID: nil,
                                     autoCorrect: autoCorrect,
                                     forUsername: username,
                                     languageCode: language) { (error, album) in
            let result: Result<Album, Error>
            
            if let album = album {
                result = .success(album)
            } else {
                result = .failure(error ?? NSError() as Error)
            }
            
            callback(result)
        }
    }
/*
    /**
     Retrieves the tags applied by an individual user to an album on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
     
     @note  🔒: Authentication Optional.
     
     - Parameter albumName   The name of the album. Required, unless mbid is specified.
     - Parameter albumArtist The name of the album's artist. Required, unless mbid is specified.
     - Parameter mbid        The MusicBrainzID for the album. Required, unless both albumName and albumArtist are specified.
     - Parameter autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter username    The name of any Last.fm user from which to obtain album tags. If this method is called and the user has not been signed in, this parameter MUST be set otherwise an exception will be raised.
     - Parameter block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTag`s if it succeeds.
     
     - Returns:   The `NSURLSessionDataTask` object from the web request.
     */
    + (NSURLSessionDataTask *)getTagsForAlbumNamed:(nullable NSString *)albumName
     func ;                    byArtistNamed:(nullable NSString *)albumArtist
                                 withMusicBrainzId:(nullable NSString *)mbid
                                       autoCorrect:(BOOL)autoCorrect
                                       forUsername:(nullable NSString *)username
                                          callback:(void (^)(NSError * _Nullable, NSArray <LFMTag *> *))block NS_REFINED_FOR_SWIFT;

    /**
     Retrieves the top tags for an album on Last.fm, ordered by popularity.
     
     - Parameter albumName   The name of the album. Required, unless mbid is specified.
     - Parameter albumArtist The name of the album's artist. Required, unless mbid is specified.
     - Parameter mbid        The MusicBrainzID for the album. Required, unless both albumName and albumArtist are specified.
     - Parameter autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag`s if it succeeds.
     
     - Returns:   The `NSURLSessionDataTask` object from the web request.
     */
    + (NSURLSessionDataTask *)getTopTagsForAlbumNamed:(nullable NSString *)albumName
                                        byArtistNamed:(nullable NSString *)albumArtist
                                    withMusicBrainzId:(nullable NSString *)mbid
                                          autoCorrect:(BOOL)autoCorrect
                                             callback:(void (^)(NSError * _Nullable, NSArray <LFMTopTag *> *))block NS_REFINED_FOR_SWIFT;

    /**
     Searches for an album by name. Returns album matches sorted by relevance.
     
     - Parameter albumName   The name of the album.
     - Parameter limit       The number of search results available per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000.
     - Parameter page        The page of results to be fetched. Start page is 1. Page must be less than 10,000.
     - Parameter block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMSearchQuery` object if it succeeds.
     
     - Returns:   The `NSURLSessionDataTask` object from the web request.
     */
    + (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                     itemsPerPage:(NSUInteger)limit
                                           onPage:(NSUInteger)page
                                         callback:(void (^)(NSError * _Nullable, NSArray <LFMAlbum *> *, LFMSearchQuery * _Nullable))block NS_REFINED_FOR_SWIFT;

    /**
     Searches for an album by name. Returns the first 30 album matches sorted by relevance.
     
     - Parameter albumName   The name of the album.
     - Parameter block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMSearchQuery` object if it succeeds.
     
     - Returns:   The `NSURLSessionDataTask` object from the web request.
     */
    + (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                         callback:(void (^)(NSError * _Nullable, NSArray <LFMAlbum *> *, LFMSearchQuery * _Nullable))block NS_REFINED_FOR_SWIFT;

    /**
     Searches for an album by name with a limit of 30 items per page. Returns album matches sorted by relevance.
     
     - Parameter albumName   The name of the album.
     - Parameter page        The page of results to be fetched. Start page is 1. Page must be less than 10,000.
     - Parameter block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMSearchQuery` object if it succeeds.
     
     - Returns:   The `NSURLSessionDataTask` object from the web request.
     */
    + (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                           onPage:(NSUInteger)page
                                         callback:(void (^)(NSError * _Nullable, NSArray <LFMAlbum *> *, LFMSearchQuery * _Nullable))block NS_REFINED_FOR_SWIFT;

    /**
     Searches for an album by name. Returns album matches sorted by relevance.
     
     - Parameter albumName   The name of the album.
     - Parameter limit       The number of search results available per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000.
     - Parameter block       The callback block containing an optional `NSError` if the request fails and an array of `LFMAlbum`s and an `LFMSearchQuery` object if it succeeds.
     
     - Returns:   The `NSURLSessionDataTask` object from the web request.
     */
    + (NSURLSessionDataTask *)searchForAlbumNamed:(NSString *)albumName
                                     itemsPerPage:(NSUInteger)limit
                                         callback:(void (^)(NSError * _Nullable, NSArray <LFMAlbum *> *, LFMSearchQuery * _Nullable))block NS_REFINED_FOR_SWIFT;
*/
}
