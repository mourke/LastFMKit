//
//  LFMTrack.m
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

#import "LFMTrack.h"
#import "LFMWiki.h"
#import "LFMAlbum.h"
#import "LFMTag.h"
#import "LFMArtist.h"
#import "LFMKit+Protected.h"

@implementation LFMTrack {
    NSString *_name;
    NSURL *_URL;
    NSUInteger _duration;
    BOOL _streamable;
    LFMArtist *_artist;
    NSUInteger _positionInAlbum;
    NSArray <LFMTag *> *_tags;
    LFMWiki *_wiki;
    LFMAlbum * __weak _album;
    NSUInteger _listeners;
    NSUInteger _playCount;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        NSString *name = [dictionary objectForKey:@"name"];
        NSString *mbid = [dictionary objectForKey:@"mbid"];
        NSURL *URL = [NSURL URLWithString:[dictionary objectForKey:@"url"]];
        NSUInteger listeners = [[dictionary objectForKey:@"listeners"] unsignedIntegerValue];
        
        if (name != nil &&
            mbid != nil &&
            URL != nil &&
            !isnan(listeners))
        {
            // Advanced variables that are only aquired on a `getInfo` call to Track.
            NSUInteger duration = [[dictionary objectForKey:@"duration"] unsignedIntegerValue];
            NSUInteger playCount = [[dictionary objectForKey:@"playcount"] unsignedIntegerValue];
            BOOL streamable = [[[dictionary objectForKey:@"streamable"] objectForKey:@"fulltrack"] boolValue];
            NSUInteger positionInAlbum = [[[[dictionary objectForKey:@"album"] objectForKey:@"@attr"] objectForKey:@"position"] unsignedIntegerValue];
            
            LFMArtist *artist = [[LFMArtist alloc] initFromDictionary:[dictionary objectForKey:@"artist"]];
            LFMAlbum *album = [[LFMAlbum alloc] initFromDictionary:[dictionary objectForKey:@"album"]];
            LFMWiki *wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"wiki"]];
            
            NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
            
            for (NSDictionary *tagDictionary in [[dictionary objectForKey:@"toptags"] objectForKey:@"tag"]) {
                LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                tag == nil ?: [tags addObject:tag];
            }
            
            _name = name;
            _mbid = mbid;
            _URL = URL;
            _listeners = listeners;
            _duration = duration;
            _playCount = playCount;
            _streamable = streamable;
            _positionInAlbum = positionInAlbum;
            _artist = artist;
            _album = album;
            _wiki = wiki;
            
            return self;
        }
    }
    
    return nil;
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
                   playCount:(NSUInteger)playCount {
    self = [super init];
    
    if (self) {
        _name = trackName;
        _artist = artist;
        _mbid = mbid;
        _album = album;
        _positionInAlbum = position;
        _URL = URL;
        _duration = duration;
        _streamable = streamable;
        _tags = tags;
        _wiki = wiki;
        _listeners = listeners;
        _playCount = playCount;
    }
    
    return self;
}

- (NSString *)name {
    return _name;
}

- (NSURL *)URL {
    return _URL;
}

- (NSUInteger)duration {
    return _duration;
}

- (BOOL)isStreamable {
    return _streamable;
}

- (LFMArtist *)artist {
    return _artist;
}

- (NSUInteger)positionInAlbum {
    return _positionInAlbum;
}

- (NSArray<LFMTag *> *)tags {
    return _tags;
}

- (LFMWiki *)wiki {
    return _wiki;
}

- (LFMAlbum *)album {
    return _album;
}

- (NSUInteger)listeners {
    return _listeners;
}

- (NSUInteger)playCount {
    return _playCount;
}

@end
