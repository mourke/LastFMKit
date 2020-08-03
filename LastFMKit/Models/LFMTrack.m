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
    NSInteger _duration;
    BOOL _streamable;
    LFMArtist *_artist;
    NSInteger _positionInAlbum;
    NSArray<LFMTag *> *_tags;
    LFMWiki *_wiki;
    LFMAlbum *_album;
    NSInteger _listeners;
    NSInteger _playCount;
}

- (instancetype)initFromDictionary:(NSDictionary *)dictionary {
    if (dictionary != nil &&
        [dictionary isKindOfClass:NSDictionary.class]) {
        id name = [dictionary objectForKey:@"name"];
        id URL = [dictionary objectForKey:@"url"];
        
        if (name != nil && [name isKindOfClass:NSString.class] &&
            URL != nil && [URL isKindOfClass:NSString.class])
        {
            NSString *mbid;
            NSInteger duration = 0;
            NSInteger playCount = 0;
            BOOL streamable = NO;
            NSInteger positionInAlbum = 0;
            LFMAlbum *album;
            NSInteger listeners = 0;
            
            id mbidObject = [dictionary objectForKey:@"mbid"];
            if (mbidObject != nil &&
                [mbidObject isKindOfClass:NSString.class]) {
                mbid = mbidObject;
            }
            
            id durationObject = [dictionary objectForKey:@"duration"];
            if (durationObject != nil &&
                [durationObject isKindOfClass:NSString.class]) {
                duration = [durationObject integerValue];
            }
            
            id playCountObject = [dictionary objectForKey:@"playcount"];
            if (playCountObject != nil &&
                [playCountObject isKindOfClass:NSString.class]) {
                playCount = [playCountObject integerValue];
            }
            
            id streamableDictionary = [dictionary objectForKey:@"streamable"];
            if (streamableDictionary != nil &&
                [streamableDictionary isKindOfClass:NSDictionary.class]) {
                id fullTrack = [(NSDictionary *)streamableDictionary objectForKey:@"fulltrack"];
                
                if (fullTrack != nil &&
                    [fullTrack isKindOfClass:NSString.class]) {
                    streamable = [fullTrack boolValue];
                }
            }
            
            id attributesDictionary = [dictionary objectForKey:@"@attr"];
            if (attributesDictionary != nil &&
                [attributesDictionary isKindOfClass:NSDictionary.class]) {
                id rank = [(NSDictionary *)attributesDictionary objectForKey:@"rank"];
                if (rank != nil &&
                    [rank isKindOfClass:NSString.class]) {
                    positionInAlbum = [rank integerValue];
                }
            }
            
            id albumDictionary = [dictionary objectForKey:@"album"];
            if (albumDictionary != nil &&
                [albumDictionary isKindOfClass:NSDictionary.class]) {
                album = [[LFMAlbum alloc] initFromDictionary:albumDictionary];
                
                id albumAttributesDictionary = [(NSDictionary *)albumDictionary objectForKey:@"@attr"];
                if (albumAttributesDictionary != nil &&
                    [albumAttributesDictionary isKindOfClass:NSDictionary.class]) {
                    id position = [(NSDictionary *)albumAttributesDictionary objectForKey:@"position"];
                    
                    if (position != nil &&
                        [position isKindOfClass:NSString.class]) {
                        positionInAlbum = [position integerValue];
                    }
                }
            }
            
            NSMutableArray <LFMTag *> *tags = [NSMutableArray array];
            id topTagsDictionary = [dictionary objectForKey:@"toptags"];
            if (topTagsDictionary != nil &&
                [topTagsDictionary isKindOfClass:NSDictionary.class]) {
                id topTagsArray = [(NSDictionary *)topTagsDictionary objectForKey:@"tag"];
                if (topTagsArray != nil &&
                    [topTagsArray isKindOfClass:NSArray.class]) {
                    for (NSDictionary *tagDictionary in topTagsArray) {
                        LFMTag *tag = [[LFMTag alloc] initFromDictionary:tagDictionary];
                        if (tag) [tags addObject:tag];
                    }
                }
            }
            
            id listenersObject = [dictionary objectForKey:@"listeners"];
            if (listenersObject != nil && [listenersObject isKindOfClass:NSString.class]) {
                listeners = [listenersObject integerValue];
            }
            
            return [self initWithName:name
                               artist:[[LFMArtist alloc] initFromDictionary:[dictionary objectForKey:@"artist"]]
                        musicBrainzID:mbid
                                album:album
                      positionInAlbum:positionInAlbum
                                  URL:[NSURL URLWithString:URL]
                             duration:duration
                           streamable:streamable
                                 tags:tags
                                 wiki:[[LFMWiki alloc] initFromDictionary:[dictionary objectForKey:@"wiki"]]
                            listeners:listeners
                            playCount:playCount];
        }
    }
    
    return nil;
}

