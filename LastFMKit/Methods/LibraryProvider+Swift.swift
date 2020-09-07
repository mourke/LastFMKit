//
//  LibraryProvider+Swift.swift
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

public extension LibraryProvider {
    /**
     Retrieves a list of all the artists in a user's library, with play counts and tag counts.
     
     - Parameter username:    The user whose library is to be fetched.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 30.
     - Parameter limit:       The maximum number of artists to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Artist`s and an `Query` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getArtists(for username: String,
                          limit: Int = 30,
                          on page: Int = 30,
                          callback: @escaping (Result<([Artist], Query), Error>) -> Void) -> LFMURLOperation {
        return __getArtistsForUsername(username,
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
}
