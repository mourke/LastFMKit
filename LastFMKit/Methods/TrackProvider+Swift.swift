//
//  TrackProvider+Swift.swift
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

public extension TrackProvider {
    
    /**
     Notifies Last.fm that a user has started listening to a track.
     
     - Note:  🔒: Authentication Required.
     
     - Parameter track:   The name of the track.
     - Parameter artist:  The name of the track's artist.
     - Parameter album:   The name of the track's album, if any.
     - Parameter position: The position of the track on said album, if any.
     - Parameter albumArtist: The artist of the album, if different to that of the track.
     - Parameter duration:    The duration of the track, in seconds.
     - Parameter mbid:        The MusicBrainzID for the track.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails. Regardless of the success of the operation, this block will be called.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func updateNowPlaying(track: String,
                                by artist: String,
                                on album: String? = nil,
                                position: Int? = nil,
                                albumArtist: String? = nil,
                                duration: TimeInterval? = nil,
                                mbid: String? = nil,
                                callback: LFMErrorCallback? = nil) -> LFMURLOperation {
        return __updateNowPlaying(withTrackNamed: track,
                                  byArtistNamed: artist,
                                  onAlbumNamed: album,
                                  positionInAlbum: position as NSNumber?,
                                  withAlbumArtistNamed: albumArtist,
                                  trackDuration: duration as NSNumber?,
                                  musicBrainzId: mbid,
                                  callback: callback)
    }
    
    /**
     Retrieves detailed information on a track using its name and artist or MusicBrainzID.
     
     - Parameter track:   The name of the track.
     - Parameter artist:  The name of the artist.
     - Parameter autoCorrect: A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
     - Parameter username:    The username for the context of the request. If supplied, the user's playcount for this track is included in the response.
     - Parameter callback:    The callback block containing an optional `LFMError` if the request fails and a `Track` object if the request succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getInfo(on track: String,
                       by artist: String,
                       autoCorrect: Bool = true,
                       username: String? = nil,
                       callback: @escaping (Result<Track, Error>) -> Void) -> LFMURLOperation {
        return __getInfoOnTrackNamed(track,
                                     byArtistNamed: artist,
                                     withMusicBrainzId: nil,
                                     autoCorrect: autoCorrect,
                                     forUser: username) { (track, error) in
            let result: Result<Track, Error>
            
            if let track = track {
                result = .success(track)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }
    
    /**
     Adds a track-play to a user's profile.
     
     A track should only be scrobbled when both of the following conditions have been met:
     * The track must be longer than 30 seconds in length.
     * The track has been played for at least half its duration, or for 4 minutes (whichever occurs earlier).
     
     - Note: 🔒: Authentication Required.
     
     - Parameter tracks:  The array of tracks to be scrobbled. The maximum amount of tracks that can be scrobbled at a time is 50. An exception will be raised if this limit is passed.
     - Parameter callback:  The callback block containing an optional `LFMError` if the request fails and an array of `ScrobbleResult` objects if the request succeeds.
     
     - Returns:   The `URLOperation` object to be resumed.
     */
    class func scrobble(tracks: [ScrobbleTrack],
                        callback: @escaping (Result<[ScrobbleResult], Error>) -> Void) -> LFMURLOperation {
        return __scrobbleTracks(tracks) { (results, error) in
            let result: Result<[ScrobbleResult], Error>
            
            if let error = error {
                result = .failure(error)
            } else {
                result = .success(results)
            }
            
            callback(result)
        }
    }
    
