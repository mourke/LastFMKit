//
//  LFMLibraryProvider.h
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

@class LFMArtist, LFMQuery;

NS_ASSUME_NONNULL_BEGIN

/**
 This class provides helper methods for looking up a user's Last.fm library.
 */
NS_SWIFT_NAME(LibraryProvider)
@interface LFMLibraryProvider : LFMProvider

/**
 Retrieves a list of all the artists in a user's library, with play counts and tag counts.
 
 @param username    The user whose library is to be fetched.
 @param page        The page of results to be fetched. Start page is 1 and is also the default value.
 @param limit       The maximum number of artists to be returned by each page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Defaults to 30.
 @param block       The callback block containing an optional `NSError` if the request fails and an array of `LFMArtist`s and an `LFMQuery` object if it succeeds.
 
 @return   The `NSURLSessionDataTask` object from the web request.
 */
+ (NSURLSessionDataTask *)getArtistsForUsername:(NSString *)username
                                    itemsPerPage:(NSUInteger)limit
                                          onPage:(NSUInteger)page
                                        callback:(void(^)(NSError * _Nullable, NSArray<LFMArtist *> *, LFMQuery * _Nullable))block;

@end

NS_ASSUME_NONNULL_END
