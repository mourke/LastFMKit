//
//  ArtistProvider+Swift.swift
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

extension ArtistProvider {

    /**
     Retrieves corrections based on common misspellings of artist names.

     @param artistName  The misspelt/misconcatinated name of an artist.
     @param block       The callback block containing an optional `NSError` if the request fails and a matching artist if one is found.

     @return   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getCorrection(forMisspelt artist: String,
                             callback: @escaping (Result<Artist, LFMError>) -> Void) -> LFMURLOperation {
        return __getCorrectionForMisspeltArtistName(artist) { (artist, error) in
            let result: Result<Artist, LFMError>
            
            if let artist = artist {
                result = .success(artist)
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    @discardableResult
    class func getInfo(on artist: String,
                       autoCorrect: Bool = true,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Artist, LFMError>) -> Void) -> LFMURLOperation {
        return __getInfoOnArtistNamed(artist,
                                      withMusicBrainzId: nil,
                                      autoCorrect: autoCorrect,
                                      forUsername: username,
                                      languageCode: language) { (artist, error) in
            let result: Result<Artist, LFMError>
            
            if let artist = artist {
                result = .success(artist)
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

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
    @discardableResult
    class func getInfo(on mid: String,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Artist, LFMError>) -> Void) -> LFMURLOperation {
        return __getInfoOnArtistNamed(nil,
                                      withMusicBrainzId: mid,
                                      autoCorrect: false,
                                      forUsername: username,
                                      languageCode: language) { (artist, error) in
            let result: Result<Artist, LFMError>
            
            if let artist = artist {
                result = .success(artist)
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves artists similar to a specified artist.

     @param artistName  The name of the artist. Required, unless mbid is specified.
     @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
     @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     @param limit       The maximum number of similar artists to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000. Defaults to 30.
     @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist` objects if the request succeeds.

     @return   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getSimilarArtists(to artist: String,
                                 autoCorrect: Bool = true,
                                 limit: Int = 30,
                                 callback: @escaping (Result<[Artist], LFMError>) -> Void) -> LFMURLOperation {
        return __getArtistsSimilar(toArtistNamed: artist,
                                   withMusicBrainzId: nil,
                                   autoCorrect: autoCorrect,
                                   limit: limit as NSNumber) { (artists, error) in
            let result: Result<[Artist], LFMError>
            
            if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                result = .success(artists)
            }
            
            callback(result)
        }
    }
    
    @discardableResult
    class func getSimilarArtists(to mbid: String,
                                 limit: Int = 30,
                                 callback: @escaping (Result<[Artist], LFMError>) -> Void) -> LFMURLOperation {
        return __getArtistsSimilar(toArtistNamed: nil,
                                   withMusicBrainzId: mbid,
                                   autoCorrect: false,
                                   limit: limit as NSNumber) { (artists, error) in
            let result: Result<[Artist], LFMError>
            
            if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                result = .success(artists)
            }
            
            callback(result)
        }
    }
    
    @discardableResult
    class func getTags(for artist: String,
                       autoCorrect: Bool = true,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTagsForArtistNamed(artist,
                                       withMusicBrainzId: nil,
                                       autoCorrect: autoCorrect,
                                       forUsername: username) { (tags, error) in
            let result: Result<[Tag], LFMError>
            
            if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }

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
    @discardableResult
    class func getTags(for mbid: String,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTagsForArtistNamed(nil,
                                       withMusicBrainzId: mbid,
                                       autoCorrect: false,
                                       forUsername: username) { (tags, error) in
            let result: Result<[Tag], LFMError>
            
            if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }
    
    @discardableResult
    class func getTopAlbums(for artist: String,
                            autoCorrect: Bool = true,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Album], Query), LFMError>) -> Void) -> LFMURLOperation {
        return __getTopAlbums(forArtistNamed: artist,
                              withMusicBrainzId: nil,
                              autoCorrect: autoCorrect,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (albums, query, error) in
            let result: Result<([Album], Query), LFMError>
            
            if let query = query {
                result = .success((albums, query))
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

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
    @discardableResult
    class func getTopAlbums(for mbid: String,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Album], Query), LFMError>) -> Void) -> LFMURLOperation {
        return __getTopAlbums(forArtistNamed: nil,
                              withMusicBrainzId: mbid,
                              autoCorrect: false,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (albums, query, error) in
            let result: Result<([Album], Query), LFMError>
            
            if let query = query {
                result = .success((albums, query))
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    @discardableResult
    class func getTopTracks(for mbid: String,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Track], Query), LFMError>) -> Void) -> LFMURLOperation {
        return __getTopTracks(forArtistNamed: nil,
                              withMusicBrainzId: mbid,
                              autoCorrect: false,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (tracks, query, error) in
            let result: Result<([Track], Query), LFMError>
            
            if let query = query {
                result = .success((tracks, query))
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
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
    @discardableResult
    class func getTopTracks(for artist: String,
                            autoCorrect: Bool = true,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Track], Query), LFMError>) -> Void) -> LFMURLOperation {
        return __getTopTracks(forArtistNamed: artist,
                              withMusicBrainzId: nil,
                              autoCorrect: autoCorrect,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (tracks, query, error) in
            let result: Result<([Track], Query), LFMError>
            
            if let query = query {
                result = .success((tracks, query))
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    @discardableResult
    class func getTopTags(for artist: String,
                          autoCorrect: Bool = true,
                          callback: @escaping (Result<[TopTag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTopTags(forArtistNamed: artist,
                            withMusicBrainzId: nil,
                            autoCorrect: autoCorrect) { (tags, error) in
            let result: Result<[TopTag], LFMError>
            
            if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }

    /**
     Retrieves the top tags for an artist on Last.fm, ordered by popularity.

     @param artistName  The name of the artist. Required, unless mbid is specified.
     @param mbid        The MusicBrainzID for the artist. Required unless artistName is specified.
     @param autoCorrect A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMTopTag`s if it succeeds.

     @return   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopTags(for mbid: String,
                          callback: @escaping (Result<[TopTag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTopTags(forArtistNamed: nil,
                            withMusicBrainzId: mbid,
                            autoCorrect: false) { (tags, error) in
            let result: Result<[TopTag], LFMError>
            
            if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }

    /**
     Searches for an artist by name. Returns artist matches sorted by relevance.

     @param artistName  The name of the artist.
     @param limit       The maximum number of artists that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     @param page        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist`s and an `LFMSearchQuery` object if it succeeds.

     @return   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func search(for query: String,
                      limit: Int = 30,
                      page: Int = 1,
                      callback: @escaping (Result<([Artist], SearchQuery), LFMError>) -> Void) -> LFMURLOperation {
        return __search(forArtistNamed: query,
                        itemsPerPage: limit as NSNumber,
                        onPage: page as NSNumber) { (artists, query, error) in
            let result: Result<([Artist], SearchQuery), LFMError>
            
            if let query = query {
                result = .success((artists, query))
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
}
