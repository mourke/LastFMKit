//
//  ScrobbleTrack+Swift.swift
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

public extension ScrobbleTrack {
    
    /**
    Initialises a new `ScrobbleTrack` object.
    
    - Parameter name:   The name of the track.
    - Parameter artist:  The name of the track's artist.
    - Parameter album:   The name of the album that the track is a part of, if any.
    - Parameter albumArtist: The album artist - if this differs from the track artist.
    - Parameter position:    The track's position in its album (if any).
    - Parameter duration:    The approximate length (in seconds) of the song.
    - Parameter timestamp:       The date at which the track started playing.
    - Parameter chosenByUser:    This parameter is used to indicate when a scrobble comes from a source that the user doesn't have "direct" control over. If the user is listening to music that is effectively chosen by someone other than themselves (e.g. from a Last.fm radio stream; from some other recommendation service; or radio show put together by a DJ or host) then this value should be set to `false`, otherwise set it to `true`.
    
    - Returns:   A `ScrobbleTrack` object.
    */
    convenience init(name: String,
                     artist: String? = nil,
                     album: String? = nil,
                     albumArtist: String? = nil,
                     positionInAlbum position: Int? = nil,
                     duration: Int? = nil,
                     timestamp: Date,
                     chosenByUser: Bool) {
        self.init(__name: name,
                  artistName: artist,
                  albumName: album,
                  albumArtist: albumArtist,
                  positionInAlbum: position as NSNumber?,
                  duration: duration as NSNumber?,
                  timestamp: timestamp,
                  chosenByUser: chosenByUser)
    }
}
