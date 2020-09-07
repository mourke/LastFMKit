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
     - Parameter callback:    The callback block containing an `LFMError` if the request fails and a `User` object if it succeeds.

     - Returns:  The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getInfo(on user: String, callback: @escaping (Result<User, Error>) -> Void) -> LFMURLOperation {
        return __getInfoOnUserNamed(user) { (user, error) in
            let result: Result<User, Error>

            if let user = user {
                result = .success(user)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }

            callback(result)
        }
    }

    /**
     Retrieves a list of a user's friends on Last.fm.

     - Parameter username:        The name of the user whose friends are to be fetched.
     - Parameter includeRecentScrobbles:  A boolean value indiciating whether or not to include information about a friend's recently played tracks.
     - Parameter limit:           The maximum number of friends to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:            The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback:           The callback block containing an optional `LFMError` if the request fails and an array of `User` objects and an `LFMQuery` object if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getFriends(of username: String,
                          includeRecentScrobbles: Bool,
                          limit: Int = 30,
                          on page: Int = 1,
                          callback:@escaping (Result<([User], Query), Error>) -> Void) -> LFMURLOperation {
        return __getFriendsOfUserNamed(username,
                                       includeRecentScrobbles: includeRecentScrobbles,
                                       itemsPerPage: limit as NSNumber,
                                       onPage: page as NSNumber) { (users, query, error) in
            let result: Result<([User], Query), Error>
            
            if let query = query {
                result = .success((users, query))
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves a list of tracks by a given artist scrobbled by a user, including scrobble time. Can be limited to specific timeranges, defaults to all time.

     - Parameter username:    The name of the user whose scrobbles are to be fetched.
     - Parameter artist:  The scrobbled track's artist.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter startDate:   The earliest date from which to fetch scrobbles.
     - Parameter endDate:     The latest date from which to fetch scrobbles.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects and an `Query` object if it succeeds.

     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTracks(scrobbledBy username: String,
                         byArtist artist: String,
                         on page: Int = 1,
                         from startDate: Date? = nil,
                         to endDate: Date? = nil,
                         callback: @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTracksScrobbled(byUserNamed: username,
                                    byArtistNamed: artist,
                                    onPage: page as NSNumber,
                                    fromStart: startDate,
                                    toEnd: endDate) { (tracks, query, error) in
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
     Retrieves the tracks loved by a user.

     - Parameter username:    The user for whom to fetch the loved tracks.
     - Parameter limit:       The maximum number of tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects and an `Query` object if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTracks(lovedBy username: String,
                         limit: Int = 30,
                         on page: Int = 1,
                         callback: @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTracksLoved(byUserNamed: username,
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
     Retrieves items to which the user added personal tags.

     - Parameter user:  The user who performed the taggings.
     - Parameter tag:   The name of the tag to which the user applied the items.
     - Parameter type:  The type of the item. This **MUST** be either `Track`, `Album` or `Artist` or an exception will be raised.
     - Parameter limit: The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:  The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback: The callback block containing an `LFMError` if the request fails and an array of the specified type (`Aritst`s, `Track`s, `Album`s) and a `Query` object if it succeeds.

     - Returns: The `LFMURLOperation` object to be resumed.
     */
    class func getItemsTagged<T: NSObject>(by user: String,
                                           for tag: String,
                                           type: T.Type,
                                           limit: Int = 30,
                                           on page: Int = 1,
                                           callback: @escaping (Result<([T], Query), Error>) -> Void) -> LFMURLOperation {
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
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }

            callback(result)
        }
    }

    /**
     Retrieves a list of the recent tracks listened to by this user.

     - Parameter username:    The user for whom to fetch recent tracks.
     - Parameter limit:       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter startDate:   The earliest date from which to fetch tracks.
     - Parameter endDate:     The latest date from which to fetch tracks.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects and an `Query` object if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getRecentTracks(for username: String,
                               limit: Int = 30,
                               on page: Int = 1,
                               from startDate: Date? = nil,
                               to endDate: Date? = nil,
                               callback: @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getRecentTracks(forUsername: username,
                                itemsPerPage: limit as NSNumber,
                                onPage: page as NSNumber,
                                fromStart: startDate,
                                toEnd: endDate) { (tracks, query, error) in
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
     Retrieves the top albums listened to by a user. The period can be stipulated. Sends the overall chart by default.

     - Parameter username:    The user for whom to fetch top albums.
     - Parameter limit:       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter period:      The time period over which to retrieve top albums.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Album` objects and an `Query` object if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopAlbums(for username: String,
                            limit: Int = 30,
                            on page: Int = 1,
                            over period: TimePeriod = .oneWeek,
                            callback: @escaping (Result<([Album], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopAlbums(forUsername: username,
                                itemsPerPage: limit as NSNumber,
                                onPage: page as NSNumber,
                                overPeriod: period) { (albums, query, error) in
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
     Retrieves the top artists listened to by a user. The period can be stipulated. Sends the overall chart by default.

     - Parameter username:    The user for whom to fetch top artists.
     - Parameter limit:       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter period:      The time period over which to retrieve top artists.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Artist` objects and an `Query` object if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopArtists(for username: String,
                             limit: Int = 30,
                             on page: Int = 1,
                             over period: TimePeriod = .oneWeek,
                             callback: @escaping (Result<([Artist], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopArtists(forUsername: username,
                                itemsPerPage: limit as NSNumber,
                                onPage: page as NSNumber,
                                overPeriod: period) { (artists, query, error) in
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
     Retrieves the top tracks listened to by a user. The period can be stipulated. Sends the overall chart by default.

     - Parameter username:    The user for whom to fetch top tracks.
     - Parameter limit:       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter period:      The time period over which to retrieve top tracks.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects and an `Query` object if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopTracks(for username: String,
                            limit: Int = 30,
                            on page: Int = 1,
                            over period: TimePeriod = .oneWeek,
                            callback: @escaping (Result<([Track], Query), Error>) -> Void) -> LFMURLOperation {
        return __getTopTracks(forUsername: username,
                                itemsPerPage: limit as NSNumber,
                                onPage: page as NSNumber,
                                overPeriod: period) { (tracks, query, error) in
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
     Retrieves the top tags used by this user.

     - Parameter username:    The user for whom to fetch top tags.
     - Parameter limit:       The maximum number of items to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `TopTag` objects if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getTopTags(for username: String,
                         limit: Int = 30,
                         callback: @escaping (Result<[TopTag], Error>) -> Void) -> LFMURLOperation {
        return __getTopTags(forUsername: username,
                            limit: limit as NSNumber) { (tags, error) in
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
     Retrieves an album chart for a user profile, for a given date range. If no date range is supplied, the most recent album chart for this user will be returned.

     - Parameter username:    The user for whom to fetch album charts.
     - Parameter startDate:   The date from which the chart should start.
     - Parameter endDate:     The date on which the chart should end.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Album` objects if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getWeeklyAlbumChart(for username: String,
                                   from startDate: Date? = nil,
                                   to endDate: Date? = nil,
                                   callback: @escaping (Result<[Album], Error>) -> Void) -> LFMURLOperation {
        return __getWeeklyAlbumChart(forUsername: username,
                                     fromStart: startDate,
                                     toEnd: endDate) { (albums, error) in
            let result: Result<[Album], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(albums)
            }
            
            callback(result)
        }
    }

    /**
     Retrieves an artist chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent artist chart for this user.

     - Parameter username:    The user for whom to fetch artist charts.
     - Parameter startDate:   The date from which the chart should start.
     - Parameter endDate:     The date on which the chart should end.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Artist` objects if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getWeeklyArtistChart(for username: String,
                                    from startDate: Date? = nil,
                                    to endDate: Date? = nil,
                                    callback: @escaping (Result<[Artist], Error>) -> Void) -> LFMURLOperation {
        return __getWeeklyArtistChart(forUsername: username,
                                     fromStart: startDate,
                                     toEnd: endDate) { (artists, error) in
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
     Retrieves a track chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent track chart for this user.

     - Parameter username:    The user for whom to fetch track charts.
     - Parameter startDate:   The date from which the chart should start.
     - Parameter endDate:     The date on which the chart should end.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getWeeklyTrackChart(for username: String,
                                   from startDate: Date? = nil,
                                   to endDate: Date? = nil,
                                   callback: @escaping (Result<[Track], Error>) -> Void) -> LFMURLOperation {
        return __getWeeklyTrackChart(forUsername: username,
                                     fromStart: startDate,
                                     toEnd: endDate) { (tracks, error) in
            let result: Result<[Track], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(tracks)
            }
            
            callback(result)
        }
    }

    /**
     Retrieves a list of available charts for this user, expressed as date ranges which can be sent to the chart services.

     - Parameter username:    The user for whom to fetch chart lists.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Chart` objects if it succeeds.

     - Returns:    The `LFMURLOperation` object to be resumed.
     */
    @discardableResult
    class func getWeeklyChartList(for username: String,
                                  callback: @escaping (Result<[Chart], Error>) -> Void) -> LFMURLOperation {
        return __getWeeklyChartList(forUsername: username) { (charts, error) in
            let result: Result<[Chart], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(charts)
            }
            
            callback(result)
        }
    }
}
