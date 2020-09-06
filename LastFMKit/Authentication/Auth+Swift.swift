//
//  Auth+Swift.swift
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

public extension Auth {
    
    /**
     Starts a mobile service session for a user. Session keys have an infinite lifetime by default so this method need only be called once at the very start of your application, unless the user revokes privileges for your application on their Last.fm settings screen. Upon success, the `Session` object passed into the `block` parameter will also be stored in the user's keychain and set as the `session` property on this class as well as the shared singleton instance on the `Session` class itself. For any subsiquent app launches, this method need not be called as the session object will automatically be loaded from the user's keychain.
     
     - Parameter username:    The last.fm username or email address.
     - Parameter password:    The password in plaintext.
     - Parameter callback:    The block called upon completion indicating success or failure.
     
     - Returns: The `URLSessionDataTask` object from the web request.
     */
    @discardableResult
    func getSession(username: String,
                    password: String,
                    callback: @escaping (Result<Session, Error>) -> Void) -> LFMURLOperation {
        return __getSessionWithUsername(username, password: password) { (session, error) in
            let result: Result<Session, Error>

            if let session = session {
                result = .success(session)
            } else {
                result = .failure(error ?? NSError() as Error)
            }
            
            callback(result)
        }
    }
}