- (instancetype)initWithName:(NSString *)trackName
                      artist:(nullable LFMArtist *)artist
               musicBrainzID:(nullable NSString *)mbid
                       album:(nullable LFMAlbum *)album
             positionInAlbum:(NSInteger)position
                         URL:(NSURL *)URL
                    duration:(NSInteger)duration
                  streamable:(BOOL)streamable
                        tags:(NSArray<LFMTag *> *)tags
                        wiki:(nullable LFMWiki *)wiki
                   listeners:(NSInteger)listeners
                   playCount:(NSInteger)playCount {
    NSParameterAssert(trackName);
    NSParameterAssert(URL);
    NSParameterAssert(tags);
    
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

- (instancetype)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

+ (instancetype)new {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (NSString *)name {
    return _name;
}

- (NSURL *)URL {
    return _URL;
}

- (NSInteger)duration {
    return _duration;
}

- (BOOL)isStreamable {
    return _streamable;
}

- (LFMArtist *)artist {
    return _artist;
}

- (NSInteger)positionInAlbum {
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

- (NSInteger)listeners {
    return _listeners;
}

- (NSInteger)playCount {
    return _playCount;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:NSStringFromSelector(@selector(name))];
    [coder encodeObject:_artist forKey:NSStringFromSelector(@selector(artist))];
    [coder encodeObject:_mbid forKey:NSStringFromSelector(@selector(mbid))];
    [coder encodeObject:_album forKey:NSStringFromSelector(@selector(album))];
    [coder encodeInteger:_positionInAlbum forKey:NSStringFromSelector(@selector(positionInAlbum))];
    [coder encodeObject:_URL forKey:NSStringFromSelector(@selector(URL))];
    [coder encodeInteger:_duration forKey:NSStringFromSelector(@selector(duration))];
    [coder encodeInteger:_playCount forKey:NSStringFromSelector(@selector(playCount))];
    [coder encodeBool:_streamable forKey:NSStringFromSelector(@selector(isStreamable))];
    [coder encodeInteger:_listeners forKey:NSStringFromSelector(@selector(listeners))];
    [coder encodeObject:_tags forKey:NSStringFromSelector(@selector(tags))];
    [coder encodeObject:_wiki forKey:NSStringFromSelector(@selector(wiki))];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)decoder {
    return [self initWithName:[decoder decodeObjectForKey:NSStringFromSelector(@selector(name))]
                       artist:[decoder decodeObjectForKey:NSStringFromSelector(@selector(artist))]
                musicBrainzID:[decoder decodeObjectForKey:NSStringFromSelector(@selector(mbid))]
                        album:[decoder decodeObjectForKey:NSStringFromSelector(@selector(album))]
              positionInAlbum:[decoder decodeIntegerForKey:NSStringFromSelector(@selector(positionInAlbum))]
                          URL:[decoder decodeObjectForKey:NSStringFromSelector(@selector(URL))]
                     duration:[decoder decodeIntegerForKey:NSStringFromSelector(@selector(duration))]
                   streamable:[decoder decodeBoolForKey:NSStringFromSelector(@selector(isStreamable))]
                         tags:[decoder decodeObjectForKey:NSStringFromSelector(@selector(tags))]
                         wiki:[decoder decodeObjectForKey:NSStringFromSelector(@selector(wiki))]
                    listeners:[decoder decodeIntegerForKey:NSStringFromSelector(@selector(listeners))]
                    playCount:[decoder decodeIntegerForKey:NSStringFromSelector(@selector(playCount))]];
}

@end