    /**
     Retrieves detailed information on a track using its name and artist or MusicBrainzID.
     
     - Parameter mbid:        The MusicBrainzID for the track.
     - Parameter username:    The username for the context of the request. If supplied, the user's playcount for this track is included in the response.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and a `Track` object if the request succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getInfo(mbid: String,
                       username: String? = nil,
                       callback: @escaping (Result<Track, Error>) -> Void) -> LFMURLOperation {
        return __getInfoOnTrackNamed(nil,
                                     byArtistNamed: nil,
                                     withMusicBrainzId: mbid,
                                     autoCorrect: false,
                                     forUser: username) { (track, error) in
            let result: Result<Track, Error>
            
            if let track = track {
                result = .success(track)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Searches for a track by name. Returns track matches sorted by relevance.
     
     - Parameter track:   The name of the track.
     - Parameter artist:  The track's artist.
     - Parameter limit:       The number of search results available per page. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter page:        The page of results to be fetched. Must be between 1 and 10,000. Defaults to 1.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track`s and an `SearchQuery` object if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func search(for track: String,
                      by artist: String,
                      limit: Int = 30,
                      on page: Int = 1,
                      callback:  @escaping (Result<([Track], SearchQuery), Error>) -> Void) -> LFMURLOperation {
        return __search(forTrackNamed: track,
                        byArtistNamed: artist,
                        itemsPerPage: limit as NSNumber,
                        onPage: page as NSNumber) { (tracks, query, error) in
            let result: Result<([Track], SearchQuery), Error>
            
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
     Retrieves tracks similar to a specified track.
     
     - Parameter track:   The name of the track.
     - Parameter artist:  The name of the artist.
     - Parameter autoCorrect: A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
     - Parameter limit:       The maximum number of similar tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects if the request succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getSimilarTracks(to track: String,
                                by artist: String,
                                autoCorrect: Bool = true,
                                limit: Int = 30,
                                callback: @escaping (Result<[Track], Error>) -> Void) -> LFMURLOperation {
        return __getTracksSimilar(toTrackNamed: track,
                                  byArtistNamed: artist,
                                   withMusicBrainzId: nil,
                                   autoCorrect: autoCorrect,
                                   limit: limit as NSNumber) { (tracks, error) in
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
     Retrieves tracks similar to a specified track.
     
     - Parameter mbid:        The MusicBrainzID for the track. Required unless both the trackName and artistName are specified.
     - Parameter limit:       The maximum number of similar tracks to be returned. Keep in mind the larger the limit, the longer the request will take to both process and fetch. Must be between 1 and 10,000. Defaults to 30.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Track` objects if the request succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getSimilarTracks(to mbid: String,
                                limit: Int = 30,
                                callback: @escaping (Result<[Track], Error>) -> Void) -> LFMURLOperation {
        return __getTracksSimilar(toTrackNamed: nil,
                                  byArtistNamed: nil,
                                   withMusicBrainzId: mbid,
                                   autoCorrect: false,
                                   limit: limit as NSNumber) { (tracks, error) in
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
     Checks whether the supplied track has a correction to a canonical track.
     
     - Parameter track:   The misspelt/misconcatinated name of a track.
     - Parameter artist:  The misspelt/misconcatinated name of the track's artist.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an `Track` object if the request succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getCorrection(forMisspelled track: String,
                             byMisspelled artist: String,
                             callback: @escaping (Result<Track, Error>) -> Void) -> LFMURLOperation {
        return __getCorrectionForMisspelledTrackNamed(track,
                                                      withMisspelledArtistNamed: artist) { (track, error) in
            let result: Result<Track, Error>
            
            if let track = track {
                result = .success(track)
            } else if let error = error {
                result = .failure(error)
            } else {
                fatalError("Unhandled error occurred")
            }
            
            callback(result)
        }
    }

    /**
     Retrieves the tags applied by an individual user to a track on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
     
     - Note:  🔒: Authentication Optional.
     
     - Parameter track:   The name of the track.
     - Parameter artist:  The name of the track's artist.
     - Parameter autoCorrect: A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
     - Parameter username:    The name of any Last.fm user from which to obtain track tags. If this method is called and the user has not been signed in, this parameter **MUST** be set otherwise an exception will be raised.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Tag`s if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTags(for track: String,
                       by artist: String,
                       autoCorrect: Bool = true,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], Error>) -> Void) -> LFMURLOperation {
        return __getTagsForTrackNamed(track,
                                      byArtistNamed: artist,
                                      withMusicBrainzId: nil,
                                      autoCorrect: autoCorrect,
                                      forUser: username) { (tags, error) in
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
     Retrieves the tags applied by an individual user to a track on Last.fm. If accessed as an authenticated service and a user parameter is not supplied then this service will return tags for the authenticated user.
     
     - Note:  🔒: Authentication Optional.
     
     - Parameter mbid:       The MusicBrainzID for the track.
     - Parameter username:    The name of any Last.fm user from which to obtain track tags. If this method is called and the user has not been signed in, this parameter **MUST** be set otherwise an exception will be raised.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `Tag`s if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTags(for mbid: String,
                       username: String? = nil,
                       callback: @escaping (Result<[Tag], Error>) -> Void) -> LFMURLOperation {
        return __getTagsForTrackNamed(nil,
                                      byArtistNamed: nil,
                                      withMusicBrainzId: mbid,
                                      autoCorrect: false,
                                      forUser: username) { (tags, error) in
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
     Retrieves the top tags for a track on Last.fm, ordered by popularity.
     
     - Parameter track:   The name of the track.
     - Parameter artist:  The name of the track's artist.
     - Parameter autoCorrect: A boolean value indicating whether or not to transform misspelled artist and track names into correct artist and track names, returning the correct version instead. The corrected artist and track name will be returned in the response.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `TopTag`s if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTopTags(for track: String,
                          by artist: String,
                          autoCorrect: Bool = true,
                          callback: @escaping (Result<[TopTag], Error>) -> Void) -> LFMURLOperation {
        return __getTopTags(forTrackNamed: track,
                            byArtistNamed: artist,
                            withMusicBrainzId: nil,
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
     Retrieves the top tags for a track on Last.fm, ordered by popularity.
     
     - Parameter mbid:        The MusicBrainzID for the track.
     - Parameter callback:       The callback block containing an optional `LFMError` if the request fails and an array of `TopTag`s if it succeeds.
     
     - Returns:   The `LFMURLOperation` object to be resumed.
     */
    class func getTopTags(for mbid: String,
                          callback: @escaping (Result<[TopTag], Error>) -> Void) -> LFMURLOperation {
        return __getTopTags(forTrackNamed: nil,
                            byArtistNamed: nil,
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
}
