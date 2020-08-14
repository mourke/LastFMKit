//
//  UserProvider+Swift.swift
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
import LastFMKit.LFMUserProvider

public extension UserProvider {
    
    /**
     Retrieves information about a user's profile.
     
     - Parameter username:    The user to fetch info for.
     - Parameter callback:    The callback block containing an optional `Error` if the request fails and a `User` object if it succeeds.
     
     - Returns:  The `URLSessionDataTask` object from the web request.
     */
    @discardableResult
    class func getInfo(on user: String, callback: @escaping (Result<User, Error>) -> Void) -> URLSessionDataTask {
        return __getInfoOnUserNamed(user) { (user, error) in
            let result: Result<User, Error>
            
            if let user = user {
                result = .success(user)
            } else {
                result = .failure(error ?? NSError() as Error)
            }
            
            callback(result)
        }
    }
    
    /**
     Retrieves items to which the user added personal tags.
     
     - Parameter user:  The user who performed the taggings.
     - Parameter tag:   The name of the tag to which the user applied the items.
     - Parameter type:  The type of the item. This MUST be either `Track`, `Album` or `Artist` or an exception will be raised.
     - Parameter limit: The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:  The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter block: The callback block containing an optional `Error` if the request fails and an array of the specified type (`Aritst`s, `Track`s, `Album`s) and a `Query` object if it succeeds.
     
     - Returns: The `URLSessionDataTask` object from the web request.
     */
    class func getItemsTagged<T: NSObject>(by user: String,
                                           for tag: String,
                                           type: T.Type,
                                           limit: Int = 30,
                                           on page: Int = 1,
                                           callback: @escaping (Result<([T], Query), Error>) -> Void) -> URLSessionDataTask {
        let taggingType: TaggingType
        
        switch type {
        case is Artist.Type:
            taggingType = .artist
        case is Album.Type:
            taggingType = .album
        case is Track.Type:
            taggingType = .track
        default:
            fatalError("The type of the item returned must be either `Track`, `Album` or `Artist`.")
        }
        
        return __getItemsTagged(byUserNamed: user,
                                forTagNamed: tag,
                                itemType: taggingType,
                                itemsPerPage: NSNumber(value: limit),
                                onPage: NSNumber(value: page)) { (items, query, error) in
            let result: Result<([T], Query), Error>
            
            if let query = query,
                let items = items as? [T] {
                result = .success((items, query))
            } else {
                result = .failure(error ?? NSError() as Error)
            }
            
            callback(result)
        }
    }
    
}
