//
//  TagProvider+Swift.swift
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

public extension TagProvider {
    
    /**
     Retrieves metadata for a tag.
     
     - Parameter tagName:     The name of the tag to be fetched.
     - Parameter language:    The language in which to return the wiki, expressed as an ISO 639 alpha-2 code.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an `Tag` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getInfo(on tag: String,
                       language: String? = nil,
                       callback: @escaping (Result<Tag, Error>) -> Void) -> LFMURLOperation {
        return __getInfoOnTagNamed(tag,
                                   language: language) { (tag, error) in
            let result: Result<Tag, Error>
            
            if let tag = tag {
                result = .success(tag)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves the top global tags on Last.fm, sorted by popularity (number of times used).
     
     - Parameter callback:   The callback block containing an optional `LFMError` if the request fails and an array of `TopTag`s if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopTags(_ callback: @escaping (Result<[TopTag], Error>) -> Void) -> LFMURLOperation {
        return __getTopTags { (tags, error) in
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
     Retrieves tags similar to a specified tag. Returns tags ranked by similarity, based on listening data.
     
     - Parameter tag:       The name of the tag.
     - Parameter callback:  The callback block containing an optional `LFMError` if the request fails and an array of `Tag` objects if the request succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getSimilarTags(to tag: String,
                              callback: @escaping (Result<[Tag], Error>) -> Void) -> LFMURLOperation {
        return __getTagsSimilar(toTagNamed: tag) { (tags, error) in
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
     Retrieves the top albums tagged by this tag, ordered by tag count.
     
     - Parameter tag:    The name of the tag.
     - Parameter page:    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter limit:   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:   The callback block containing an optional `LFMError` if the request fails and an array of `Album`s and an `Query` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopAlbums(taggedBy tag: String,
                            limit: Int = 30,
                            on page: Int = 1,
                            callback:  @escaping (Result<([Album], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopAlbumsTagged(byTagNamed: tag,
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
     Retrieves the top artists tagged by this tag, ordered by tag count.
     
     - Parameter tag: The name of the tag.
     - Parameter page:    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter limit:   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:   The callback block containing an optional `LFMError` if the request fails and an array of `Artist`s and an `Query` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopArtists(taggedBy tag: String,
                            limit: Int = 30,
                            on page: Int = 1,
                            callback:  @escaping (Result<([Artist], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopArtistsTagged(byTagNamed: tag,
                                    itemsPerPage: limit as NSNumber,
                                    onPage: page as NSNumber) { (artists, query, error) in
            let result: Result<([Artist], Query), Error>
                                        
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

    /**
     Retrieves the top tracks tagged by this tag, ordered by tag count.
     
     - Parameter tag: The name of the tag.
     - Parameter page:    The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter limit:   The maximum number of albums to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:   The callback block containing an optional `LFMError` if the request fails and an array of `Track`s and an `Query` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopTracks(taggedBy tag: String,
                            limit: Int = 30,
                            on page: Int = 1,
                            callback:  @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopTracksTagged(byTagNamed: tag,
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
}
