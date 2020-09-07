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

public extension ArtistProvider {

    /**
     Retrieves corrections based on common misspellings of artist names.
     
     - Parameter artist:    The misspelt/misconcatinated name of an artist.
     - Parameter callback:  The callback block containing a `LFMError` if the request fails and a matching `Artist` if one is found.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getCorrection(forMisspelled artist: String,
                             callback: @escaping (Result<Artist, Error>) -> Void) -> LFMURLOperation {
        return __getCorrectionForMisspelledArtistName(artist) { (artist, error) in
            let result: Result<Artist, Error>
            
            if let artist = artist {
                result = .success(artist)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    /**
    Retrieves detailed information on an artist using their name.
     
     - Note:  🔒: Authentication Optional.

     - Parameter artist:         The name of the artist
     - Parameter autoCorrect:    A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter username:       The username for the context of the request. If supplied, the user's playcount for this artist is included in the response.  If not supplied, the playcount for the authenticated user (if any) will be returned.
     - Parameter language:       The language to return the biography in, expressed as an ISO 639 alpha-2 code.
     - Parameter callback:       The callback block containing an `LFMError` if the request fails and an `Artist` object if the request succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    class func getInfo(on artist: String,
                       autoCorrect: Bool = true,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Artist, Error>) -> Void) -> LFMURLOperation {
        return __getInfoOnArtistNamed(artist,
                                      withMusicBrainzId: nil,
                                      autoCorrect: autoCorrect,
                                      forUsername: username,
                                      languageCode: language) { (artist, error) in
            let result: Result<Artist, Error>
            
            if let artist = artist {
                result = .success(artist)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves detailed information on an artist using their MusicBrainzID.
     
     - Note:  🔒: Authentication Optional.

     - Parameter mbid:           The MusicBrainzID for the artist.
     - Parameter username:       The username for the context of the request. If supplied, the user's playcount for this artist is included in the response.  If not supplied, the playcount for the authenticated user (if any) will be returned.
     - Parameter language:       The language to return the biography in, expressed as an ISO 639 alpha-2 code.
     - Parameter callback:       The callback block containing an `LFMError` if the request fails and an `Artist` object if the request succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getInfo(on mid: String,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Artist, Error>) -> Void) -> LFMURLOperation {
        return __getInfoOnArtistNamed(nil,
                                      withMusicBrainzId: mid,
                                      autoCorrect: false,
                                      forUsername: username,
                                      languageCode: language) { (artist, error) in
            let result: Result<Artist, Error>
            
            if let artist = artist {
                result = .success(artist)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves artists similar to a specified artist.

     - Parameter artist:        The name of the artist.
     - Parameter autoCorrect:   A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter limit:         The maximum number of similar artists to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:    The callback block containing an `LFMError` if the request fails and an array of `LFMArtist` objects if the request succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getSimilarArtists(to artist: String,
                                 autoCorrect: Bool = true,
                                 limit: Int = 30,
                                 callback: @escaping (Result<[Artist], Error>) -> Void) -> LFMURLOperation {
        return __getArtistsSimilar(toArtistNamed: artist,
                                   withMusicBrainzId: nil,
                                   autoCorrect: autoCorrect,
                                   limit: limit as NSNumber) { (artists, error) in
            let result: Result<[Artist], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(artists)
            }
            
            callback(result)
        }
    }
    
    /**
    Retrieves artists similar to a specified artist.

     - Parameter mbid:      The MusicBrainzID for the artist.
     - Parameter limit:     The maximum number of similar artists to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:  The callback block containing an `LFMError` if the request fails and an array of `LFMArtist` objects if the request succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    class func getSimilarArtists(to mbid: String,
                                 limit: Int = 30,
                                 callback: @escaping (Result<[Artist], Error>) -> Void) -> LFMURLOperation {
        return __getArtistsSimilar(toArtistNamed: nil,
                                   withMusicBrainzId: mbid,
                                   autoCorrect: false,
                                   limit: limit as NSNumber) { (artists, error) in
            let result: Result<[Artist], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(artists)
            }
            
            callback(result)
        }
    }
    
    /**
    Retrieves the tags applied by an individual user to an artist on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.

    - Note:🔒: Authentication Optional.

    - Parameter artist:     The name of the artist.
    - Parameter autoCorrect: A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
    - Parameter username:   The name of any Last.fm user on which to obtain artist tags from. If this method is called and the user has not been signed in, this parameter **must** be set otherwise an exception will be raised.
    - Parameter callback: The callback block containing an `LFMError` if the request fails and an array of `Tag`s if it succeeds.

    - Returns:   The `LFMURLOperation` object to be resumed.
    */
    class func getTags(for artist: String,
                       autoCorrect: Bool = true,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], Error>) -> Void) -> LFMURLOperation {
        return __getTagsForArtistNamed(artist,
                                       withMusicBrainzId: nil,
                                       autoCorrect: autoCorrect,
                                       forUsername: username) { (tags, error) in
            let result: Result<[Tag], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }

    /**
     Retrieves the tags applied by an individual user to an artist on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.

     - Note:🔒: Authentication Optional.

     - Parameter mbid:        The MusicBrainzID for the artist.
     - Parameter username:    The name of any Last.fm user on which to obtain artist tags from. If this method is called and the user has not been signed in, this parameter **must** be set otherwise an exception will be raised.
     - Parameter callback:  The callback block containing an `LFMError` if the request fails and an array of `Tag`s if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTags(for mbid: String,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], Error>) -> Void) -> LFMURLOperation {
        return __getTagsForArtistNamed(nil,
                                       withMusicBrainzId: mbid,
                                       autoCorrect: false,
                                       forUsername: username) { (tags, error) in
            let result: Result<[Tag], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }
    
    /**
    Retrieves the top albums for an artist on Last.fm, ordered by popularity.

    - Parameter artist:         The name of the artist.
    - Parameter autoCorrect:    A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
    - Parameter limit:          The maximum number of albums that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
    - Parameter page:           The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
    - Parameter callback:     The callback block containing an `LFMError` if the request fails and an array of `Album`s and an `Query` object if it succeeds.

    - Returns:   The `LFMURLOperation` object to be resumed.
    */
    class func getTopAlbums(for artist: String,
                            autoCorrect: Bool = true,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Album], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopAlbums(forArtistNamed: artist,
                              withMusicBrainzId: nil,
                              autoCorrect: autoCorrect,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (albums, query, error) in
            let result: Result<([Album], Query), Error>
            
            if let query = query {
                result = .success((albums, query))
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves the top albums for an artist on Last.fm, ordered by popularity.

     - Parameter mbid:          The MusicBrainzID for the artist.
     - Parameter limit:         The maximum number of albums that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:          The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback:    The callback block containing an `LFMError` if the request fails and an array of `Album`s and an `Query` object if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTopAlbums(for mbid: String,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Album], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopAlbums(forArtistNamed: nil,
                              withMusicBrainzId: mbid,
                              autoCorrect: false,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (albums, query, error) in
            let result: Result<([Album], Query), Error>
            
            if let query = query {
                result = .success((albums, query))
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
    Retrieves the top tracks for an artist on Last.fm, ordered by popularity.

    - Parameter mbid:        The MusicBrainzID for the artist.
    - Parameter limit:       The maximum number of albums that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
    - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
    - Parameter callback:  The callback block containing an `LFMError` if the request fails and an array of `Track`s and an `Query` object if it succeeds.

    - Returns:   The `LFMURLOperation` object to be resumed.
    */
    class func getTopTracks(for mbid: String,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopTracks(forArtistNamed: nil,
                              withMusicBrainzId: mbid,
                              autoCorrect: false,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (tracks, query, error) in
            let result: Result<([Track], Query), Error>
            
            if let query = query {
                result = .success((tracks, query))
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    /**
     Retrieves the top tracks for an artist on Last.fm, ordered by popularity.

     - Parameter artist:      The name of the artist.
     - Parameter autoCorrect: A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter limit:       The maximum number of albums that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback:  The callback block containing an `LFMError` if the request fails and an array of `Track`s and an `Query` object if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTopTracks(for artist: String,
                            autoCorrect: Bool = true,
                            limit: Int = 30,
                            page: Int = 1,
                            callback: @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopTracks(forArtistNamed: artist,
                              withMusicBrainzId: nil,
                              autoCorrect: autoCorrect,
                              itemsPerPage: limit as NSNumber,
                              onPage: page as NSNumber) { (tracks, query, error) in
            let result: Result<([Track], Query), Error>
            
            if let query = query {
                result = .success((tracks, query))
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    /**
     Retrieves the top tags for an artist on Last.fm, ordered by popularity.

     - Parameter artist:         The name of the artist.
     - Parameter autoCorrect:    A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter callback:      The callback block containing an `LFMError` if the request fails and an array of `TopTag`s if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    class func getTopTags(for artist: String,
                          autoCorrect: Bool = true,
                          callback: @escaping (Result<[TopTag], Error>) -> Void) -> LFMURLOperation {
        return __getTopTags(forArtistNamed: artist,
                            withMusicBrainzId: nil,
                            autoCorrect: autoCorrect) { (tags, error) in
            let result: Result<[TopTag], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }

    /**
     Retrieves the top tags for an artist on Last.fm, ordered by popularity.

     - Parameter mbid:          The MusicBrainzID for the artist. misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter callback:    The callback block containing an `LFMError` if the request fails and an array of `TopTag`s if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTopTags(for mbid: String,
                          callback: @escaping (Result<[TopTag], Error>) -> Void) -> LFMURLOperation {
        return __getTopTags(forArtistNamed: nil,
                            withMusicBrainzId: mbid,
                            autoCorrect: false) { (tags, error) in
            let result: Result<[TopTag], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(tags)
            }
            
            callback(result)
        }
    }

    /**
     Searches for an artist by name. Returns artist matches sorted by relevance.

     - Parameter query:         The name of the artist.
     - Parameter limit:         The maximum number of artists that will be returned per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page :         The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback:    The callback block containing an `LFMError` if the request fails and an array of `Artist`s and an `SearchQuery` object if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func search(for query: String,
                      limit: Int = 30,
                      page: Int = 1,
                      callback: @escaping (Result<([Artist], SearchQuery), Error>) -> Void) -> LFMURLOperation {
        return __search(forArtistNamed: query,
                        itemsPerPage: limit as NSNumber,
                        onPage: page as NSNumber) { (artists, query, error) in
            let result: Result<([Artist], SearchQuery), Error>
            
            if let query = query {
                result = .success((artists, query))
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
}
