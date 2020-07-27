//
//  LFMTrack.m
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
    LFMAlbum *_album;
    NSUInteger _listeners;
    NSUInteger _playCount;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self &&
        dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id name = [dictionary objectForKey:@"name"];
        id URL = [dictionary objectForKey:@"url"];
        
        if (name != nil && [name isKindOfClass:NSString.class] &&
            URL != nil && [URL isKindOfClass:NSString.class])
        {
            id mbid = [dictionary objectForKey:@"mbid"];
            if (mbid != nil &&
                [mbid isKindOfClass:NSString.class]) {
                _mbid = mbid;
            }
            
            id duration = [dictionary objectForKey:@"duration"];
            if (duration != nil &&
                [duration isKindOfClass:NSString.class]) {
                _duration = [duration unsignedIntegerValue];
            }
            
            id playCount = [dictionary objectForKey:@"playcount"];
            if (playCount != nil &&
                [playCount isKindOfClass:NSString.class]) {
                _playCount = [duration unsignedIntegerValue];
            }
            
            id streamableDictionary = [dictionary objectForKey:@"streamable"];
            if (streamableDictionary != nil &&
                [streamableDictionary isKindOfClass:NSDictionary.class]) {
                id streamable = [(NSDictionary *)streamableDictionary objectForKey:@"fulltrack"];
                
                if (streamable != nil &&
                    [streamable isKindOfClass:NSString.class]) {
                    _streamable = [streamable boolValue];
                }
            }
            
            id attributesDictionary = [dictionary objectForKey:@"@attr"];
            if (attributesDictionary != nil &&
                [attributesDictionary isKindOfClass:NSDictionary.class]) {
                id rank = [(NSDictionary *)attributesDictionary objectForKey:@"rank"];
                if (rank != nil &&
                    [rank isKindOfClass:NSString.class]) {
                    _positionInAlbum = [rank unsignedIntegerValue];
                }
            }
            
            id albumDictionary = [dictionary objectForKey:@"album"];
            if (albumDictionary != nil &&
                [albumDictionary isKindOfClass:NSDictionary.class]) {
                _album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
                
                id albumAttributesDictionary = [(NSDictionary *)albumDictionary objectForKey:@"@attr"];
                if (albumAttributesDictionary != nil &&
                    [albumAttributesDictionary isKindOfClass:NSDictionary.class]) {
                    id positionInAlbum = [(NSDictionary *)albumAttributesDictionary objectForKey:@"position"];
                    
                    if (positionInAlbum != nil &&
                        [positionInAlbum isKindOfClass:NSString.class]) {
                        _positionInAlbum = [positionInAlbum unsignedIntegerValue];
                    }
                }
            }
            
            _artist = [[LFMArtist alloc] initFromDictionary:[dictionary objectForKey:@"artist"]];
            _wiki = [[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"wiki"]];
            
            id topTagsDictionary = [dictionary objectForKey:@"toptags"];
            if (topTagsDictionary != nil &&
                [topTagsDictionary isKindOfClass:NSDictionary.class]) {
                NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
                
                id topTagsArray = [(NSDictionary *)topTagsDictionary objectForKey:@"tag"];
                if (topTagsArray != nil &&
                    [topTagsArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *tagDictionary in topTagsArray) {
                        LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                        if (tag) [tags addObject:tag];
                    }
                }
                
                _tags = tags;
            }
            
            id listeners = [dictionary objectForKey:@"listeners"];
            if ([listeners isKindOfClass:NSString.class]) {
                _listeners = [listeners unsignedIntegerValue];
            }
            
            _name = name;
            _mbid = mbid;
            _URL = [NSURL URLWithString:URL];
            
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
