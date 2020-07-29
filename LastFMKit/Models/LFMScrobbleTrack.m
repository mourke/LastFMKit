//
//  LFMScrobbleTrack.m
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

#import "LFMScrobbleTrack.h"

@implementation LFMScrobbleTrack {
    NSDate *_timestamp;
    BOOL _chosenByUser;
}

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
                   playCount:(NSUInteger)playCount
                   timestamp:(NSDate *)timestamp
                chosenByUser:(BOOL)chosenByUser {
    self = [super initWithName:trackName
                        artist:artist
                 musicBrainzID:mbid
                         album:album
               positionInAlbum:position
                           URL:URL
                      duration:duration
                    streamable:streamable
                          tags:tags
                          wiki:wiki
                     listeners:listeners
                     playCount:playCount];
    
    if (self) {
        _timestamp = timestamp;
        _chosenByUser = chosenByUser;
    }
    
    return nil;
}

- (instancetype)initFromTrack:(LFMTrack *)track withTimestamp:(NSDate *)timestamp chosenByUser:(BOOL)chosenByUser {
    return [self initWithName:track.name
                       artist:track.artist
                musicBrainzID:track.mbid
                        album:track.album
              positionInAlbum:track.positionInAlbum
                          URL:track.URL
                     duration:track.duration
                   streamable:track.isStreamable
                         tags:track.tags
                         wiki:track.wiki
                    listeners:track.listeners
                    playCount:track.playCount
                    timestamp:timestamp
                 chosenByUser:chosenByUser];
}

- (instancetype)initWithName:(NSString *)trackName artist:(nullable LFMArtist *)artist musicBrainzID:(NSString *)mbid album:(nullable LFMAlbum *)album positionInAlbum:(NSUInteger)position URL:(NSURL *)URL duration:(NSUInteger)duration streamable:(BOOL)streamable tags:(NSArray<LFMTag *> *)tags wiki:(nullable LFMWiki *)wiki listeners:(NSUInteger)listeners playCount:(NSUInteger)playCount {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSDate *)timestamp {
    return _timestamp;
}

- (BOOL)wasChosenByUser {
    return _chosenByUser;
}

@end
