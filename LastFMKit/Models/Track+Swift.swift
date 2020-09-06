//
//  Track+Swift.swift
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

public extension Track {
    /// The approximate length (in seconds) of the song.
    var duration: Int? {
        return __duration?.intValue
    }

    /// The track's position in its album (if any).
    var positionInAlbum: Int? {
        return __positionInAlbum?.intValue
    }
    
    /// The amount of listeners the track has.
    var listeners: Int? {
        return __listeners?.intValue
    }

    //// The amount of "scrobbles" the track has.
    var playCount: Int? {
        return __playCount?.intValue
    }

    /**
     Initialises a new `Track` object.
     
     - Parameter track:   The name of the track.
     - Parameter artist:      The track's artist.
     - Parameter mbid:        The MusicBrainzID for the track.
     - Parameter album:       The album that the track is a part of, if any.
     - Parameter position:    The track's position in its album (if any).
     - Parameter url:         The Last.fm URL for the track.
     - Parameter duration:   The approximate length (in seconds) of the song.
     - Parameter streamable:  A boolean value indicating whether or not the track is streamable.
     - Parameter tags:       An array of tags that most accurately describe the track.
     - Parameter wiki:        A small amount of information about the track.
     - Parameter listeners:   The amount of listeners the track has.
     - Parameter playCount:   The amount of "scrobbles" the track has.
     
     - Returns:   A `Track` object.
     */
    convenience init(name: String,
                     artist: Artist? = nil,
                     musicBrainzID: String? = nil,
                     album: Album? = nil,
                     position: Int? = nil,
                     url: URL,
                     duration: TimeInterval? = nil,
                     streamable: Bool,
                     tags: [Tag] = [],
                     wiki: Wiki? = nil,
                     listeners: Int? = nil,
                     playCount: Int? = nil) {
        self.init(__name: name,
                  artist: artist,
                  musicBrainzID: musicBrainzID,
                  album: album,
                  positionInAlbum: position as NSNumber?,
                  url: url,
                  duration: duration as NSNumber?,
                  streamable: streamable,
                  tags: tags,
                  wiki: wiki,
                  listeners: listeners as NSNumber?,
                  playCount: playCount as NSNumber?)
    }
}
