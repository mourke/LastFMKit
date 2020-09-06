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
     
     - Note:  🔒: Authentication Optional.
     
     - Parameter album:         The name of the album.
     - Parameter artist:        The name of the album's artist.
     - Parameter autoCorrect:   A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter username:      The username for the context of the request. If supplied, the user's playcount for this album is included in the response. If not supplied, the playcount for the authenticated user (if any) will be returned.
     - Parameter language:      The language to return the biography in, expressed as an ISO 639 alpha-2 code.
     - Parameter callback:      The callback block containing an `LFMError` if the request fails and an `Album` object if the request succeeds.
    
     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    @discardableResult
    class func getInfo(on album: String,
                       by artist: String,
                       autoCorrectArtist autoCorrect: Bool = true,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Album, LFMError>) -> Void) -> LFMURLOperation {
        return __getInfoOnAlbumNamed(album,
                                     byArtistNamed: artist,
                                     albumMBID: nil,
                                     autoCorrect: autoCorrect,
                                     forUsername: username,
                                     languageCode: language) { (album, error) in
            let result: Result<Album, LFMError>
            
            if let album = album {
                result = .success(album)
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    /**
     Retrieves the metadata and tracklist for an album on Last.fm using the album release MBID.
     
     - Note:  🔒: Authentication Optional.
     
     - Parameter mbid:          The MusicBrainzID for the album **release**.
     - Parameter artist:        The name of the album's artist.
     - Parameter autoCorrect:   A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter username:      The username for the context of the request. If supplied, the user's playcount for this album is included in the response. If not supplied, the playcount for the authenticated user (if any) will be returned.
     - Parameter language:      The language to return the biography in, expressed as an ISO 639 alpha-2 code.
     - Parameter callback:      The callback block containing an `LFMError` if the request fails and an `Album` object if the request succeeds.
     
     - Important:   It is **very** important that you use the album release id and not the album release group id. The album release group contains information about the album release - i.e. the releases for each country, whether a delux cd was released, the digital version etc. The album release is a specific one of these group items. If you provide an album release group id you will get an *error code* **6** saying the album was not found.
    
     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    @discardableResult
    class func getInfo(on mid: String,
                       username: String? = nil,
                       language: String? = nil,
                       callback: @escaping (Result<Album, LFMError>) -> Void) -> LFMURLOperation {
        return __getInfoOnAlbumNamed(nil,
                                     byArtistNamed: nil,
                                     albumMBID: mid,
                                     autoCorrect: false,
                                     forUsername: username,
                                     languageCode: language) { (album, error) in
            let result: Result<Album, LFMError>
            
            if let album = album {
                result = .success(album)
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    /**
     Retrieves the tags applied by an individual user to an album on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
     
     - Note:  🔒: Authentication Optional.
     
     - Parameter albumName:     The name of the album.
     - Parameter albumArtist:   The name of the album's artist.
     - Parameter autoCorrect:   A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter username:      The name of any Last.fm user from which to obtain album tags. If this method is called and the user has not been signed in, this parameter **MUST** be set otherwise an exception will be raised.
     - Parameter callback:      The callback block containing an `LFMError` if the request fails and an array of `Tag`s if it succeeds.
        
     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    @discardableResult
    class func getTags(for album: String,
                       by artist: String,
                       autoCorrectArtist autoCorrect: Bool = true,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTagsForAlbumNamed(album,
                                     byArtistNamed: artist,
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
     Retrieves the tags applied by an individual user to an album on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
     
     - Note:  🔒: Authentication Optional.
     
     - Parameter mbid:      The MusicBrainzID for the album **release**.
     - Parameter username:  The name of any Last.fm user from which to obtain album tags. If this method is called and the user has not been signed in, this parameter MUST be set otherwise an exception will be raised.
     - Parameter callback:  The callback block containing an `LFMError` if the request fails and an array of `Tag`s if it succeeds.
     
     - Important:   It is **very** important that you use the album release id and not the album release group id. The album release group contains information about the album release - i.e. the releases for each country, whether a delux cd was released, the digital version etc. The album release is a specific one of these group items. If you provide an album release group id you will get an *error code* **6** saying the album was not found.
        
     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    @discardableResult
    class func getTags(for mbid: String,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTagsForAlbumNamed(nil,
                                     byArtistNamed: nil,
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
    
    /**
     Retrieves the top tags for an album on Last.fm, ordered by popularity.
    
     - Parameter albumName:     The name of the album.
     - Parameter albumArtist:   The name of the album's artist.
     - Parameter autoCorrect:   A boolean value indicating whether or not to transform misspelled artist names into correct artist names. The corrected artist name will be returned in the response.
     - Parameter callback:      The callback block containing an `LFMError` if the request fails and an array of `TopTag`s if it succeeds.
    
     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    @discardableResult
    class func getTopTags(for album: String,
                          by artist: String,
                          autoCorrectArtist autoCorrect: Bool = true,
                          callback: @escaping (Result<[TopTag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTopTags(forAlbumNamed: album,
                            byArtistNamed: artist,
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
     Retrieves the top tags for an album on Last.fm, ordered by popularity.
    
     - Parameter mbid:      The MusicBrainzID for the album  **release**.
     - Parameter callback:  The callback block containing an `LFMError` if the request fails and an array of `TopTag`s if it succeeds.
     
     - Important:   It is **very** important that you use the album release id and not the album release group id. The album release group contains information about the album release - i.e. the releases for each country, whether a delux cd was released, the digital version etc. The album release is a specific one of these group items. If you provide an album release group id you will get an *error code* **6** saying the album was not found.
    
     - Returns:   The `LFMURLOperation` object to be resumed.
    */
    @discardableResult
    class func getTopTags(for mbid: String,
                          callback: @escaping (Result<[TopTag], LFMError>) -> Void) -> LFMURLOperation {
        return __getTopTags(forAlbumNamed: nil,
                            byArtistNamed: nil,
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
     Searches for an album by name. Returns album matches sorted by relevance.
     
     - Parameter albumName:   The name of the album.
     - Parameter limit:       The number of search results available per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Limit must be between 1 and 10,000.
     - Parameter page:        The page of results to be fetched. Start page is 1. Page must be less than 10,000.
     - Parameter callback:    The callback block containing an `LFMError` if the request fails and an array of `Album`s and an `SearchQuery` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func search(for query: String,
                      limit: Int = 30,
                      page: Int = 1,
                      callback: @escaping (Result<([Album], SearchQuery), LFMError>) -> Void) -> LFMURLOperation {
        return __search(forAlbumNamed: query,
                        itemsPerPage: NSNumber(value: limit),
                        onPage: NSNumber(value: page)) { (albums, searchQuery, error) in
            let result: Result<([Album], SearchQuery), LFMError>
            
            if let searchQuery = searchQuery, !albums.isEmpty {
                result = .success((albums, searchQuery))
            } else if let error = error {
                result = .failure(LFMError.underlyingError(error as NSError))
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
}
