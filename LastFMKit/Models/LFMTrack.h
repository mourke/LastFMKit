//
//  LFMTrack.h
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

#import <Foundation/Foundation.h>

@class LFMArtist, LFMTag, LFMWiki, LFMAlbum;

NS_ASSUME_NONNULL_BEGIN

/**
 This class represents the Last.fm track object.
 */
NS_SWIFT_NAME(Track)
@interface LFMTrack : NSObject

/** The name of the track. */
@property(strong, nonatomic, readonly) NSString *name;

/** The track's Musicbrainz id. */
@property (strong, nonatomic, readonly) NSString *mbid;

/** The Last.fm URL for the track. Eg. "http://www.last.fm/music/Cher/Believe" */
@property(strong, nonatomic, readonly) NSURL *URL NS_SWIFT_NAME(url);

/** The approximate length (in seconds) of the song. */
@property(nonatomic, readonly) NSUInteger duration;

/** A boolean value indicating whether or not the track is streamable. */
@property(nonatomic, readonly, getter=isStreamable) BOOL streamable;

/** The track's position in its album (if any). Will be NaN if the track doesn't belong to any album. */
@property(nonatomic) NSUInteger positionInAlbum;

/** An array of tags that most accurately describe the track. */
@property(strong, nonatomic) NSArray <LFMTag *> *tags;

/** The track's artist. */
@property(nonatomic, strong, readonly, nullable) LFMArtist *artist;

/** A small amount of information about the track. */
@property(strong, nonatomic, nullable) LFMWiki *wiki;

/** The album that the track is a part of, if any. */
@property(weak, nonatomic, nullable) LFMAlbum *album;

/** The amount of listeners the track has. */
@property(nonatomic, readonly) NSUInteger listeners;

/** The amount of "scrobbles" the track has. */
@property(nonatomic, readonly) NSUInteger playCount;

/**
 Initialises a new `LFMTrack` object.
 
 @param trackName   The name of the track.
 @param artist      The track's artist.
 @param mbid        The MusicBrainzID for the track.
 @param album       The album that the track is a part of, if any.
 @param position    The track's position in its album (if any). Will be NaN if the track doesn't belong to any album.
 @param URL         The Last.fm URL for the track.
 @param duration    The approximate length (in seconds) of the song.
 @param streamable  A boolean value indicating whether or not the track is streamable.
 @param tags        An array of tags that most accurately describe the track.
 @param wiki        A small amount of information about the track.
 @param listeners   The amount of listeners the track has.
 @param playCount   The amount of "scrobbles" the track has.
 
 @returns   An `LFMScrobbleTrack` object.
 */
- (instancetype)initWithName:(NSString *)trackName
                      artist:(nullable LFMArtist *)artist
               musicBrainzID:(NSString *)mbid
                       album:(nullable LFMAlbum *)album
             positionInAlbum:(NSUInteger)position
                         URL:(NSURL *)URL
                    duration:(NSUInteger)duration
                  streamable:(BOOL)streamable
                        tags:(NSArray<LFMTag *> *)tags
                        wiki:(nullable LFMWiki *)wiki
                   listeners:(NSUInteger)listeners
                   playCount:(NSUInteger)playCount NS_SWIFT_NAME(init(name:artist:mbid:album:position:url:duration:streamable:tags:wiki:listeners:playCount:));

- (instancetype) __unavailable init;
+ (instancetype) __unavailable new;

@end

NS_ASSUME_NONNULL_END
