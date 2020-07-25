//
//  UserProvider+Swift.swift
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

import Foundation
import LastFMKit.LFMUserProvider

public extension UserProvider {
    
    /**
     Retrieves items to which the user added personal tags.
     
     - Parameter user:  The user who performed the taggings.
     - Parameter tag:   The name of the tag to which the user applied the items.
     - Parameter type:  The type of the item. This MUST be either `Track`, `Album` or `Artist` or an exception will be raised.
     - Parameter limit: The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 50.
     - Parameter page:  The page of results to be fetched. Start page is 1 and is also the default value.
     - Parameter block: The callback block containing an optional `Error` if the request fails and an array of the specified type (`Aritst`s, `Track`s, `Album`s) and a `Query` object if it succeeds.
     
     - Returns: The `URLSessionDataTask` object from the web request.
     */
    class func getItemsTagged<T: NSObject>(by user: String, for tag: String, type: T.Type, limit: UInt, on page: UInt, callback block: @escaping (Error?, [T], Query?) -> Void) -> URLSessionDataTask {
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
        
        return __getItemsTagged(byUserNamed: user, forTagNamed: tag, itemType: taggingType, itemsPerPage: limit, onPage: page) { (error, items, query) in
            block(error, items as! [T], query)
        }
    }
    
}
